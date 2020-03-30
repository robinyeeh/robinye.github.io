---
layout: post
title: "Nginx Openresty Lua Shell Command"
date: 2019-02-16 16:50:00 +0800
comments: true
categories: "Nginx"
---

This article will describe run shell command and return information using nginx openresty and lua script.

#### Install Openresty

You can add the openresty repository to your CentOS system so as to easily install our packages and receive
 updates in the future (via the yum update command). To add the repository, just run the following commands:

```
sudo yum install yum-utils
sudo yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo
```

Then you can install a package, say, openresty, like this:

```
sudo yum install openresty
```

If you want to install the resty command-line utility, then install the openresty-resty package like below:
```
sudo yum install openresty-resty
```

#### Install lua-resty-shell

Refer to github https://github.com/juce/lua-resty-shell

```
git clone https://github.com/juce/lua-resty-shell.git
cp lua-resty-shell/lib/resty/shell.lua /usr/local/openresty/lualib/resty/
```

#### Start sockproc

Refer to github https://github.com/juce/sockproc

```
git clone https://github.com/juce/sockproc.git

cd sockproc
make 

chmod +x sockproc
./sockproc /tmp/shell.sock
chmod 0666 /tmp/shell.sock

Add the above configuration to /etc/rc.local in case server reboot
vi /etc/rc.local

/root/sockproc/sockproc /tmp/shell.sock 
chmod 0666 /tmp/shell.sock
```

#### Configure Nginx

```
vi /usr/local/openresty/nginx/conf/nginx.conf

change "#user nobody;" to "user root;"
```

#### Add Lua Configuration

```
vi /usr/local/openresty/nginx/conf/nginx.conf
```

And add the following configuration:
```
location /update_blog {
    content_by_lua_file lua/blog.lua;
}
```

```
vi /usr/local/openresty/nginx/lua/blog.lua

And add the following configuration:
function update_blog()
        local status, stdout, stderr = shell.execute("/opt/app/blog/update")

        ngx.header.content_type = "text/plain;charset=utf-8"
        if status ~= 0 then
                ngx.say(stderr)
        else
                ngx.say(stdout)
        end
end

update_blog() 
```


 


