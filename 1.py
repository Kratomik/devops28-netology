#!/usr/bin/env python3

import os

bash_command = ["cd ~/Documents/py/devops28-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(f'/home/sovar/Documents/py/devops28-netology/{prepare_result}')
