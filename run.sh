#!/bin/bash

/etc/init.d/bt restart

panel_init(){
        panel_path=/www/server/panel
        pidfile=$panel_path/logs/panel.pid
        cd $panel_path
        env_path=$panel_path/pyenv/bin/activate
        if [ -f $env_path ];then
                source $env_path
                pythonV=$panel_path/pyenv/bin/python
                chmod -R 700 $panel_path/pyenv/bin
        else
                pythonV=/usr/bin/python
        fi
        reg="^#\!$pythonV\$"
        is_sed=$(cat $panel_path/BT-Panel|head -n 1|grep -E $reg)
        if [ "${is_sed}" = "" ];then
                sed -i "s@^#!.*@#!$pythonV@" $panel_path/BT-Panel
        fi
        is_sed=$(cat $panel_path/BT-Task|head -n 1|grep -E $reg)
        if [ "${is_sed}" = "" ];then
                sed -i "s@^#!.*@#!$pythonV@" $panel_path/BT-Task
        fi
        chmod 700 $panel_path/BT-Panel
        chmod 700 $panel_path/BT-Task
        log_file=$panel_path/logs/error.log
        task_log_file=$panel_path/logs/task.log
        if [ -f $panel_path/data/ssl.pl ];then
                log_file=/dev/null
        fi

        port=$(cat $panel_path/data/port.pl)
}
panel_init

password=$(cat $panel_path/default.pl)
if [ -f $panel_path/data/domain.conf ];then
                        address=$(cat $panel_path/data/domain.conf)
                fi
                if [ -f $panel_path/data/admin_path.pl ];then
                        auth_path=$(cat $panel_path/data/admin_path.pl)
                fi
                if [ "$address" = "" ];then
                        address=$(curl -sS --connect-timeout 10 -m 60 https://www.bt.cn/Api/getIpAddress)
                fi
                                pool=http
                                if [ -f $panel_path/data/ssl.pl ];then
                                        pool=https
                                fi
                echo -e "=================================================================="
                echo -e "\033[32mBT-Panel default info!\033[0m"
                echo -e "=================================================================="
                echo  "Bt-Panel-URL: $pool://$address:$port$auth_path"
                echo -e `$pythonV $panel_path/tools.py username`
                echo -e "password: $password"
                echo -e "\033[33mWarning:\033[0m"
                echo -e "\033[33mIf you cannot access the panel, \033[0m"
                echo -e "\033[33mrelease the following port (8888|888|80|443|20|21) in the security group\033[0m"
                echo -e "=================================================================="

exec /usr/sbin/sshd -D

