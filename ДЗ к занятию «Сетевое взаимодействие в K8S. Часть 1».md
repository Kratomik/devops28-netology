# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к приложению, установленному в предыдущем ДЗ и состоящему из двух контейнеров, по разным портам в разные контейнеры как внутри кластера, так и снаружи.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Описание Service.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.

- Ответ:
```Bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
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
```
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
deployment-698d5c746f-jt5fz   2/2     Running   0          31m
deployment-698d5c746f-nzvwj   2/2     Running   0          31m
deployment-698d5c746f-msmfh   2/2     Running   0          31m
multitool                     1/1     Running   0          30m
nicolay@nicolay-VirtualBox:~/Загрузки$

```

2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.

- Ответ:
```Bash
apiVersion: v1
kind: Service
metadata:
  name: svc-nginx
spec:
  ports:
    - name: nginx
      protocol: TCP
      port: 9001
      targetPort: 80
    - name: multitool
      protocol: TCP
      port: 9002
      targetPort: 8080
  selector:
    app: nginx
```

3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.

- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl describe svc/svc-nginx
Name:              svc-nginx
Namespace:         default
Labels:            <none>
Annotations:       <none>
Selector:          app=nginx
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.152.183.26
IPs:               10.152.183.26
Port:              nginx  9001/TCP
TargetPort:        80/TCP
Endpoints:         10.1.118.159:80,10.1.118.160:80,10.1.118.161:80
Port:              multitool  9002/TCP
TargetPort:        8080/TCP
Endpoints:         10.1.118.159:8080,10.1.118.160:8080,10.1.118.161:8080
Session Affinity:  None
Events:            <none>
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl exec -it multitool /bin/bash
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
multitool:/#
multitool:/#
multitool:/# curl http://10.152.183.26:9001
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
multitool:/# curl http://10.152.183.26:9002
WBITT Network MultiTool (with NGINX) - deployment-698d5c746f-jt5fz - 10.1.118.159 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
multitool:/#
```

4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.

- Ответ:
```Bash
multitool:/#
multitool:/# clear
multitool:/#
multitool:/# curl http://svc-nginx:9001
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
multitool:/# curl http://svc-nginx:9002
WBITT Network MultiTool (with NGINX) - deployment-698d5c746f-msmfh - 10.1.118.160 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
multitool:/#
```

5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
- Ответ:
```Bash
apiVersion: v1
kind: Service
metadata:
  name: svc-nodeport
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 32005
  selector:
    app: nginx
```

```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ kubectl describe svc/svc-nodeport
Name:                     svc-nodeport
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 app=nginx
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.152.183.240
IPs:                      10.152.183.240
Port:                     <unset>  80/TCP
TargetPort:               80/TCP
NodePort:                 <unset>  32005/TCP
Endpoints:                10.1.118.159:80,10.1.118.160:80,10.1.118.161:80
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>

nicolay@nicolay-VirtualBox:~/Загрузки$
```

2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
- Ответ:
<img src="screen/svc-nodeport.png" width="" height="500"/>

3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
