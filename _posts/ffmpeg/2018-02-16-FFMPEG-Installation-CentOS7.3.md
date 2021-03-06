---
layout: post
title: "FFMPEG Installation (CentOS7.3)"
date: 2018-02-16 16:50:00 +0800
comments: true
categories: "ffmpeg"
---

This article will describe how to install ffmpeg, ffplay and ffprobe.

##### Clone Source Code

```
$ git clone https://github.com/FFmpeg/FFmpeg.git
```


##### Install FFMpeg

1. Install fdk aac

```
$ wget https://jaist.dl.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.6.tar.gz
$ tar zxvf fdk-aac-0.1.6.tar.gz

$ cd fdk-aac
$ sudo yum install autoconf
$ sudo apt-get install libtool
$ ./autogen.sh
$ ./configure
$ make -j 8
$ make install
```

2. Install yasm

```
$ wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
$ tar zxvf yasm-1.3.0.tar.gz
$ cd yasm-1.3.0
$ ./configure
$ make -j 8
$ make install 
```

3. Install nasm

```
$ wget https://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.gz
$ tar zxvf nasm-2.13.03.tar.gz
$ cd nasm-2.13.03
$ ./configure
$ make -j 8
$ make install 
```

4. Install x264

```
$ wget wget http://mirror.yandex.ru/mirrors/ftp.videolan.org/x264/snapshots/last_x264.tar.bz2
$ bunzip last_x264.tar.bz2
$ tar xvf last_x264.tar
$ cd last_x264
$ ./configure --enable-static --enable-shared 
$ make -j 8
$ make install 
```

5. Install x265

```
$ yum -y install hg cmake mercurial
$ hg clone http://hg.videolan.org/x265
$ cd x265/build/linux
$ ./make-Makefiles.bash
$ make -j 8
$ make install
$ export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

```

##### Compile FFMpeg

```
$ ./configure  --enable-pthreads --enable-static --disable-shared --enable-x86asm --enable-gpl --enable-libfdk_aac --enable-libx264 --enable-libx265 --enable-nonfree
$ make -j 8
$ make install

$ echo /usr/local/lib >> /etc/ld.so.conf/usr/local/lib
$ ldconfig
```

##### Check Installation

```
$ ./ffmpeg
$ ldd ffmpeg
```

##### Other Codec and Muxer

```
ame
wget http://ufpr.dl.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz

opus
wget http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz

ogg
wget http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz

vorbis
wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz

libvpx
wget git clone https://github.com/webmproject/libvpx.git

xvidcore
wget http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz

libtheora
wget http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
```

##### FFMpeg Compile Configure Options

1. Standard options

|Option      |Description                         |
|:-----      |-----                               |
|–logfile=FILE	    |配置过程中的log输出文件，默认输出到当前位置的ffbuild/config.log文件|
|–disable-logging	|配置过程中不输出日志|
|–fatal-warnings	|把配置过程中的任何警告当做致命的错误处理|
|–prefix=PREFIX	|设定安装的跟目录，如果不指定默认是/usr|
|–bindir=DIR	|设置可执行程序的安装位置，默认是[PREFIX/bin]|
|–datadir=DIR	|设置测试程序以及数据的安装位置，默认是[PREFIX/share/ffmpeg]|
|–docdir=DIR	|设置文档的安装目录，默认是[PREFIX/share/doc/ffmpeg]|
|–libdir=DIR	|设置静态库的安装位置，默认是[PREFIX/lib]|
|–shlibdir=DIR	|设置动态库的安装位置，默认是[LIBDIR]|
|–incdir=DIR	|设置头文件的安装位置，默认是[PREFIX/include]；一般来说用于依赖此头文件来开发就够了|
|–mandir=DIR	|设置man文件的安装目录，默认是[PREFIX/share/man]|
|–pkgconfigdir=DIR	|设置pkgconfig的安装目录，默认是[LIBDIR/pkgconfig]，只有--enable-shared使能的时候这个选项才有效|
|–enable-rpath	|use rpath to allow installing libraries in paths not part of the dynamic linker search path use rpath when linking programs [USE WITH CARE]|
|–install-name-dir=DIR	|Darwin directory name for installed targets|

2. Licensing options

