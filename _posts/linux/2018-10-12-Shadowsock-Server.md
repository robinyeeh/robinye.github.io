---
layout: post
title: "Shadowsock Server"
date: 2018-10-12 15:12:00 +0800
comments: true
categories: "Linux"
---

#### Shadowsock Server Installation

##### Install Shadowsock Server
1. Enable Google BBR:

```
# rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
# rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
# yum --enablerepo=elrepo-kernel install kernel-ml -y
# #egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
# #grub2-set-default 1
  
# shutdown -r now
# uname -r
```

2. Check linux network config

```
# echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
# sysctl -p
# sysctl net.ipv4.tcp_available_congestion_control
# lsmod | grep bbr
# cat /boot/grub2/grub.cfg |grep menuentry
# grub2-editenv list
# lsmod | grep bbr
```

3. Install shadowsocks

```
# yum install -y gcc automake autoconf libtool make
# yum install -y curl-devel zlib-devel openssl-devel perl-devel expat-devel gettext-devel
# mkdir -p /opt/app/shadowsocks-libev/
# cd /opt/app/shadowsocks-libev/
# wget https://github.com/shadowsocks/shadowsocks-libev/archive/v2.6.2.tar.gz
# (git clone https://github.com/madeye/shadowsocks-libev.git)
# tar zxvf v2.6.2.tar.gz

# yum -y install asciidoc xmlto

# cd shadowsocks-libev-2.6.2/
# ./configure && make
# make install
# mkdir -p /etc/shadowsocks
 
``` 

4. Configure shadowsocks

```
# vi /etc/shadowsocks/config.json
```

```
{
    "server":"xx.xx.xx.xx",
    "server_port":80,
    "local_address": "127.0.0.1",
    "local_port":1999,
    "password":"xxxxxxxxx",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false,
    "workers": 1
}
```

5. Start server

```
# nohup /usr/local/bin/ss-server -c /etc/shadowsocks/config.json &
```

6. Disable firewall

```
# systemctl status firewalld.service
# systemctl stop firewalld.service
# systemctl disable firewalld.service
```

#### Shadowsocks client

Configure shadow Socks Linux client:

```
# export http_proxy="http://127.0.0.1:8123/"
```

1. Install polipo

```
# git clone https://github.com/jech/polipo.git
# sudo yum install  texinfo  -y
# make all
# sudo make install 
# sudo mkdir -p /etc/polipo/
# sudo vi /etc/polipo/config
```

2. And add the following configuration

```
logSyslog = true
logFile = /var/log/polipo/polipo.log
proxyAddress = "0.0.0.0"
proxyPort = 8123
socksParentProxy = "127.0.0.1:1080"
socksProxyType = socks5
chunkHighMark = 50331648
objectHighMark = 16384
serverMaxSlots = 64
serverSlots = 16
serverSlots1 = 32
daemonise = true
```

```
# sudo chmod 777 -R /var/log/polipo/     
# sudo /usr/local/bin/polipo -c /etc/polipo/config
```

3. Configure http and https proxy

```
# vi ~/.bash_profile

export http_proxy="http://127.0.0.1:8123/"
export https_proxy="http://127.0.0.1:8123/"
```

4. Enable proxy

```
# nohup sslocal -c shadowsocks.json  -v 2&
```


