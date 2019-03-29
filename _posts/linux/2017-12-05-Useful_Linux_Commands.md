---
layout: post
title: "Useful Linux Commands"
date: 2018-12-05 11:52:00 +0800
comments: true
categories: "Linux"
---

Listed useful linux commands.

##### 1. Linux connection limit

-   Limit single IP's max connections to 30

```
/sbin/iptables -I INPUT -p tcp --dport 8623 -m connlimit --connlimit-above 50 -j REJECT
/etc/rc.d/init.d/iptables save
/etc/init.d/iptables status
```

-   Limit single IP's max connections to 30 within 60 seconds

```
iptables -A INPUT -p tcp --dport 80 -m recent --name BAD_HTTP_ACCESS --update --seconds 60 --hitcount 30 -j REJECT
iptables -A INPUT -p tcp --dport 80 -m recent --name BAD_HTTP_ACCESS --set -j ACCEPT
```

-   Enhance iptables anti CC attach, better to change ipt_recent params like：

```
\#cat  /etc/modprobe.conf
options ipt_recent ip_list_tot=1000 ip_pkt_list_tot=60

\# To track 1000 IP addresses, and record 60 packets for each IP
\# modprobe ipt_recent
```

-   Add firewall rules:

```
\# vi /etc/sysconfig/iptables
\# service iptables save
\# service iptables restart
```

##### 2. File descriptor

```
lsof -n|awk '{print $2}'|sort|uniq -c|sort -nr|more
lsof -p PID
```

##### 3. iostat

```
iostat -d -k 1 10 #Show TPS and packets throughput
iostat -d -x -k 1 10 #Show device usage（%util）、response time（await）
iostat -c 1 10 #Show CPU status
```

##### 4. mount backup driver:

```
sudo mount -t ntfs-3g /dev/sdb1 /mnt/wd
```

##### 5. Find by time

```
find . -mtime +3 -type f | xargs rm
```     

##### 6. Linux Version

```
lsb_release -a
ldd `which ffmpeg`
```

or

```
cat /etc/redhat-release 
```

##### 7. Add route

```
route add -net 192.168.2.0/24 eth0
route del -net 192.168.1.0/24 eth0
```

##### 8. Date change

```
date -s 06/10/96
clock -w
```

##### 9. Check port

```
lsof -i:80
netstat -anp | grep 80
```

##### 10. Check port number connections

```
netstat -anp | grep 80 | grep EST | wc -l
```

##### 11. TCP dump

```
tcpdump -Xx -s0 port 80
```

CentOS 7:

```
tcpdump -Xx -s0 -i any port 80
```

##### 12. eth0 network

```
ifconfig eth0 down
ifconfig eth0 hw ether 00:AA:BB:CC:DD:EE
service network restart
ifconfig eth0 up
```

#####13. VIM Replace

```
%s/203.116.18.235/swiftdrm.conversant.com.sg/g
```

##### 14. ftp client

```
lftp metadata@ftp.example.com
```

##### 15. nohup

```
nohup cp -r /userdata01/storage/ /opt/storage2/ &
```

##### 16. Open files

```
$sudo vi  /etc/security/limits.conf
```

add the following line before # End of file

```
*               -       nofile          65535
```

##### 17. Find files in size range

```
find . -size -3k  (<3k)   c byte, k, M, G
find . -size +3k (>3k)
```

##### 18. SSH RSA

1) Generate public and private key on client machine

```
$ ssh-keygen -t rsa
$ cd ~/.ssh
$ chmod 600 id_rsa
``` 

(Press enter three times, id_rsa : Private key， id_rsa.pub : Public key )

2) Copy public key to server machine

```
$ scp ~/.ssh/id_rsa.pub sftp@192.168.1.20:~/.ssh
$ touch ~/.ssh/authorized_keys
$ chmod 600 ~/.ssh/authorized_keys
```

(/etc/ssh/sshd_config to change authorized keys, and default one is authorized_keys）

3) Append public key to authorized keys

```
$ cat id_rsa.pub >> authorized_keys
```

4) Check if login needs password

```
$ ssh sftp@192.168.1.20
```

#####19. scp  -bash: scp: command not found

```
\# yum install openssh-clients
```

##### 20. Sync Lunix time

```
$ sudo yum install ntpdate
$ sudo ntpdate -u asia.pool.ntp.org (ntp.api.bz)
```

```
timedatectl  #查看系统时间方面的各种状态
timedatectl list-timezones # 列出所有时区
timedatectl set-local-rtc 1 # 将硬件时钟调整为与本地时钟一致, 0 为设置为 UTC 时间
timedatectl set-timezone Asia/Shanghai # 设置系统时区为上海
```