|Option      |Description                         |
|:-----      |-----                               |
|–enable-gpl	    |allow use of GPL code, the resulting libs and binaries will be under GPL [no]|
|–enable-version3	|upgrade (L)GPL to version 3 [no]|
|–enable-nonfree	|allow use of nonfree code, the resulting libs and binaries will be unredistributable [no]|

3. Configuration options

|Option      |Description                         |
|:-----      |-----                               |
|–disable-static	|不生产静态库，默认生成静态库|
|–enable-shared	    |生成动态库，默认不生成动态库|
|–enable-small	|optimize for size instead of speed，默认开启|
|–disable-runtime-cpudetect	|disable detecting cpu capabilities at runtime (smaller binary)，默认开启|
|–enable-gray	|enable full grayscale support (slower color)|
|–disable-swscale-alpha	|disable alpha channel support in swscale|
|–disable-all	|禁止编译所有库和可执行程序|
|–enable-raise-major	|增加主版本号|

4. Program options

|Option      |Description                         |
|:-----      |-----                               |
|–disable-programs	|build command line programs|
|–disable-ffmpeg	|disable ffmpeg build|
|–enable-ffplay	|disable ffplay build|
|–disable-ffprobe	|disable ffprobe build|
|–enable-ffserver	|disable ffserver build|

5. Component options

|Option      |Description                         |
|:-----      |-----                               |
|–disable-avdevice	|disable libavdevice build|
|–disable-avcodec	|disable libavcodec build|
|–disable-avformat	|disable libavformat build|
|–disable-swresample	|disable libswresample build|
|–disable-swscale	|disable libswscale build|
|–disable-postproc	|disable libpostproc build|
|–disable-avfilter	|disable libavfilter build|
|–enable-avresample	|enable libavresample build [no]|
|–disable-pthreads	|disable pthreads [autodetect]|
|–disable-w32threads	|disable Win32 threads [autodetect]|
|–disable-os2threads	|disable OS/2 threads [autodetect]|
|–disable-network	|disable network support [no]|
|–disable-dct	|disable DCT code|
|–disable-dwt	|disable DWT code|
|–disable-error-resilience	|disable error resilience code|
|–disable-lsp	|disable LSP code|
|–disable-lzo	|disable LZO decoder code|
|–disable-mdct	|disable MDCT code|
|–disable-rdft	|disable RDFT code|
|–disable-fft	|disable FFT code|
|–disable-faan	|disable floating point AAN (I)DCT code|
|–disable-pixelutils	|disable pixel utils in libavutil|

6. Individual component options

You can enable individual encoders such as x264, x265, ac3, eac3.

|Option      |Description                         |
|:-----      |-----                               |
|–disable-everything	|disable all components listed below|
|–disable-encoder=NAME	|disable encoder NAME|
|–enable-encoder=NAME	|enable encoder NAME|
|–disable-encoders	|disable all encoders|
|–disable-decoder=NAME	|disable decoder NAME|
|–enable-decoder=NAME	|enable decoder NAME|
|–disable-decoders	|disable all decoders|
|–disable-hwaccel=NAME	|disable hwaccel NAME|
|–enable-hwaccel=NAME	|enable hwaccel NAME|
|–disable-hwaccels	|disable all hwaccels|
|–disable-muxer=NAME	|disable muxer NAME|
|–enable-muxer=NAME	|enable muxer NAME|
|–disable-muxers	|disable all muxers|
|–disable-demuxer=NAME	|disable demuxer NAME|
|–enable-demuxer=NAME	|enable demuxer NAME|
|–disable-demuxers	|disable all demuxers|
|–enable-parser=NAME	|enable parser NAME|
|–disable-parser=NAME	|disable parser NAME|
|–disable-parsers	|disable all parsers|
|–enable-bsf=NAME	|enable bitstream filter NAME|
|–disable-bsf=NAME	|disable bitstream filter NAME|
|–disable-bsfs	disable |all bitstream filters|
|–enable-protocol=NAME	|enable protocol NAME|
|–disable-protocol=NAME	|disable protocol NAME|
|–disable-protocols	|disable all protocols|
|–enable-indev=NAME	|enable input device NAME|
|–disable-indev=NAME	|disable input device NAME|
|–disable-indevs	|disable input devices|
|–enable-outdev=NAME	|enable output device NAME|
|–disable-outdev=NAME	|disable output device NAME|
|–disable-outdevs	|disable output devices|
|–disable-devices	|disable all devices|
|–enable-filter=NAME	|enable filter NAME|
|–disable-filter=NAME	|disable filter NAME|
|–disable-filters	|disable all filters|

