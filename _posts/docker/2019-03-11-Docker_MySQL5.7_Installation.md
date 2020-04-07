---
layout: post
title: "Docker MySQL5.7 Installation"
date: 2019-03-11 20:30:23 +0080
comments: true
categories: "docker"
---

### Install Docker on CentOS7.3


```
# yum -y install yum-utils device-mapper-persistent-data lvm2
# yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# yum makecache fast
# yum -y install docker-ce

# systemctl start docker

Check docker installation:
# docker ps -a
```


### Install MySQL5.7

```
# docker search mysql

Add docker registry image:
#vi /etc/docker/daemon.json
{
"registry-mirrors": ["http://hub-mirror.c.163.com"]
}

# systemctl daemon-reload
# systemctl restart docker.service
# docker pull mysql:5.7

# docker images
```

It took me around 2 hours to fix the following issue:
Error response from daemon: Get https://registry-1.docker.io/v2/: net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)

I installed CentOS7.3 by using Parallels Desktop on my mac book, so i found that the default dns is like this:
nameserver 10.211.55.1
nameserver fe80::21c:42ff:fe00:18%eth0  

Then i remove these 2 dns config and add the following dns and it works fine now:
nameserver 8.8.8.8
nameserver 8.8.4.4

### Start MySQL

```
Change MySQL conf:
# vi /usr/local/docker/mysql/conf/mysqld.cnf
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
log-error      = /var/log/mysql/error.log

bind-address    = 0.0.0.0

# docker run -p 3306:3306 --name mysql \
  -v /usr/local/docker/mysql/conf:/etc/mysql \
  -v /usr/local/docker/mysql/logs:/var/log/mysql \
  -v /usr/local/docker/mysql/data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=123321 \
  -d mysql:5.7

```

### Grant Access

```
# firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="10.211.55.0/24" accept"
# firewall-cmd --reload
# firewall-cmd --permanent --zone=public --add-port=3306/tcp
```