---
layout: post
title: "ffmpeg Usage"
date: 2017-10-11 11:35:58 +0000
comments: true
categories: "ffmpeg"
---

##### FFMpeg Usage


1. Save RTMP stream to mp4

```
ffmpeg -i rtmp://192.168.3.43:1935/linear/test001?token=1551176683-ea6e1e45cecec8d802906ea44d412902 -c copy -flags +global_header -f segment -segment_time 60 -segment_format_options movflags=+faststart -reset_timestamps 1 test%d.mp4
```

2. Extract frame and get frame type, frame codec and frame size

```
ffprobe test0.mp4 -show_frames | grep -E 'pict_type|coded_picture_number|pkt_size' > frames.txt
```

3. Record RTMP Stream

```
./ffmpeg -i rtmp://172.17.120.242:1937/live/ai-4 -c copy clip.flv
```

4. Show Video Frames Information

```
ffprobe -show_frames -print_format csv -select_streams v /Users/robin/Documents/clip.flv > 12.csv
```

5. Show Frames PTS

```
ffmpeg -i test.mp4 -vf select="between(n\,200\,300),setpts=PTS-STARTPTS" test2.mp4
```

6. Extract Pictures from Video

Extract pictures every 5 seconds from 00:00:00 with duration 01:00. 

```
ffmpeg -i test.mp4 -ss 00:00:00  -t 01:00 -f image2 -vf fps=fps=1/5 ./images2/%5d.jpg
```

Extract pictures with filter:
```
ffmpeg -i test.mp4 -ss 00:00:00  -to 00:01:00 -f image2 -vf "fps=24,select='not(mod(t,5))'" -vsync 0 -frame_pts 1 ./images/%d.jpg
````

7. Transcode TS

Transcode ts with video codec: x264, resolutieon:1024x768, video profile: Main, level 31, B frames : 2,  auto insert B frame : off, fps : 25, B/P 
frame previous reference frames : 1, pixel format : yuv420p, video bite rate : 1000kbps, audio codec : aac, audio bitrate: 128kbps, audio sample rate : 44100

```
ffmpeg -i  a.ts -vcodec libx264 -s 1024x768 -profile:v Main  -level 31 -bf 2 -b_strategy 0 -r 25 -refs 1 -pix_fmt yuv420p -b:v 1000k  -acodec aac -ab 128k -ar 44100 -y b.ts
```

8. Show Stream Info

```
ffprobe -show_streams -print_format json test.mp4
```

9. Push RTMP Stream with MP4

```
ffmpeg -threads 2 -stream_loop -1  -re -i /Users/robin/Documents/clip.flv -fflags +genpts  -vcodec copy -acodec copy -f flv rtmp://127.0.0.1:1935/live/stream01
```

Push RTMP Streams with MP4, and draw local timestamp(This will need to configure freetype and compile):
```
ffmpeg -threads 2 -stream_loop -1  -re -i ./test.mp4 -fflags +genpts  -vcodec libx264 -acodec copy -vf drawtext="expansion=strftime:basetime=$(date +%s -d '2018-10-13 14:10:50'):fontfile=arial.ttf:x=w-tw:fontcolor=red:fontsize=30:text='%Y-%m-%d  %H\\:%M\\: %S" -f flv rtmp://127.0.0.1:1935/live/stream01
```

10. Convert MP4 to HLS

```
ffmpeg  -i test.mp4 -c copy -map 0 -bsf:v h264_mp4toannexb -f hls -hls_wrap 0 -hls_time 30 -hls_segment_filename cut/'cut-%03d.ts' out.m3u8
```

11. Remux MPEGTS to MP4

```
ffmpeg -i cut/cut-000.ts -c copy -f mp4 cut/cut-000.mp4
```

12. Concat MP4

```
ffmpeg -i cut1.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts cut1.ts
ffmpeg -i cut2.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts cut2.ts
ffmpeg -i cut3.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts cut3.ts

ffmpeg -i "concat:cut/cut-000.ts|cut/cut-001.ts|cut/cut-002.ts" -c copy -bsf:a aac_adtstoasc -movflags +faststart out.mp4
```

13. Check Supported Encoders

```
./ffmpeg -encoders | grep x264
```

14. Fade in and Fade Out

```
ffmpeg -r 1/5 -i in%03d.jpg -c:v libx264 -r 30 -y -pix_fmt yuv420p slide.mp4 
ffmpeg -i slide.mp4 -y -vf fade=in:0:30 slide_fade_in.mp4
ffmpeg -i slide_fade_in.mp4 -y -vf fade=out:120:30 slide_fade_in_out.mp4
```

15. Cut mp4

```
ffmpeg -ss 00:00:00 -t 00:00:30 -accurate_seek -i test.mp4 -codec copy -avoid_negative_ts 1 cut1.mp4
```

16. Extract yuv from video

```
ffmpeg -i  test.mp4 -pix_fmt yuv420p test.yuv
```

17. Extract ac3 from video

```
ffmpeg -i test.mts -acodec copy -vn test.ac3
```

18. Extract h264 from video

```
ffmpeg -i test.mts -vcodec copy -an -f h264 test.h264
```
19. Play yuv data

```
ffplay -f rawvideo -video_size 1000x562 test.yuv 
```




