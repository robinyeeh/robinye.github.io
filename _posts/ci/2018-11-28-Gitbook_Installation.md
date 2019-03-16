---
layout: post
title: "Gitbook Installation"
date: 2018-11-28 22:10:22 +0080
comments: true
categories: "CI/CD"
---

### Gitbook Installation

Gitbook is really good markdown framework for you to manage pages and api easily.

####  Install npm  

```
$ sudo curl -sL -o /etc/yum.repos.d/khara-nodejs.repo https://copr.fedoraproject.org/coprs/khara/nodejs/repo/epel-7/khara-nodejs-epel-7.repo
$ sudo yum -y install npm
$ sudo npm install -g gitbook-cli
$ sudo npm uninstall -g gitbook
$ gitbook update
```

####  Init gitbook and install plugins 

```
cd /opt/app/cdn/docs
$ gitbook init
$ gitbook install ./
```

####  Start gitbook serve

`$ gitbook serve`

*  Or generate html files

`$ gitbook build`

####  Nginx config

```
upstream cdn_docs {
   ip_hash;
   server 192.168.4.134:4000 max_fails=1 fail_timeout=5s;
}

server {
    listen  80;
    server_name cdn-docs.example.com;

    rewrite ^(.*)$  https://$host$1 permanent;
}

server {
    listen       443;
    server_name  cdn-docs.example.com;

    access_log  /opt/logs/cdn/nginx/ssl_docs.access.log  main;

    ssl on;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers ECDHE-RSA-AES256-SHA384:AES256-SHA256:RC4:HIGH:!MD5:!aNULL:!eNULL:!NULL:!DH:!EDH:!AESGCM;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:40m;
    ssl_session_timeout 60m;
    ssl_certificate SSL/example/example.com.crt;
    ssl_certificate_key SSL/example/example.com.key;

    rewrite_log off;
    error_log /opt/logs/cdn/nginx/ssl_docs.access.error.log;


    location / {
         limit_except GET POST OPTIONS PUT DELETE{
             deny all;
         }

         proxy_pass         http://cdn_docs;
         proxy_set_header   Host             $host;
         proxy_set_header   X-Real-IP        $remote_addr;
         proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;

         expires 0d;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /etc/nginx/html;
    }

    client_max_body_size 400m;
}
```

#### Gitbook config

```
{
    "gitbook": "3.2.3",
    "title": "XXXXXXXXXX",
    "description": "https://docs.robinye.com",
    "author": "Conversant",
    "links": {
        "sidebar": {}
    },
    "plugins": ["-sharing","-livereload","prism","anchor-navigation-ex","favicon","splitter", "page-footer-ex", "toggle-chapters", "sectionx","header"],
    "pluginsConfig": {
        "anchor-navigation-ex": {
            "associatedWithSummary": false,
            "showLevel": false,
            "multipleH1": false,
            "mode": "float",
            "pageTop": {
                "showLevelIcon": false,
                "level1Icon": "fa fa-hand-o-right",
                "level2Icon": "fa fa-hand-o-right",
                "level3Icon": "fa fa-hand-o-right"
            }
        },
        "theme-default": {
            "showLevel": false
        },
        "prism": {
            "css": [
                "/opt/app/docs/resources/styles/website.css"
            ]
        },
        "favicon":{
	        "shortcut": "resources/images/favicon.ico",
	        "bookmark": "resources/images/favicon.ico"
        },
        "page-footer-ex": {
            "copyright": " © xxxxxxxxxxx Pte Ltd. All rights reserved.",
            "markdown": true,
            "update_label": "<i>Updated</i>",
            "update_format": "YYYY-MM-DD HH:mm:ss"
        },
        "layout": {
              "headerPath" : "layouts/header.html"
        }
    }
}
```