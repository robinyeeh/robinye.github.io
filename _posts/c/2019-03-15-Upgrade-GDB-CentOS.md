---
layout: post
title: "Upgrade GDB and GDB Server on CentOS"
date: 2019-03-15 16:43:00 +0080
comments: true
categories: "c++"
---

This article will describe how to upgrade GDB and GDB serve on CentOS

#### Download GDB

```
$ mkdir -p /opt/install/gdb
$ cd /opt/install/gdb

$ wget http://ftp.gnu.org/gnu/gdb/gdb-8.2.tar.gz
$ tar zxvf gdb-8.2.tar.gz
```

##### Compile and Install GDB

```
$ cd gdb-8.2
$ ./configure
$ make 
$ sudo make install

$ sudo mv /usr/local/bin/gdb /usr/bin/
$ gdb --version

GNU gdb (GDB) 8.2
Copyright (C) 2018 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```

##### Compile and Install GDBServer

```
$ cd gdb-8.2/gdb/gdbserver/
$ ./configure
$ make 
$ sudo make install

$ sudo mv /usr/local/bin/gdbserver /usr/bin/
$ gdbserver --version
``` 

##### Add Linux ToolChain

```
Click "Settings -> Build, Execution, Deployment -> Toolchain"

Create new one and named to "Linux", select environment "Remote Host"

Add SSH credentials
```


