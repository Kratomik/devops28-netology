<<<<<<< HEAD
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
chdir("/tmp")                           = 0



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
/home/nicolay/.magic.mgc
/home/nicolay/.magic
/etc/magic.mgc
    Далее было обращение:
/etc/magic
/usr/share/misc/magic.mgc
	

1. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удалён (deleted в lsof), но сказать сигналом приложению переоткрыть файлы или просто перезапустить приложение возможности нет. Так как приложение продолжает писать в удалённый файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков, предложите способ обнуления открытого удалённого файла, чтобы освободить место на файловой системе.
Сделать Truncate
echo ""| sudo tee /proc/PID/fd/DESCRIPTOR,
где PID - это PID процесса, который записывает в удаленный файл, а DESRIPTOR - дескриптор, удаленного файла.

Пример,

exec 5> output.file
ping localhost >&5
rm output.file

nicolay@nicolay-VirtualBox:~$ sudo lsof | grep deleted

ping      28043                         nicolay    1w      REG                8,5    10165     393332 /home/nicolay/output.file (deleted)
ping      28043                         nicolay    5w      REG                8,5    10165     393332 /home/nicolay/output.file (deleted)

echo ""| tee /proc/28043/fd/5


1. Занимают ли зомби-процессы ресурсы в ОС (CPU, RAM, IO)?
Зомби-процессы не занимают какие-либо системные ресурсы, но сохраняют свой ID процесса (есть риск исчерпания доступных идентификаторов)
	
	
1. В IO Visor BCC есть утилита `opensnoop`:

    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные сведения по установке [по ссылке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

nicolay@nicolay-VirtualBox:~$ sudo opensnoop-bpfcc
PID    COMM               FD ERR PATH
541    NetworkManager     22   0 /var/lib/NetworkManager/timestamps.SZF611
1      systemd            18   0 /proc/6891/cgroup
1004   gsd-color          17   0 /etc/localtime
1004   gsd-color          17   0 /etc/localtime
1017   gsd-housekeepin    10   0 /etc/fstab
1017   gsd-housekeepin    10   0 /proc/self/mountinfo
1017   gsd-housekeepin    10   0 /run/mount/utab
1017   gsd-housekeepin    10   0 /proc/self/mountinfo
1017   gsd-housekeepin    10   0 /run/mount/utab



1. Какой системный вызов использует `uname -a`?
uname({sysname="Linux", nodename="nicolay-VirtualBox", ...}) = 0
uname({sysname="Linux", nodename="nicolay-VirtualBox", ...}) = 0


 Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc` и где можно узнать версию ядра и релиз ОС.	
Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.


1. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:

    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
; - выполелнение команд последовательно
&& - команда после && выполняется только если команда до && завершилась успешно (статус выхода 0)
test -d /tmp/some_dir && echo Hi - так как каталога /tmp/some_dir не существует, то статус выхода не равен 0 и echo Hi не будет выполняться
    
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?
set -e - останавливает выполнение скрипта при ошибке. Я думаю, в скриптах имеет смысл применять set -e с &&, так как она прекращает действие скрипта (не игнорирует ошибку) при ошибке в команде после &&
Пример,

echo Hi && test -d /tmp/some_dir; echo Bye
Без set -e скрипт выполнит echo Bye, а с этой командой - нет


1. Из каких опций состоит режим bash `set -euxo pipefail`, и почему его хорошо было бы использовать в сценариях?
-e  Exit immediately if a command exits with a non-zero status.
-u  Treat unset variables as an error when substituting.
-x  Print commands and their arguments as they are executed.
-o pipefail     the return value of a pipeline is the status of
                           the last command to exit with a non-zero status,
                           or zero if no command exited with a non-zero status
Данный режим обеспечит прекращение выполнения скрипта в случае ошибок и выведет необходимую для траблшутинга информацию (по сути логирование выполнения)


1. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` изучите (`/PROCESS STATE CODES`), что значат дополнительные к основной заглавной букве статуса процессов. Его можно не учитывать при расчёте (считать S, Ss или Ssl равнозначными).

nicolay@nicolay-VirtualBox:~$ ps -d -o stat | sort | uniq -c
      6 I
     32 I<
      1 R+
     34 S
      8 S+
     11 Sl
     23 Sl+
      2 SN
      1 STAT

For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group


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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	# Домашнее задание к занятию «Операционные системы. Лекция 2»

### Цель задания

В результате выполнения задания вы:

* познакомитесь со средством сбора метрик node_exporter и средством сбора и визуализации метрик NetData. Такие инструменты позволяют выстроить систему мониторинга сервисов для своевременного выявления проблем в их работе;
* построите простой systemd unit-файл для создания долгоживущих процессов, которые стартуют вместе со стартом системы автоматически;
* проанализируете dmesg, а именно часть лога старта виртуальной машины, чтобы понять, какая полезная информация может там находиться;
* поработаете с unshare и nsenter для понимания, как создать отдельный namespace для процесса (частичная контейнеризация).

### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас установлен [Netdata](https://github.com/netdata/netdata) c ресурса с предподготовленными [пакетами](https://packagecloud.io/netdata/netdata/install) или `sudo apt install -y netdata`.


### Дополнительные материалы для выполнения задания

1. [Документация](https://www.freedesktop.org/software/systemd/man/systemd.service.html) по systemd unit-файлам.
2. [Документация](https://www.kernel.org/doc/Documentation/sysctl/) по параметрам sysctl.

------

## Задание

1. На лекции вы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку;
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`);
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
	
	nicolay@nicolay-VirtualBox:~$ cat /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter --web.config=/opt/node_exporter/web.yml

[Install]
WantedBy=multi-user.target
Процесс корректно стартует, завершается, перезапускается (в том числе после ребута)
	
	● node_exporter.service - Prometheus Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2023-03-22 20:01:20 +07; 1s ago
   Main PID: 1628 (node_exporter)
      Tasks: 4 (limit: 4614)
     Memory: 1.8M
     CGroup: /system.slice/node_exporter.service
             └─1628 /usr/local/bin/node_exporter --web.config=/opt/node_exporter/web.yml

мар 22 20:01:20 nicolay-VirtualBox node_exporter[1628]: level=info ts=2023-03-22T13:01:20.823Z caller=node_exporter.go:112 collector=thermal_zone
мар 22 20:01:20 nicolay-VirtualBox node_exporter[1628]: level=info ts=2023-03-22T13:01:20.824Z caller=node_exporter.go:112 collector=time
мар 22 20:01:20 nicolay-VirtualBox node_exporter[1628]: level=info ts=2023-03-22T13:01:20.824Z caller=node_exporter.go:112 collector=timex
мар 22 20:01:20 nicolay-VirtualBox node_exporter[1628]: level=info ts=2023-03-22T13:01:20.824Z caller=node_exporter.go:112 collector=udp_queues
мар 22 20:01:20 nicolay-VirtualBox node_exporter[1628]: level=info ts=2023-03-22T13:01:20.824Z caller=node_exporter.go:112 collector=uname
мар 22 20:01:20 nicolay-VirtualBox node_exporter[1628]: level=info ts=2023-03-22T13:01:20.824Z caller=node_exporter.go:112 collector=vmstat
мар 22 20:01:20 nicolay-VirtualBox node_exporter[1628]: level=info ts=2023-03-22T13:01:20.824Z caller=node_exporter.go:112 collector=xfs
мар 22 20:01:20 nicolay-VirtualBox node_exporter[1628]: level=info ts=2023-03-22T13:01:20.824Z caller=node_exporter.go:112 collector=zfs
мар 22 20:01:20 nicolay-VirtualBox node_exporter[1628]: level=info ts=2023-03-22T13:01:20.824Z caller=node_exporter.go:191 msg="Listening on" addres>
мар 22 20:01:20 nicolay-VirtualBox node_exporter[1628]: level=info ts=2023-03-22T13:01:20.824Z caller=tls_config.go:203 msg="TLS is disabled and it >
lines 1-19/19 (END)
	
nicolay@nicolay-VirtualBox:~$ ps -e |grep node_exporter
   1628 ?        00:00:00 node_exporter

nicolay@nicolay-VirtualBox:~$ sudo cat /proc/1628/environ
LANG=ru_RU.UTF-8PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/binHOME=/home/node_exporterLOGNAME=node_exporterUSER=node_exporterINVOCATION_ID=bd73851af9aa4bedadbe07310d976422JOURNAL_STREAM=8:36350nicolay	

1. Изучите опции node_exporter и вывод `/metrics` по умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
	
	Для CPU (для каждого из возможных ядер)
node_cpu_seconds_total{cpu="0",mode="idle"}
node_cpu_seconds_total{cpu="0",mode="system"}
node_cpu_seconds_total{cpu="0",mode="user"}
process_cpu_seconds_total

	Для ОЗУ
node_memory_MemAvailable_bytes
node_memory_MemFree_bytes
node_memory_Buffers_bytes
node_memory_Cached_bytes

	По дискам (выбрать необходимые диски)
node_disk_io_time_seconds_total{device="sda"}
node_disk_read_time_seconds_total{device="sda"}
node_disk_write_time_seconds_total{device="sda"}
node_filesystem_avail_bytes

	По сети
node_network_info
node_network_receive_bytes_total
node_network_receive_errs_total
node_network_transmit_bytes_total
node_network_transmit_errs_total

1. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). 
   
   После успешной установки:
   
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`;
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере на своём ПК (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata, и с комментариями, которые даны к этим метрикам.
	
	nicolay@nicolay-VirtualBox:~$ sudo ss -tulpn | grep :19999
tcp     LISTEN   0        4096             0.0.0.0:19999          0.0.0.0:*      users:(("netdata",pid=690,fd=4)) 
	

1. Можно ли по выводу `dmesg` понять, осознаёт ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
	nicolay@nicolay-VirtualBox:~$ dmesg | grep -i virtual
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[    0.002958] CPU MTRRs all blank - virtualized system.
[    0.025949] Booting paravirtualized kernel on KVM
[    1.619009] usb 1-1: Manufacturer: VirtualBox
[    1.823675] input: VirtualBox USB Tablet as /devices/pci0000:00/0000:00:06.0/usb1/1-1/1-1:1.0/0003:80EE:0021.0001/input/input6
[    1.823858] hid-generic 0003:80EE:0021.0001: input,hidraw0: USB HID v1.10 Mouse [VirtualBox USB Tablet] on usb-0000:00:06.0-1/input0
[    3.001490] systemd[1]: Detected virtualization oracle.
[    3.004070] systemd[1]: Set hostname to <nicolay-VirtualBox>.
[    6.022016] input: VirtualBox mouse integration as /devices/pci0000:00/0000:00:04.0/input/input7

	

1. Как настроен sysctl `fs.nr_open` на системе по умолчанию? Определите, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
	nicolay@nicolay-VirtualBox:~$ /sbin/sysctl -n fs.nr_open
1048576
nr_open - означает максимальное число дескрипторов, которые может использовать процесс. Но этого значения не дает достичь другой лимит:

nicolay@nicolay-VirtualBox:~$ ulimit -n
1024
	
	
1. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в этом задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т. д.

nicolay@nicolay-VirtualBox:~$ sudo unshare -f --pid --mount-proc sleep 1h
nicolay@nicolay-VirtualBox:~$ ps -aux | grep sleep
root        1664  0.0  0.0  16716   576 pts/0    S    20:22   0:00 sleep 1h
root        1669  0.0  0.0  16716   512 pts/0    S    20:23   0:00 sleep 1h
root        1809  0.0  0.1  20624  4764 pts/0    S+   20:34   0:00 sudo unshare -f --pid --mount-proc sleep 1h
root        1810  0.0  0.0  16720   516 pts/0    S+   20:34   0:00 unshare -f --pid --mount-proc sleep 1h
root        1811  0.0  0.0  16716   580 pts/0    S+   20:34   0:00 sleep 1h
nicolay     1880  0.0  0.0  17696   712 pts/1    S+   20:34   0:00 grep --color=auto sleep

nicolay@nicolay-VirtualBox:/proc$ sudo nsenter --target 1811 --pid --mount
root@nicolay-VirtualBox:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0  16716   580 pts/0    S+   20:34   0:00 sleep 1h
root           2  0.2  0.1  19236  4916 pts/2    S    20:38   0:00 -bash
root          11  0.0  0.0  20160  3388 pts/2    R+   20:39   0:00 ps aux



1. Найдите информацию о том, что такое `:(){ :|:& };:`.
 Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время всё будет плохо, после чего (спустя минуты) — ОС должна стабилизироваться.
fork-бомба — вредоносная или ошибочно написанная программа, бесконечно создающая свои копии (системным вызовом fork()), которые обычно также начинают создавать свои копии и т. д.
Выполнение такой программы может вызывать большую нагрузку вычислительной системы или даже отказ в обслуживании вследствие нехватки системных ресурсов (дескрипторов процессов, памяти, процессорного времени), что и является целью.


 Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации.  
Как настроен этот механизм по умолчанию, и как изменить число процессов, которое можно создать в сессии?
[ 5667.545996] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-6.scope

nicolay@nicolay-VirtualBox:~$ ulimit -u
15380

nicolay@nicolay-VirtualBox:~$ ulimit -u 500

*В качестве решения отправьте ответы на вопросы и опишите, как эти ответы были получены.*

----

### Правила приёма домашнего задания

В личном кабинете отправлена ссылка на .md-файл в вашем репозитории.

-----

### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки. 
	
	
	
	
	
	
	
	
	
	
	
# Домашнее задание к занятию «Файловые системы»

### Цель задания

В результате выполнения задания вы: 

* научитесь работать с инструментами разметки жёстких дисков, виртуальных разделов — RAID-массивами и логическими томами, конфигурациями файловых систем. Основная задача — понять, какие слои абстракций могут нас отделять от файловой системы до железа. Обычно инженер инфраструктуры не сталкивается напрямую с настройкой LVM или RAID, но иметь понимание, как это работает, необходимо;
* создадите нештатную ситуацию работы жёстких дисков и поймёте, как система RAID обеспечивает отказоустойчивую работу.


### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас на новой виртуальной машине  установлены утилиты: `mdadm`, `fdisk`, `sfdisk`, `mkfs`, `lsblk`, `wget` (шаг 3 в задании).  
2. Воспользуйтесь пакетным менеджером apt для установки необходимых инструментов.


### Дополнительные материалы для выполнения задания

1. Разряженные файлы — [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB).
2. [Подробный анализ производительности RAID](https://www.baarf.dk/BAARF/0.Millsap1996.08.21-VLDB.pdf), страницы 3–19.
3. [RAID5 write hole](https://www.intel.com/content/www/us/en/support/articles/000057368/memory-and-storage.html).


------

## Задание

1) Узнайте о [sparse-файлах](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных).

**Разреженные файлы** - это файлы, для которых выделяется пространство на диске только для участков с ненулевыми данными.
Список всех "дыр" хранится в метаданных ФС и используется при операциях с файлами.
В результате получается, что разреженный файл занимает меньше места на диске (более эффективное использование дискового пространства)

2) Могут ли файлы, являющиеся жёсткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Не могут, такие жесткие ссылки имеют один и тот же inode (объект, который содержит метаданные файла).

3) Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```ruby
    path_to_disk_folder = './disks'

    host_params = {
        'disk_size' => 2560,
        'disks'=>[1, 2],
        'cpus'=>2,
        'memory'=>2048,
        'hostname'=>'sysadm-fs',
        'vm_name'=>'sysadm-fs'
    }
    Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
        config.vm.hostname=host_params['hostname']
        config.vm.provider :virtualbox do |v|

            v.name=host_params['vm_name']
            v.cpus=host_params['cpus']
            v.memory=host_params['memory']

            host_params['disks'].each do |disk|
                file_to_disk=path_to_disk_folder+'/disk'+disk.to_s+'.vdi'
                unless File.exist?(file_to_disk)
                    v.customize ['createmedium', '--filename', file_to_disk, '--size', host_params['disk_size']]
                    v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', disk.to_s, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
                end
            end
        end
        config.vm.network "private_network", type: "dhcp"
    end
    ```

    Эта конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2,5 Гб.
```bash	
nicolay@nicolay-VirtualBox:~$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0    7:0    0     4K  1 loop /snap/bare/5
loop1    7:1    0 346,3M  1 loop /snap/gnome-3-38-2004/115
loop2    7:2    0  63,3M  1 loop /snap/core20/1828
loop3    7:3    0 346,3M  1 loop /snap/gnome-3-38-2004/119
loop4    7:4    0  63,3M  1 loop /snap/core20/1852
loop5    7:5    0  91,7M  1 loop /snap/gtk-common-themes/1535
loop6    7:6    0  54,2M  1 loop /snap/snap-store/558
loop7    7:7    0    46M  1 loop /snap/snap-store/638
loop8    7:8    0  49,9M  1 loop /snap/snapd/18357
loop9    7:9    0  49,9M  1 loop /snap/snapd/18596
sda      8:0    0    50G  0 disk
├─sda1   8:1    0   512M  0 part /boot/efi
├─sda2   8:2    0     1K  0 part
└─sda5   8:5    0  49,5G  0 part /
sdb      8:16   0   2,5G  0 disk
sdc      8:32   0   2,5G  0 disk
```	

4) Используя `fdisk`, разбейте первый диск на два раздела: 2 Гб и оставшееся пространство.
```bash	
nicolay@nicolay-VirtualBox:~$ sudo fdisk /dev/sdb

Добро пожаловать в fdisk (util-linux 2.34).
Изменения останутся только в памяти до тех пор, пока вы не решите записать их.
Будьте внимательны, используя команду write.

Устройство не содержит стандартной таблицы разделов.
Создана новая метка DOS с идентификатором 0x8c7bac1d.

Команда (m для справки): n
Тип раздела
   p   основной (0 первичный, 0 расширеный, 4 свободно)
   e   расширенный (контейнер для логических разделов)
Выберите (по умолчанию - p): p
Номер раздела (1-4, по умолчанию 1):
Первый сектор (2048-5242879, по умолчанию 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, по умолчанию 5242879): +2G

Создан новый раздел 1 с типом 'Linux' и размером 2 GiB.

Команда (m для справки): n
Тип раздела
   p   основной (1 первичный, 0 расширеный, 3 свободно)
   e   расширенный (контейнер для логических разделов)
Выберите (по умолчанию - p):

Используется ответ по умолчанию p
Номер раздела (2-4, по умолчанию 2):
Первый сектор (4196352-5242879, по умолчанию 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, по умолчанию 5242879):

Создан новый раздел 2 с типом 'Linux' и размером 511 MiB.

Команда (m для справки): w
Таблица разделов была изменена.
Вызывается ioctl() для перечитывания таблицы разделов.
Синхронизируются диски.

nicolay@nicolay-VirtualBox:~$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0    7:0    0     4K  1 loop /snap/bare/5
loop1    7:1    0 346,3M  1 loop /snap/gnome-3-38-2004/115
loop2    7:2    0  63,3M  1 loop /snap/core20/1828
loop3    7:3    0 346,3M  1 loop /snap/gnome-3-38-2004/119
loop4    7:4    0  63,3M  1 loop /snap/core20/1852
loop5    7:5    0  91,7M  1 loop /snap/gtk-common-themes/1535
loop6    7:6    0  54,2M  1 loop /snap/snap-store/558
loop7    7:7    0    46M  1 loop /snap/snap-store/638
loop8    7:8    0  49,9M  1 loop /snap/snapd/18357
loop9    7:9    0  49,9M  1 loop /snap/snapd/18596
sda      8:0    0    50G  0 disk
├─sda1   8:1    0   512M  0 part /boot/efi
├─sda2   8:2    0     1K  0 part
└─sda5   8:5    0  49,5G  0 part /
sdb      8:16   0   2,5G  0 disk
├─sdb1   8:17   0     2G  0 part
└─sdb2   8:18   0   511M  0 part
sdc      8:32   0   2,5G  0 disk
```

5) Используя `sfdisk`, перенесите эту таблицу разделов на второй диск.	
```bash
nicolay@nicolay-VirtualBox:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc
Проверяется, чтобы сейчас никто не использовал этот диск... ОК

Диск /dev/sdc: 2,51 GiB, 2684354560 байт, 5242880 секторов
Disk model: VBOX HARDDISK
Единицы: секторов по 1 * 512 = 512 байт
Размер сектора (логический/физический): 512 байт / 512 байт
Размер I/O (минимальный/оптимальный): 512 байт / 512 байт

>>> Заголовок скрипта принят.
>>> Заголовок скрипта принят.
>>> Заголовок скрипта принят.
>>> Заголовок скрипта принят.
>>> Создана новая метка DOS с идентификатором 0x8c7bac1d.
/dev/sdc1: Создан новый раздел 1 с типом 'Linux' и размером 2 GiB.
/dev/sdc2: Создан новый раздел 2 с типом 'Linux' и размером 511 MiB.
/dev/sdc3: Готово.

Новая ситуация:
Тип метки диска: dos
Идентификатор диска: 0x8c7bac1d

Устр-во    Загрузочный  начало   Конец Секторы Размер Идентификатор Тип
/dev/sdc1                 2048 4196351 4194304     2G            83 Linux
/dev/sdc2              4196352 5242879 1046528   511M            83 Linux

Таблица разделов была изменена
Вызывается ioctl() для перечитывания таблицы разделов.
Синхронизируются диски.

nicolay@nicolay-VirtualBox:~$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0    7:0    0     4K  1 loop /snap/bare/5
loop1    7:1    0 346,3M  1 loop /snap/gnome-3-38-2004/115
loop2    7:2    0  63,3M  1 loop /snap/core20/1828
loop3    7:3    0 346,3M  1 loop /snap/gnome-3-38-2004/119
loop4    7:4    0  63,3M  1 loop /snap/core20/1852
loop5    7:5    0  91,7M  1 loop /snap/gtk-common-themes/1535
loop6    7:6    0  54,2M  1 loop /snap/snap-store/558
loop7    7:7    0    46M  1 loop /snap/snap-store/638
loop8    7:8    0  49,9M  1 loop /snap/snapd/18357
loop9    7:9    0  49,9M  1 loop /snap/snapd/18596
sda      8:0    0    50G  0 disk
├─sda1   8:1    0   512M  0 part /boot/efi
├─sda2   8:2    0     1K  0 part
└─sda5   8:5    0  49,5G  0 part /
sdb      8:16   0   2,5G  0 disk
├─sdb1   8:17   0     2G  0 part
└─sdb2   8:18   0   511M  0 part
sdc      8:32   0   2,5G  0 disk
├─sdc1   8:33   0     2G  0 part
└─sdc2   8:34   0   511M  0 part
```
6) Соберите `mdadm` RAID1 на паре разделов 2 Гб.
```bash
nicolay@nicolay-VirtualBox:~$ sudo mdadm --create /dev/md0 -l 1 -n 2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
may not be suitable as a boot device.  If you plan to
store '/boot' on this device please ensure that
your boot-loader understands md/v1.x metadata, or use
--metadata=0.90
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```
7) Соберите `mdadm` RAID0 на второй паре маленьких разделов.
```bash
nicolay@nicolay-VirtualBox:~$ sudo mdadm --create /dev/md1 -l 0 -n 2 /dev/sdb2 /dev/sdc2
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.

nicolay@nicolay-VirtualBox:~$ lsblk
NAME    MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
loop0     7:0    0     4K  1 loop  /snap/bare/5
loop1     7:1    0 346,3M  1 loop  /snap/gnome-3-38-2004/115
loop2     7:2    0  63,3M  1 loop  /snap/core20/1828
loop3     7:3    0 346,3M  1 loop  /snap/gnome-3-38-2004/119
loop4     7:4    0  63,3M  1 loop  /snap/core20/1852
loop5     7:5    0  91,7M  1 loop  /snap/gtk-common-themes/1535
loop6     7:6    0  54,2M  1 loop  /snap/snap-store/558
loop7     7:7    0    46M  1 loop  /snap/snap-store/638
loop8     7:8    0  49,9M  1 loop  /snap/snapd/18357
loop9     7:9    0  49,9M  1 loop  /snap/snapd/18596
sda       8:0    0    50G  0 disk
├─sda1    8:1    0   512M  0 part  /boot/efi
├─sda2    8:2    0     1K  0 part
└─sda5    8:5    0  49,5G  0 part  /
sdb       8:16   0   2,5G  0 disk
├─sdb1    8:17   0     2G  0 part
│ └─md0   9:0    0     2G  0 raid1
└─sdb2    8:18   0   511M  0 part
  └─md1   9:1    0  1018M  0 raid0
sdc       8:32   0   2,5G  0 disk
├─sdc1    8:33   0     2G  0 part
│ └─md0   9:0    0     2G  0 raid1
└─sdc2    8:34   0   511M  0 part
  └─md1   9:1    0  1018M  0 raid0
```
8) Создайте два независимых PV на получившихся md-устройствах.
```bash
nicolay@nicolay-VirtualBox:~$ sudo pvcreate /dev/md1 /dev/md0
Physical volume "/dev/md1" successfully created.
Physical volume "/dev/md0" successfully created.
nicolay@nicolay-VirtualBox:~$ sudo pvscan
PV /dev/md0                      lvm2 [<2,00 GiB]
PV /dev/md1                      lvm2 [1018,00 MiB]
Total: 2 [2,99 GiB] / in use: 0 [0   ] / in no VG: 2 [2,99 GiB]
```
9) Создайте общую volume-group на этих двух PV.
```bash
nicolay@nicolay-VirtualBox:~$ sudo vgcreate VG1 /dev/md0 /dev/md1
Volume group "VG1" successfully created
nicolay@nicolay-VirtualBox:~$ sudo vgscan
Found volume group "VG1" using metadata type lvm2

nicolay@nicolay-VirtualBox:~$ sudo pvdisplay
  --- Physical volume ---
  PV Name               /dev/md0
  VG Name               VG1
  PV Size               <2,00 GiB / not usable 0
  Allocatable           yes
  PE Size               4,00 MiB
  Total PE              511
  Free PE               511
  Allocated PE          0
  PV UUID               WvgmRg-fyyk-K3Xi-0sVG-brv1-hNVY-chcULk

  --- Physical volume ---
  PV Name               /dev/md1
  VG Name               VG1
  PV Size               1018,00 MiB / not usable 2,00 MiB
  Allocatable           yes
  PE Size               4,00 MiB
  Total PE              254
  Free PE               254
  Allocated PE          0
  PV UUID               9WyUe1-XlOI-IiJg-0nY4-6FtP-s5x5-ZC7Ihz
```
10) Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
```bash
nicolay@nicolay-VirtualBox:~$ sudo lvcreate -L 100M -n LV1 VG1 /dev/md1
  Logical volume "LV1" created.

nicolay@nicolay-VirtualBox:~$ lsblk
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
loop0           7:0    0     4K  1 loop  /snap/bare/5
loop1           7:1    0 346,3M  1 loop  /snap/gnome-3-38-2004/115
loop2           7:2    0  63,3M  1 loop  /snap/core20/1828
loop3           7:3    0 346,3M  1 loop  /snap/gnome-3-38-2004/119
loop4           7:4    0  63,3M  1 loop  /snap/core20/1852
loop5           7:5    0  91,7M  1 loop  /snap/gtk-common-themes/1535
loop6           7:6    0  54,2M  1 loop  /snap/snap-store/558
loop7           7:7    0    46M  1 loop  /snap/snap-store/638
loop8           7:8    0  49,9M  1 loop  /snap/snapd/18357
loop9           7:9    0  49,9M  1 loop  /snap/snapd/18596
sda             8:0    0    50G  0 disk
├─sda1          8:1    0   512M  0 part  /boot/efi
├─sda2          8:2    0     1K  0 part
└─sda5          8:5    0  49,5G  0 part  /
sdb             8:16   0   2,5G  0 disk
├─sdb1          8:17   0     2G  0 part
│ └─md0         9:0    0     2G  0 raid1
└─sdb2          8:18   0   511M  0 part
  └─md1         9:1    0  1018M  0 raid0
    └─VG1-LV1 253:0    0   100M  0 lvm
sdc             8:32   0   2,5G  0 disk
├─sdc1          8:33   0     2G  0 part
│ └─md0         9:0    0     2G  0 raid1
└─sdc2          8:34   0   511M  0 part
  └─md1         9:1    0  1018M  0 raid0
    └─VG1-LV1 253:0    0   100M  0 lvm
```
11) Создайте `mkfs.ext4` ФС на получившемся LV.
```bash
nicolay@nicolay-VirtualBox:~$ sudo mkfs.ext4 /dev/VG1/LV1
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Сохранение таблицы inod'ов: done
Создание журнала (1024 блоков): готово
Writing superblocks and filesystem accounting information: готово
```
12) Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
```bash
nicolay@nicolay-VirtualBox:~$ mkdir /tmp/new
nicolay@nicolay-VirtualBox:~$ sudo mount /dev/VG1/LV1 /tmp/new
```
13) Поместите туда тестовый файл, например, `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
```bash
nicolay@nicolay-VirtualBox:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2023-03-26 19:54:15--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Распознаётся mirror.yandex.ru (mirror.yandex.ru)… 213.180.204.183, 2a02:6b8::183
Подключение к mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... соединение установлено.
HTTP-запрос отправлен. Ожидание ответа… 200 OK
Длина: 24587067 (23M) [application/octet-stream]
Сохранение в: «/tmp/new/test.gz»