##### 21. GZIP backup

```
./mysqldump -u root -p redmine_261 | gzip > /opt/backup/redmine/redmine_mysqldb_$(date +%Y%m%d).gz
```

##### 22. DNS

```
dig + trace www.abc.com

202.96.209.133
202.96.209.5
114.114.114.114
```

###### 23. Linux multiple IP 

```
\# cd /etc/sysconfig/network-scripts
\# cp ifcfg-eth0 ifcfg-eth1
\#vi ifcfg-eth1

DEVICE=eth1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=none
BOOTPROTO=static
IPADDR=192.168.1.28
NETMASK=255.255.255.0
```

##### 24. Auto interaction.

```
echo "password" | sudo -S yum -y install
```

##### 25. Check serials number.

```
$ dmidecode -t 1
$ dmidecode | grep "Serial Number"
```

##### 26. Install openssl-devel

Execute the following command if openssl-devel can not be installed:

```
$ sudo yum install --enablerepo=centosplus openssl-devel
```

##### 27. Linux inotify

```
$  sudo vi /etc/sysctl.conf

Add the following line:
fs.inotify.max_user_instances = 128
fs.inotify.max_user_watches = 8192000
fs.inotify.max_queued_events = 1638400
```

```
$ sudo sysctl fs.inotify.max_user_watches=819200
$ sudo sysctl fs.inotify.max_queued_events = 163840
```

Check values:
```
$ cat /proc/sys/fs/inotify/max_user_instances
$ cat /proc/sys/fs/inotify/max_user_watches
$ cat /proc/sys/fs/inotify/max_queued_events
```

###### 28. Dig

```
$ sudo yum -y install bind-utils
```

###### 29. Sudoer

```
$ su
type password of root


# visudo
Add line like
robin    ALL=(ALL)       ALL
```

##### 30. Iptables

```
# /etc/sysconfig
-A INPUT -s 192.168.1.0/24 -j ACCEPT
-A INPUT -s 192.168.6.0/24 -j ACCEPT

-A INPUT -s 192.168.1.0/255.255.255.0 -p tcp -m tcp --dport 1111 -j ACCEPT
-A INPUT -s 192.168.1.0/255.255.255.0 -p tcp -m tcp --dport 2222 -j ACCEPT
-A INPUT -s 192.168.1.0/255.255.255.0 -p tcp -m tcp --dport 3333 -j ACCEPT
-A INPUT -s 192.168.1.0/255.255.255.0 -p tcp -m tcp --dport 4444 -j ACCEPT
-A INPUT -s 192.168.1.0/255.255.255.0 -p tcp -m tcp --dport 5555 -j ACCEPT

-A INPUT -p tcp -m tcp --dport 5432 -j ACCEPT
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -s 192.168.100.107 -j ACCEPT
-A INPUT -p tcp -m multiport --dports 21,80,443,5432,8730,8731,8735 -j ACCEPT
-A INPUT -p tcp -m multiport --dports 60000:60500 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 8022 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A INPUT -s 203.116.18.243/32 -p udp -m udp --dport 161 -j ACCEPT
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
```

##### 31. Log archive

```
00 1 * * * find /opt/logs/storeshare/server -mtime +10 -type d | xargs -i mv {} /userdata01/bakUserFiles/log_archive/storeshare_91/server
10 1 * * * find /opt/logs/storeshare/bill -mtime +10 -type d | xargs -i mv {} /userdata01/bakUserFiles/log_archive/storeshare_91/bill
20 1 * * * find /opt/logs/storeshare/web -mtime +10 -type d | xargs -i mv {} /userdata01/bakUserFiles/log_archive/storeshare_91/web
30 1 * * * find /opt/logs/storeshare/report-ds -mtime +10 -type d | xargs -i mv {} /userdata01/bakUserFiles/log_archive/storeshare_91/report-ds
40 1 * * * find /opt/logs/storeshare/transcoder -mtime +10 -type d | xargs -i mv {} /userdata01/bakUserFiles/log_archive/storeshare_91/transcoder
```

find /opt/logs/bhd_ott/api -mtime +90 -type d | xargs -i rm -rf

##### 32. Secure CRT Jump

```
Expect : ~]$
Send   : ssh -p 8022 convstcn@203.116.18.238

Expect : assword:
Send  :  *********
```

##### 33. ssh no login

1) Generate public and private key on client machine

```
$ ssh-keygen -t rsa -C StoreShare
$ cd ~/.ssh
$ chmod 600 id_rsa
```

 (Press enter three times, id_rsa : Private key， id_rsa.pub : Public key )

