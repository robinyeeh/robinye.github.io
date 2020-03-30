---
layout: post
title: "Http Stress Test Tool - WRK"
date: 2018-11-28 21:36:58 +0080
comments: true
categories: "Linux"
---

###wrk for http benchmark


CentOS Installation:

```
https://github.com/wg/wrk/wiki/Installing-wrk-on-Linux
```

github:

```
https://github.com/wg/wrk
```

MacOS Installation

```
https://github.com/wg/wrk/wiki/Installing-wrk-on-OS-X
```

if got error  like this 

```
Undefined symbols for architecture x86_64:
  "_OPENSSL_add_all_algorithms_noconf", referenced from:
      _ssl_init in ssl.o
  "_SSL_library_init", referenced from:
      _ssl_init in ssl.o
  "_SSL_load_error_strings", referenced from:
      _ssl_init in ssl.o
  "_SSLv23_client_method", referenced from:
      _ssl_init in ssl.o
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

then add verbose like this and run "make" again:

```
LDFLAGS += -pagezero_size 10000 -image_base 100000000 -v
```

you will see the following lines 

```
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
 "/Library/Developer/CommandLineTools/usr/bin/ld" -demangle -lto_library /Library/Developer/CommandLineTools/usr/lib/libLTO.dylib -dynamic -arch x86_64 -image_base 100000000 -macosx_version_min 10.14.5 -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk -pagezero_size 10000 -o wrk -Lobj/lib -L/usr/local/opt/openssl/lib obj/wrk.o obj/net.o obj/ssl.o obj/aprintf.o obj/stats.o obj/script.o obj/units.o obj/ae.o obj/zmalloc.o obj/http_parser.o obj/bytecode.o obj/version.o -lluajit-5.1 -lpthread -lm -lcrypto -lssl -L/usr/local/lib -lSystem /Library/Developer/CommandLineTools/usr/lib/clang/10.0.1/lib/darwin/libclang_rt.osx.a
```

and then rearrange -L for openssl lib and run like following command and wrk executable file will be generated:

```
"/Library/Developer/CommandLineTools/usr/bin/ld" -demangle -lto_library /Library/Developer/CommandLineTools/usr/lib/libLTO.dylib -dynamic -arch x86_64 -image_base 100000000 -macosx_version_min 10.14.5 -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk -pagezero_size 10000 -o wrk -L/usr/local/opt/openssl/lib -Lobj/lib obj/wrk.o obj/net.o obj/ssl.o obj/aprintf.o obj/stats.o obj/script.o obj/units.o obj/ae.o obj/zmalloc.o obj/http_parser.o obj/bytecode.o obj/version.o -lluajit-5.1 -lpthread -lm -lcrypto -lssl -L/usr/local/lib -lSystem /Library/Developer/CommandLineTools/usr/lib/clang/10.0.1/lib/darwin/libclang_rt.osx.a```


#### wrk2

```
https://github.com/giltene/wrk2
``` 