7. External library support

|Option      |Description                         |
|:-----      |-----                               |
|–enable-avisynth	|enable reading of AviSynth script files [no]|
|–disable-bzlib	|disable bzlib [autodetect]|
|–enable-chromaprint	|enable audio fingerprinting with chromaprint [no]|
|–enable-frei0r	|enable frei0r video filtering [no]|
|–enable-gcrypt	|enable gcrypt, needed for rtmp(t)e support if openssl, librtmp or gmp is not used [no]|
|–enable-gmp	|enable gmp, needed for rtmp(t)e support if openssl or librtmp is not used [no]|
|–enable-gnutls	|enable gnutls, needed for https support if openssl is not used [no]|
|–disable-iconv	|disable iconv [autodetect]|
|–enable-jni	|enable JNI support [no]|
|–enable-ladspa	|enable LADSPA audio filtering [no]|
|–enable-libass	|enable libass subtitles rendering, needed for subtitles and ass filter [no]|
|–enable-libbluray	|enable BluRay reading using libbluray [no]|
|–enable-libbs2b	|enable bs2b DSP library [no]|
|–enable-libcaca	|enable textual display using libcaca [no]|
|–enable-libcelt	|enable CELT decoding via libcelt [no]|
|–enable-libcdio	|enable audio CD grabbing with libcdio [no]|
|–enable-libdc1394	|enable IIDC-1394 grabbing using libdc1394 and libraw1394 [no]|
|–enable-libebur128	|enable libebur128 for EBU R128 measurement, needed for loudnorm filter [no]|
|–enable-libfdk-aac	|enable AAC de/encoding via libfdk-aac [no]|
|–enable-libflite	|enable flite (voice synthesis) support via libflite [no]|
|–enable-libfontconfig	|enable libfontconfig, useful for drawtext filter [no]|
|–enable-libfreetype	|enable libfreetype, needed for drawtext filter [no]|
|–enable-libfribidi	|enable libfribidi, improves drawtext filter [no]|
|–enable-libgme	|enable Game Music Emu via libgme [no]|
|–enable-libgsm	|enable GSM de/encoding via libgsm [no]|
|–enable-libiec61883	|enable iec61883 via libiec61883 [no]|
|–enable-libilbc	|enable iLBC de/encoding via libilbc [no]|
|–enable-libkvazaar	|enable HEVC encoding via libkvazaar [no]|
|–enable-libmodplug	|enable ModPlug via libmodplug [no]|
|–enable-libmp3lame	|enable MP3 encoding via libmp3lame [no]|
|–enable-libnut	|enable NUT (de)muxing via libnut, native (de)muxer exists [no]|
|–enable-libopencore-amrnb	|enable AMR-NB de/encoding via libopencore-amrnb [no]|
|–enable-libopencore-amrwb	|enable AMR-WB decoding via libopencore-amrwb [no]|
|–enable-libopencv	|enable video filtering via libopencv [no]|
|–enable-libopenh264	|enable H.264 encoding via OpenH264 [no]|
|–enable-libopenjpeg	|enable JPEG 2000 de/encoding via OpenJPEG [no]|
|–enable-libopenmpt	|enable decoding tracked files via libopenmpt [no]|
|–enable-libopus	|enable Opus de/encoding via libopus [no]|
|–enable-libpulse	|enable Pulseaudio input via libpulse [no]|
|–enable-librubberband	|enable rubberband needed for rubberband filter [no]|
|–enable-librtmp	|enable RTMP[E] support via librtmp [no]|
|–enable-libschroedinger	|enable Dirac de/encoding via libschroedinger [no]|
|–enable-libshine	|enable fixed-point MP3 encoding via libshine [no]|
|–enable-libsmbclient	|enable Samba protocol via libsmbclient [no]|
|–enable-libsnappy	|enable Snappy compression, needed for hap encoding [no]|
|–enable-libsoxr	|enable Include libsoxr resampling [no]|
|–enable-libspeex	|enable Speex de/encoding via libspeex [no]|
|–enable-libssh	|enable SFTP protocol via libssh [no]|
|–enable-libtesseract	|enable Tesseract, needed for ocr filter [no]|
|–enable-libtheora	|enable Theora encoding via libtheora [no]|
|–enable-libtwolame	|enable MP2 encoding via libtwolame [no]|
|–enable-libv4l2	|enable libv4l2/v4l-utils [no]|
|–enable-libvidstab	|enable video stabilization using vid.stab [no]|
|–enable-libvo-amrwbenc	|enable AMR-WB encoding via libvo-amrwbenc [no]|
|–enable-libvorbis	|enable Vorbis en/decoding via libvorbis, native implementation exists [no]|
|–enable-libvpx	|enable VP8 and VP9 de/encoding via libvpx [no]|
|–enable-libwavpack	|enable wavpack encoding via libwavpack [no]|
|–enable-libwebp	|enable WebP encoding via libwebp [no]|
|–enable-libx264	|enable H.264 encoding via x264 [no]|
|–enable-libx265	|enable HEVC encoding via x265 [no]|
|–enable-libxavs	|enable AVS encoding via xavs [no]|
|–enable-libxcb	|enable X11 grabbing using XCB [autodetect]|
|–enable-libxcb-shm	|enable X11 grabbing shm communication [autodetect]|
|–enable-libxcb-xfixes	|enable X11 grabbing mouse rendering [autodetect]|
|–enable-libxcb-shape	|enable X11 grabbing shape rendering [autodetect]|
|–enable-libxvid	|enable Xvid encoding via xvidcore, native MPEG-4/Xvid encoder exists [no]|
|–enable-libzimg	|enable z.lib, needed for zscale filter [no]|
|–enable-libzmq	|enable message passing via libzmq [no]|
|–enable-libzvbi	|enable teletext support via libzvbi [no]|
|–disable-lzma	|disable lzma [autodetect]|
|–enable-decklink	|enable Blackmagic DeckLink I/O support [no]|
|–enable-mediacodec	|enable Android MediaCodec support [no]|
|–enable-netcdf	|enable NetCDF, needed for sofalizer filter [no]|
|–enable-openal	|enable OpenAL 1.1 capture support [no]|
|–enable-opencl	|enable OpenCL code|
|–enable-opengl	|enable OpenGL rendering [no]|
|–enable-openssl	|enable openssl, needed for https support if gnutls is not used [no]|
|–disable-schannel	|disable SChannel SSP, needed for TLS support on Windows if openssl and gnutls are not used [autodetect]|
|–disable-sdl2	|disable sdl2 [autodetect]|
|–disable-securetransport	|disable Secure Transport, needed for TLS support on OSX if openssl and gnutls are not used [autodetect]|
|–enable-x11grab	|enable X11 grabbing (legacy) [no]|
|–disable-xlib	|disable xlib [autodetect]|
|–disable-zlib	|disable zlib [autodetect]|

