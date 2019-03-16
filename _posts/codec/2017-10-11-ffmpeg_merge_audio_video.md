---
layout: post
title: "ffmpeg 合并音视频"
date: 2017-10-11 11:35:58 +0000
comments: true
categories: "Codec"
---

###ffmpeg 合并音视频###

对于 MPEG 格式的视频，可以直接连接：

```
ffmpeg -i "concat:input1.mpg|input2.mpg|input3.mpg" -c copy output.mpg
```


对于mp4文件, 需要转为ts然后在合并为mp4
ffmpeg + ts 这种方案不会造成音视频质量的损失。这个的思路是先将 mp4 转化为同样编码形式的 ts 流，因为 ts流是可以 concate 的，先把 mp4 封装成 ts ，然后 concate ts 流， 最后再把 ts 流转化为 mp4。

```
ffmpeg -i 1.mp4 -vcodec copy -acodec copy -vbsf h264_mp4toannexb 1.ts
ffmpeg -i 2.mp4 -vcodec copy -acodec copy -vbsf h264_mp4toannexb 2.ts
ffmpeg -i "concat:1.ts|2.ts" -acodec copy -vcodec copy -absf aac_adtstoasc output.mp4
```