---
layout: post
title: "RTMP Stream Quality Stats"
date: 2018-05-27 06:36:58 +0080
comments: true
categories: "Streaming"
---

###RTMP Stream Quality Stats

This tool is built based on SRS librtmp [https://github.com/ossrs/srs](https://github.com/ossrs/srs). Which is used 
to show the stream bandwidth, keyframe interval, FPS, frame drop rate, audio codec, video codec, and resolution every 10 seconds.
The result can reflect if there's frame drop or packet loss during stream transferring.

#### clone souce code from github

```
$ git clone https://github.com/robinyeeh/srs-stream-stats.git
```

#### Compile

```
$ cd srs-stream-stats
$ cmake .
$ make
```

#### Usage

```
$ chmod +x srs-stream-stats
$./srs-stream-stats rtmp://127.0.0.1:1935/live/livestream,rtmp://127.0.0.1:1935/live/livestream2
```

#### Example Results
```
[2019-03-14 06:21:45.13] [140614975698688]Stream : /app_andy/stream_andy, Bandwidth : 1513416 bps, Keyframe Interval : 2, FPS : 20, Frame drops : 0.00 %, Audio codec : AAC, Video codec : H.264, Resolution: 1280 * 720
[2019-03-14 06:21:55.23] [140614975698688]Stream : /app_andy/stream_andy, Bandwidth : 1504132 bps, Keyframe Interval : 2, FPS : 20, Frame drops : 0.00 %, Audio codec : AAC, Video codec : H.264, Resolution: 1280 * 720
[2019-03-14 06:22:05.33] [140614975698688]Stream : /app_andy/stream_andy, Bandwidth : 1515004 bps, Keyframe Interval : 2, FPS : 20, Frame drops : 0.00 %, Audio codec : AAC, Video codec : H.264, Resolution: 1280 * 720
```





 