8. hardware acceleration features

|Option      |Description                         |
|:-----      |-----                               |
|–disable-audiotoolbox	|disable Apple AudioToolbox code [autodetect]|
|–enable-cuda	|enable dynamically linked Nvidia CUDA code [no]|
|–enable-cuvid	|enable Nvidia CUVID support [autodetect]|
|–disable-d3d11va	|disable Microsoft Direct3D 11 video acceleration code [autodetect]|
|–disable-dxva2	|disable Microsoft DirectX 9 video acceleration code [autodetect]|
|–enable-libmfx	|enable Intel MediaSDK (AKA Quick Sync Video) code via libmfx [no]|
|–enable-libnpp	|enable Nvidia Performance Primitives-based code [no]|
|–enable-mmal	|enable Broadcom Multi-Media Abstraction Layer (Raspberry Pi) via MMAL [no]|
|–disable-nvenc	|disable Nvidia video encoding code [autodetect]|
|–enable-omx	|enable OpenMAX IL code [no]|
|–enable-omx-rpi	|enable OpenMAX IL code for Raspberry Pi [no]|
|–disable-vaapi	|disable Video Acceleration API (mainly Unix/Intel) code [autodetect]|
|–disable-vda	|disable Apple Video Decode Acceleration code [autodetect]|
|–disable-vdpau	|disable Nvidia Video Decode and Presentation API for Unix code [autodetect]|
|–disable-videotoolbox	|disable VideoToolbox code [autodetect]|

