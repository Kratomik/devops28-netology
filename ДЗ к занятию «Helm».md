# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/charts$ helm create netology-app
Creating netology-app
```
```Bash
nicolay@nicolay-VirtualBox:~/charts$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS       AGE
multitool                            1/1     Running   2 (2d5h ago)   6d23h
web1-netology-app-5d5b87f7fb-25cn7   1/1     Running   0              39s
nicolay@nicolay-VirtualBox:~/charts$
```
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/charts$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS       AGE
multitool                            1/1     Running   2 (2d5h ago)   6d23h
web1-netology-app-5d5b87f7fb-25cn7   1/1     Running   0              39s
nicolay@nicolay-VirtualBox:~/charts$
```
```Bash
nicolay@nicolay-VirtualBox:~/charts$ kubectl get svc
NAME                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes          ClusterIP   10.152.183.1     <none>        443/TCP   28d
web1-netology-app   ClusterIP   10.152.183.244   <none>        80/TCP    13m
nicolay@nicolay-VirtualBox:~/charts$
```
```Bash
nicolay@nicolay-VirtualBox:~/charts$ helm history web1
REVISION        UPDATED                         STATUS          CHART                   APP VERSION     DESCRIPTION
1               Sat Mar  2 18:34:51 2024        deployed        netology-app-0.1.0      1.20.0          Install complete
nicolay@nicolay-VirtualBox:~/charts$
```
3. В переменных чарта измените образ приложения для изменения версии.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/charts$ helm history web1
REVISION        UPDATED                         STATUS          CHART                   APP VERSION     DESCRIPTION
1               Sat Mar  2 18:34:51 2024        superseded      netology-app-0.1.0      1.20.0          Install complete
2               Sat Mar  2 18:56:36 2024        deployed        netology-app-0.1.0      1.21.0          Upgrade complete
nicolay@nicolay-VirtualBox:~/charts$
```
------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/charts$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS       AGE
multitool                            1/1     Running   2 (2d6h ago)   7d
web1-netology-app-66987bd85d-gttcg   1/1     Running   0              4m18s
web1-netology-app-66987bd85d-p9xq5   1/1     Running   0              10s
web1-netology-app-66987bd85d-grp82   1/1     Running   0              10s
nicolay@nicolay-VirtualBox:~/charts$
```  
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/charts$ kubectl get pods -n app1
NAME                                 READY   STATUS    RESTARTS   AGE
app1-netology-app-557bd79d4c-22dfs   1/1     Running   0          62s
app1-netology-app-557bd79d4c-fgjmw   1/1     Running   0          62s
app1-netology-app-557bd79d4c-9jgxz   1/1     Running   0          62s
app2-netology-app-69c8b8d54d-vrb5c   1/1     Running   0          24s
app2-netology-app-69c8b8d54d-7c629   1/1     Running   0          24s
app2-netology-app-69c8b8d54d-ccc5l   1/1     Running   0          24s
nicolay@nicolay-VirtualBox:~/charts$
```
```Bash
nicolay@nicolay-VirtualBox:~/charts$ helm list -n app1
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
app1    app1            1               2024-03-02 19:07:01.842638873 +0700 +07 deployed        netology-app-0.1.0      1.25.0
app2    app1            1               2024-03-02 19:07:39.980700178 +0700 +07 deployed        netology-app-0.1.0      1.26.0
nicolay@nicolay-VirtualBox:~/charts$
```
```Bash
nicolay@nicolay-VirtualBox:~/charts$ kubectl get pods -n app2
NAME                                 READY   STATUS    RESTARTS   AGE
app3-netology-app-5879d6745c-q6d4l   1/1     Running   0          24s
app3-netology-app-5879d6745c-qwxvm   1/1     Running   0          24s
app3-netology-app-5879d6745c-bfjn8   1/1     Running   0          24s
nicolay@nicolay-VirtualBox:~/charts$
```
```Bash
nicolay@nicolay-VirtualBox:~/charts$ helm list -n app2
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
app3    app2            1               2024-03-02 19:24:40.796718061 +0700 +07 deployed        netology-app-0.1.0      1.27.0
nicolay@nicolay-VirtualBox:~/charts$
```
3. Продемонстрируйте результат.

### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
