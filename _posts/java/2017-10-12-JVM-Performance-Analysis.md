---
layout: post
title: "JVM Performance Analysis - jps, jmap, jstack, jstat"
date: 2017-10-12 16:30:00 +0800
comments: true
categories: "Java"
---


This article will show how to analyze JVM resources usage and performance. 



##### jps（Java Virtual Machine Process Status Tool）

jps will show all JVM processes including main jar or classes, pid, JVM parameters

```
jps [options] [hostid]

$ jps -m -l -v

14192 sun.tools.jps.Jps -m -l -v -Denv.class.path=/opt/app/jdk8/lib/ -Dapplication.home=/opt/app/jdk8 -Xms8m
27478 org.logstash.Logstash -f logstash.conf -Xms1g -Xmx1g -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Djruby.compile.invokedynamic=true -Djruby.jit.threshold=0 -XX:+HeapDumpOnOutOfMemoryError -Djava.security.egd=file:/dev/urandom
```

##### jmap

Jmap will show heap usage and memory object address 


1) Heap usage

```
$ jmap -heap pid
Heap Configuration:
   MinHeapFreeRatio         = 40
   MaxHeapFreeRatio         = 70
   MaxHeapSize              = 1073741824 (1024.0MB)
   NewSize                  = 268435456 (256.0MB)
   MaxNewSize               = 268435456 (256.0MB)
   OldSize                  = 268435456 (256.0MB)
   NewRatio                 = 2
   SurvivorRatio            = 1
   MetaspaceSize            = 134217728 (128.0MB)
   CompressedClassSpaceSize = 1073741824 (1024.0MB)
   MaxMetaspaceSize         = 268435456 (256.0MB)
   G1HeapRegionSize         = 0 (0.0MB)

Heap Usage:
New Generation (Eden + 1 Survivor Space):
   capacity = 178978816 (170.6875MB)
   used     = 27958776 (26.66356658935547MB)
   free     = 151020040 (144.02393341064453MB)
   15.621276654327627% used
Eden Space:
   capacity = 89522176 (85.375MB)
   used     = 27958776 (26.66356658935547MB)
   free     = 61563400 (58.71143341064453MB)
   31.231117527795572% used
From Space:
   capacity = 89456640 (85.3125MB)
   used     = 0 (0.0MB)
   free     = 89456640 (85.3125MB)
   0.0% used
To Space:
   capacity = 89456640 (85.3125MB)
   used     = 0 (0.0MB)
   free     = 89456640 (85.3125MB)
   0.0% used
concurrent mark-sweep generation:
   capacity = 268435456 (256.0MB)
   used     = 45908304 (43.78157043457031MB)
   free     = 222527152 (212.2184295654297MB)
   17.10217595100403% used
```   

2) MetaSpace

```
jmap -clstats  pid

class_loader    classes bytes   parent_loader   alive?  type

<bootstrap>     3254    5628057   null          live    <internal>
0x00000000d0000000      13035   20110262        0x00000000d0042e98      dead    org/springframework/boot/loader/LaunchedURLClassLoader@0x0000000100060a10
0x00000000d1db55d8      1       880     0x00000000d0000000      dead    sun/reflect/DelegatingClassLoader@0x0000000100009df8
0x00000000d0fca8f8      1       880     0x00000000d0000000      dead    sun/reflect/DelegatingClassLoader@0x0000000100009df8
```

3) heap objects