9. Toolchain options

|Option      |Description                         |
|:-----      |-----                               |
|–arch=ARCH	|选择目标架构[armv7a/aarch64/x86/x86_64等]|
|–cpu=CPU	|选择目标cpu[armv7-a/armv8-a/x86/x86_64]|
|–cross-prefix=PREFIX	|设定交叉编译工具链的前缀,不算gcc/nm/as命令，例如android 32位的交叉编译链$ndk_dir/toolchains/arm-linux-androideabi-$toolchain_version/prebuilt/linux-$host_arch/bin/arm-linux-androideabi-|
|–progs-suffix=SUFFIX	|program name suffix []|
|–enable-cross-compile	|如果目标平台和编译平台不同则需要使能它|
|–sysroot=PATH	|交叉工具链的头文件和库位，例如Android 32位位置$ndk_dir/platforms/android-14/arch-arm|
|–sysinclude=PATH	|location of cross-build system headers|
|–target-os=OS	|设置目标系统|
|–target-exec=CMD	|command to run executables on target|
|–target-path=DIR	|path to view of build directory on target|
|–target-samples=DIR	|path to samples directory on target|
|–tempprefix=PATH	|force fixed dir/prefix instead of mktemp for checks|
|–toolchain=NAME	|set tool defaults according to NAME|
|–nm=NM	|use nm tool NM [nm -g]|
|–ar=AR	|use archive tool AR [ar]|
|–as=AS	|use assembler AS []|
|–ln_s=LN_S	|use symbolic link tool LN_S [ln -s -f]|
|–strip=STRIP	|use strip tool STRIP [strip]|
|–windres=WINDRES	|use windows resource compiler WINDRES [windres]|
|–yasmexe=EXE	|use yasm-compatible assembler EXE [yasm]|
|–cc=CC	|use C compiler CC [gcc]|
|–cxx=CXX	|use C compiler CXX [g++]|
|–objcc=OCC	|use ObjC compiler OCC [gcc]|
|–dep-cc=DEPCC	|use dependency generator DEPCC [gcc]|
|–ld=LD	|use linker LD []|
|–pkg-config=PKGCONFIG	|use pkg-config tool PKGCONFIG [pkg-config]|
|–pkg-config-flags=FLAGS	|pass additional flags to pkgconf []|
|–ranlib=RANLIB	|use ranlib RANLIB [ranlib]|
|–doxygen=DOXYGEN	|use DOXYGEN to generate API doc [doxygen]|
|–host-cc=HOSTCC	|use host C compiler HOSTCC|
|–host-cflags=HCFLAGS	|use HCFLAGS when compiling for host|
|–host-cppflags=HCPPFLAGS	|use HCPPFLAGS when compiling for host|
|–host-ld=HOSTLD	|use host linker HOSTLD|
|–host-ldflags=HLDFLAGS	|use HLDFLAGS when linking for host|
|–host-libs=HLIBS	|use libs HLIBS when linking for host|
|–host-os=OS	|compiler host OS []|
|–extra-cflags=ECFLAGS	|设置cflags，如果是Android平台可以根据ndk内的设定,arm-linux-androideabi-4.6/setup.mk，建议参考你当前的setup来配置|
|–extra-cxxflags=ECFLAGS	|add ECFLAGS to CXXFLAGS []|
|–extra-objcflags=FLAGS	|add FLAGS to OBJCFLAGS []|
|–extra-ldflags=ELDFLAGS	|参考cflags|
|–extra-ldexeflags=ELDFLAGS	|add ELDFLAGS to LDEXEFLAGS []|
|–extra-ldlibflags=ELDFLAGS	|add ELDFLAGS to LDLIBFLAGS []|
|–extra-libs=ELIBS	|add ELIBS []|
|–extra-version=STRING	|version string suffix []|
|–optflags=OPTFLAGS	|override optimization-related compiler flags|
|–build-suffix=SUFFIX	|library name suffix []|
|–enable-pic	|build position-independent code|
|–enable-thumb	|compile for Thumb instruction set|
|–enable-lto	|use link-time optimization|
|–env=”ENV=override”	|override the environment variables|

10. Advanced options

