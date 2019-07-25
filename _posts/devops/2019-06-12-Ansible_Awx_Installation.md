---
layout: post
title: "Ansible Awx Installation"
date: 2019-06-12 16:12:58 +0080
comments: true
categories: "DevOps"
---


#### Ansible Awx Installation ####

Ansisble awx is an open source project for auto deployment based on ansible tower, you could deploy apps via web ui on multiple machines.
github: https://github.com/ansible/awx

##### Install Docker

Install docker first.

##### Install Ansible Awx

```
$ git clone https://github.com/ansible/awx.git
$ cd ansible/awx/installer

$ pip install docker 
$ pip install docker compose

$ mkdir -p /opt/app/ansible/awx/projects
$ vi inventory

add the following configuration:
project_data_dir=/opt/app/ansible/awx/projects

$ ansible-playbook -i inventory install.yml -vv
```

##### Check Installation
 
```
$ docker container ls
$ docker ps -a

CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS                       PORTS                                                 NAMES
de801e698d0c        ansible/awx_task:6.1.0         "/tini -- /bin/sh -c…"   22 seconds ago      Up 21 seconds                8052/tcp                                              awx_task
93e74e44bee2        ansible/awx_web:6.1.0          "/tini -- /bin/sh -c…"   23 seconds ago      Up 21 seconds                0.0.0.0:80->8052/tcp                                  awx_web
9dde0d231347        ansible/awx_rabbitmq:3.7.4     "docker-entrypoint.s…"   24 seconds ago      Up 22 seconds                4369/tcp, 5671-5672/tcp, 15671-15672/tcp, 25672/tcp   awx_rabbitmq
a399aad93e0c        postgres:9.6                   "docker-entrypoint.s…"   24 seconds ago      Up 22 seconds                5432/tcp                                              awx_postgres
f08d5601a7e7        memcached:alpine               "docker-entrypoint.s…"   24 seconds ago      Up 22 seconds                11211/tcp                                             awx_memcached   
```

##### Access UI

```
UI: http://localhost
username : admin
password : password
```

##### Manual

You can access the following website to view manual. 

```
https://blog.51cto.com/10616534/2407182?source=drh

https://docs.ansible.com/ansible-tower/
```

##### Quick Start Steps

1. Create credentials

Create github access credential and target machines credential. For github credential, please select "Source Control", and for target machines, please 
select "Machine". For the password, it's recommended using private key instead of password for production. But you could use password for local testing.

![](/images/devops/create_credential.png)

2. Create project 

Create project and add playbook. You can either create playbook and place under /opt/app/ansible/awx/projects or pull from git.

You could refer to the example playbook at https://github.com/robinyeeh/ansible-awx-roles-demo 

![](/images/devops/create_project.png)

3. Create inventory, group and hosts

Please add the following variables when creating inventory:
```
---
remote_user: root
become_user: root
become: true

project: mbp
version: 1.0.0
#build: g63782e4
env: dev
date: "{{ lookup('pipe', 'date +%Y%m%d') }}"
source_dir: /var/lib/awx/projects/packages
installation_dir: /opt/install/{{ project }}/{{ date }}
project_dir: /opt/app/{{ project }}
```

![](/images/devops/create_inventory.png)

![](/images/devops/create_group.png)

![](/images/devops/create_host.png)

4. Create template

Please select inventory, project you created, and select correct playbook. For credential, it should be target machines access credential.

![](/images/devops/create_template.png)

5. Update SCM

Click button to update latest playbook.

![](/images/devops/update_scm.png)

6. Start job using created template

![](/images/devops/lauch_template.png)



