---
layout: post
title: "ffmpeg 生成MPEG Dash"
date: 2017-10-11 11:35:58 +0000
comments: true
categories: "ffmpeg"
---


### ffmpeg 生成MPEG Dash

* 切成 Segments
```
$ MP4Box -dash-strict 5000 -profile dashavc264:live -rap foo.mp4#video foo.mp4#audio -out index.mpd
```

命令执行成功后会在当前目录下生成一个mpd文件，两个mp4文件和一系列的m4s文件。下面分别说明：

* index.mpd: 上面提到的 Manifest 文件，XML格式，包含对视频的描述。至于完整的Schema介绍，我也没找到......一点点问G吧。
* *_init.mp4: 初始的mp4文件，相当于视频头，在这个头文件中包含了完整的视频元信息(moov)，具体的可以使用 MP4Box <init video> -info 查看。
* *.m4s: 即上面提到的Segments文件，每个m4s仅包含媒体信息 (moof + mdat)，而播放器是不能直接播放这个文件的，需要用支持DASH的播放器从init文件开始播放。
关于video structure的知识，可以参考这个网页

命令行参数中，-dash 5000 表示把视频按5s一段来切，-profile 指定一些预设的配置，-rap 强制Segments的起始位置为random access point，这个我也不清楚具体指什么，就是网上抄的命令。后面列出所有要导入的媒体流，如果有多个码率，按规则写即可，最后在 -out 后跟上输出的mpd文件名，m4s文件会存放在和mpd文件同级的目录中。
这个切片基本上相当于把视频从中间直接分开，没有重新编码之类的过程，所以比较快。
注意在切片时把audio和video通过上面的命令分开，因为虽然DASH协议并没有限制一个m4s中是否可以包含多过一个moof块，但是目前的浏览器如Chrome是只支持在一个 Segment 中只包含一个moof的。

* 多码率支持
DASH中，对多码率的支持是通过增加 <Representation> 来完成的，具体可以问Google。
* 播放
把生成出来的所有东西放到http服务器的static目录中，即可通过mpd播放器访问了。除此之外，也可以使用支持mpd的app来放。

HLS

* 切成 Segments
```
$ ffmpeg -i foo.mp4 -g 25 -hls_time 1 -hls_list_size 0 index.m3u8
```


这个命令把视频按1秒切成Segments。命令执行成功后，会在当前目录下生成一个m3u8文件和一系列的ts文件。在HLS中，每个Segments都是可以独立播放的MPEG-2 TS文件，而m3u8的作用就是明确这些ts文件的顺序。m3u8文件是纯文本格式，可以方便的阅读修改。命令行参数中，-g 用来指定按frame切视频，而 -hls_time 指定Segments的长度为1s。这两个参数可以限定切出来的Segments 基本 符合1s一段的规则。所以在使用 -g 时需要先确定源视频文件的fps后再设定。不过，即便如此，也有一些Segments的长度会有1s以内的偏差，应该是无法避免的了。-hls_list_size 表示最后生成的m3u8中列出的ts文件的数目，默认是5，此处写0表示把所有的ts文件都列上（这里是项目需求，实际使用中可以适当设置以减少m3u8文件大小）。
没有测过如果最后生成10个ts文件，但是m3u8中只有5个的情况下，能不能把视频放完。回头如果试了再补充。

由于这个命令需要使用ffmpeg对源视频进行重新编码，所以需要占用比较多的CPU和时间。

* 多码率支持
HLS中，多码率的支持是通过 #EXT-X-STREAM-INF 标签指定的，在此标签中通过设置 BANDWIDTH 参数来指定码率，然后在接下来的一行中填写uri来标明此码率对应的m3u8。
* 播放
如果使用Safari，可以直接把m3u8的地址输入地址栏，即可直接播放。据称Android的Chrome也支持，但是桌面的不支持，不过可以通过扩展播放。


Player:

	* http://demo.theoplayer.com/test-hls-mpeg-dash-stream
	* http://bitmovin.com/hls-mpeg-dash-test-player/
	* http://dash-mse-test.appspot.com/dash-player.html
	* http://shaka-player-demo.appspot.com/demo/
	* http://dashif.org/reference/players/javascript/1.4.0/samples/dash-if-reference-player/




```