|Option      |Description                         |
|:-----      |-----                               |
|–malloc-prefix=PREFIX	|prefix malloc and related names with PREFIX|
|–custom-allocator=NAME	|use a supported custom allocator|
|–disable-symver	|disable symbol versioning|
|–enable-hardcoded-tables	|use hardcoded tables instead of runtime generation|
|–disable-safe-bitstream-reader	|disable buffer boundary checking in bitreaders (faster, but may crash)|
|–enable-memalign-hack	|emulate memalign, interferes with memory debuggers|
|–sws-max-filter-size=N	|the max filter size swscale uses [256]|

11. Optimization options

|Option      |Description                         |
|:-----      |-----                               |
|–disable-asm	|disable all assembly optimizations|
|–disable-altivec	|disable AltiVec optimizations|
|–disable-vsx	|disable VSX optimizations|
|–disable-power8	|disable POWER8 optimizations|
|–disable-amd3dnow	|disable 3DNow! optimizations|
|–disable-amd3dnowext	|disable 3DNow! extended optimizations|
|–disable-mmx	|disable MMX optimizations|
|–disable-mmxext	|disable MMXEXT optimizations|
|–disable-sse	|disable SSE optimizations|
|–disable-sse2	|disable SSE2 optimizations|
|–disable-sse3	|disable SSE3 optimizations|
|–disable-ssse3	|disable SSSE3 optimizations|
|–disable-sse4	|disable SSE4 optimizations|
|–disable-sse42	|disable SSE4.2 optimizations|
|–disable-avx	|disable AVX optimizations|
|–disable-xop	|disable XOP optimizations|
|–disable-fma3	|disable FMA3 optimizations|
|–disable-fma4	|disable FMA4 optimizations|
|–disable-avx2	|disable AVX2 optimizations|
|–disable-aesni	|disable AESNI optimizations|
|–disable-armv5te	|disable armv5te optimizations|
|–disable-armv6	|disable armv6 optimizations|
|–disable-armv6t2	|disable armv6t2 optimizations|
|–disable-vfp	|disable VFP optimizations|
|–disable-neon	|disable NEON optimizations|
|–disable-inline-asm	|disable use of inline assembly|
|–disable-yasm	|disable use of nasm/yasm assembly|
|–disable-mipsdsp	|disable MIPS DSP ASE R1 optimizations|
|–disable-mipsdspr2	|disable MIPS DSP ASE R2 optimizations|
|–disable-msa	|disable MSA optimizations|
|–disable-mipsfpu	|disable floating point MIPS optimizations|
|–disable-mmi	|disable Loongson SIMD optimizations|
|–disable-fast-unaligned	|consider unaligned accesses slow|

12. Developer options

|Option      |Description                         |
|:-----      |-----                               |
|–disable-debug	|disable debugging symbols|
|–enable-debug=LEVEL	|set the debug level []|
|–disable-optimizations	|disable compiler optimizations|
|–enable-extra-warnings	|enable more compiler warnings|
|–disable-stripping	|disable stripping of executables and shared libraries|
|–assert-level=level	|0(default), 1 or 2, amount of assertion testing, 2 causes a slowdown at runtime.|
|–enable-memory-poisoning	|fill heap uninitialized allocated space with arbitrary data|
|–valgrind=VALGRIND	|run “make fate” tests through valgrind to detect memory leaks and errors, using the specified valgrind binary. Cannot be combined with –target-exec|
|–enable-ftrapv	|Trap arithmetic overflows|
|–samples=PATH	|location of test samples for FATE, if not set use $FATE_SAMPLES at make invocation time.|
|–enable-neon-clobber-test	|check NEON registers for clobbering (should be used only for debugging purposes)|
|–enable-xmm-clobber-test	|check XMM registers for clobbering (Win64-only; should be used only for debugging purposes)|
|–enable-random	|randomly enable/disable components|
|–disable-random	 
|–enable-random=LIST	|randomly enable/disable specific components or|
|–disable-random=LIST	|component groups. LIST is a comma-separated list of NAME[:PROB] entries where NAME is a component (group) and PROB the probability associated with|
|–random-seed=VALUE	|seed value for –enable/disable-random|
|–disable-valgrind-backtrace	|do not print a backtrace under Valgrind (only applies to –disable-optimizations builds)|
 


