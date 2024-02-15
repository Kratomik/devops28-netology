# Домашнее задание к занятию «Хранение в K8s. Часть 1»

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
- Ответ:
```Bash
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
      app: busy
  template:
    metadata:
      labels:
        app: busy
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        imagePullPolicy: IfNotPresent
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
        volumeMounts:
        - name: netology
          mountPath: /tmp
      volumes:
        - name: netology
          emptyDir: {}
```

2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.

- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl exec -it deployment-766774fbbf-kkxm9 bin/bash
deployment-766774fbbf-kkxm9:/# cat /tmp/netology.txt
Netology privet
Every 5s: echo Netology privet                              2024-02-15 12:19:10

Netology privet
Every 5s: echo Netology privet                              2024-02-15 12:19:15

Netology privet
deployment-766774fbbf-kkxm9:/#
```
```Bash
Netology privet
Every 5s: echo Netology privet                              2024-02-15 12:19:15

Netology privet
Every 5s: echo Netology privet                              2024-02-15 12:19:20

Netology privet
Every 5s: echo Netology privet                              2024-02-15 12:19:25

Netology privet
Every 5s: echo Netology privet                              2024-02-15 12:19:30

Netology privet
Every 5s: echo Netology privet                              2024-02-15 12:19:35

Netology privet
Every 5s: echo Netology privet                              2024-02-15 12:19:40
```

5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
- Ответ:
```Bash
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: multitool
  labels:
    app: multitool
spec:
  selector:
    matchLabels:
      app: multitool
  template:
    metadata:
      labels:
        app: multitool
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
          mountPath: /var/log/syslog
      volumes:
        - name: netology
          hostPath:
            path: /var/log/syslog
```
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl exec -it multitool-r62rc bin/bash
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
multitool-r62rc:/# cat /var/log/syslog
Feb 15 19:47:43 nicolay-VirtualBox microk8s.daemon-containerd[3659]: 2024-02-15 19:47:43.877 [INFO][2453684] k8s.go 576: Cleaning up netns ContainerID="79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea"
Feb 15 19:47:43 nicolay-VirtualBox microk8s.daemon-containerd[3659]: 2024-02-15 19:47:43.877 [INFO][2453684] dataplane_linux.go 520: CleanUpNamespace called with no netns name, ignoring. ContainerID="79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea" iface="eth0" netns=""
Feb 15 19:47:43 nicolay-VirtualBox microk8s.daemon-containerd[3659]: 2024-02-15 19:47:43.877 [INFO][2453684] k8s.go 583: Releasing IP address(es) ContainerID="79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea"
Feb 15 19:47:43 nicolay-VirtualBox microk8s.daemon-containerd[3659]: 2024-02-15 19:47:43.877 [INFO][2453684] utils.go 195: Calico CNI releasing IP address ContainerID="79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea"
Feb 15 19:47:43 nicolay-VirtualBox microk8s.daemon-containerd[3659]: 2024-02-15 19:47:43.935 [INFO][2453689] ipam_plugin.go 416: Releasing address using handleID ContainerID="79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea" HandleID="k8s-pod-network.79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea" Workload="nicolay--virtualbox-k8s-multitool--66jxb-eth0"
Feb 15 19:47:43 nicolay-VirtualBox microk8s.daemon-containerd[3659]: time="2024-02-15T19:47:43+07:00" level=info msg="About to acquire host-wide IPAM lock." source="ipam_plugin.go:357"
Feb 15 19:47:43 nicolay-VirtualBox microk8s.daemon-containerd[3659]: time="2024-02-15T19:47:43+07:00" level=info msg="Acquired host-wide IPAM lock." source="ipam_plugin.go:372"
Feb 15 19:47:43 nicolay-VirtualBox microk8s.daemon-containerd[3659]: 2024-02-15 19:47:43.963 [WARNING][2453689] ipam_plugin.go 433: Asked to release address but it doesn't exist. Ignoring ContainerID="79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea" HandleID="k8s-pod-network.79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea" Workload="nicolay--virtualbox-k8s-multitool--66jxb-eth0"
Feb 15 19:47:43 nicolay-VirtualBox microk8s.daemon-containerd[3659]: 2024-02-15 19:47:43.963 [INFO][2453689] ipam_plugin.go 444: Releasing address using workloadID ContainerID="79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea" HandleID="k8s-pod-network.79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea" Workload="nicolay--virtualbox-k8s-multitool--66jxb-eth0"
Feb 15 19:47:43 nicolay-VirtualBox microk8s.daemon-containerd[3659]: time="2024-02-15T19:47:43+07:00" level=info msg="Released host-wide IPAM lock." source="ipam_plugin.go:378"
Feb 15 19:47:43 nicolay-VirtualBox microk8s.daemon-containerd[3659]: 2024-02-15 19:47:43.970 [INFO][2453684] k8s.go 589: Teardown processing complete. ContainerID="79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea"
Feb 15 19:47:43 nicolay-VirtualBox microk8s.daemon-containerd[3659]: time="2024-02-15T19:47:43.973885781+07:00" level=info msg="TearDown network for sandbox \"79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea\" successfully"
Feb 15 19:47:44 nicolay-VirtualBox microk8s.daemon-containerd[3659]: time="2024-02-15T19:47:44.003488254+07:00" level=info msg="RemovePodSandbox \"79e6db9aa6f2acfcd5068e4fbccda36d15b08e03f482312b42504d73b482deea\" returns successfully"
Feb 15 19:47:44 nicolay-VirtualBox systemd[1]: run-containerd-runc-k8s.io-5f8f0bc1db9b5a11c81215cbddfc6cdf6eb6f1aa2d68440d7551fd28078c8c50-runc.2THDpy.mount: Succeeded.
Feb 15 19:47:44 nicolay-VirtualBox systemd[1]: run-containerd-runc-k8s.io-4d8a30732099923c38383354ec618398601414f8336ca5e195cc448a2ad433a8-runc.Yrs37T.mount: Succeeded.
Feb 15 19:47:44 nicolay-VirtualBox systemd[1086]: run-containerd-runc-k8s.io-4d8a30732099923c38383354ec618398601414f8336ca5e195cc448a2ad433a8-runc.Yrs37T.mount: Succeeded.
multitool-r62rc:/#
```
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
