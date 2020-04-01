---
layout: post
title: "TiDB Installation"
date: 2020-04-01 18:39:58 +0800
comments: true
categories: "Database"
---

### TiDB Installation###


1. Install TiDB

```
# mkdir -p /opt/install/tidb
# cd /opt/install/tidb
# wget http://download.pingcap.org/tidb-latest-linux-amd64.tar.gz
# tar zxvf tidb-latest-linux-amd64.tar.gz 
# mv tidb-v3.0.12-linux-amd64/ /usr/local/tidb/
# mkdir -p /opt/data/pd/ /opt/data/tikv/ 
# mkdir -p /opt/logs/tidb

# cd /usr/local/tidb/
# ./bin/pd-server --data-dir=/opt/data/pd --log-file=/opt/logs/tidb/pd.log &
# ./bin/tikv-server --pd="127.0.0.1:2379" --data-dir=/opt/data/tikv --log-file=/opt/logs/tidb/tikv.log &
# ./bin/tidb-server --store=tikv --path="127.0.0.1:2379" --log-file=/opt/logs/tidb/tidb.log &
```

2. Install MySQL Client

```
# wget https://repo.mysql.com//mysql57-community-release-el7-11.noarch.rpm 
# yum install -y mysql57-community-release-el7-11.noarch.rpm 
# yum install -y mysql-community-client.x86_64
```

3. Check and Test

```
# mysql -h 127.0.0.1 -P 4000 -u root
```