2) Copy public key to server machine

```
$ scp ~/.ssh/id_rsa.pub sftp@192.168.1.20:~/.ssh
$ touch ~/.ssh/authorized_keys
$ chmod 600 ~/.ssh/authorized_keys
```
 (/etc/ssh/sshd_config to change authorized keys, and default one is authorized_keys）

3) Append public key to authorized keys

```
$ cat id_rsa.pub >> authorized_keys
```

4) Check if login needs password
```
$ ssh sftp@192.168.1.20
```

5) multiple keys

```
vi ~/.ssh/config
```

add config:
Host 1.2.3.4
    IdentityFile ~/.ssh/id_rsa_second
    User test

touch ~/.ssh/config

```
chmod 700 .ssh/
chmod 644 .ssh/authorized_keys
chmod 600 .ssh/id_rsa
```

##### 34. CURL

```
curl -H "Content-Type:application/json;charset=UTF-8" -H "X-User-Agent:WEB" -H "Accept-Language:zh_CN" -H "Authorization:Basic xxxxxxxxxxxxxxxxx" -XGET "http://127.0.0.1:8730/1/product/paging_filter?tag_ids=2072&package_type=AVOD&sort_field=release_date" -o /dev/null -w %{time_namelookup}::%{time_connect}::%{time_starttransfer}::%{time_total}::%{speed_download}"\n"
```

##### 35. xfs mount

```
\#yum install xfsprogs
\# modprobe xfs

\# mkfs.xfs -f /dev/sdb1

\# mount -t xfs /dev/sdb1 /sdb
\# cat /etc/fstab
```

##### 36. ICMP Echo 

```
\# echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
如果要恢复，只要：
\# echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_all
```

##### 37. SecureCRT SSH Auto Login

```
Expect : ~]$
Send : ssh convstcn@192.168.0.104
Expect : assword: 
Send : *****

Expect : ~]$
Send : sudo su - postgres
Expecet : :
Send : ******
```

##### 38. Install rzsz

```
\# yum install lrzsz
```
Install gcc

```
yum install libmpc-devel mpfr-devel gmp-devel
cd /usr/src/
curl ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-4.9.3/gcc-4.9.3.tar.bz2 -O
tar xvfj gcc-4.9.3.tar.bz2
cd gcc-4.9.3
./configure --disable-multilib --enable-languages=c,c++
make -j `grep processor /proc/cpuinfo | wc -l`
make install
```

###### 39.centos 7 firewall

1)  Disable firewall

```
systemctl stop firewalld.service             #停止firewall
systemctl disable firewalld.service        #禁止firewall开机启动
```

2)  Open port

```
firewall-cmd --zone=public --add-port=80/tcp --permanent
```
命令含义：

```
--zone #作用域
--add-port=80/tcp #添加端口，格式为：端口/通讯协议
--permanent #永久生效，没有此参数重启后失效
>>> 重启防火墙
firewall-cmd --reload
常用命令介绍
firewall-cmd --state                           ##查看防火墙状态，是否是running
firewall-cmd --reload                          ##重新载入配置，比如添加规则之后，需要执行此命令
firewall-cmd --get-zones                       ##列出支持的zone
firewall-cmd --get-services                    ##列出支持的服务，在列表中的服务是放行的
firewall-cmd --query-service ftp               ##查看ftp服务是否支持，返回yes或者no
firewall-cmd --add-service=ftp                 ##临时开放ftp服务
firewall-cmd --add-service=ftp --permanent     ##永久开放ftp服务
firewall-cmd --remove-service=ftp --permanent  ##永久移除ftp服务
firewall-cmd --add-port=80/tcp --permanent     ##永久添加80端口
iptables -L -n                                 ##查看规则，这个命令是和iptables的相同的
man firewall-cmd                               ##查看帮助
更多命令，使用  firewall-cmd --help 查看帮助文件
```

3)  CentOS 7.0默认使用的是firewall作为防火墙，使用iptables必须重新设置一下
1、直接关闭防火墙

```
systemctl stop firewalld.service           #停止firewall
systemctl disable firewalld.service     #禁止firewall开机启动
```

2、设置 iptables service

```
yum -y install iptables-services
如果要修改防火墙配置，如增加防火墙端口3306
vi /etc/sysconfig/iptables
增加规则
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT
保存退出后
systemctl restart iptables.service #重启防火墙使配置生效
systemctl enable iptables.service #设置防火墙开机启动
最后重启系统使设置生效即可。
```

##### 39.IO test

```
time dd if=/dev/zero of=/opt/app/test.dbf bs=8k count=300000
```


 


