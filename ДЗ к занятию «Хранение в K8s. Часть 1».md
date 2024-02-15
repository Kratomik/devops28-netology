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
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