/tmp/new/test.gz                      100%[======================================================================>]  23,45M  4,89MB/s    за 4,8s

2023-03-26 19:54:20 (4,85 MB/s) - «/tmp/new/test.gz» сохранён [24587067/24587067]
```
14) Прикрепите вывод `lsblk`.
```bash
nicolay@nicolay-VirtualBox:~$ lsblk
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
loop0           7:0    0     4K  1 loop  /snap/bare/5
loop1           7:1    0 346,3M  1 loop  /snap/gnome-3-38-2004/115
loop2           7:2    0  63,3M  1 loop  /snap/core20/1828
loop3           7:3    0 346,3M  1 loop  /snap/gnome-3-38-2004/119
loop4           7:4    0  63,3M  1 loop  /snap/core20/1852
loop5           7:5    0  91,7M  1 loop  /snap/gtk-common-themes/1535
loop6           7:6    0  54,2M  1 loop  /snap/snap-store/558
loop7           7:7    0    46M  1 loop  /snap/snap-store/638
loop8           7:8    0  49,9M  1 loop  /snap/snapd/18357
loop9           7:9    0  49,9M  1 loop  /snap/snapd/18596
sda             8:0    0    50G  0 disk
├─sda1          8:1    0   512M  0 part  /boot/efi
├─sda2          8:2    0     1K  0 part
└─sda5          8:5    0  49,5G  0 part  /
sdb             8:16   0   2,5G  0 disk
├─sdb1          8:17   0     2G  0 part
│ └─md0         9:0    0     2G  0 raid1
└─sdb2          8:18   0   511M  0 part
  └─md1         9:1    0  1018M  0 raid0
    └─VG1-LV1 253:0    0   100M  0 lvm   /tmp/new
