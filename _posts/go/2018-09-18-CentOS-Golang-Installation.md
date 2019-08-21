---
layout: post
title: "CentOS Golang Installation"
date: 2018-09-18 19:35:00 +0800
comments: true
categories: "go"
---


This article will how to install Golang on CentOS. 



##### Download Golang

Visit go lang website https://golang.org/dl/ and get link of latest stable version.

```
$ mkdir -p /opt/install/go
$ cd /opt/install/go
$ wget https://dl.google.com/go/go1.12.1.linux-amd64.tar.gz
```

##### Unzip and Configure GO environment

```
$ tar zxvf go1.12.1.linux-amd64.tar.gz
$ mv go /opt/app

$ sudo vi /etc/profile

export GOROOT=/opt/app/go
export GOPATH=$GOROOT/gocode
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

$ sudo -s source /etc/profile
```

##### Check Version

```
$ go version

go version go1.12.1 linux/amd64
```

##### Run Go App

```
$ go run startup.go
```

##### Build Go App to Executable File

```
$ export GOPATH=/opt/app/appname_dir
$ go build .
``` 