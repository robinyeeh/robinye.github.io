---
layout: post
title: "Use Let's Encrypt to Secure Your Website"
date: 2018-07-17 16:16:58 +0800
comments: true
categories: "Security"
---

###Use Let's Encrypt to Secure Your Website###


####Download Let's Encrypt####
```
# yum install certbot 
```

#### Generate Single SSL Cert ####

```
# certbot certonly --standalone --email heaven.robin@gmail.com -d robinye.com -d cdn-test.robinye.com

Note: Please stop nginx/apache if you got the following error:  
Problem binding to port 80: Could not bind to IPv4 or IPv6.
```

####Generate wildcart SSL Cert####

```
# certbot certonly -d "*.robinye.com" --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory --manual

Add TXT DNS Record Before "Press Enter to Continue"
_acme-challenge 600 TXT psdo4leNJANtg6NAbu600uWXWwVeqbt3LvjI3tWTCbg

use dig/nslookup to check if DNS record is ready:
$ nslookup _acme-challenge.robinye.com
```

#### Check SSL cert####

```
ll /etc/letsencrypt/live/robinye.com/
```

#### Add configuration to Nginx ####

```
server {
    listen 443;
    server_name robinye.com;

    access_log  /var/log/nginx/access.log;

    ssl on;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers ECDHE-RSA-AES256-SHA384:AES256-SHA256:RC4:HIGH:!MD5:!aNULL:!eNULL:!NULL:!DH:!EDH:!AESGCM;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:40m;
    ssl_session_timeout 60m;
    ssl_certificate /etc/letsencrypt/live/robinye.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/robinye.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/robinye.com/chain.pem;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-Ip $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto  https;
    }

    client_max_body_size 500m;
}
```


#### Auto renew SSL Cert ####

```
$ crontab -e
add the following line:
30 2 * * 1 certbot renew >> /var/log/letsencrypt/le-renew.log && nginx reload
```

#### Manually renew SSL Cert ####

```
certbot  --server https://acme-v02.api.letsencrypt.org/directory -d "*.robinye.com" --manual --preferred-challenges dns-01 certonly
```