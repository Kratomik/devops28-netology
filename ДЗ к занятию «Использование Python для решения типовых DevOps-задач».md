# Домашнее задание к занятию «Использование Python для решения типовых DevOps-задач»

### Цель задания

В результате выполнения задания вы:

* познакомитесь с синтаксисом Python;
* узнаете, для каких типов задач его можно использовать;
* воспользуетесь несколькими модулями для работы с ОС.


### Инструкция к заданию

1. Установите Python 3 любой версии.
2. Скопируйте в свой .md-файл содержимое этого файла, исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md).
3. Заполните недостающие части документа решением задач — заменяйте `???`, остальное в шаблоне не меняйте, чтобы не сломать форматирование текста, подсветку синтаксиса. Вместо логов можно вставить скриншоты по желанию.
4. Для проверки домашнего задания в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем репозитории.
4. Любые вопросы по выполнению заданий задавайте в чате учебной группы или в разделе «Вопросы по заданию» в личном кабинете.

### Дополнительные материалы

1. [Полезные ссылки для модуля «Скриптовые языки и языки разметки».](https://github.com/netology-code/sysadm-homeworks/tree/devsys10/04-script-03-yaml/additional-info)

------

## Задание 1

Есть скрипт:

```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:

| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | сложение произвести не получится, int нельзя складывать с str  |
| Как получить для переменной `c` значение 12?  | c = str(a) + b  |
| Как получить для переменной `c` значение 3?  | с = a + int(b)  |

------

## Задание 2

Мы устроились на работу в компанию, где раньше уже был DevOps-инженер. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. 

Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/Documents/py/devops28-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(f'/home/nicolay/Documents/py/devops28-netology/{prepare_result}')

```

### Вывод скрипта при запуске во время тестирования:

```bash
nicolay@nicolay-VirtualBox:~$ python3 ./1.py
/home/nicolay/Documents/py/devops28-netology/   изменено:      index.php
/home/nicolay/Documents/py/devops28-netology/   изменено:      second.php
/home/nicolay/Documents/py/devops28-netology/   изменено:      terraform/readme
nicolay@nicolay-VirtualBox:~$

```

------

## Задание 3

Доработать скрипт выше так, чтобы он не только мог проверять локальный репозиторий в текущей директории, но и умел воспринимать путь к репозиторию, который мы передаём, как входной параметр. Мы точно знаем, что начальство будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:

```python
#!/usr/bin/env python3

import os, sys

param = sys.argv[1]
bash_command = [f'cd {param}', "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(f'{param}/{prepare_result}')

```

### Вывод скрипта при запуске во время тестирования:

```bash
nicolay@nicolay-VirtualBox:~$ python3 ./3.py /home/nicolay/Documents/py/devops28-netology/
/home/nicolay/Documents/py/devops28-netology//  изменено:      index.php
/home/nicolay/Documents/py/devops28-netology//  изменено:      second.php
/home/nicolay/Documents/py/devops28-netology//  изменено:      terraform/readme
```

------

## Задание 4

Наша команда разрабатывает несколько веб-сервисов, доступных по HTTPS. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. 

Проблема в том, что отдел, занимающийся нашей инфраструктурой, очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS-имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. 

Мы хотим написать скрипт, который: 

- опрашивает веб-сервисы; 
- получает их IP; 
- выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. 

Также должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена — оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:

```python
#!/usr/bin/env python3

import socket
import json

print('read ip_add.log ...')
file_old = open('ip_add.log', 'r')
stage_ipadds = json.loads(file_old.read())
print(f'ip_add.log: {stage_ipadds}\n')

ip_item = []
dns_item = ["drive.google.com", "mail.google.com", "google.com"]
for resolv in dns_item:
    ip_item.append(socket.gethostbyname(resolv))
current_ipadds = dict(zip(dns_item, ip_item))

stage_ipadds_new = open('ip_add.log', 'w')
stage_ipadds_new.write(json.dumps(current_ipadds))
stage_ipadds_new.close()

print('For check:')
print(current_ipadds)

for i in current_ipadds:
    if (current_ipadds[i] == stage_ipadds[i]):
        print(f'<{i}> - <{current_ipadds[i]}>')
    else:
        print(f'[ERROR] <{i}> IP mismatch: <{stage_ipadds[i]}> <{current_ipadds[i]}>')
```

### Вывод скрипта при запуске во время тестирования:

```bash
nicolay@nicolay-VirtualBox:~$ python3 ./4.py
read ip_add.log ...
ip_add.log: {'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}
For check:
{'drive.google.com': '142.251.1.194', 'mail.google.com': '108.177.14.83', 'google.com': '108.177.14.102'}
[ERROR] <drive.google.com> IP mismatch: <0.0.0.0> <142.251.1.194>
[ERROR] <mail.google.com> IP mismatch: <0.0.0.0> <108.177.14.83>
[ERROR] <google.com> IP mismatch: <0.0.0.0> <108.177.14.102>
```

------

## Задание со звёздочкой* 

Это самостоятельное задание, его выполнение необязательно.
___

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в GitHub и пользуется Gitflow, то нам приходится каждый раз: 

* переносить архив с нашими изменениями с сервера на наш локальный компьютер;
* формировать новую ветку; 
* коммитить в неё изменения; 
* создавать pull request (PR); 
* и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. 

Мы хотим максимально автоматизировать всю цепочку действий. Для этого: 

1. Нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к GitHub, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым).
1. При желании можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. 
1. С директорией локального репозитория можно делать всё, что угодно. 
1. Также принимаем во внимание, что Merge Conflict у нас отсутствуют, и их точно не будет при push как в свою ветку, так и при слиянии в master. 

Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:

```python
???
```

### Вывод скрипта при запуске во время тестирования:

```
???
```

----
