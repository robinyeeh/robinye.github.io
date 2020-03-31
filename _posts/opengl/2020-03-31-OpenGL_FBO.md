---
layout: post
title: "OpenGL FBO"
date: 2020-03-31 12:08:00 +0800
comments: true
categories: "opengl"
---

##### OpenGL Frame Buffer Object

OpenGL 管线渲染的最终目的地就是FrameBuffer（帧缓冲），前面写的很多渲染操作等都是在默认的帧缓冲进行操作的，这个默认的帧缓冲是在我们创建Surface
的时候自动创建和配置好的，这个OpenGL ES默认的帧缓冲是由窗口系统提供的，是默认显示到屏幕上的，我们现在的需求是不显示到屏幕中，所以用Frame Buffer Object来实现。

我们都知道显示在屏幕上的每一帧数据都是对应着内存的数据，在内存中对应分配着存储帧数据的缓冲区，比如说写入颜色的颜色缓冲区，写入深度值的深度缓冲区，
以及基于一些条件丢弃片元的模板缓冲区，这几种缓冲一起称之为帧缓冲。

FBO是一组颜色、深度、模板附着点。纹理对象可以连接到FBO中的颜色附着点和深度附着点，另一种连接到深度附着点和模板附着点的叫做渲染缓冲对象（RBO）。

在一个帧缓存对象中有多个颜色关联点、一个深度关联点，和一个模板关联。每个FBO中至少有一个颜色关联点，其数目与实体显卡相关。可以通过GL_MAX_COLOR_ATTACHMENTS_EXT
来查询颜色关联点的最大数目。
需要注意：FBO中并没有存储图像，只有多个关联点。

实际上可以把帧缓冲对象理解为一个插线板，自己本身没有内存，但是可以连接纹理对象和渲染缓冲对象两种外设，这两种外设是有内存的来存储图像数据。


1. Creating FBO

```
//源码：
 public static native void glGenFramebuffers(
        int n, //创建几个fbo
        int[] framebuffers,//帧缓冲区数组
        int offset //从第几个开始取数据
    );

//创建了一个fbo
 private int[] mFrameBuffers == new int[1];
 GLES20.glGenFramebuffers(mFrameBuffers.length,mFrameBuffers,0);
```

返回的mFrameBuffers就包含了一个帧缓冲对象，fbo就创建好了，然后就是需要将这个帧缓冲对象设置为当前的帧缓冲区,使用glBindFramebuffer 方法


```
//源码
    public static native void glBindFramebuffer(
        int target, //一般设置为GL_FRAMEBUFFER
        int framebuffer //帧缓冲区对象
    );
    
GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER,mFrameBuffers[0]);
```

绑定完成以后，接下来所有的读、写操作都会影响到当前绑定的帧缓冲对象。当然也可以把帧缓冲分开绑定到读、写操作上，只需要将target修改为
GL_READ_FRAMEBUFFER或GL_DRAW_FRAMEBUFFER就可以了。这个时候的帧缓冲对象，只是个"空壳"，还需要绑定上面的附着。

2. Texture Attachment

Create texture
```
//2.创建fbo纹理
int[] mFrameBufferTextures = new int[1];//用来记录纹理id
OpenGLUtils.glGenTextures(mFrameBufferTextures);//创建纹理
GLES20.glBindTexture(GLES20.GL_TEXTURE_2D,mFrameBufferTextures[0]);

//加载一个2D图像作为纹理对象
//目标：2D纹理 + 等级 + 格式+ 宽、高 + 格式 + 数据类型 + 像素数据
GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D,0,GLES20.GL_RGBA,mOutputWidth,mOutputHeight,
                0,GLES20.GL_RGBA,GLES20.GL_UNSIGNED_BYTE, null);
```

Attach the texture to frame buffer

```
public static native void glFramebufferTexture2D(
        int target,//创建帧缓冲类型的目标，一般为GLES20.GL_FRAMEBUFFER
        int attachment,//附着点，这里我们传入的是一个纹理对象，所以需要传入一个颜色附着点。
        int textarget,//希望附着的纹理类型，上面创建的是一个2D图像类型，所以这里传入GL_TEXTURE_2D
        int texture,//附着的纹理ID
        int level  //Mipmap level 一般设置为0
    );
    
 GLES20.glFramebufferTexture2D(GLES20.GL_FRAMEBUFFER,GLES20.GL_COLOR_ATTACHMENT0,
                GLES20.GL_TEXTURE_2D,mFrameBufferTextures[0],0);    
```

Detach texture from frame buffer
```
GLES20.glBindTexture(GLES20.GL_TEXTURE_2D,0);
GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER,0);
```


Notes: This article is from [https://blog.csdn.net/YuQing_Cat/article/details/83791373](https://blog.csdn.net/YuQing_Cat/article/details/83791373)