sdc             8:32   0   2,5G  0 disk
├─sdc1          8:33   0     2G  0 part
│ └─md0         9:0    0     2G  0 raid1
└─sdc2          8:34   0   511M  0 part
  └─md1         9:1    0  1018M  0 raid0
    └─VG1-LV1 253:0    0   100M  0 lvm   /tmp/new
```
15) Протестируйте целостность файла:
```bash
nicolay@nicolay-VirtualBox:~$ gzip -t /tmp/new/test.gz
nicolay@nicolay-VirtualBox:~$ echo $?
0
```
16) Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
```bash
nicolay@nicolay-VirtualBox:~$ sudo pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 4,00%
  /dev/md1: Moved: 100,00%
nicolay@nicolay-VirtualBox:~$ lsblk
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
loop0           7:0    0     4K  1 loop  /snap/bare/5
loop1           7:1    0 346,3M  1 loop  /snap/gnome-3-38-2004/115
loop2           7:2    0  63,3M  1 loop  /snap/core20/1828
loop3           7:3    0 346,3M  1 loop  /snap/gnome-3-38-2004/119
loop4           7:4    0  63,3M  1 loop  /snap/core20/1852
loop5           7:5    0  91,7M  1 loop  /snap/gtk-common-themes/1535
loop6           7:6    0  54,2M  1 loop  /snap/snap-store/558
loop7           7:7    0    46M  1 loop  /snap/snap-store/638
loop8           7:8    0  49,9M  1 loop  /snap/snapd/18357
loop9           7:9    0  49,9M  1 loop  /snap/snapd/18596
sda             8:0    0    50G  0 disk
├─sda1          8:1    0   512M  0 part  /boot/efi
├─sda2          8:2    0     1K  0 part
└─sda5          8:5    0  49,5G  0 part  /
sdb             8:16   0   2,5G  0 disk
├─sdb1          8:17   0     2G  0 part
│ └─md0         9:0    0     2G  0 raid1
│   └─VG1-LV1 253:0    0   100M  0 lvm   /tmp/new
└─sdb2          8:18   0   511M  0 part
  └─md1         9:1    0  1018M  0 raid0
