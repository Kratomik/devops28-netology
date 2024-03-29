# Домашнее задание к занятию «Введение в Terraform»

### Цель задания

1. Установить и настроить Terrafrom.
2. Научиться использовать готовый код.

------

### Чеклист готовности к домашнему заданию

1. Скачайте и установите актуальную версию **terraform** >=1.4.X . Приложите скриншот вывода команды ```terraform --version```.
```Bash
nicolay@nicolay-VirtualBox:~$
nicolay@nicolay-VirtualBox:~$ terraform --version
Terraform v1.4.6
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.5.2. You can update by downloading from https://www.terraform.io/downloads.html
nicolay@nicolay-VirtualBox:~$
```
2. Скачайте на свой ПК данный git репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.
3. Убедитесь, что в вашей ОС установлен docker.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Репозиторий с ссылкой на зеркало для установки и настройки Terraform  [ссылка](https://github.com/netology-code/devops-materials).
2. Установка docker [ссылка](https://docs.docker.com/engine/install/ubuntu/). 
------

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте. 
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/ter-homeworks/01/src$
nicolay@nicolay-VirtualBox:~/ter-homeworks/01/src$
nicolay@nicolay-VirtualBox:~/ter-homeworks/01/src$ terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of kreuzwerker/docker from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Using previously-installed kreuzwerker/docker v3.0.2
- Using previously-installed hashicorp/random v3.5.1

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
nicolay@nicolay-VirtualBox:~/ter-homeworks/01/src$
```
2. Изучите файл **.gitignore**. В каком terraform файле согласно этому .gitignore допустимо сохранить личную, секретную информацию?
- Ответ:
Сохранить личную, секретную информацию согласно .gitignore допустимо в файле **personal.auto.tfvars**
3. Выполните код проекта. Найдите  в State-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.
- Ответ: В данном содержимом state файла нет секретного содержимого, так как мы ни каких токенов и паролей не передаем для развертывания. Если я не прав можете чуть больше информации дать, к примеру где я могу найти информацию по этому поводу или может я что-то не так делаю. Ниже приведено полное содержимое файла **terraform.tfstate**
```Bash
{
  "version": 4,
  "terraform_version": "1.4.6",
  "serial": 93,
  "lineage": "1cf12d0a-38e6-05b3-9d5b-cb2235a8d53a",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "random_password",
      "name": "random_string",
      "provider": "provider[\"registry.terraform.io/hashicorp/random\"]",
      "instances": [
        {
          "schema_version": 3,
          "attributes": {
            "bcrypt_hash": "$2a$10$N6NEh5miZWJBbYYslidHauFw6fLq1ntaKLoXaJWOAngbzVdoVoMqS",
            "id": "none",
            "keepers": null,
            "length": 16,
            "lower": true,
            "min_lower": 1,
            "min_numeric": 1,
            "min_special": 0,
            "min_upper": 1,
            "number": true,
            "numeric": true,
            "override_special": null,
            "result": "fqzD4tXMtX3wmTZD",
            "special": false,
            "upper": true
          },
          "sensitive_attributes": []
        }
      ]
    }
  ],
  "check_results": null
}

```
4. Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла **main.tf**.
Выполните команду ```terraform validate```. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.
- Ответ:
  Недопустимое имя ресурса - имя должно начинаться с буквы или символа подчеркивания и может содержать только буквы, цифры, символы подчеркивания и тире;
  Необъявленная переменная окружения в имени контейнера - в качестве исправления указал имя контейнера "terraform_nginx"
5. Выполните код. В качестве ответа приложите вывод команды ```docker ps```
```Bash
nicolay@nicolay-VirtualBox:~/ter-homeworks/01/src$
nicolay@nicolay-VirtualBox:~/ter-homeworks/01/src$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
d5c000f0ff3c   021283c8eb95   "/docker-entrypoint.…"   19 seconds ago   Up 12 seconds   0.0.0.0:8000->80/tcp   terraform_nginx
nicolay@nicolay-VirtualBox:~/ter-homeworks/01/src$
```
6. Замените имя docker-контейнера в блоке кода на ```hello_world```, выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чем может быть опасность применения ключа  ```-auto-approve``` ? В качестве ответа дополнительно приложите вывод команды ```docker ps```
- Ответ: При применение ключа перестает выводить и спрашивать сообщение о применение изменения, т.е в автоматическом режиме применяет конфигурацию. В таком случае если в коде закралась ошибка, то исправить её на данном этапе не предоставится возможным. 
```Bash
nicolay@nicolay-VirtualBox:~/ter-homeworks/01/src$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
1c72d9d251ba   021283c8eb95   "/docker-entrypoint.…"   13 seconds ago   Up 12 seconds   0.0.0.0:8000->80/tcp   hello_world
nicolay@nicolay-VirtualBox:~/ter-homeworks/01/src$
```
7. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**. 
- Ответ:
```Bash
{
  "version": 4,
  "terraform_version": "1.4.6",
  "serial": 35,
  "lineage": "1cf12d0a-38e6-05b3-9d5b-cb2235a8d53a",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```
8. Объясните, почему при этом не был удален docker образ **nginx:latest** ? Ответ подкрепите выдержкой из документации провайдера.
- Ответ: keep_locally - (Необязательно, логическое значение) Если true, то образ Docker не будет удален при операции уничтожения. Если это ложь, он удалит изображение из локального хранилища докера при операции уничтожения. У нас в конфигурации как раз данный параметр "true", поэтому данный образ остался.

------

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 

### Задание 2*

1. Изучите в документации provider [**Virtualbox**](https://docs.comcloud.xyz/providers/shekeriev/virtualbox/latest/docs) от 
shekeriev.
2. Создайте с его помощью любую виртуальную машину. Чтобы не использовать VPN советуем выбрать любой образ с расположением в github из [**списка**](https://www.vagrantbox.es/)

В качестве ответа приложите plan для создаваемого ресурса и скриншот созданного в VB ресурса. 

------

### Правила приема работы

Домашняя работа оформляется в отдельном GitHub репозитории в файле README.md.   
Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки. 
