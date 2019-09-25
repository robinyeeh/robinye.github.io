---
layout: post
title: "Python Kafka Producer Consumer"
date: 2019-05-03 21:36:58 +0080
comments: true
categories: "MQ"
---

This article will describe how to use produce and consume message via python client for kafka.


##### Useful Kafka Client Tools

```
List kafka topic:
$ ./bin/kafka-topics.sh --zookeeper 127.0.0.1:2181 --list

View kafka topic:
./bin/kafka-topics.sh --describe --zookeeper 127.0.0.1:2181 --topic test-topic01

Change topic partition count:
./bin/kafka-topics.sh --zookeeper 127.0.0.1:2181 --alter --topic test-topic01 --partitions 2

Show offset:
$ ./bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list '127.0.0.1:9092' --topic 'topic_name' --time -1

Show consume message :
./bin/kafka-run-class.sh kafka.tools.SimpleConsumerShell --broker-list '127.0.0.1:9092' --topic 'topic_name' --max-messages 1 --offset 9 --partition 0

Produce message:
./bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test_topic01

./bin/kafka-console-producer.sh --broker-list 127.0.0.1:9092 --topic test_topic01

./bin/kafka-console-consumer.sh --bootstrap-server 127.0.0.1:9092 --topic test_topic01 --from-beginning
```

##### Kafka Python Demo

```
Github at https://github.com/robinyeeh/kafka-python-demo
```