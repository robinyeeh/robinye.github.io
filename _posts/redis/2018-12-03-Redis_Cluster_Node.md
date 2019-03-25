---
layout: post
title: "Install Redis Cluster"
date: 2018-12-03 21:36:58 +0080
comments: true
categories: "Redis"
---

This article will describe how to set redis cluster based on redis 5.0.


##### Download Redis

```
mkdir -p /opt/install/redis
cd /opt/install/redis
wget http://download.redis.io/releases/redis-5.0.0.tar.gz
```

##### Install Redis

Redis cluster should have at least 6 nodes, so we will use 2 server for demo.

```
tar zxvf redis-5.0.0.tar.gz
mv redis-5.0.0 /opt/app/

cd /opt/app/
ln -s redis-5.0.0 redis

sudo yum -y install gcc gcc-c++ libstdc++-devel tcl -y
cd /opt/app/redis
make 
make test
```

##### Install redis on server 1

1) Create node folders
```
mkdir cluster
cd cluster
mkdir 9261 9262 9263 9264

cp /opt/app/redis/src/redis-server 9261/
cp /opt/app/redis/src/redis-server 9262/
cp /opt/app/redis/src/redis-server 9263/
cp /opt/app/redis/src/redis-server 9264/
```

2) Change node configuration
```
cp /opt/app/redis/redis.conf 9261/
cd 9261/

sed -i -e 's/bind 127.0.0.1/#bind 127.0.0.1/' redis.conf
sed -i -e 's/protected-mode yes/protected-mode no/' redis.conf
sed -i -e 's/pidfile \/var\/run\/redis_6379.pid/pidfile redis.pid/' redis.conf
sed -i -e 's/appendonly no/appendonly yes/' redis.conf
sed -i -e 's/# cluster-enabled yes/cluster-enabled yes/' redis.conf
sed -i -e 's/# cluster-config-file nodes-6379.conf/cluster-config-file nodes.conf/' redis.conf
sed -i -e 's/# cluster-node-timeout 15000/cluster-node-timeout 5000/' redis.conf
sed -i -e 's/notify-keyspace-events ""/notify-keyspace-events "Egx"/' redis.conf
sed -i -e 's/port 6379/port 9261/' redis.conf
```

3) Change redis configuration
```
cp /opt/app/redis/cluster/9261/redis.conf /opt/app/redis/cluster/9262
cd /opt/app/redis/cluster/9262
sed -i -e 's/port 9261/port 9262/' redis.conf

cp /opt/app/redis/cluster/9261/redis.conf /opt/app/redis/cluster/9263
cd /opt/app/redis/cluster/9263
sed -i -e 's/port 9261/port 9263/' redis.conf

cp /opt/app/redis/cluster/9261/redis.conf /opt/app/redis/cluster/9264
cd /opt/app/redis/cluster/9264
sed -i -e 's/port 9261/port 9264/' redis.conf
```

4) Create cluster startup shell

```
cd /opt/app/redis/cluster
vi start_cluster.sh 

add the following command:

cd /opt/app/redis/cluster/9261
/opt/app/redis/cluster/9261/redis-server redis.conf &

cd /opt/app/redis/cluster/9262
/opt/app/redis/cluster/9262/redis-server redis.conf &

cd /opt/app/redis/cluster/9263
/opt/app/redis/cluster/9263/redis-server redis.conf &

cd /opt/app/redis/cluster/9264
/opt/app/redis/cluster/9264/redis-server redis.conf &

chmod u+x start_cluster.sh
./start_cluster.sh 
```

##### Install redis on server 2 with same step as above


##### Create cluster

```
cd /opt/app/redis
./src/redis-cli  --cluster  create  192.168.4.135:9261 192.168.4.135:9262 192.168.4.135:9263 192.168.4.135:9264 192.168.4.136:9261 192.168.4.136:9262 192.168.4.136:9263 192.168.4.136:9264 --cluster-replicas 1
```

##### Check Cluster nodes

```
./src/redis-cli -p 9261 cluster nodes
./src/redis-cli -p 9261 cluster info
```

##### Recover Cluster 

1) Stop all nodes and back up all aof and rdb for nodes.

2) Remove nodes.conf and redis.pid
```
ps -ef |grep redis |awk '{print $2}'|xargs kill -9

find /opt/app/redis/cluster -name "nodes.conf" | xargs mv 
find /opt/app/redis/cluster -name "redis.pid" | xargs rm
```

3) Start all nodes and start cluster
```
cd /opt/app/redis/cluster
./start_cluster.sh
cd /opt/app/redis
./src/redis-cli  --cluster  create  192.168.4.135:9261 192.168.4.135:9262 192.168.4.135:9263 192.168.4.135:9264 192.168.4.136:9261 192.168.4.136:9262 192.168.4.136:9263 192.168.4.136:9264 --cluster-replicas 1
```

4) Restore data for all aof and rdb 
