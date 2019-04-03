---
layout: post
title: "Remote Debug Nginx RTMP using GDBServer and Clion"
date: 2019-02-16 16:50:00 +0800
comments: true
categories: "Nginx"
---

This article will describe how to remote debug nginx RTMP by using GBDserver from windows Clion.

##### Change Nginx Make Debug 

Download nginx source code nginx-1.12.2.tar.gz and nginx RTMP source code from https://github.com/arut/nginx-rtmp-module/archive/v1.2.1.tar.gz

```
vi /opt/app/temp/nginx-1.12.2/auto/cc/conf

change ngx_compile_opt="-c" to ngx_compile_opt="-c -g"
```

##### Configure before make

```
cd /opt/app/temp/nginx-1.12.2
./configure \
  --with-http_ssl_module \
  --with-ld-opt="-Wl,-rpath,/usr/local/lib" \
  --add-module=/opt/app/temp/nginx-rtmp-module-1.2.1 

vi objs/Makefile
```

To make sure the compile command includes "-g" parameter like 

```
objs/src/core/nginx.o:  $(CORE_DEPS) \
        src/core/nginx.c
        $(CC) -c -g $(CFLAGS) $(CORE_INCS) \
                -o objs/src/core/nginx.o \
                src/core/nginx.c
```

##### Compile Source Code

```
make
```

##### Add nginx configuration

```
# completed
user root;
worker_processes 1;

events {
    worker_connections  256;
    accept_mutex        off;
}

http {
    default_type       application/octet-stream;
    sendfile           on;
    keepalive_timeout  65;

    server {
        listen       8080;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        location /stat.xsl {
            root  lsda;
        }
    }
}

rtmp {
    server {
        listen               11935;
        chunk_size           4000;
        notify_method        get;
        drop_idle_publisher  10s;

        application hawk0320 {
            live on;
            allow publish 127.0.0.1;
            deny publish all;
            pull rtmp://192.168.3.43:1935/hawk0320;
        }
    }
}
```

##### Start Nginx RTMP

```
./objs/nginx -c /opt/app/temp/nginx/conf/nginx.conf
```

##### Attach Nginx Process to GDBServer

```
ps -ef |grep nginx

root     17076     1  0 18:31 ?        00:00:00 nginx: master process ./objs/nginx -c /opt/app/temp/nginx/conf/nginx.conf
root     17077 17076  0 18:31 ?        00:00:00 nginx: worker process

gdbserver :9999 --attach 17077
```

##### Add Debug Configuration On Clion

Please refer to [Windows Clion DGB 远程调试](https://robinye.com/2019/03/15/Windows_Clion_GDB_Debug/)





 


