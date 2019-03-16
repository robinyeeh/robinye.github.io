---
layout: post
title: "Gitlab Installation"
date: 2018-11-28 21:36:58 +0080
comments: true
categories: "CI/CD"
---

#### Gitlab installation 

Gitlab is a really good souce code repository host server for source code management like master, branches, tags.

It also provide built-in CI/CD tools for team to submit source codes, countinuous integration, countinuous deployment easily. Of course you could integrate with k8s as well for auto deployment.

1. Install docker

```
$ sudo yum -y install docker

Add aliyun docker image
$ sudo vi /etc/docker/daemon.json
{
  "registry-mirrors": ["https://3d9d1zrw.mirror.aliyuncs.com"]
}
```

2. Install gitlab

```
sudo docker run --detach \
--hostname git.example.com.cn \
--env GITLAB_OMNIBUS_CONFIG="external_url 'http://git.example.com.cn/';; gitlab_rails['lfs_enabled'] = true;"  \
--publish 443:443 --publish 80:80 --publish 9022:22 \
--name gitlab \
--restart always \
--volume /opt/app/gitlab/config:/etc/gitlab \
--volume /opt/app/gitlab/logs:/var/log/gitlab \
--volume /opt/app/gitlab/data:/var/opt/gitlab \
gitlab/gitlab-ce:latest

```

3. add dns record

```
git.example.com.cn             IN A    192.168.1.100
```

4. Add email notification, Please refer to [https://docs.gitlab.com/omnibus/settings/smtp.html#qq-exmail](https://docs.gitlab.com/omnibus/settings/smtp.html#qq-exmail)

```
$ sudo docker exec -it gitlab /bin/bash

\# vi /etc/gitlab/gitlab.rb

change config:
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.exmail.qq.com" 
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_user_name'] = "xxxx@example.com.cn" 
gitlab_rails['smtp_password'] = "xxxxx" 
gitlab_rails['smtp_domain'] = "smtp.exmail.qq.com" 
gitlab_rails['smtp_authentication'] = "login" 
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true
gitlab_rails['gitlab_email_from'] = 'xxx@example.com.cn'

\#gitlab-ctl reconfigure
```

5. change timezone

```
\# vi /etc/gitlab/gitlab.rb
gitlab_rails['time_zone'] = 'Asia/Shanghai'
```

4. Access http://git.example.com.cn to verify.

Refer to the official website page:
https://docs.gitlab.com/omnibus/docker/README.html


#### Gitlab backup and restore

1. Submit Image

```
\# docker commit -p 15c5ad5fb4bf gitlab/gitlab-ce:20180131
```

2. Backup Image

```
\# docker save -o /opt/backup/docker/gitlab-docker-20180131.tar gitlab/gitlab-ce:20180131
```

3. Migrate Image

```
\# docker load -i /opt/backup/docker/gitlab-docker-20180131.tar
```

4. Load image and start container

```
sudo docker run --detach \
--hostname git.conversant.com.cn \
--env GITLAB_OMNIBUS_CONFIG="external_url 'http://git.conversant.com.cn/';; gitlab_rails['lfs_enabled'] = true;"  \
--publish 443:443 --publish 80:80 --publish 9022:22 \
--name gitlab \
--restart always \
--volume /opt/app/gitlab/config:/etc/gitlab \
--volume /opt/app/gitlab/logs:/var/log/gitlab \
--volume /opt/app/gitlab/data:/var/opt/gitlab \
--volume /opt/app/gitlab/logs/reconfigure:/var/log/gitlab/reconfigure \
gitlab/gitlab-ce:latest
```

5. Check version:

```
\# docker exec -it gitlab cat /opt/gitlab/version-manifest.json | grep build_version
```

5. Backup gitlab

```
\# docker exec -t 15c5ad5fb4bf gitlab-rake gitlab:backup:create
```

6. Copy gitlab

```
\# docker cp 15c5ad5fb4bf:/var/opt/gitlab/backups/1517416278_2018_01_31_10.2.5_gitlab_backup.tar /opt/backup/docker/
\# scp 1517416278_2018_01_31_10.2.5_gitlab_backup.tar conversant@192.168.1.10:/opt/backup/docker/
```

7. Copy gitlab backup

```
\# docker cp /opt/backup/docker/1517416278_2018_01_31_10.2.5_gitlab_backup.tar b8e2c066855f:/var/opt/gitlab/backups
```

8. Restore backup

```
\# docker exec -it gitlab chmod 777 /var/opt/gitlab/backups/1517416278_2018_01_31_10.2.5_gitlab_backup.tar 
\# docker exec -it gitlab gitlab-rake gitlab:backup:restore BACKUP=1517416278_2018_01_31_10.2.5   
```

9. Add configuration

```
external_url 'https://git.conversant.com.cn'

nginx['listen_port'] = 80
nginx['listen_https'] = false

gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.exmail.qq.com" 
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_user_name'] = "gitlab-noreply@conversant.com.cn" 
gitlab_rails['smtp_password'] = "password" 
gitlab_rails['smtp_domain'] = "smtp.exmail.qq.com" 
gitlab_rails['smtp_authentication'] = "login" 
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true
```

10. Start container

```
\# docker start gitlab
```

11. Stop container

```
\# docker stop gitlab
```

12. Show logs

```
\# docker logs -f -t --tail 10 gitlab
```