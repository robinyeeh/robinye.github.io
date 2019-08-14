---
layout: post
title: "Spring Cloud Docker"
date: 2019-07-26 19:15:00 +0080
comments: true
categories: "DevOps"
---


#### Spring Cloud Docker

This article describes how to use docker to deploy spring cloud micro services. 


##### Install Docker

```
$ sudo yum -y install docker-ce
```

##### Build Image for Service
 
```
Add "Dockerfile" for service mbp-registry:

FROM java:8
RUN mkdir -p /opt/app/mbp
COPY target/mbp-registry-1.0.0.tar.gz /opt/app/mbp
RUN tar zxvf /opt/app/mbp/mbp-registry-1.0.0.tar.gz -C /opt/app/mbp &&\
    chmod a+x /opt/app/mbp/registry/bin/service.sh

ENV env default

EXPOSE 8761

ENTRYPOINT ["/opt/app/mbp/registry/bin/service.sh", "start", "default"]

build docker image:
$ docker build -t mbp-registry:1.0.0 .

check docker images:
$ docker images

run docker container:
$ docker run -d --name=mbp-registry -i -t mbp-registry:1.0.0

check container logs:
$ docker logs -f -t --tail=100  3774d195ed9d
```

##### Access UI

```
UI: http://localhost:8080
```