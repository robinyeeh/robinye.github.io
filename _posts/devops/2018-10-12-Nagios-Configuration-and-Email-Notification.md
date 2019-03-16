---
layout: post
title: "Nagios Configuration and Email Notification"
date: 2018-09-20 16:12:58 +0080
comments: true
categories: "DevOps"
---


### Nagios Configuration and Email Notification ###

#### Add Contact and Group for Nagios

```
# vi /usr/local/nagios/etc/objects/contacts.cfg

define contact{
        contact_name                    contact-admin             ; Short name of user
        use                             generic-contact         ; Inherit default values from generic-contact template (defined above)
        alias                           SwiftServe Admin            ; Full name of user
        register                        1

        email                           robin@xxxxx.com.cn        ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******
        }
        

define contactgroup{
        contactgroup_name       group-admins
        alias                   Group Administrators
        members                 contact-admin
        }        
```

#### Add host and service template

```
# vi /usr/local/nagios/etc/objects/templates.cfg

define host{
   name                         monitor-server
   use                          linux-server
   notifications_enabled        1
   notification_period          24x7
   notification_interval        120
   notification_options         d,u,r,f,s
   register                     1
   contact_groups               group-admins
   }
   
define service {
   name                         monitor-service
   use                          generic-service
   notifications_enabled        1
   notification_period          24x7
   notification_options         w,u,c,r,f,s
   notification_interval        120
   register                     1
   _gluster_entity              Service
   contact_groups               group-admins
}    
```

#### Add Host and Service monotiring
```
# vi /usr/local/nagios/etc/objects/monitoring.cfg

define host{
        use         monitor-server
                                     
        host_name   192.168.4.101
        alias       192.168.4.102
        address     192.168.4.103
        }

        
define service{
        use                             monitor-service         ; Name of service template to use
        host_name                       192.168.4.101
        service_description             LogServer
        check_command                   check_nrpe!LSDA_check_tcp_abc-com_p8080_8090
        }        
```

#### Change thirdparty smtp server

```
# vi /etc/mail.rc

set from="robin@xxxx.com.cn"
set smtp=smtp.exmail.qq.com
set smtp-auth-user=robin@xxxxx.com.cn
set smtp-auth-password=xxxxxx
set smtp-auth=login
set smtp-use-starttls
set ssl-verify=ignore
set nss-config-dir=/etc/pki/nssdb/
```

###### Test and Verify

```
# mailx -v -s "hello" "robin@xxxx.com.cn"
ctrl+d
```

#### Restart Nagios
```
# /bin/systemctl restart nagios
```
