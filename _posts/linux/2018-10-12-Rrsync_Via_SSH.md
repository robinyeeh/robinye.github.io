---
layout: post
title: "RSync via SSH"
date: 2018-09-20 16:32:00 +0800
comments: true
categories: "Linux"
---

### RSync via SSH ###


Sync files from remote server to local server.


```
rsync -avz -e "ssh -p 22" --progress --remove-source-files user@192.168.1.111:/home/user/src-folder/ /home/user/dest-folder
```
