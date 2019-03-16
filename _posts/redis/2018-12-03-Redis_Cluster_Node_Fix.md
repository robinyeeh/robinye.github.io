---
layout: post
title: "Fix Redis Cluster Node"
date: 2018-12-03 21:36:58 +0080
comments: true
categories: "Redis"
---

###Fix Redis Cluster Node


Remove nodes.conf:

```
$ rm nodes.conf
```

Start redis node:

```
$ /opt/app/redis/cluster/8261/redis-server redis.conf &
```

Fix and sync node data:

```
 /opt/app/redis/src/redis-cli  --cluster fix 192.168.1.100:8261
```
