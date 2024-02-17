# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
- Ответ:
```Bash
apiVersion: v1
kind: PersistentVolume
metadata:
   name: my-pv
spec:
   capacity:
     storage: 1Mi
   accessModes:
   - ReadWriteOnce
   persistentVolumeReclaimPolicy: Delete
   storageClassName: ""
   hostPath:
      path: /data/pv

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  storageClassName: ""
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Mi

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mult
  template:
    metadata:
      labels:
        app: mult
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        imagePullPolicy: IfNotPresent
        env:
          - name: HTTP_PORT
            value: "8080"
        ports:
        - containerPort: 8080
        name: http-port
        resources:
          limits:
            cpu: 200m
            memory: 512Mi
          requests:
            cpu: 100m
            memory: 256Mi
        volumeMounts:
        - name: netology
          mountPath: /tmp
      - name: busybox
        image: busybox:1.28
        command: [ 'sh', '-c', 'watch -n 5 echo Netology privet > /tmp/netology.txt' ]
        ports:
        - containerPort: 80
        volumeMounts:
        - name: netology
          mountPath: /tmp
      volumes:
        - name: netology
          persistentVolumeClaim:
            claimName: my-pvc
```
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории. 
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl exec -it deployment-5fd8c98b74-4r2dw  bin/bash
deployment-5fd8c98b74-4r2dw:/# cat /tmp/netology.txt
Every 5s: echo Netology privet                              2024-02-17 07:01:26

Netology privet
Every 5s: echo Netology privet                              2024-02-17 07:01:31

Netology privet
Every 5s: echo Netology privet                              2024-02-17 07:01:36

Netology privet
Every 5s: echo Netology privet                              2024-02-17 07:01:41

Netology privet
Every 5s: echo Netology privet                              2024-02-17 07:01:46

Netology privet
Every 5s: echo Netology privet                              2024-02-17 07:01:51

Netology privet
deployment-5fd8c98b74-4r2dw:/#
```
```Bash
deployment-5fd8c98b74-4r2dw:/# cat /tmp/netology.txt
Netology privet
Every 5s: echo Netology privet                              2024-02-17 07:01:51

Netology privet
Every 5s: echo Netology privet                              2024-02-17 07:01:56

Netology privet
Every 5s: echo Netology privet                              2024-02-17 07:02:01

Netology privet
Every 5s: echo Netology privet                              2024-02-17 07:02:06

Netology privet
Every 5s: echo Netology privet                              2024-02-17 07:02:11
```
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.
- Ответ: после удаления Deployments и PVC, PV свалился в статус "Failed", это произошло потому что удалена связь между PV --> PVC, если PVC не удалять, связь останется и PV будет в статусе "Bound". 
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl delete -f ./busytool.yml
persistentvolumeclaim "my-pvc" deleted
deployment.apps "deployment" deleted
```
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM            STORAGECLASS   REASON   AGE
my-pv   1Mi        RWO            Delete           Failed   default/my-pvc                           7m16s
nicolay@nicolay-VirtualBox:~/Загрузки$
```
5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.
- Ответ: файл сохранился локально на машине по пути /data/pv
```Bash
nicolay@nicolay-VirtualBox:/$ ls -lah /data/pv/
итого 12K
drwxr-xr-x 2 root root 4,0K фев 17 13:55 .
drwxr-xr-x 3 root root 4,0K фев 17 13:55 ..
-rw-r--r-- 1 root root 1,5K фев 17 14:19 netology.txt
nicolay@nicolay-VirtualBox:/$
```
После удаления PV файл остался не тронутым. В конфиге политика стоит "Delete", поэтому он должен был удалиться, но драйвером не поддерживается данная команда.
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl delete -f ./busytool.yml
persistentvolume "my-pv" deleted
Error from server (NotFound): error when deleting "./busytool.yml": persistentvolumeclaims "my-pvc" not found
Error from server (NotFound): error when deleting "./busytool.yml": deployments.apps "deployment" not found
nicolay@nicolay-VirtualBox:~/Загрузки$
```
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ sudo ls -lah /data/pv/
итого 12K
drwxr-xr-x 2 root root 4,0K фев 17 13:55 .
drwxr-xr-x 3 root root 4,0K фев 17 13:55 ..
-rw-r--r-- 1 root root 1,3K фев 17 14:28 netology.txt
nicolay@nicolay-VirtualBox:~/Загрузки$
```
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.
2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.
- Ответ:
```Bash
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-multitool
spec:
  storageClassName: "nfs"
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Mi

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: multitool
  labels:
    app: mult
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mult
  template:
    metadata:
      labels:
        app: mult
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        ports:
        - containerPort: 80
        volumeMounts:
        - name: netology
          mountPath: /usr/share/nginx/html/index.html
      volumes:
        - name: netology
          persistentVolumeClaim:
            claimName: pvc-multitool
```
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl apply -f ./multitool-nfs.yml
persistentvolumeclaim/pvc-multitool created
deployment.apps/multitool created
nicolay@nicolay-VirtualBox:~/Загрузки$
nicolay@nicolay-VirtualBox:~/Загрузки$
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                  STORAGECLASS   REASON   AGE
data-nfs-server-provisioner-0              1Gi        RWO            Retain           Bound    nfs-server-provisioner/data-nfs-server-provisioner-0                           28m
pvc-624af378-61ca-47a0-842e-0934cbd08670   10Mi       RWO            Delete           Bound    default/pvc-multitool                                  nfs                     25s

nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl get pvc
NAME            STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-multitool   Bound    pvc-624af378-61ca-47a0-842e-0934cbd08670   10Mi       RWO            nfs            29s

nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
multitool-77678b77d-c4tcl   1/1     Running   0          47s
nicolay@nicolay-VirtualBox:~/Загрузки$
```
3. Продемонстрировать возможность чтения и записи файла изнутри пода. 
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl get pods -o wide
NAME                         READY   STATUS    RESTARTS   AGE    IP             NODE                 NOMINATED NODE   READINESS GATES
multitool-78d9d685fd-9mxwx   1/1     Running   0          3m9s   10.1.118.176   nicolay-virtualbox   <none>           <none>
nicolay@nicolay-VirtualBox:~/Загрузки$
nicolay@nicolay-VirtualBox:~/Загрузки$
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl exec -it multitool-78d9d685fd-9mxwx bin/bash
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
multitool-78d9d685fd-9mxwx:/# touch /usr/share/nginx/html/index.html
multitool-78d9d685fd-9mxwx:/# echo Privet! > /usr/share/nginx/html/index.html
multitool-78d9d685fd-9mxwx:/# curl 10.1.118.176
Privet!
multitool-78d9d685fd-9mxwx:/# cat /usr/share/nginx/html/index.html
Privet!
multitool-78d9d685fd-9mxwx:/#
```
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
