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

1. Узнайте о [sparse-файлах](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных).

Разреженные файлы - это файлы, для которых выделяется пространство на диске только для участков с ненулевыми данными. Список всех "дыр" хранится в метаданных ФС и используется при операциях с файлами. В результате получается, что разреженный файл занимает меньше места на диске (более эффективное использование дискового пространства)


1. Могут ли файлы, являющиеся жёсткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Не могут, такие жесткие ссылки имеют один и тот же inode (объект, который содержит метаданные файла).


1. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

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


1. Используя `fdisk`, разбейте первый диск на два раздела: 2 Гб и оставшееся пространство.

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



1. Используя `sfdisk`, перенесите эту таблицу разделов на второй диск.

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

1. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

nicolay@nicolay-VirtualBox:~$ sudo mdadm --create /dev/md0 -l 1 -n 2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.


1. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

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


1. Создайте два независимых PV на получившихся md-устройствах.

nicolay@nicolay-VirtualBox:~$ sudo pvcreate /dev/md1 /dev/md0
  Physical volume "/dev/md1" successfully created.
  Physical volume "/dev/md0" successfully created.
nicolay@nicolay-VirtualBox:~$ sudo pvscan
  PV /dev/md0                      lvm2 [<2,00 GiB]
  PV /dev/md1                      lvm2 [1018,00 MiB]
  Total: 2 [2,99 GiB] / in use: 0 [0   ] / in no VG: 2 [2,99 GiB]


1. Создайте общую volume-group на этих двух PV.

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


1. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

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


1. Создайте `mkfs.ext4` ФС на получившемся LV.

nicolay@nicolay-VirtualBox:~$ sudo mkfs.ext4 /dev/VG1/LV1
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Сохранение таблицы inod'ов: done
Создание журнала (1024 блоков): готово
Writing superblocks and filesystem accounting information: готово


1. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

nicolay@nicolay-VirtualBox:~$ mkdir /tmp/new
nicolay@nicolay-VirtualBox:~$ sudo mount /dev/VG1/LV1 /tmp/new


1. Поместите туда тестовый файл, например, `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

nicolay@nicolay-VirtualBox:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2023-03-26 19:54:15--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Распознаётся mirror.yandex.ru (mirror.yandex.ru)… 213.180.204.183, 2a02:6b8::183
Подключение к mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... соединение установлено.
HTTP-запрос отправлен. Ожидание ответа… 200 OK
Длина: 24587067 (23M) [application/octet-stream]
Сохранение в: «/tmp/new/test.gz»

/tmp/new/test.gz                      100%[======================================================================>]  23,45M  4,89MB/s    за 4,8s

2023-03-26 19:54:20 (4,85 MB/s) - «/tmp/new/test.gz» сохранён [24587067/24587067]


1. Прикрепите вывод `lsblk`.

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


1. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
nicolay@nicolay-VirtualBox:~$ gzip -t /tmp/new/test.gz
nicolay@nicolay-VirtualBox:~$ echo $?
0



1. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

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

1. Сделайте `--fail` на устройство в вашем RAID1 md.

nicolay@nicolay-VirtualBox:~$ sudo mdadm /dev/md0 -f /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md0


1. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

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

1. Протестируйте целостность файла — он должен быть доступен несмотря на «сбойный» диск:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```

nicolay@nicolay-VirtualBox:~$ gzip -t /tmp/new/test.gz
nicolay@nicolay-VirtualBox:~$ echo $?
0


1. Погасите тестовый хост — `vagrant destroy`.
 
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
