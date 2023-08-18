# Домашнее задание к занятию 3 «Использование Ansible»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
- Ответ:
```Bash
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - block:
        - name: Clickhouse | Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Clickhouse | Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - ./clickhouse-common-static-{{ clickhouse_version }}.rpm
          - ./clickhouse-client-{{ clickhouse_version }}.rpm
          - ./clickhouse-server-{{ clickhouse_version }}.rpm
        disable_gpg_check: true
      notify: Start clickhouse service
    - name: Flush handlers
      meta: flush_handlers
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0

- name: Install Vector
  hosts: vector
  handlers:
    - name: Start Vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
    - name: Vector | Download packages
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm"
        dest: "./vector-{{ vector_version }}-1.x86_64.rpm"
    - name: Vector | Install packages
      become: true
      ansible.builtin.yum:
        name: "./vector-{{ vector_version }}-1.x86_64.rpm"
        disable_gpg_check: true
    - name: Vector | Apply template
      become: true
      ansible.builtin.template:
        src: vector.yml.j2
        dest: "{{ vector_config_dir }}/vector.yml"
        mode: "0644"
        owner: "{{ ansible_user_id }}"
        group: "{{ ansible_user_gid }}"
        validate: vector validate --no-environment --config-yaml %s
    - name: Vector | change systemd unit
      become: true
      ansible.builtin.template:
        src: vector.service.j2
        dest: /usr/lib/systemd/system/vector.service
        mode: "0644"
        owner: "{{ ansible_user_id }}"
        group: "{{ ansible_user_gid }}"
        backup: true
      notify: Start Vector service

- name: Install lighthouse
  hosts: lighthouse
  handlers:
    - name: Nginx reload
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted
  pre_tasks:
    - name: Lighthouse | Install git
      become: true
      ansible.builtin.yum:
        name: git
        state: present
    - name: Lighthouse | install epel-release
      become: true
      ansible.builtin.yum:
        name: epel-release
        state: present
    - name: Lighhouse | Install nginx
      become: true
      ansible.builtin.yum:
        name: nginx
        state: present
    - name: Lighthouse | Apply nginx config
      become: true
      ansible.builtin.template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
        mode: 0644
  tasks:
    - name: Lighthouse | Clone repository
      ansible.builtin.git:
        repo: "{{ lighthouse_url }}"
        dest: "{{ lighthouse_dir }}"
        version: master
    - name: Lighthouse | Apply config
      become: true
      ansible.builtin.template:
        src: lighthouse_nginx.conf.j2
        dest: /etc/nginx/conf.d/lighthouse.conf
        mode: 0644
      notify: Nginx reload
```
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
- Ответ: Используемые модули отображены в ответе на первый вопрос.

3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
- Ответ: Перечисление действий tasks отображены в ответе на первый вопрос, вывод команды ниже.
```Bash
[mag@node-centos7 playbook]$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Install Clickhouse] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "mag", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "mag", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] ********************************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] *********************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Download packages] *********************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Install packages] **********************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Apply template] ************************************************************************************************************************************************************************************
[WARNING]: The value 1000 (type int) in a string field was converted to u'1000' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
ok: [vector-01]

TASK [Vector | change systemd unit] *******************************************************************************************************************************************************************************
ok: [vector-01]

PLAY [Install lighthouse] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Install git] ***********************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | install epel-release] **************************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Lighhouse | Install nginx] **********************************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Lighthouse | Apply nginx config] ****************************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Lighthouse | Clone repository] ******************************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Lighthouse | Apply config] **********************************************************************************************************************************************************************************
changed: [lighthouse-01]

RUNNING HANDLER [Nginx reload] ************************************************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY RECAP ********************************************************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
lighthouse-01              : ok=8    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[mag@node-centos7 playbook]$
```
4. Подготовьте свой inventory-файл `prod.yml`.
- Ответ:
```Bash
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 158.160.1.75


vector:
  hosts:
    vector-01:
      ansible_host: 158.160.21.195

lighthouse:
  hosts:
    lighthouse-01:
      ansible_host: 158.160.25.133
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
- Ответ: команда **ansible-lint** ошибок не дала, вывод ниже
```Bash
[mag@node-centos7 playbook]$
[mag@node-centos7 playbook]$ ansible-lint site.yml
[mag@node-centos7 playbook]$
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```Bash
[mag@node-centos7 playbook]$ ansible-playbook site.yml -i inventory/prod.yml --check

PLAY [Install Clickhouse] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "mag", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "mag", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] ********************************************************************************************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install Vector] *********************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Download packages] *********************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Install packages] **********************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Apply template] ************************************************************************************************************************************************************************************
[WARNING]: The value 1000 (type int) in a string field was converted to u'1000' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
ok: [vector-01]

TASK [Vector | change systemd unit] *******************************************************************************************************************************************************************************
ok: [vector-01]

PLAY [Install lighthouse] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Install git] ***********************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | install epel-release] **************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighhouse | Install nginx] **********************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Apply nginx config] ****************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Clone repository] ******************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Apply config] **********************************************************************************************************************************************************************************
ok: [lighthouse-01]

PLAY RECAP ********************************************************************************************************************************************************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0
lighthouse-01              : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[mag@node-centos7 playbook]$

```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
- Ответ: так как команда **ansible-lint** не дала ошибок, я ничего не испровлял, соответственно и изменений не было.
```Bash
[mag@node-centos7 playbook]$ ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Clickhouse] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "mag", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "mag", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Clickhouse | Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] ********************************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] *********************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Download packages] *********************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Install packages] **********************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Apply template] ************************************************************************************************************************************************************************************
[WARNING]: The value 1000 (type int) in a string field was converted to u'1000' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
ok: [vector-01]

TASK [Vector | change systemd unit] *******************************************************************************************************************************************************************************
ok: [vector-01]

PLAY [Install lighthouse] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Install git] ***********************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | install epel-release] **************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighhouse | Install nginx] **********************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Apply nginx config] ****************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Clone repository] ******************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Apply config] **********************************************************************************************************************************************************************************
ok: [lighthouse-01]

PLAY RECAP ********************************************************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
lighthouse-01              : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[mag@node-centos7 playbook]$

```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
- Ответ: после запуска команды второй раз вывод такой же как и выше

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
