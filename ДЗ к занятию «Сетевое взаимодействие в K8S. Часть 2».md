# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.

- Ответ:
```Bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fronted
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
      - name: fronted
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

2. Создать Deployment приложения _backend_ из образа multitool. 

- Ответ:
```Bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  labels:
    app: back
spec:
  replicas: 1
  selector:
    matchLabels:
      app: back
  template:
    metadata:
      labels:
        app: back
    spec:
      containers:
      - name: backend
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
NAME                      READY   STATUS    RESTARTS   AGE
fronted-f84d474c8-j9642   1/1     Running   0          4m56s
fronted-f84d474c8-vrmrx   1/1     Running   0          4m56s
fronted-f84d474c8-skw84   1/1     Running   0          4m56s
backend-b8d656c6b-qd8qx   1/1     Running   0          68s

nicolay@nicolay-VirtualBox:~/Загрузки$
```

3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 

- Ответ:
```Bash
apiVersion: v1
kind: Service
metadata:
  name: svc-front
spec:
  ports:
    - name: nginx
      protocol: TCP
      port: 9001
      targetPort: 80
  selector:
    app: nginx
```
```Bash
apiVersion: v1
kind: Service
metadata:
  name: svc-back
spec:
  ports:
    - name: multitool
      protocol: TCP
      port: 9002
      targetPort: 8080
  selector:
    app: back
```


4. Продемонстрировать, что приложения видят друг друга с помощью Service.
- Ответ:
```Bash
multitool:/# curl http://svc-front:9001
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
multitool:/# curl http://svc-back:9002
WBITT Network MultiTool (with NGINX) - backend-b8d656c6b-qd8qx - 10.1.118.137 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
multitool:/#
```
```Bash
backend-b8d656c6b-qd8qx:/# curl http://svc-front:9001
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
```

5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.

- Ответ:
```Bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: http-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: "nginx"
  rules:
  - host: microk8s.example.ru
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: svc-front
            port:
              number: 80
      - path: /app
        pathType: Exact
        backend:
          service:
            name: svc-back
            port:
              number: 8080
```

3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.

- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ curl -H "Host: microk8s.example.ru" http://10.1.118.128
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

```
```Bash
nicolay@nicolay-VirtualBox:~/Загрузки$ curl -H "Host: microk8s.example.ru" http://10.1.118.128/app
WBITT Network MultiTool (with NGINX) - backend-b8d656c6b-qd8qx - 10.1.118.137 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
nicolay@nicolay-VirtualBox:~/Загрузки$
```
4. Предоставить манифесты и скриншоты или вывод команды п.2.

------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
