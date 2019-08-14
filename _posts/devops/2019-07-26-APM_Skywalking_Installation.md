---
layout: post
title: "APM SkyWalking Installation"
date: 2019-07-26 16:55:00 +0080
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

##### Support Oracle Trace

```
$ git clone https://github.com/SkyAPM/java-plugin-extensions

Download ojdbc14 10.2.0.4 from oracle and install locally:
$ mvn install:install-file -DgroupId=com.oracle -DartifactId=ojdbc14 -Dversion=10.2.0.4.0 -Dpackaging=jar -Dfile=Oracle_10g_10.2.0.4_JDBC_ojdbc14.jar
$ cd java-plugin-extensions
$ mvn clean package
$ cp oracle-10.x-plugin/target/apm-oracle-10.x-plugin-1.0.1.jar /opt/app/apache-skywalking-apm-bin/agent/plugins

restart your application
```