# Домашнее задание к занятию 2 «Работа с Playbook»

## Подготовка к выполнению

1. * Необязательно. Изучите, что такое [ClickHouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [Vector](https://www.youtube.com/watch?v=CgEhyffisLY).
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.
- Ответ:
```Bash
clickhouse:
  hosts:
      clickhouse:
            ansible_connection: docker
            
vector:
  hosts:
      vector:
            ansible_connection: docker
```
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2.
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
- Ответ:
```Bash
[mag@node-centos7 playbook]$ ansible-playbook -i inventory/prod.yml site.yml -kK
SSH password:
BECOME password[defaults to SSH password]:
[WARNING]: Found both group and host with same name: vector
[WARNING]: Found both group and host with same name: clickhouse

PLAY [Install Clickhouse] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [clickhouse]

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
changed: [clickhouse] => (item=clickhouse-client)
changed: [clickhouse] => (item=clickhouse-server)
failed: [clickhouse] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
changed: [clickhouse]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************************************
changed: [clickhouse]

RUNNING HANDLER [Start clickhouse service] ************************************************************************************************************************************************************************
changed: [clickhouse]

TASK [Create database] ********************************************************************************************************************************************************************************************
changed: [clickhouse]

PLAY [Install Vector] *********************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [vector]

TASK [Vector | Download packages] *********************************************************************************************************************************************************************************
changed: [vector]

TASK [Vector | Install packages] **********************************************************************************************************************************************************************************
changed: [vector]

TASK [Vector | Apply template] ************************************************************************************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
changed: [vector]

TASK [Vector | change systemd unit] *******************************************************************************************************************************************************************************
changed: [vector]

RUNNING HANDLER [Start Vector service] ****************************************************************************************************************************************************************************
fatal: [vector]: FAILED! => {"changed": false, "msg": "Could not find the requested service vector: "}

NO MORE HOSTS LEFT ************************************************************************************************************************************************************************************************

PLAY RECAP ********************************************************************************************************************************************************************************************************
clickhouse                 : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector                     : ok=5    changed=4    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

[mag@node-centos7 playbook]$
```

```Bash
[mag@node-centos7 playbook]$ ansible-playbook -i inventory/prod.yml site.yml -kK
SSH password:
BECOME password[defaults to SSH password]:
[WARNING]: Found both group and host with same name: vector
[WARNING]: Found both group and host with same name: clickhouse

PLAY [Install Clickhouse] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [clickhouse]

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse] => (item=clickhouse-client)
ok: [clickhouse] => (item=clickhouse-server)
failed: [clickhouse] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************************************
ok: [clickhouse]

TASK [Create database] ********************************************************************************************************************************************************************************************
ok: [clickhouse]

PLAY [Install Vector] *********************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [vector]

TASK [Vector | Download packages] *********************************************************************************************************************************************************************************
ok: [vector]

TASK [Vector | Install packages] **********************************************************************************************************************************************************************************
ok: [vector]

TASK [Vector | Apply template] ************************************************************************************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
ok: [vector]

TASK [Vector | change systemd unit] *******************************************************************************************************************************************************************************
ok: [vector]

PLAY RECAP ********************************************************************************************************************************************************************************************************
clickhouse                 : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector                     : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[mag@node-centos7 playbook]$
```
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
- Ответ: ошибок не выдал, ниже вывод того, что произошло.
```Bash
[mag@node-centos7 playbook]$
[mag@node-centos7 playbook]$ ansible-lint ./site.yml
[mag@node-centos7 playbook]$
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
- Ответ:
```Bash
[mag@node-centos7 playbook]$ ansible-playbook -i inventory/prod.yml site.yml --check -kK
SSH password:
BECOME password[defaults to SSH password]:
[WARNING]: Found both group and host with same name: vector
[WARNING]: Found both group and host with same name: clickhouse

PLAY [Install Clickhouse] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [clickhouse]

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse] => (item=clickhouse-client)
ok: [clickhouse] => (item=clickhouse-server)
failed: [clickhouse] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 1, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************************************
ok: [clickhouse]

TASK [Create database] ********************************************************************************************************************************************************************************************
skipping: [clickhouse]

PLAY [Install Vector] *********************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [vector]

TASK [Vector | Download packages] *********************************************************************************************************************************************************************************
ok: [vector]

TASK [Vector | Install packages] **********************************************************************************************************************************************************************************
ok: [vector]

TASK [Vector | Apply template] ************************************************************************************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
ok: [vector]

TASK [Vector | change systemd unit] *******************************************************************************************************************************************************************************
ok: [vector]

PLAY RECAP ********************************************************************************************************************************************************************************************************
clickhouse                 : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0
vector                     : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[mag@node-centos7 playbook]$
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
- Ответ: Запуск ansible-lint ./site.yml не дал ошибок поэтому изменять ничего не пришлось, соответсвенно вывод без изменений.
```Bash
[mag@node-centos7 playbook]$ ansible-playbook -i inventory/prod.yml site.yml --diff -kK
SSH password:
BECOME password[defaults to SSH password]:
[WARNING]: Found both group and host with same name: vector
[WARNING]: Found both group and host with same name: clickhouse

PLAY [Install Clickhouse] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [clickhouse]

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse] => (item=clickhouse-client)
ok: [clickhouse] => (item=clickhouse-server)
failed: [clickhouse] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************************************
ok: [clickhouse]

TASK [Create database] ********************************************************************************************************************************************************************************************
ok: [clickhouse]

PLAY [Install Vector] *********************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [vector]

TASK [Vector | Download packages] *********************************************************************************************************************************************************************************
ok: [vector]

TASK [Vector | Install packages] **********************************************************************************************************************************************************************************
ok: [vector]

TASK [Vector | Apply template] ************************************************************************************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
ok: [vector]

TASK [Vector | change systemd unit] *******************************************************************************************************************************************************************************
ok: [vector]

PLAY RECAP ********************************************************************************************************************************************************************************************************
clickhouse                 : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector                     : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
- Ответ: повторный вывод такой же как и выше. 

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по [ссылке](https://github.com/opensearch-project/ansible-playbook).
- Ответ:
## Проект Clickhouse and Vector
В данном проекте находиться ansible playbook site.yml, с помощью которога мы разворачиваем несколько программ.
Этот ansible playbook поддерживает следующее:
- Может быть развернут только на линейках использующие пакетный meneger yum (пример CentOS7)
- Имеет только одно окружение **inventory/prod.yml**
## Обязательное условие
- **Ansible 2.9+**
## Описание ansible playbook
Данный плейбук проигрывает два плея **Clickhouse** и **Vector**. Подробное описание плеев приведено ниже:
1. Установка Clichouse - данный пакет будет устанавливатся на хосте clickhouse, у него будут повышены права до root. Далее есть одна taska, которая скачивает дистрибутив **clickhouse** из официального репозитория, далее устанавливает три пакета **clickhouse-common-static; clickhouse-client; clickhouse-server** определённой версии, версия указана в **group_vars/clickhouse/vars.yml**. После установки пакетов, вызывается обработчик который запускает сам сервис. После этого создается база данных и регистрируется.
2. Установка Vector - данный пакет будет устанавливаться на хосте vector, у него будут повышены права до root. Далее есть так же одна taska, которая скачивает пакет из официального репозитория с определённой версией, версия указана **group_vars/vector.yml** устанавливает пакет на нужный хост. Пакет устанавливается на основе шаблонов на ходящийхся по пути **/templates/vector.yml.j2**, далее создается файл **vector.yml** по нужному пути, файл имеет права **0644*, владелец и группа на данном файле ansible_user. Далее происходит валидация конфига. После этого создается сервис на основе шаблона **/templates/vector.service.j2** по данному пути **/usr/lib/systemd/system/vector.service**, файл имеет права **0644*, владелец и группа на данном файле ansible_user. Создается **backup** конфига и вызывается обработчик котррый запускает сам service.

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
