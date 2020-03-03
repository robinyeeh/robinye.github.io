---
layout: post
title: "ffmpeg4 api changes"
date: 2020-03-01 16:35:58 +0000
comments: true
categories: "ffmpeg"
---

##### FFMpeg Usage


1. avcodec_decode_video2()

```
This function has been changed to functions avcodec_send_packet() and avcodec_receive_frame:
	old:
	avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, pPacket);

	new:
	avcodec_send_packet(pCodecCtx, pPacket);
	avcodec_receive_frame(pCodecCtx, pFrame);
```
	
2. avcodec_encode_video2()

```
This function has been changed to two functions avcodec_send_frame and avcodec_receive_packet:
	old:
	avcodec_encode_video2(pCodecCtx, pPacket, pFrame, &got_picture);

	new:
	avcodec_send_frame(pCodecCtx, pFrame);
	avcodec_receive_packet(pCodecCtx, pPacket);
```	

3. avpicture_get_size()

```
This function has been deprecated and new function is av_image_get_size(): 
	old:
	avpicture_get_size(AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height);

	new:
	//The last argument -> align is 1，value depends on the situation
	av_image_get_buffer_size(AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height, 1);
```
	
4. avpicture_fill（）

```
This function has been deprecated and changed to av_image_fill_arrays:
	old:
	avpicture_fill((AVPicture *)pFrame, buffer, AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height);

	new:
	//The last argument -> align is 1，value depends on the situation
	av_image_fill_arrays(pFrame->data, pFrame->linesize, buffer, AV_PIX_FMT_YUV420P,  pCodecCtx->width, pCodecCtx->height,1);
```

5. AVFormatContext param codec has been deprecated and use codecpar instead

```
	old:
	pCodecCtx = pFormatCtx->streams[video_index]->codec;
	pCodec = avcodec_find_decoder(pFormatCtx->streams[video_index]->codec->codec_id);

	new:
	pCodecCtx = avcodec_alloc_context3(NULL);
	avcodec_parameters_to_context(pCodecCtx,pFormatCtx->streams[video_index]->codecpar);
	pCodec    = avcodec_find_decoder(pCodecCtx->codec_id);
```

6. Enum value PIX_FMT_YUV420P has been changed to AV_PIX_FMT_YUV420P


7. AVStream::codec has been deprecated and use codecpar instead

```
	old:
	if(pFormatCtx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO){

	new:
	if(pFormatCtx->streams[i]->codecpar->codec_type==AVMEDIA_TYPE_VIDEO){
```
	
8. AVStream::codec has been deprecated and use codecpar instead

```
	old:
	pCodecCtx = pFormatCtx->streams[videoindex]->codec;

	new:
	pCodecCtx = avcodec_alloc_context3(NULL);
	avcodec_parameters_to_context(pCodecCtx, pFormatCtx->streams[videoindex]->codecpar);
```
	
9. avpicture_get_size has been deprecated and use av_image_get_buffer_size instead

```
	old:
	avpicture_get_size(AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height)

	new:
	#include "libavutil/imgutils.h"
	av_image_get_buffer_size(AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height, 1)
```
	
10. avpicture_fill has been deprecated and use av_image_fill_arrays instead

```
	old:
	avpicture_fill((AVPicture *)pFrameYUV, out_buffer, AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height);

	new:
	av_image_fill_arrays(pFrameYUV->data, pFrameYUV->linesize, out_buffer, AV_PIX_FMT_YUV420P, 
	 pCodecCtx->width, pCodecCtx->height, 1);
```

11. avcodec_decode_video2 has been deprecated

```
	old:
	ret = avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet); //got_picture_ptr Zero if no frame could be decompressed

	new:
	ret = avcodec_send_packet(pCodecCtx, packet);

	got_picture = avcodec_receive_frame(pCodecCtx, pFrame); //got_picture = 0 success, a frame was returned

	or：

	int ret = avcodec_send_packet(aCodecCtx, &pkt);

	if (ret != 0)
	{
	 prinitf("%s/n","error");
	 return;
	}

	while( avcodec_receive_frame(aCodecCtx, &frame) == 0){
	 //receive audio or video frame
	 //handle frame
	}
```
	
12. av_free_packet has been deprecated 

```
	old:
	av_free_packet(packet);

	new:
	av_packet_unref(packet);
```
	
13. avcodec_decode_audio4 has been deprecated

```
	old:
	result = avcodec_decode_audio4(dec_ctx, out_frame, &got_output, &enc_pkt);

	new:
	int ret = avcodec_send_packet(dec_ctx, &enc_pkt);

	if (ret != 0) {
	 prinitf("%s/n","error");
	}

	while( avcodec_receive_frame(dec_ctx, &out_frame) == 0){
	 //receive audio or video frame
	 //handle frame

	}
```

14. av_register_all(), av_register_input_foramt(), av_register_output_format() have been deprecated
	





