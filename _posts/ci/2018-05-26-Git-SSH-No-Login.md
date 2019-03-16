---
layout: post
title: "Git 和 TortoiseGit SSH 免密登录"
date: 2018-05-26 15:35:58 +0080
comments: true
categories: "CI/CD"
---

##Git 和 TortoiseGit SSH 免密登录


####Git SSH 免密登录

1. 本地生成秘钥

    ```
    运行 Git Bash
    执行如下命令:
    $ ssh-keygen -t rsa -C "xxxxx@xxx.com"
    一路默认回车
    id_rsa和id_rsa.pub文件会生成到C:\Users\${PC-Account}\.ssh　
    ```　

2. Git服务器打开RSA认证
   
    ```
　　 在Git服务器上首先需要将/etc/ssh/sshd_config中将RSA认证打开：
    RSAAuthentication yes
    PubkeyAuthentication yes
    AuthorizedKeysFile  .ssh/authorized_keys
  
　　 在/home/user下创建.ssh目录，然后创建authorized_keys文件，把id_rsa.pub里面的内容复制到authorized_keys文件中
    $mkdir -p /home/${user}/.ssh
    $cat id_rsa.pub > /home/${user}/.ssh/authorized_keys
    ```

4.修改权限

	```
    $chmod 700 /home/${user}/.ssh
    $chmod 600 /home/${user}/.ssh/authorized_keys
	```

5.Git Bash中测试SSH免密
    
	```
    $ ssh -T ${user}@xx.xx.xx.xx
    如果不需要提示密码登录, 那么免密成功
	```


#### TortoiseGit免密

1. 在TortoiseGit的Settings里, 将Network中的传输客户端替换为C:\installs\Git\usr\bin\ssh.exe

2. 在Git->Remote中将Putty Key改为C:\Users\${PC-Account}\.ssh\id_rsa



 