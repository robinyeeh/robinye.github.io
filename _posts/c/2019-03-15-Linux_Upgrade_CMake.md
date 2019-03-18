---
layout: post
title: "Linux Upgrade CMake to 3.14"
date: 2019-03-15 16:33:00 +0080
comments: true
categories: "c++"
---

### Linux Upgrade CMake to 3.14


1. 下载Cmake

    ```
    wget https://cmake.org/files/v3.14/cmake-3.14.0.tar.gz
    ```

2. 解压Cmake

    ```
    tar zxvf cmake-3.14.0.tar.gz
    ```

3. 编译安装cmake

    ```
    cd cmake-3.14.0
    ./bootstrap
    gmake
    gmake install
    ```

4. 查看编译后的cmake版本

    ```
     /usr/local/bin/cmake --version
    ```

5. 移除原来的cmake版本

    ```
     yum remove cmake -y
    ```
6. 新建软连接

    ```
     ln -s /usr/local/bin/cmake /usr/bin/
    ```
7. 终端查看版本

    ```
    cmake --version
    ```
出现版本表示成功！cmake编译完成
