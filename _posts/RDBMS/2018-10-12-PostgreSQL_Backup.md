---
layout: post
title: "PostgreSQL Backup"
date: 2018-10-12 10:39:58 +0000
comments: true
categories: "RDBMS"
---

#### Installation

```
$ sudo yum install -y https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm  

$ sudo yum install -y postgresql95

```

#### No login

```
$ cd
$ vi .pgpass 

add
host:port:database_name:username:password

$ chmod 600 .pgpass
```

#### add cron

```
$ crontab -e

10 1 * * * pg_dump -h hostname database_name -U username -w > /opt/backup/db/pgsql_`date "+\%Y\%m\%d"`.dmp && gzip /opt/backup/db/pgsql_`date "+\%Y\%m\%d"`.dmp

```


#### Purge logs 

```
10 1 * * * find /opt/app/elastic/logstash/logs -size +50G -type f -exec sh -c 'echo "" > {}' \;
```