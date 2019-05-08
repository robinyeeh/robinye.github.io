---
layout: post
title: "CentOS Disk Management"
date: 2019-03-18 11:40:00 +0800
comments: true
categories: "Linux"
---

This article will describe how to manage disks on CentOS7.

##### DELL RAID Configure

1. F12 goes into dell bios
2. Press F10 and select "Life cycle ...."
3. Select system settings
4. Create new VD
5. Import all disks for RAID group


##### Disk format and mount

1. Check physical disks
```
# fdisk -l

Disk /dev/sda: 599.6 GB, 599550590976 bytes, 1170997248 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000d19ba

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     2099199     1048576   83  Linux
/dev/sda2         2099200    85985279    41943040   82  Linux swap / Solaris
/dev/sda3        85985280  1170997247   542505984   83  Linux

Disk /dev/sdb: 599.6 GB, 599550590976 bytes, 1170997248 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdc: 599.6 GB, 599550590976 bytes, 1170997248 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdd: 599.6 GB, 599550590976 bytes, 1170997248 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

2. Disk format, xfs is recommended for centos7 file system format

```
# mkfs.xfs /dev/sdb
# mkfs.xfs /dev/sdc
# mkfs.xfs /dev/sdd
```

3. Disk mount

Temporarily mount disk
```
cat /etc/passwd

mount -t xfs /dev/sdb /storage1 -o uid=0, gid=0
mount -t xfs /dev/sdc /storage2 -o uid=0, gid=0
mount -t xfs /dev/sdd /storage3 -o uid=0, gid=0
```

Permanently mount disk 
```
/dev/sdb               /storage1          xfs     noatime,nodiratime,defaults,nofail       0 0
/dev/sdc               /storage2          xfs     noatime,nodiratime,defaults,nofail       0 0
/dev/sdd               /storage3          xfs     noatime,nodiratime,defaults,nofail       0 0
```

uid=0, gid=0 are the user id and group id that you would like to mount for. Run "cat /etc/passwd" to show all users and groups.

4. Check mount

```
# df -h

# mount -a
``` 


 


