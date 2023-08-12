# Домашнее задание к занятию 1 «Введение в Ansible»

## Подготовка к выполнению

1. Установите Ansible версии 2.10 или выше.
2. Создайте свой публичный репозиторий на GitHub с произвольным именем.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$ ansible-playbook ./site.yml -i inventory/test.yml

PLAY [Print os facts] *******************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [localhost]

TASK [Print OS] *************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ******************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$
```

2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$ ansible-playbook ./site.yml -i inventory/test.yml

PLAY [Print os facts] *******************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [localhost]

TASK [Print OS] *************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ******************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$
```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/devops28-netology$ docker ps -a
CONTAINER ID   IMAGE                      COMMAND       CREATED         STATUS         PORTS     NAMES
13faf33f7fed   pycontribs/ubuntu:latest   "/bin/bash"   6 minutes ago   Up 6 minutes             ubuntu
953818af6ed3   pycontribs/centos:7        "/bin/bash"   8 minutes ago   Up 8 minutes             centos7
nicolay@nicolay-VirtualBox:~/devops28-netology$
```

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$ ansible-playbook ./site.yml -i inventory/prod.yml

PLAY [Print os facts] *******************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ******************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$
```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$ ansible-playbook ./site.yml -i inventory/prod.yml

PLAY [Print os facts] *******************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ******************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$
```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$ cat ./group_vars/deb/examp.yml
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          64656334343539623331636638623066316334376235373236313639353737363339393964633030
          3731633730656530316431313831393637646239303936620a663931366538303732326230666164
          61336566383565616433396132656237626234303166316135626663306637386365353761636536
          3837353864653263610a653765616234376233336131386364306537363537363134333732313965
          38363935313831346166326661353562383739656432356136633966343936336564
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$
```
```Bash
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$ cat ./group_vars/el/examp.yml
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          66633236386230333338663336636138663265383233363539366131376632633065316333643232
          6138353932633262613234306332616239373431396336330a643838323062363536653236323739
          37623930626564396539366536326563373864333539346137366266383062643538366662643264
          3865386635366237610a656534633666636661336364383061616239663138613330323166393939
          6365
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$
```

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$ ansible-playbook ./site.yml -i inventory/prod.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *******************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ******************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$
```


9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
- Ответ:
```Bash
local                          execute on controller
```
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$ cat ./inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$
```


11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
- Ответ:
```Bash
nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$ ansible-playbook ./site.yml -i inventory/prod.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *******************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ******************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

nicolay@nicolay-VirtualBox:~/devops28-netology/ansible/08-ansible-01-base/playbook$
```


12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