```
$ jmap -histo:live pid | more

 num     #instances         #bytes  class name
----------------------------------------------
   1:        117308       14355664  [C
   2:         33751        2970088  java.lang.reflect.Method
   3:         87343        2794976  java.util.concurrent.ConcurrentHashMap$Node
   4:        115701        2776824  java.lang.String
   5:         17993        1989544  java.lang.Class
   6:         42924        1716960  java.util.LinkedHashMap$Entry
   7:          8141        1716648  [B
   8:         19448        1647008  [Ljava.lang.Object;
   9:         16633        1159896  [Ljava.util.HashMap$Node;
  10:         20501        1148056  java.util.LinkedHashMap
  11:           496        1067896  [Ljava.util.concurrent.ConcurrentHashMap$Node;
  12:          8107         939656  [I
  13:           232         752120  [J
  14:         45468         727488  java.lang.Object
  15:         18292         585344  java.util.HashMap$Node
  16:         21154         470584  [Ljava.lang.Class;
  17:          3644         320672  org.apache.catalina.webresources.CachedResource
  18:          8395         268640  java.util.LinkedList
  19:          5315         255120  org.aspectj.weaver.reflect.ShadowMatchImpl
  20:          9658         231792  java.util.ArrayList
  21:          2372         227712  org.springframework.beans.GenericTypeAwarePropertyDescriptor
  22:           312         204672  io.netty.util.internal.shaded.org.jctools.queues.MpscArrayQueue
  23:          7044         202808  [Ljava.lang.String;
  24:          2805         201960  org.springframework.core.annotation.AnnotationAttributes
  25:          8126         195024  org.springframework.core.MethodClassKey
  26:          3974         190752  org.springframework.core.ResolvableType
  27:          4708         188320  java.lang.ref.SoftReference
  28:          5858         187456  java.lang.ref.WeakReference
  29:          5315         170080  org.aspectj.weaver.patterns.ExposedState
  30:          6399         153576  java.util.LinkedList$Node
```

Or you could save to dump.dat, and use MAT, VisualVM or jhat to see them.

```
$ jmap -dump:format=b,file=dump.dat pid     

$ jhat -port 8888 dump.dat
```
Then you could access via browser like http://192.168.1.10:8888

##### jstack

jstack is used to see thread's heap and stack info.

```
$ ps -mp pid -o THREAD, tid, time
or 
$ top -Hp 11118

11330 convers+  20   0 4845904 702244  14424 S  0.7  8.8   3:18.93 java                                                                       
11331 convers+  20   0 4845904 702244  14424 S  0.7  8.8   3:18.48 java                                                                       
11118 convers+  20   0 4845904 702244  14424 S  0.0  8.8   0:00.00 java                                                                       
11120 convers+  20   0 4845904 702244  14424 S  0.0  8.8   0:20.02 java                                                                       
11121 convers+  20   0 4845904 702244  14424 S  0.0  8.8   0:01.59 java                                                                       
11122 convers+  20   0 4845904 702244  14424 S  0.0  8.8   0:01.49 java                                                                       
11123 convers+  20   0 4845904 702244  14424 S  0.0  8.8   0:01.36 java
```

```
$ printf "%x\n" 11330

2b6e
```

```
$ jstack 11118 | grep 2b6e 

"Thread-0" #9 prio=5 os_prio=0 tid=0x00007f9f4c0dc800 nid=0x3ac5 runnable [0x00007f9f0dad5000] 
```

##### jstat


```
$ jstat -gc 21711 250 4

 S0C    S1C    S0U    S1U      EC       EU        OC         OU       MC      MU      CCSC    CCSU       YGC    YGCT    FGC    FGCT     GCT   
87360.0 87360.0  0.0    0.0   87424.0  58567.3   262144.0   47141.1   97536.0 92335.0 12288.0 11383.9    161    4.935   3      0.936    5.871
87360.0 87360.0  0.0    0.0   87424.0  58567.3   262144.0   47141.1   97536.0 92335.0 12288.0 11383.9    161    4.935   3      0.936    5.871
87360.0 87360.0  0.0    0.0   87424.0  58567.3   262144.0   47141.1   97536.0 92335.0 12288.0 11383.9    161    4.935   3      0.936    5.871
87360.0 87360.0  0.0    0.0   87424.0  58567.3   262144.0   47141.1   97536.0 92335.0 12288.0 11383.9    161    4.935   3      0.936    5.871
```

heap mem = new gen  + old gen + metaspace zone

new = Eden zone +  2 Survivor zone(From zone and To zone) 

S0C : Survivor 0 capacity (KB)
S1C : Survivor 1 capacity
S0U : Survivor 0 used
S1U : Survivor 1 used

EC, EU：Eden capacity and used
OC, OU：old capacity and used
MC, MU：metaspace capacity and used
YGC、YGT：new gen GC events and GC time
FGC、FGCT：Full GC events and Full GC time
GCT：Total GC time