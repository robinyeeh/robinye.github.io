---
layout: post
title: "PostgreSQL Installation"
date: 2018-06-12 10:39:58 +0000
comments: true
categories: "RDBMS"
---

###PostgreSQL Installation###

Postgres SQL: 

1. Install Postgresql

```
\# yum install -y https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-6-x86_64/pgdg-centos95-9.5-3.noarch.rpm(CentOS 6)
\\# yum install -y https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm(CentOS 7)
\# yum install -y postgresql95
\# yum install -y postgresql95-server
\# yum install -y postgresql95-contrib.x86_64
\# yum install -y pg_pathman95.x86_64
\# yum install -y pgagent_95.x86_64
```

2. Create data folder

```
\# mkdir -p /opt/psql9.5.12/data
\# chmod 700 /opt/psql9.5.12/data
\# sudo chown postgres:postgres /opt/psql9.5.12/data -R
```

3. Set profile

```
\# sudo vi /etc/profile
export PATH=/usr/pgsql-9.5/bin:$PATH
export PGDATA=/opt/psql9.5.12/data/
(Note: Please go to step 7 if installing slave server)

\# su - postgres
\# vi ~/.bash_profile
export PATH=/usr/pgsql-9.5/bin:$PATH
export PGDATA=/opt/9.5.12/data/
```

4.InitDB

```
\# su - postgres
\# /usr/pgsql-9.5/bin/postgresql95-setup initdb
\# cp -r /var/lib/pgsql/9.5/data/* /9.5.12/data/  
```

5. Configure master 

```
\# vi /opt/psql9.5.12/data/pg_hba.conf

Replace ident or peer with trust:
(#"local" is for Unix domain socket connections only)
local   all             all                                     trust

Add the following configuration under:
(\#IPv4 local connections)
host    all             all             10.10.10.1/24            md5

\# Allow replication connections from localhost, by a user with the# replication privilege
\#local   replication     postgres                                peer
\#host    replication     postgres        127.0.0.1/32            ident
host    replication     replicator         10.10.10.1/24          trust

\# vi /opt/PostgreSQL/data/postgresql.conf
listen_addresses = '*'
port = 5432
wal_level = hot_standby 
max_wal_senders = 5 
wal_keep_segments = 32 
archive_mode = on 
archive_command = 'cp %p /opt/PostgreSQL/data/%f < /dev/null'
```

6. Start Master DB

```
\# su - postgres
\# pg_ctl  -D /opt/psql9.5.12/data/ -l /opt/psql9.5.12/data/logfile start
\# psql 
postgres=# alter user postgres with password '123456';
postgres=# CREATE USER replicator REPLICATION LOGIN ENCRYPTED PASSWORD '123456';
postgres=# create extension pg_pathman;
postgres=# create extension pgagent ;
postgres=# \q;
```

7. Install Slave DB 

```
Step 1 ~ 3

7. Copy master DB data to slave (on slave)
\# su - postgres
$ pg_basebackup -h 10.10.10.20 -D /opt/PostgreSQL/data -U replicator -P -v -x
```

8. Configure Slave DB

```
$ vi /opt/psql9.5.12/data/postgresql.conf
listen_addresses = '*'
hot_standby = on
wal_level = hot_standby
max_wal_senders = 5
wal_keep_segments = 32

$ sudo su - postgres
$ cp /usr/pgsql-9.5/share/recovery.conf.sample  /opt/PostgreSQL/data/
$ cd /opt/PostgreSQL/data/
$ chown postgres:postgres  recovery.conf.sample  
$ mv recovery.conf.sample   recovery.conf
$ vi recovery.conf
primary_conninfo = 'host=10.10.10.20 port=5432 user=replicator password=123456'
trigger_file = '/opt/PostgresSql/data/trigger'
standby_mode = 'on'
```

9. Open Firewall if needed

```
$ sudo /sbin/iptables -I INPUT -p tcp --dport 5432 -j ACCEPT
$ sudo /etc/rc.d/init.d/iptables save
$ sudo /etc/init.d/iptables status
```

10. Start Slave DB

```
\# su  -postgres
$  pg_ctl  -D /opt/psql9.5.12/data/ -l /opt/psql9.5.12/data/logfile start

h3. Commands


1. start
 pg_ctl  -D /opt/psql9.5.12/data/ -l /opt/psql9.5.12/data/logfile start

2. stop
 pg_ctl  -D /opt/psql9.5.12/data/ -l /opt/psql9.5.12/data/logfile  stop

3. restart
 pg_ctl  -D /opt/psql9.5.12/data/ -l /opt/psql9.5.12/data/logfile restart

```