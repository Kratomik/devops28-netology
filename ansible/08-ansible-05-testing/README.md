# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule: `pip3 install "molecule==3.5.2"` и драйвера `pip3 install molecule_docker molecule_podman`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos_7` внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
<<<<<<< HEAD
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 
5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.
=======
- Ответ:
```Bash
[mag@node-centos7 vector-role]$ molecule init scenario --driver-name docker
/home/mag/.local/lib/python3.6/site-packages/requests/__init__.py:104: RequestsDependencyWarning: urllib3 (1.26.16) or chardet (5.0.0)/charset_normalizer (2.0.12) doesn't match a supported version!
  RequestsDependencyWarning)
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/mag/devops28-netology/ansible/08-ansible-05-testing/08-ansible-04-role/playbook/roles/vector-role/molecule/default successfully.
```

3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
- Ответ:
```Bash
g@node-centos7 vector-role]$ molecule test
/home/mag/.local/lib/python3.6/site-packages/requests/__init__.py:104: RequestsDependencyWarning: urllib3 (1.26.16) or chardet (5.0.0)/charset_normalizer (2.0.12) doesn't match a supported version!
  RequestsDependencyWarning)
INFO     default scenario test matrix: dependency, lint, syntax, create, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/mag/.cache/ansible-compat/a98023/modules:/home/mag/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATHS=/home/mag/.cache/ansible-compat/a98023/collections:/home/mag/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/mag/.cache/ansible-compat/a98023/roles:/home/mag/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
COMMAND: ansible-lint .
yamllint .

INFO     Running default > syntax
INFO     Sanity checks: 'docker'

playbook: /home/mag/devops28-netology/ansible/08-ansible-05-testing/08-ansible-04-role/playbook/roles/vector-role/molecule/default/converge.yml
INFO     Running default > create
WARNING  Skipping, instances already created.
INFO     Running default > converge

PLAY [Converge] *************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [centos7]

TASK [Include vector-role] **************************************************************************************************************************

TASK [vector-role : Download packages] **************************************************************************************************************
ok: [centos7]

TASK [vector-role : Install packages] ***************************************************************************************************************
ok: [centos7]

TASK [vector-role : Apply template] *****************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the
entire value to ensure it does not change.
ok: [centos7]

TASK [vector-role : change systemd unit] ************************************************************************************************************
ok: [centos7]

PLAY RECAP ******************************************************************************************************************************************
centos7                    : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] *************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [centos7]

TASK [Include vector-role] **************************************************************************************************************************

TASK [vector-role : Download packages] **************************************************************************************************************
ok: [centos7]

TASK [vector-role : Install packages] ***************************************************************************************************************
ok: [centos7]

TASK [vector-role : Apply template] *****************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the
entire value to ensure it does not change.
ok: [centos7]

TASK [vector-role : change systemd unit] ************************************************************************************************************
ok: [centos7]

PLAY RECAP ******************************************************************************************************************************************
centos7                    : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ***************************************************************************************************************************************

TASK [Example assertion] ****************************************************************************************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP ******************************************************************************************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] **************************************************************************************************************************************

TASK [Destroy molecule instance(s)] *****************************************************************************************************************
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) deletion to complete] ****************************************************************************************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos7)

TASK [Delete docker networks(s)] ********************************************************************************************************************

PLAY RECAP ******************************************************************************************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```

4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 
5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
- Ответ:
```Bash
[mag@node-centos7 vector-role]$ molecule test
/home/mag/.local/lib/python3.6/site-packages/requests/__init__.py:104: RequestsDependencyWarning: urllib3 (1.26.16) or chardet (5.0.0)/charset_normalizer (2.0.12) doesn't match a supported version!
  RequestsDependencyWarning)
INFO     default scenario test matrix: dependency, lint, syntax, create, converge, idempotence, side_effect, verify, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/mag/.cache/ansible-compat/a98023/modules:/home/mag/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATHS=/home/mag/.cache/ansible-compat/a98023/collections:/home/mag/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/mag/.cache/ansible-compat/a98023/roles:/home/mag/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
COMMAND: ansible-lint .
yamllint .

INFO     Running default > syntax
INFO     Sanity checks: 'docker'

playbook: /home/mag/devops28-netology/ansible/08-ansible-05-testing/08-ansible-04-role/playbook/roles/vector-role/molecule/default/converge.yml
INFO     Running default > create
WARNING  Skipping, instances already created.
INFO     Running default > converge

PLAY [Converge] *************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [centos7]

TASK [Include vector-role] **************************************************************************************************************************

TASK [vector-role : Download packages] **************************************************************************************************************
ok: [centos7]

TASK [vector-role : Install packages] ***************************************************************************************************************
ok: [centos7]

TASK [vector-role : Apply template] *****************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the
entire value to ensure it does not change.
ok: [centos7]

TASK [vector-role : change systemd unit] ************************************************************************************************************
ok: [centos7]

PLAY RECAP ******************************************************************************************************************************************
centos7                    : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] *************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [centos7]

TASK [Include vector-role] **************************************************************************************************************************

TASK [vector-role : Download packages] **************************************************************************************************************
ok: [centos7]

TASK [vector-role : Install packages] ***************************************************************************************************************
ok: [centos7]

TASK [vector-role : Apply template] *****************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the
entire value to ensure it does not change.
ok: [centos7]

TASK [vector-role : change systemd unit] ************************************************************************************************************
ok: [centos7]

PLAY RECAP ******************************************************************************************************************************************
centos7                    : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ***************************************************************************************************************************************

TASK [Example assertion] ****************************************************************************************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Execute vector] *******************************************************************************************************************************
ok: [centos7]

TASK [Check vector config file] *********************************************************************************************************************
--- before: /etc/vector/vector.yml (content)
+++ after: /etc/vector/vector.yml (content)
@@ -13,3 +13,4 @@
     demo_logs:
         format: syslog
         type: demo_logs
+    pattern = "(?<capture>\\d+)%{GREEDYDATA}"

changed: [centos7]

TASK [Assert vector is installed] *******************************************************************************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP ******************************************************************************************************************************************
centos7                    : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > destroy

PLAY [Destroy] **************************************************************************************************************************************

TASK [Destroy molecule instance(s)] *****************************************************************************************************************
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) deletion to complete] ****************************************************************************************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos7)

TASK [Delete docker networks(s)] ********************************************************************************************************************

PLAY RECAP ******************************************************************************************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
[mag@node-centos7 vector-role]$
```
6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

>>>>>>> 6820e8cc191e4cec72abbc17183903f332d3ccbf

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
<<<<<<< HEAD
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.
=======
- Ответ:
```Bash
docker run --privileged=True -v /home/mag/devops28-netology/ansible/08-ansible-05-testing/08-ansible-04-role/playbook/roles/vector-role:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
```
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
- Ответ: внутри контейнера выполнил команду **tox** вывод ниже:
```Bash 
py37-ansible210: commands succeeded
py37-ansible30: commands succeeded
py39-ansible210: commands succeeded
py39-ansible30: commands succeeded
```
4. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
- Ответ: внутри контейнера выполнил команду **tox** вывод ниже:
```Bash
py39-ansible210: commands succeeded
py39-ansible30: commands succeeded
```
5. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
6. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
```Bash
py39-ansible210: commands succeeded
py39-ansible30: commands succeeded
```
7. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.
>>>>>>> 6820e8cc191e4cec72abbc17183903f332d3ccbf

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
