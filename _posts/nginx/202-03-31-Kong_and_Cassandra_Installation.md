---
layout: post
title: "Kong and Cassandra Installation"
date: 2020-03-31 20:33:00 +0800
comments: true
categories: "Nginx"
---

This article describes how to install Kong and Cassandra on CentOS 7.3. As I'm looking for high performance API gateway, and Kong is based on
nginx and lua can support 10k ~ 20k conn concurrency which is what i wanted. I tried Spring cloud gateway but the performance is not as good 
as i expected.

And also Kong provide upstream rate limit as well as authentication like jwt.

##### Install Cassandra

Official website: https://cassandra.apache.org/download/

1. Add cassandra yum repository
```
# vi /etc/yum.repos.d/cassandra.repo
And and the following config:
[cassandra]
name=Apache Cassandra
baseurl=https://downloads.apache.org/cassandra/redhat/311x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.apache.org/cassandra/KEYS
```

2. Install Cassandra
```
# yum install cassandra
```

3. Start cassandra
```
# su - cassandra
$ cassandra
```

4. Check installation
```
$ cqlsh
cqlsh> describe cluster
cqlsh> describe keyspaces
cqlsh> show version
```

##### Install Kong

Official website: https://konghq.com/

1. Install Kong
```
# mkdir -p /opt/install/kong
# wget https://bintray.com/kong/kong-rpm/rpm -O bintray-kong-kong-rpm.repo
# sed -i -e 's/baseurl.*/&\/centos\/'$major_version''/ bintray-kong-kong-rpm.repo
# sudo mv bintray-kong-kong-rpm.repo /etc/yum.repos.d/
sudo yum install -y kong

kong version
```

2. Change Kong Configuration
```
# cd /etc/kong
# cp kong.conf.default kong.conf
# vi kong.conf
change the following configuration:
database = cassandra
cassandra_contact_points = 127.0.0.1
cassandra_port = 9042
cassandra_keyspace = kong
cassandra_consistency = ONE
cassandra_timeout = 5000
cassandra_ssl = off
cassandra_ssl_verify = off

db_update_frequency = 5
db_update_propagation = 10

# kong migrations bootstrap
# kong start
```

3. Check if Kong Started
```
#  curl 127.0.0.1:8001
```

##### Install Konga

As kong just provide restful api for community version (It will provide admin portal for enterprise version), so you may need 
an admin portal to manage services, routes, etc. Konga is the best one so far.

Official website: https://pantsel.github.io/konga/
github: https://github.com/pantsel/konga

1. Install Nodejs
```
# yum install gcc gcc-c++
# cd /opt/app
# wget https://npm.taobao.org/mirrors/node/v10.14.1/node-v10.14.1-linux-x64.tar.gz
# tar zxvf node-v10.14.1-linux-x64.tar.gz
# mv node-v10.14.1-linux-x64 /usr/local/nodejs
# vi /etc/profile

export NODE_HOME=/usr/local/nodejs  
export PATH=$NODE_HOME/bin:$PATH

# source /etc/profile
# npm -v
# node -v

# mkdir ~/.npm-global
# npm config set prefix '~/.npm-global'
# export PATH=~/.npm-global/bin:$PATH
```

2. Install Konga
```
# npm run bower-deps
# npm start
```

It will just use local database, it will be better to use MySQL, or Mongo instead.

3. Access and check

Access http://127.0.0.1:1337

You need to input name and kong admin url like "kong" and "http://127.0.0.1:8001"




 


