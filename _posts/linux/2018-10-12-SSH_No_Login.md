---
layout: post
title: "SSH No login"
date: 2018-09-20 13:02:00 +0800
comments: true
categories: "Linux"
---

### SSH No login ###

##### Generate SSH RSA ####
1. Generate public and private key on client machine

```
	$ ssh-keygen -t rsa -C xxx_Dev
	$ cd ~/.ssh
	$ chmod 600 id_rsa
	
	(Press enter three times, id_rsa : Private key， id_rsa.pub : Public key )
```


2. Copy public key to server machine

```
	$ scp ~/.ssh/id_rsa.pub sftp@192.168.1.1:~/.ssh
	$ touch ~/.ssh/authorized_keys
	$ chmod 600 ~/.ssh/authorized_keys
	
	 (/etc/ssh/sshd_config to change authorized keys, and default one is authorized_keys）
```


3. Append public key to authorized keys

```
$ cat id_rsa.pub >> authorized_keys
```


4. Check if login needs password

```
$ ssh sftp@192.168.1.1
```


##### Multiple keys

1. Add private key to ssh client side
```
vi ~/.ssh/config

add config:
Host 1.2.3.4
    IdentityFile ~/.ssh/id_rsa_second
    User test

touch ~/.ssh/config

chmod 700 .ssh/
chmod 600 .ssh/id_rsa_second
chmod 600 .ssh/config
```

2. Add public key to ssh server side

```
cat id_rsa_pub >> .ssh/authorized_keys
chmod 644 .ssh/authorized_keys
```

 


