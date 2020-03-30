---
layout: post
title: "Golang Kafka Producer and Consumer"
date: 2020-03-30 19:56:00 +0800
comments: true
categories: "go"
---


A week ago, my colleague said that they can not consume kafka message and do not know the reason. I want to use
python script to check but there's no outbound network to use pip to install Kafka python component, so i wrote
Golang one and built as executable file in my local CentOS7.3 server and then upload it to the server that we want
to check kafka message. 


##### Golang Kafka Producer

Github address for kafka producer: https://github.com/robinyeeh/kafka-producer


```
$ git clone https://github.com/robinyeeh/kafka-producer.git
$ cd kafka-producer
$ go build

$ ./kafka_producer 127.0.0.1:9092 test_topic
```

##### Golang Kafka Consumer

Github address for kafka consumer: https://github.com/robinyeeh/kafka-producer

```
$ git clone https://github.com/robinyeeh/kafka-consumer.git
$ cd kafka-consumer
$ go build

$ ./kafka_consumer 127.0.0.1:9092 test_topic
```