sdc             8:32   0   2,5G  0 disk
├─sdc1          8:33   0     2G  0 part
│ └─md0         9:0    0     2G  0 raid1
│   └─VG1-LV1 253:0    0   100M  0 lvm   /tmp/new
└─sdc2          8:34   0   511M  0 part
  └─md1         9:1    0  1018M  0 raid0
```
17) Сделайте `--fail` на устройство в вашем RAID1 md.
```bash
nicolay@nicolay-VirtualBox:~$ sudo mdadm /dev/md0 -f /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md0
```
18) Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
```bash
[ 1014.562238] md/raid1:md0: not clean -- starting background reconstruction
[ 1014.562247] md/raid1:md0: active with 2 out of 2 mirrors
[ 1014.562331] md0: detected capacity change from 0 to 4188160
[ 1014.565354] md: resync of RAID array md0
[ 1055.654710] md: md0: resync done.
[ 1068.428013] md1: detected capacity change from 0 to 2084864
[ 1289.331906] lvm2-activation-generator: lvmconfig failed
[ 1289.953041] lvm2-activation-generator: lvmconfig failed
[ 2013.213756] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null). Quota mode: none.
[ 2013.213808] ext4 filesystem being mounted at /tmp/new supports timestamps until 2038 (0x7fffffff)
[ 2459.640995] dm-1: detected capacity change from 204800 to 8192
[ 2623.941318] md/raid1:md0: Disk failure on sdc1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
```
19) Протестируйте целостность файла — он должен быть доступен несмотря на «сбойный» диск:
```bash
nicolay@nicolay-VirtualBox:~$ gzip -t /tmp/new/test.gz
nicolay@nicolay-VirtualBox:~$ echo $?
0
```
20) Погасите тестовый хост — `vagrant destroy`.
 
*В качестве решения пришлите ответы на вопросы и опишите, как они были получены.*

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



	
# Домашнее задание к занятию «Компьютерные сети. Лекция 1»

### Цель задания

В результате выполнения задания вы: 

* научитесь работать с HTTP-запросами, чтобы увидеть, как клиенты взаимодействуют с серверами по этому протоколу;
* поработаете с сетевыми утилитами, чтобы разобраться, как их можно использовать для отладки сетевых запросов, соединений.

### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас установлены необходимые сетевые утилиты — dig, traceroute, mtr, telnet.
2. Используйте `apt install` для установки пакетов.


### Инструкция к заданию

1. Создайте .md-файл для ответов на вопросы задания в своём репозитории, после выполнения прикрепите ссылку на него в личном кабинете.
2. Любые вопросы по выполнению заданий задавайте в чате учебной группы или в разделе «Вопросы по заданию» в личном кабинете.


### Дополнительные материалы для выполнения задания

1. Полезным дополнением к обозначенным выше утилитам будет пакет net-tools. Установить его можно с помощью команды `apt install net-tools`.
2. RFC протокола HTTP/1.0, в частности [страница с кодами ответа](https://www.rfc-editor.org/rfc/rfc1945#page-32).
3. [Ссылки на другие RFC для HTTP](https://blog.cloudflare.com/cloudflare-view-http3-usage/).

------

## Задание

**Шаг 1.** Работа c HTTP через telnet.

- Подключитесь утилитой telnet к сайту stackoverflow.com:

`telnet stackoverflow.com 80`
 
- Отправьте HTTP-запрос:

```bash
nicolay@nicolay-VirtualBox:/etc$ telnet stackoverflow.com 80
Trying 151.101.1.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 403 Forbidden
Connection: close
Content-Length: 1921
Server: Varnish
Retry-After: 0
Content-Type: text/html
Accept-Ranges: bytes
Date: Sun, 02 Apr 2023 04:21:16 GMT
Via: 1.1 varnish
X-Served-By: cache-fra-eddf8230037-FRA
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1680409277.841161,VS0,VE1
X-DNS-Prefetch-Control: off

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Forbidden - Stack Exchange</title>
    <style type="text/css">
                body
                {
                        color: #333;
                        font-family: 'Helvetica Neue', Arial, sans-serif;
                        font-size: 14px;
                        background: #fff url('img/bg-noise.png') repeat left top;
                        line-height: 1.4;
                }
                h1
                {
                        font-size: 170%;
                        line-height: 34px;
                        font-weight: normal;
                }
                a { color: #366fb3; }
                a:visited { color: #12457c; }
                .wrapper {
                        width:960px;
                        margin: 100px auto;
                        text-align:left;
                }
                .msg {
                        float: left;
                        width: 700px;
                        padding-top: 18px;
                        margin-left: 18px;
                }
    </style>
</head>
<body>
    <div class="wrapper">
                <div style="float: left;">
                        <img src="https://cdn.sstatic.net/stackexchange/img/apple-touch-icon.png" alt="Stack Exchange" />
                </div>
                <div class="msg">
                        <h1>Access Denied</h1>
                        <p>This IP address (95.170.131.174) has been blocked from access to our services. If you believe this to be in error, please contact us at <a href="mailto:team@stackexchange.com?Subject=Blocked%2095.170.131.174%20(Request%20ID%3A%20967390246-FRA)">team@stackexchange.com</a>.</p>
                        <p>When contacting us, please include the following information in the email:</p>
                        <p>Method: block</p>
                        <p>XID: 967390246-FRA</p>
                        <p>IP: 95.170.131.174</p>
                        <p>X-Forwarded-For: </p>
                        <p>User-Agent: </p>

                        <p>Time: Sun, 02 Apr 2023 04:21:16 GMT</p>
                        <p>URL: stackoverflow.com/questions</p>
                        <p>Browser Location: <span id="jslocation">(not loaded)</span></p>
                </div>
        </div>
        <script>document.getElementById('jslocation').innerHTML = window.location.href;</script>
</body>
</html>Connection closed by foreign host.

```
*Получен ответ HTTP/1.1 403 Forbidden. Доступ к запрошенному ресурсу запрещён.*
	
**Шаг 2.** Повторите задание 1 в браузере, используя консоль разработчика F12:
Первый ответ сервера HTTP 307 Internal Redirect
```bash
URL запроса: http://stackoverflow.com/
Метод запроса: GET
Код статуса: 307 Internal Redirect
Правило для URL перехода: strict-origin-when-cross-origin
Location: https://stackoverflow.com/
Non-Authoritative-Reason: HSTS
```
Этот код означает, что ресурс был временно перемещён в URL, указанный в Location (https://stackoverflow.com/). При этом для перенаправленного запроса тело и метод запроса не будут изменены.
```bash	
Страница была загружена за 1.07 сек Самый долгий запрос
https://cdn.sstatic.net/Img/product/teams/microsoft-integration/microsoft-teams-logo.svg?v=00361aadd408
```
Скриншот приложен в файле Итог ДЗ-компьтерные сети лекция 1
	
**Шаг 3.** Какой IP-адрес у вас в интернете?
Из сооброжений безопасности полный ip говорить не буду хоть он и не белый
37.78.х.х

**Шаг 4.** Какому провайдеру принадлежит ваш IP-адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`.
Провайдер "Ростелеком", AS12389
```bash
nicolay@nicolay-VirtualBox:~$ whois -h whois.radb.net 37.78.x.x
route:          37.78.0.0/16
descr:          PAO Rostelecom, Macroregional Branch South, Krasnodar, BRAS
origin:         AS12389
mnt-by:         STC-MNT
mnt-by:         ROSTELECOM-MNT
created:        2015-11-24T04:39:44Z
last-modified:  2015-11-24T04:39:44Z
source:         RIPE
remarks:        ****************************
remarks:        * THIS OBJECT IS MODIFIED
remarks:        * Please note that all data that is generally regarded as personal
remarks:        * data has been removed from this object.
remarks:        * To view the original object, please query the RIPE Database at:
remarks:        * http://www.ripe.net/whois
remarks:        ****************************
```
**Шаг 5.** Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`.
```bash
nicolay@nicolay-VirtualBox:~$ traceroute -AnI 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  192.168.13.254 [*]  8.850 ms  0.695 ms  0.824 ms
 2  192.168.15.253 [*]  0.723 ms  0.618 ms  0.684 ms
 3  91.201.72.225 [AS25549]  1.977 ms  1.994 ms  1.674 ms
 4  10.128.24.145 [*]  1.342 ms  1.506 ms  3.280 ms
 5  194.226.100.92 [*]  155.371 ms  154.865 ms  154.508 ms
 6  74.125.244.180 [AS15169]  55.283 ms  55.559 ms  55.216 ms
 7  216.239.48.163 [AS15169]  64.993 ms  64.673 ms  64.350 ms
 8  172.253.51.223 [AS15169]  60.652 ms  60.333 ms  60.012 ms
 9  * * *
10  * * *
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  8.8.8.8 [AS15169/AS263411]  58.428 ms  59.819 ms  58.795 ms
```

**Шаг 6.** Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка — delay?
```bash
nicolay-VirtualBox (192.168.12.200)                                                                                         2023-04-02T13:08:31+0700
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                            Packets               Pings
 Host                                                                                                     Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. AS???    192.168.13.254                                                                                0.0%    13    0.7  13.5   0.7  72.5  25.2
 2. AS???    192.168.15.253                                                                                0.0%    13    0.8   1.1   0.7   3.5   0.8
 3. AS25549  91.201.72.225                                                                                 0.0%    13    1.5   1.8   1.4   2.6   0.3
 4. AS???    10.128.24.145                                                                                 0.0%    13    2.3   1.7   1.3   2.3   0.3
 5. AS???    194.226.100.92                                                                                0.0%    12   55.6  55.9  55.1  61.4   1.8
 6. AS15169  74.125.244.180                                                                                0.0%    12   55.4  57.1  55.3  63.5   2.8
 7. AS15169  216.239.48.163                                                                                0.0%    12   58.0 507.7  57.0 1695. 651.5
 8. AS15169  172.253.51.223                                                                                0.0%    12   59.9  60.1  59.8  60.6   0.3
 9. (waiting for reply)
10. (waiting for reply)
11. (waiting for reply)
12. (waiting for reply)
13. (waiting for reply)
14. (waiting for reply)
15. (waiting for reply)
16. (waiting for reply)
17. (waiting for reply)
18. (waiting for reply)
19. (waiting for reply)
20. AS15169  8.8.8.8                                                                                       0.0%    12   58.8  58.8  58.4  60.7   0.6
```
Небольшая задержка на AS15169  172.253.51.223

**Шаг 7.** Какие DNS-сервера отвечают за доменное имя dns.google? Какие A-записи? Воспользуйтесь утилитой `dig`.
```bash
nicolay@nicolay-VirtualBox:~$  dig +short NS dns.google
ns1.zdns.google.
ns2.zdns.google.
ns3.zdns.google.
ns4.zdns.google.
	
nicolay@nicolay-VirtualBox:~$  dig +short A dns.google
8.8.4.4
8.8.8.8
```

**Шаг 8.** Проверьте PTR записи для IP-адресов из задания 7. Какое доменное имя привязано к IP? Воспользуйтесь утилитой `dig`.
```bash
nicolay@nicolay-VirtualBox:~$ dig +noall +answer -x 8.8.8.8
8.8.8.8.in-addr.arpa.   5999    IN      PTR     dns.google.

nicolay@nicolay-VirtualBox:~$ dig +noall +answer -x 8.8.4.4
4.4.8.8.in-addr.arpa.   85576   IN      PTR     dns.google.
```

*В качестве ответов на вопросы приложите лог выполнения команд в консоли или скриншот полученных результатов.*

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
	
	
	
# Домашнее задание к занятию «Командная оболочка Bash: Практические навыки»

### Цель задания

В результате выполнения задания вы:

* познакомитесь с командной оболочкой Bash;
* используете синтаксис bash-скриптов;
* узнаете, как написать скрипт в файл так, чтобы он мог выполниться с параметрами и без.


### Чеклист готовности к домашнему заданию

1. У вас настроена виртуальная машина, контейнер или установлена гостевая ОС семейств Linux, Unix, MacOS.
2. Установлен Bash.


### Инструкция к заданию

1. Скопируйте в свой .md-файл содержимое этого файла, исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-01-bash/README.md).
2. Заполните недостающие части документа решением задач — заменяйте `???`, остальное в шаблоне не меняйте, чтобы не сломать форматирование текста, подсветку синтаксиса. Вместо логов можно вставить скриншоты по желанию.
3. Для проверки домашнего задания в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем репозитории.
4. Любые вопросы по выполнению заданий задавайте в чате учебной группы или в разделе «Вопросы по заданию» в личном кабинете.

### Дополнительные материалы

1. [Полезные ссылки для модуля «Скриптовые языки и языки разметки».](https://github.com/netology-code/sysadm-homeworks/tree/devsys10/04-script-03-yaml/additional-info)

------

## Задание 1

Переменной c будет присвоено значение "a+b" т.к. обращение к переменным не идет, это просто строковое значение. Переменной d будет присвоено значение "1+2" т.к. из-за знака "+" переменные a и b интерпретируются как строки. Переменной e будет присвоено значение "3" т.к. конструкция $(( )) указывает что это арифметическая операция.


## Задание 2
Есть скрипт
```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```

### Ваши скрипты:

2.1 В первую очередь в скрипте есть ошибка которая не дает ему выполниться. Нет закрывающей скобки в операторе while. Исправленный вариант:
```bash
while ((1==1))
  do
  curl https://localhost:4757
  if (($? != 0))
  then
    date >> curl.log
  fi
done
```
2.2 В задаче написано что при работе скрипта потребяется место на диске. Место потребляется только если проблема продолжается. Если нужно знать только последнюю отметку времени то можно модифицировать скрипт и заменить оператор добавления текста на замену текста:
```bash
while ((1==1))
  do
  curl https://localhost:4757
  if (($? != 0))
  then
    date > curl.log
  fi
done
```
2.3 Если нам нужно чтобы скрипт завершал свою работу после того как пробелма пропала, можно доработать его добавив выход по успешному выполнению curl:
```bash
while ((1==1))
  do
  curl https://localhost:4757
  if (($? != 0))
  then
    date >> curl.log
  else
    break
  fi
done
```
## Задание 3

Скрипт проверки доступности хостов по порту 80
### Ваш скрипт:
```bash
#!/bin/bash

logfile="out.log"
port=80
hosts=("192.168.0.1" "173.194.222.113" "87.250.250.242")

for i in {0..4}
do
  for host in ${hosts[@]}
  do
    nc -z -w1 $host $port
    rc=$?
    if (($rc == 0))
    then
      echo `date` $host OK >> $logfile
    else
      echo `date` $host ERROR >> $logfile
    fi
  done
done
```
## Задание 4

Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен — IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:

```bash
#!/bin/bash

logfile="out.log"
errfile="error"
port=80
hosts=("192.168.0.1" "173.194.222.113" "87.250.250.242")

for i in {0..4}
do
  for host in ${hosts[@]}
  do
    nc -z -w1 $host $port
    rc=$?
    if (($rc == 0))
    then
      echo `date` $host OK >> $logfile
    else
      echo `date` $host ERROR >> $logfile
      echo $host >> $errfile
      exit 1
    fi
  done
done
```

---

## Задание со звёздочкой* 

Это самостоятельное задание, его выполнение необязательно.
____

Мы хотим, чтобы у нас были красивые сообщения для коммитов в репозиторий. Для этого нужно написать локальный хук для Git, который будет проверять, что сообщение в коммите содержит код текущего задания в квадратных скобках, и количество символов в сообщении не превышает 30. Пример сообщения: \[04-script-01-bash\] сломал хук.

### Ваш скрипт:

```bash
#!/bin/bash

template="\[.*\]"
commitfile=$1
maxlength=30

length=`cat $commitfile | wc -c`
(grep -Eq $template $commitfile) && match=1 || match=0

if (($match == 0))
then
  echo >&2 Commit message not match template.
  err=1
fi

if (("$length" > "$maxlength"))
then
  echo >&2 Commit message too long. Max length $maxlength.
  err=1
fi

if ((err == 1))
then
  exit 1
fi
```
	
	


	
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
=======
# devops28-netology



## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/Lebedkin-Nikolay/devops28-netology.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.com/Lebedkin-Nikolay/devops28-netology/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Automatically merge when pipeline succeeds](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing(SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thank you to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README
Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
>>>>>>> 91feb6905b2f838bc6969488633467bf230afbb5
