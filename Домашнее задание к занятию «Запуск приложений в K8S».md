# Домашнее задание к занятию «Запуск приложений в K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.

- Ответ:

<img src="screen/nginx.yml" width="" height="500"/>

2. После запуска увеличить количество реплик работающего приложения до 2.
3. Продемонстрировать количество подов до и после масштабирования.

- Ответ:
<img src="screen/kubectl-get-pods-1.png" width="" height="500"/>

<img src="screen/kubectl-get-pods-2.png" width="" height="500"/>

4. Создать Service, который обеспечит доступ до реплик приложений из п.1.

- Овет:
```Bash
apiVersion: v1
kind: Service
metadata:
  name: svc-nginx
spec:
  ports:
    - name: nginx
      protocol: TCP
      port: 80
    - name: multitool
      protocol: TCP
      port: 1180
  selector:
    app: nginx
```
<img src="screen/describe-svc.png" width="" height="500"/>


5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

- Ответ:

<img src="screen/curl-multitool-1.png" width="" height="500"/>

<img src="screen/curl-multitool-3.png" width="" height="500"/>

Примечание: вначале курлил поды думал, что так нужно, потом пересмотрел лекцию преподователь говорил, что курлить нужно сервис :), а к тому времени у меня уже все было удалено, развернул заново и соответсвенно ip сервиса уже изменился. Небольшое поянение почему ip сервиса чуть выше на скрине отличаются от данного скрина

<img src="screen/curl-svc.png" width="" height="500"/>

<img src="screen/curl-svc-1180.png" width="" height="500"/>


------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
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
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.19
          ports:
          - containerPort: 80
      initContainers:
        - name: init-myservice
          image: busybox:1.28
          command: [ 'sh', '-c', "until nslookup myservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for myservice; sleep 2; done"]
```
<img src="screen/init-containers.png" width="" height="500"/>

2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.

- Ответ:

<img src="screen/start-myservice.png" width="" height="500"/>
------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------
