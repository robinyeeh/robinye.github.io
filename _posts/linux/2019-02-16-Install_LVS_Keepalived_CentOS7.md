---
layout: post
title: "Install LVS and keepalived on CentOS7"
date: 2019-02-16 11:40:00 +0800
comments: true
categories: "Linux"
---

This article will describe how to install LVS and keepalived on CentOS7 for layer 4 network load balance.

### Introduction

- DR : Direct server
- VIP: Virtual IP
- CIP: client IP
- RIP: real IP

LVS and keepalive is usually used for layer 4(TCP/UDP) load balance. There're 3 ways of redirect.

-   NAT: All inbound and outbound will pass through LB server. It will change VIP to client IP as src IP when inbound, 
and change VIP as src IP when outbound. It will be performance issue.  
-   DR: Inbound will pass through LB server but outbound won't. It will change MAC address instead of src IP.
Mostly we use this way but DR and VIP, RIP should be in same subnet.
-   TUN : Rarely use this way. 

##### 1. Install Dependencies

```
yum -y install gcc openssl openssl-devel libnl libnl-devel libnl3-devel net-snmp-devel libnfnetlink-devel -y
```

##### 2. Install LVS

```
yum -y install ipvsadm
```

##### 3. Install keepalived

There will be TCP bind issue for VIP "TCP socket bind failed. Rescheduling." if using yum to install keepalived.
So we will download package and compile,build by ourselves.

```
mkdir -p /opt/install/keepalived
cd /opt/install/keepalived
wget http://www.keepalived.org/software/keepalived-2.0.13.tar.gz
tar zxvf keepalived-2.0.13.tar.gz
cd keepalived-2.0.13

./configure --prefix=/usr/local/keepalived/
make && make install
```

##### 4. Configure Auto Start

```
mkdir /etc/keepalived
cp /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf
cp /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/keepalived
```

##### 5. Configure keepalived

Please note that you need to comment "#vrrp_strict", otherwise it will be ping issue to VIP. 

```
vi /etc/keepalived/keepalived.conf

onfiguration File for keepalived

global_defs {
   notification_email {
     acassen@firewall.loc
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   notification_email_from Alexandre.Cassen@firewall.loc
   smtp_server 192.168.200.1
   smtp_connect_timeout 30
   router_id LVS_DEVEL
   vrrp_skip_check_adv_addr
   #vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

vrrp_instance VI_1 {
    state MASTER
    interface enp0s3
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.4.180
    }
}

virtual_server 192.168.4.180 5044 {
    delay_loop 6
    lb_algo wlc
    lb_kind DR
    persistence_timeout 50
    protocol TCP

    real_server 192.168.4.135 5044 {
        weight 1
        TCP_CHECK {
		connect_timeout 3
		nb_get_retry 3
		delay_before_retry 3
		connect_port 5044
	}  
    }

    real_server 192.168.4.136 5044 {
        weight 1
        TCP_CHECK {
                connect_timeout 3
                nb_get_retry 3
                delay_before_retry 3
                connect_port 5044
        }       
    }
}
```

##### 6. Start keepalived and enable auto-start

```
systemctl enable keepalived.service
systemctl start keepalived.service
systemctl status keepalived.service
```

##### 7. Add VIP to Real Server

```
ip addr add 192.168.4.180/24 brd 192.168.7.255 dev enp0s3 label enp0s3
arping -q -A -c 1 -I enp0s3 192.168.4.180
```

To remove VIP
```
ip addr del 192.168.4.180/24 dev enp0s3
```

##### 8. Check LB forward
 
Check if VIP is bonded to ethnet
```
ip a

inet 192.168.4.180/32 scope global enp0s3
       valid_lft forever preferred_lft forever
```

Check forward
```
ipvsadm -l

Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  ssvdev-lsda03:lxi-evntsvc wlc persistent 50
  -> 192.168.4.135:lxi-evntsvc    Route   1      0          0         
  -> 192.168.4.136:lxi-evntsvc    Route   1      0          0   
```

Check connection entries

```
ipvsadm -lnc

pro expire state       source             virtual            destination
TCP 00:47  NONE        192.168.6.38:0     192.168.4.180:5046 192.168.4.136:5046
TCP 14:57  ESTABLISHED 192.168.6.38:55008 192.168.4.180:5046 192.168.4.136:5046
```

### FAQ

##### 1. Bind network card error

Check eth network card and change interface

```
ipconfig 

enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500

Change this line in /etc/keepalived/keepalived.conf
interface enp0s3
```

##### 2. Can not TCP bind 

Please download package to compile and install instead of yum install. 

##### 3. Can not ping

Please comment "vrrp_strict" in /etc/keepalived/keepalived.conf

##### 4. Can not telnet

Please add Virtual IP in read server, refer to step 7.

##### 5. Can not forward inbound request

Please check if your real server's application bind to IPV4 "0.0.0.0" or IPV6 ":::".

```
netstat -anp | grep 5044

tcp        0      0 0.0.0.0:5044            0.0.0.0:*               LISTEN      30784/java

or 

tcp6       0      0 :::5044                 :::*                    LISTEN      19697/java   
```


 


