---
layout: post
title: "ffmpeg Usage"
date: 2017-10-11 11:35:58 +0000
comments: true
categories: "Codec"
---

###ffmpeg Usage###

Save RTMP stream to mp4


```
ffmpeg -i rtmp://192.168.3.43:1935/linear/test001?token=1551176683-ea6e1e45cecec8d802906ea44d412902 -c copy -flags +global_header -f segment -segment_time 60 -segment_format_options movflags=+faststart -reset_timestamps 1 test%d.mp4
```


Extract frame and get frame type, frame codec and frame size

```
ffprobe test0.mp4 -show_frames | grep -E 'pict_type|coded_picture_number|pkt_size' > frames.txt
```