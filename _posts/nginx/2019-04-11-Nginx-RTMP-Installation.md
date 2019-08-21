---
layout: post
title: "Nginx RTMP Installation"
date: 2019-02-16 16:50:00 +0800
comments: true
categories: "Nginx"
---

This article will describe how to remote debug nginx RTMP by using GBDserver from windows Clion.

##### Change Nginx Make Debug 

Download nginx source code nginx-1.12.2.tar.gz and nginx RTMP source code from https://github.com/arut/nginx-rtmp-module/archive/v1.2.1.tar.gz

```
# yum -y install lrzsz

# mkdir /opt/install/nginx
# cd /opt/install/nginx 

# wget https://github.com/nginx/nginx/archive/release-1.12.2.tar.gz
# tar zxvf release-1.12.2.tar.gz

# wget https://github.com/arut/nginx-rtmp-module/archive/v1.2.1.tar.gz
# tar zxvf v1.2.1.tar.gz


# git clone https://github.com/robinyeeh/nginx-http-flv-module.git

# cd /opt/install/nginx/nginx-release-1.12.2
# ./auto/configure --prefix=/opt/app/nginx --add-module=/opt/install/nginx/nginx-rtmp-module-1.2.1 --add-module=/opt/install/nginx/nginx-http-flv-module --with-http_ssl_module
# make & make install
```

##### For Mac

```
# ./auto/configure --prefix=/opt/app/nginx --add-module=/opt/install/nginx/nginx-rtmp-module-1.2.1 --add-module=/opt/install/nginx/nginx-http-flv-module --with-openssl=/usr/local/Cellar/openssl/1.0.2s
```

##### RTMP conf
```
rtmp {
     log_format all_params 'LSDA-1-1: $remote_addr [$time_local] $command "$app" "$name" "$args" - $bytes_received $bytes_sent '
                           '"$pageurl" "$flashver" $session_time "" "127.0.0.1" "" - $connection "$swfurl" "$tcurl"';
     access_log nginx-rtmp-access.log all_params;

     #on_play  http://localhost:80/auth_callback;

     server {
         listen         1935;
         chunk_size     4000;
         notify_method  get;

         application live {
             live on;
         }
     }

```

##### Push Stream

```
Push stream with endless loop:
$ ffmpeg -threads 2 -stream_loop -1  -re -i ./test.mp4 -fflags +genpts  -vcodec copy -acodec copy -f flv rtmp://127.0.0.1:1935/live/stream01
```

##### Play Stream

```
$ ffplay rtmp://127.0.0.1:1935/live/stream01
```




 


