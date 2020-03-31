---
layout: post
title: "OpenGL FBO"
date: 2020-03-31 12:08:00 +0800
comments: true
categories: "opengl"
---

##### OpenGL Frame Buffer Object



Detach texture from frame buffer
```
GLES20.glBindTexture(GLES20.GL_TEXTURE_2D,0);
GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER,0);
```


Notes: This article is from [https://blog.csdn.net/YuQing_Cat/article/details/83791373](https://blog.csdn.net/YuQing_Cat/article/details/83791373)