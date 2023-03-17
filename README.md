# Домашнее задание к занятию «Работа в терминале. Лекция 1»

### Цель задания

В результате выполнения задания вы:

* научитесь работать с базовым функционалом инструмента VirtualBox, который помогает с быстрой развёрткой виртуальных машин;
* научитесь работать с документацией в формате man, чтобы ориентироваться в этом полезном и мощном инструменте документации;
* познакомитесь с функциями Bash (PATH, HISTORY, batch/at), которые помогут комфортно работать с оболочкой командной строки (шеллом) и понять некоторые его ограничения.


### Инструкция к заданию

1. Установите средство виртуализации [Oracle VirtualBox](https://www.virtualbox.org/).
1. Установите средство автоматизации [Hashicorp Vagrant](https://hashicorp-releases.yandexcloud.net/vagrant/).
1. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал. Можно предложить:

	* iTerm2 в Mac OS X;
	* Windows Terminal в Windows;
	* выбрать цветовую схему, размер окна, шрифтов и т.д.;
	* почитать о кастомизации PS1 и применить при желании.

	Несколько популярных проблем:
	
	* добавьте Vagrant в правила исключения, перехватывающие трафик, для анализа антивирусов, таких, как Kaspersky, если у вас возникают связанные с SSL/TLS ошибки;
	* MobaXterm может конфликтовать с Vagrant в Windows;
	* Vagrant плохо работает с директориями с кириллицей (может быть вашей домашней директорией), тогда можно либо изменить [VAGRANT_HOME](https://www.vagrantup.com/docs/other/environmental-variables#vagrant_home), либо создать в системе профиль пользователя с английским именем;
	* VirtualBox конфликтует с Windows Hyper-V, и его необходимо [отключить](https://www.vagrantup.com/docs/installation#windows-virtualbox-and-hyper-v);
	* [WSL2](https://docs.microsoft.com/ru-ru/windows/wsl/wsl2-faq#does-wsl-2-use-hyper-v-will-it-be-available-on-windows-10-home) использует Hyper-V, поэтому с ним VirtualBox также несовместим;
	* аппаратная виртуализация (Intel VT-x, AMD-V) должна быть активна в BIOS;
	* в Linux при установке [VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads) может дополнительно потребоваться пакет `linux-headers-generic` (debian-based) / `kernel-devel` (rhel-based).


### Дополнительные материалы для выполнения задания

1. [Конфигурация VirtualBox через Vagrant](https://www.vagrantup.com/docs/providers/virtualbox/configuration.html).
2. [Использование условий в Bash](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html).

------

## Задание

1. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:

	* Создайте директорию, в которой будут храниться конфигурационные файлы Vagrant. В ней выполните `vagrant init`. Замените содержимое Vagrantfile по умолчанию следующим:

		```bash
		Vagrant.configure("2") do |config|
			config.vm.box = "bento/ubuntu-20.04"
		end
		```

	* Выполнение в этой директории `vagrant up` установит провайдер VirtualBox для Vagrant, скачает необходимый образ и запустит виртуальную машину.

	* `vagrant suspend` выключит виртуальную машину с сохранением её состояния — т. е. при следующем `vagrant up` будут запущены все процессы внутри, которые работали на момент вызова suspend, `vagrant halt` выключит виртуальную машину штатным образом.

1. Изучите графический интерфейс VirtualBox, посмотрите, как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы она выделила. Определите, какие ресурсы выделены по умолчанию.

Скриншот в документе "Итог ДЗ-4" в репозитории.

1. Познакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: [документация](https://www.vagrantup.com/docs/providers/virtualbox/configuration.html). Изучите, как добавить оперативную память или ресурсы процессора виртуальной машине.

config.vm.provider "virtualbox" do |v|
  v.memory = 1024
  v.cpus = 2
end


1. Команда `vagrant ssh` из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.

1. Изучите разделы `man bash`, почитайте о настройках самого bash:

    * какой переменной можно задать длину журнала `history`, и на какой строчке manual это описывается?
 Переменной HISTSIZE. это описано в строчке 747 man bash

    * что делает директива `ignoreboth` в bash?
ignoreboth - использует обе опции 'ignorespace' и 'ignoredups'
ignorespace - не сохраняет строки начинающиеся с символа <пробел>
ignoredups - не сохраняет строки, совпадающие с последней выполненной командой
    
1. В каких сценариях использования применимы скобки `{}`, на какой строчке `man bash` это описано?

При интерпритации имён файлов используются параметры, заключенные в фигурные скобки. Код заключенный в фигурные скобки может выполнть перенаправление ввода-вывода.
Вложенные блоки кода, заключенные в фигурные скобки исполняются в пределах того же процесса, что и сам скрипт.
Это описано на строке 914 man bash, раздел "Brace Expansion"

1. С учётом ответа на предыдущий вопрос подумайте, как создать однократным вызовом `touch` 100 000 файлов. Получится ли аналогичным образом создать 300 000 файлов? Если нет, то объясните, почему.

Для создания 100 000 файлов одной командо 'touch' нужно выполнить команду:
touch {1..100000}
Аналогиным образом создать 300 000 файлов без изменения ARG_MAX(увеличить выделение на выборку аргументов аргументов команды) не получиться, выдаёт ошибку:
" Слишком длинный список аргументов"

1. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`?

Конструкция [[ -d /tmp ]]вернёт 0 при наличии каталога /tmp

1. Сделайте так, чтобы в выводе команды `type -a bash` первым стояла запись с нестандартным путём, например, bash is... Используйте знания о просмотре существующих и создании новых переменных окружения, обратите внимание на переменную окружения PATH.

	```bash
	bash is /tmp/new_path_directory/bash
	bash is /usr/local/bin/bash
	bash is /bin/bash
	```

	Другие строки могут отличаться содержимым и порядком.
    В качестве ответа приведите команды, которые позволили вам добиться указанного вывода, или соответствующие скриншоты.

 mkdir /tmp/new_path_directory
 cp /bin/bash /tmp/new_path_directory/
 PATH=/tmp/new_path_directory/:$PATH


1. Чем отличается планирование команд с помощью `batch` и `at`?

batch однократно выполняет команду при факторе нагрузки системы ниже допустимого уровня (по умолчанию 1,5).
at используется для выполнения команд в заданное время.

1. Завершите работу виртуальной машины, чтобы не расходовать ресурсы компьютера или батарею ноутбука.

*В качестве решения дайте ответы на вопросы свободной форме.* 

---

### Правила приёма домашнего задания

В личном кабинете отправлена ссылка на .md-файл в вашем репозитории.

### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки.  






# Домашнее задание к занятию «Работа в терминале. Лекция 2»

### Цель задания

В результате выполнения задания вы:

* познакомитесь с возможностями некоторых команд (grep, wc), чтобы в дальнейшем обращать внимание на схожие особенности команд;
* попрактикуетесь с перенаправлением потоков ввода, вывода, ошибок, что поможет грамотно использовать функционал в скриптах;
* поработаете с файловой системой /proc как примером размещения информации о процессах.


### Инструкция к заданию

1. Создайте .md-файл для ответов на вопросы задания в своём репозитории, после выполнения прикрепите ссылку на него в личном кабинете.
2. Любые вопросы по решению задач задавайте в чате учебной группы.

------

### Дополнительные материалы для выполнения задания

1. [Статья с примерами перенаправлений в Bash и работы с файловыми дескрипторами](https://wiki.bash-hackers.org/howto/redirection_tutorial).


------

## Задание

Ответьте на вопросы:

1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа: опишите ход своих мыслей и поясните, если считаете, что она могла бы быть другого типа.

Команда cd - это shell builtin команда, то есть команда, которая вызывается напрямую в shell, а не как внешняя исполняемая. Если бы она была внешней, то запускалась бы в отдельном процессе и меняла бы директорию для этого процесса (текущий каталог shell оставался бы неизменным).

2. Какая альтернатива без pipe для команды `grep <some_string> <some_file> | wc -l`?   

	<details>
	<summary>Подсказка.</summary>

	`man grep` поможет в ответе на этот вопрос. 

	</details>
	
	Изучите [документ](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.
	
	Алтернативная команда: grep <some_string> <some_file> -c

3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
Родителем для всех процессов является процесс systemd,
Скриншот приложен в документе - Итог ДЗ-лекция в терминале 2

4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?
ls /root 2>/dev/pts/X
где /dev/pts/X - псевдотерминал другой сессии

5. Получится ли одновременно передать команде файл на stdin и вывести её stdout в другой файл? Приведите работающий пример.
Да получится: cat <test1 >test2
Скриншот приложен в документе - Итог ДЗ-лекция в терминале 2

6. Получится ли, находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
Да, можно,
echo "test" > /dev/tty1

Находясь в tty1, я увидетл отправленные данные	

7. Выполните команду `bash 5>&1`. К чему она приведёт? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?
bash 5>&1 - Создаём новый дискриптр и перенаправляем его в STDOUT
echo netology > /proc/$$/fd/5 - перенаправляем вывод команды в дискриптор 5

8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв отображение stdout на pty?  
	Напоминаем: по умолчанию через pipe передаётся только stdout команды слева от `|` на stdin команды справа.Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
Получится. Для этого нужно "поменять местами STDOUT и STDERR". Для этого применяется конструкция N>&1 1>&2 2>&N (где N - новый промежуточный дескриптор).
Например, \
nicolay@nicolay-VirtualBox:~/test$ ls /var/
backups  cache  crash  lib  local  lock  log  mail  metrics  opt  run  snap  spool  tmp
nicolay@nicolay-VirtualBox:~/test$
nicolay@nicolay-VirtualBox:~/test$
nicolay@nicolay-VirtualBox:~/test$
nicolay@nicolay-VirtualBox:~/test$ ls
test1  test2
nicolay@nicolay-VirtualBox:~/test$
nicolay@nicolay-VirtualBox:~/test$
nicolay@nicolay-VirtualBox:~/test$
nicolay@nicolay-VirtualBox:~/test$ ls /root
ls: невозможно открыть каталог '/root': Отказано в доступе
nicolay@nicolay-VirtualBox:~/test$
nicolay@nicolay-VirtualBox:~/test$ (ls /var && ls && ls /root) 3>&1 1>&2 2>&3 | wc -l
backups  cache  crash  lib  local  lock  log  mail  metrics  opt  run  snap  spool  tmp
test1  test2
1
nicolay@nicolay-VirtualBox:~/test$
В результате получили, что в pipe передается stdout с дескриптором 2 (stderr)


1.Что выведет команда `cat /proc/$$/environ`? Как ещё можно получить аналогичный по содержанию вывод?
Команда cat /proc/$$/environ выводит выведет список переменных окружения для процесса, под которой выполняется текущая оболочка bash.
Аналогичный по содержанию вывод можно получить с помощью команды: printenv


1. Используя `man`, опишите, что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.
/proc/[pid]/cmdline - файл только на чтение, который содержит строку запуска процессов, кроме зомби-процессов (строка 153)
/proc/[pid]/exe - представляет собой символическую ссылку, содержащую фактический путь к выполняемой команде (строка 200)

1. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.
sse4_2
nicolay@nicolay-VirtualBox:~/test$ grep sse /proc/cpuinfo
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni ssse3 cx16 pcid sse4_1 sse4_2 hypervisor lahf_lm pti fsgsbase md_clear flush_l1d arch_capabilities
nicolay@nicolay-VirtualBox:~/test$



1. При открытии нового окна терминала и `vagrant ssh` создаётся новая сессия и выделяется pty.  
	Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2.  
	
	Однако:

    ```bash
	vagrant@netology1:~$ ssh localhost 'tty'
	not a tty
    ```

	Почитайте, почему так происходит и как изменить поведение.
exit
По умолчанию при запуске команды через SSH не выделяется TTY. Если же не указывать команды, то TTY будет выдаваться, так как предполагается, что будет запущен сеанс оболочки. Полагаю, что изменить поведение можно через ssh localhost с последующей авторизацией и выполнением 'tty'. Либо через ssh -t localhost 'tty'

	
1. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.
Переносится после изменения /proc/sys/kernel/yama/ptrace_scope

1. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell, который запущен без `sudo` под вашим пользователем. Для решения этой проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте, что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.

tee - получает значения из stdin и записывает их в stdout и файл. Так как tee запускается отдельным процессом из-под sudo, то получая в stdin через pipe данные от echo - у нее есть права записать в файл.

----

### Правила приёма домашнего задания

В личном кабинете отправлена ссылка на .md файл в вашем репозитории.


### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки.
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	# Домашнее задание к занятию «Операционные системы. Лекция 1»

### Цель задания

В результате выполнения задания вы:

* познакомитесь с инструментом strace, который помогает отслеживать системные вызовы процессов и является необходимым для отладки и расследований при возникновении ошибок в работе программ;
* рассмотрите различные режимы работы скриптов, настраиваемые командой set. Один и тот же код в скриптах в разных режимах работы ведёт себя по-разному.

### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас установлен инструмент `strace`, выполнив команду `strace -V` для проверки версии. В Ubuntu 20.04 strace установлен, но в других дистрибутивах его может не быть в коплекте «из коробки». Обратитесь к документации дистрибутива, чтобы понять, как установить инструмент strace.
2. Убедитесь, что у вас установлен пакет `bpfcc-tools`, информация по установке [по ссылке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

### Дополнительные материалы для выполнения задания

1. Изучите документацию lsof — `man lsof`. Та же информация есть [в сети](https://linux.die.net/man/8/lsof).
2. Документация по режимам работы bash находится в `help set` или [в сети](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html).

------

## Задание

1. Какой системный вызов делает команда `cd`? 

    В прошлом ДЗ вы выяснили, что `cd` не является самостоятельной  программой. Это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае увидите полный список системных вызовов, которые делает сам `bash` при старте. 

    Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.

1. Попробуйте использовать команду `file` на объекты разных типов в файловой системе. Например:

    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    
    Используя `strace`, выясните, где находится база данных `file`, на основании которой она делает свои догадки.

1. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удалён (deleted в lsof), но сказать сигналом приложению переоткрыть файлы или просто перезапустить приложение возможности нет. Так как приложение продолжает писать в удалённый файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков, предложите способ обнуления открытого удалённого файла, чтобы освободить место на файловой системе.

1. Занимают ли зомби-процессы ресурсы в ОС (CPU, RAM, IO)?
1. В IO Visor BCC есть утилита `opensnoop`:

    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные сведения по установке [по ссылке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

1. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc` и где можно узнать версию ядра и релиз ОС.

1. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:

    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?

1. Из каких опций состоит режим bash `set -euxo pipefail`, и почему его хорошо было бы использовать в сценариях?

1. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` изучите (`/PROCESS STATE CODES`), что значат дополнительные к основной заглавной букве статуса процессов. Его можно не учитывать при расчёте (считать S, Ss или Ssl равнозначными).

----

### Правила приёма домашнего задания

В личном кабинете отправлена ссылка на .md-файл в вашем репозитории.


### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки.  
