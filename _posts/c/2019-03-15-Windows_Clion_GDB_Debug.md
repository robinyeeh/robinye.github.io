---
layout: post
title: "Windows Clion DGB 远程调试"
date: 2019-03-15 16:43:00 +0080
comments: true
categories: "c++"
---

### Windows Clion DGB 远程调试

#### 环境准备

假设本地开发环境是 Windows 操作系统，程序远程执行环境是 CentOS 操作系统。为满足远程调试，需要在 CentOS 上安装必要的软件，安装的软件包括：

- cmake
- gcc
- gdb
- gdbserver

####安装相关组件

cmake 用于管理编译过程，生成 Makefile 文件；gcc-c++ 是编译器；gdb 是个调试工具，程序调试功能实际上就是由 gdb 提供的；gdbserver 用于监听某个 TCP 端口，允许远程主机连接，以实现远程调试功能。

```
yum install -y cmake gcc-c++ gdb gdb-gdbserver
```

#### 代码同步

使用 CLion 创建一个 C++ 项目 helloworld。然后，打开菜单 Tools - Deployment - Configuration，配置远程主机以及本地目录与远程目录的映射关系：
![](/images/blog/c/2019-02-16-001953.jpg)

![](/images/blog/c/2019-02-16-002249.jpg)

右键项目文件夹，选择 Deployment - Upload to 10.88.115.114，便将项目源代码上传至 10.88.115.114 主机上。

![](/images/blog/c/2019-02-16-002124.jpg)

上述我们配置了远程主机与本地主机目录映射，因此执行上传操作后，可以看到源代码已被上传至上述配置的目录中。

#### 代码编译

CLion 为我们生成了默认的源代码main.cpp，修改 main.cpp，增加一个 add 函数，方便展示调试功能：

```
#include <iostream>

using namespace std;

int add(int a, int b)
{
    int sum = a + b;
    return sum;
}

int main() {
    std::cout << "Hello, World!" << std::endl;
    int sum = 0;
    sum = add(5, 3);
    std:cout << "sum of 5 and 3 is " << sum << std::endl;

    return 0;
}
```

修改 main.cpp 源代码后，需要重新将代码上传至远程机器。

CLion生成的 CMakeLists.txt 如下，使用 C++98 标准，指定生成的可执行文件名为 helloworld：

```
project(helloworld)

set(CMAKE_CXX_STANDARD 98)

add_executable(helloworld main.cpp)
```

由于上面我们已将源代码上传至 10.88.115.114 主机，进入 10.88.115.114 目录 /home/lihao/code/cpp/hello，然后执行以下操作

```
$ cd /home/lihao/code/cpp/hello
$ mkdir build
$ cd build
$ cmake .. -DCMAKE_BUILD_TYPE=Debug
$ make
```

执行 cmake 命令会生成 Makefile 文件，指定 -DCMAKE_BUILD_TYPE=Debug 是为了支持 gdb 调试。

执行 make 命令会在 build 目录下编译生成可执行文件：helloworld。

#### 远程调试

经过上述的操作步骤，接下来我们就可以实施远程调试了。

在远程主机继续执行命令：

```
gdbserver :1234 /home/lihao/code/cpp/hello/build/helloworld
```

即指定 gdbserver 监听端口 1234，输出：

```
Process /home/lihao/code/cpp/hello/build/helloworld created; pid = 12496
Listening on port 1234
```

返回本地 CLion，配置远程调试信息，增加一个 GDB Remote Debug 配置：

![](/images/blog/c/2019-02-16-002509.jpg)

然后输入以下配置信息：

![](/images/blog/c/2019-02-16-002550.jpg)

设置断点，按下调试按钮，可以看到程序已被执行起来，且中断在断点处，可以看到变量值：

![](/images/blog/c/2019-02-16-002647.jpg)

需要指出的是，helloworld 程序的运行是在远程主机，并不是本地主机，CLion 通过向 gdbserver 发送调试命令从而达到控制远程主机上的 gdb 的目的。

Note: 如果提示CMake版本需要升级, 请参考[]() 升级Cmake.

----
参考资料  
https://blog.csdn.net/lihao21/article/details/87425187  


