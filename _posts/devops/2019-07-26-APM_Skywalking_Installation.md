---
layout: post
title: "APM SkyWalking Installation"
date: 2019-06-12 16:12:58 +0080
comments: true
categories: "DevOps"
---


#### APM SkyWalking Installation ####

SkyWalking is an APM open source project for tracking CPU, distributed service calls performance and errors.  
github: [https://github.com/apache/skywalking](https://github.com/apache/skywalking)

Compare to Zipkin, you do not need to change any code for your current applications, but with a little change of your startup command or script 
since SkyWalking intercept and analyze the requests based on java byte code. The disadvantage is that the performance is slower than zipkin or CAT. 

If you are still interested in zipkin, you can access demo repository on github at [https://github.com/robinyeeh/spring-cloud-zipkin-demo](https://github.com/robinyeeh/spring-cloud-zipkin-demo)

v6.2.0 can not support elasticsearch 7.x but 6.3+ works (I tested that there's compatibility as ES 7 does not have type concept anymore).

##### Install SkyWalking and Start Collector

```
$ wget http://mirrors.tuna.tsinghua.edu.cn/apache/skywalking/6.2.0/apache-skywalking-apm-6.2.0.tar.gz
$ tar zxvf apache-skywalking-apm-6.2.0.tar.gz

$ cd apache-skywalking-apm-bin
$ vi config/application.yml

add comment for h2 and remove comment for elasticsearch

$ cd bin
$ ./startup.sh
```

##### Start Applications with SkyWalking Agent
 
```
nohup java -javaagent:/opt/app/apache-skywalking-apm-bin/agent/skywalking-agent.jar -DSW_AGENT_NAME=mbp-registry -jar mbp-registry-1.0.0.jar &
nohup java -javaagent:/opt/app/apache-skywalking-apm-bin/agent/skywalking-agent.jar -DSW_AGENT_NAME=mbp-video -jar mbp-video-1.0.0.jar &
nohup java -javaagent:/opt/app/apache-skywalking-apm-bin/agent/skywalking-agent.jar -DSW_AGENT_NAME=mbp-user -jar mbp-user-1.0.0.jar &
```

##### Access UI

```
UI: http://localhost:8080
```