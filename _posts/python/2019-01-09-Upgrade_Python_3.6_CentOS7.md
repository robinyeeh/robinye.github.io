---
layout: post
title: "Upgrade Python to 3.6 on CentOS 7"
date: 2018-12-02 20:30:23 +0080
comments: true
categories: "Python"
---

### Upgrade Python to 3.6 on CentOS 7

1. Check if you already installed python

```
$ python -V
2.7.5

$ which python
```

2. Back up python 2.7

```
$ sudo yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make

$ cd /usr/bin/
$ sudo mv python python.bak
```

3. Install python3

```
$ mkdir -p /opt/install/python
$ cd /opt/install/python
$ wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tar.xz
$ tar -xvJf  Python-3.6.3.tar.xz
$ cd Python-3.6.3

$ ./configure prefix=/usr/local/python3
$ make
$ sudo make install

$ sudo ln -s /usr/local/python3/bin/python3 /usr/bin/python
```

4. Check if python3 installed 

```
$ python -V
3.6.3

$ python2 -V
2.7.5
```

4. Change python2 for yum

```
$ sudo vi /usr/bin/yum

Change "#! /usr/bin/python" to "#! /usr/bin/python2"
```

5. Upgrade pip

```
$ sudo vi /usr/libexec/urlgrabber-ext-down
Change "#! /usr/bin/python" to "#! /usr/bin/python2"

$ sudo python -m pip install --upgrade pip
```