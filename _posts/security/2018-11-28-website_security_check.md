---
layout: post
title: "Make your website security to A+"
date: 2018-11-28 22:36:58 +0080
comments: true
categories: "Security"
---

### Make your website security to A+


### Test Your Website Security Level


```
Go to wosign webstie, and input your website host name,it will give you the security level of your website.

https://wosign.ssllabs.com
````

If you got F, there are some steps which could help you secure your website.

### Use HTTPs via HTTP

1. If you do not have TLS/SSL certificate, then you could refer to [Use Let's Encrypt to Secure Your Website](https://robinye.com/blog/2018/07/17/Use%20Let's%20Encrypt%20to%20Secure%20Your%20Website/), and generate TLS/SS certificate for free. 

2. Generate 2048 bit strong key.

```
openssl dhparam -out dhparams.pem 2048
```

3. Add configuration to your nginx.

```
    ssl on;  
    ssl_protocols TLSv1.2 TLSv1.1;  
    ssl_ciphers EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH;  
    ssl_prefer_server_ciphers on;  
    ssl_dhparam SSL/dhparams.pem;  
    ssl_session_cache shared:SSL:40m;  
    ssl_session_timeout 60m;  
    ssl_certificate /etc/letsencrypt/live/xxx.com/fullchain.pem;  
    ssl_certificate_key /etc/letsencrypt/live/xxx.com/privkey.pem;  
    ssl_trusted_certificate /etc/letsencrypt/live/xxx.com/chain.pem;  
```

### Add security response header to your nginx

```
    add_header  strict-transport-security 'max-age=31536000;includeSubDomains';
    add_header  X-Frame-Options "ALLOW-FROM http://parent-frame-domain.com/";
    add_header  X-Content-Type-Options 'nosniff';   
    add_header  Content-Security-Policy "frame-ancestors parent-frame-domain.com;default-src 'self' https://accesstowebsite.com  https://*.accesstowebsite https://www.facebook.com https://staticxx.facebook.com; script-src 'self' https://connect.facebook.net 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';img-src 'self' https://img2.accesstowebsite.com";
    add_header  X-XSS-Protection '1; mode=block';
    add_header  Referrer-Policy "no-referrer-when-downgrade";
```

### Test your website again

```
Go to wosign webstie, and input your website host name,it will give you the security level of your website.

https://wosign.ssllabs.com
````