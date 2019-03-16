---
layout: post
title: "Add DSO to tengine"
date: 2018-09-20 15:52:00 +0800
comments: true
categories: "DevOps"
---

### Add DSO to tengine ###

#### Download headers more nginx module ####

```
$ cd /opt/install/nginx/   
$ wget https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz    
$ tar zxvf v0.33.tar.gz
$ sudo /opt/app/nginx/sbin/dso_tool --add-module=/opt/install/nginx/headers-more-nginx-module-0.33
```
#### Load DSO ####

```
$ sudo vi /opt/app/tengine/conf/nginx.conf

Add configuration:
dso {
\#    load ngx_http_fastcgi_module.so;
\#    load ngx_http_rewrite_module.so;
     load ngx_http_headers_more_filter_module.so;
}
```

#### Add clear headers configuration ####

```
$ sudo vi /opt/app/tengine/conf/nginx/conf/default.conf

more_clear_headers "X-Frame-Options";
```
