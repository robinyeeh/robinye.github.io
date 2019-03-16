---
layout: post
title: "Rust语言初学"
date: 2018-05-26 13:35:58 +0080
comments: true
categories: "Rust"
---

##Rust语言初学


####Rust 安装和准备

1. 根据Rust官网中参考安装rust. https://www.rust-lang.org/en-US/install.html

2. 在Intellij Ideas官网下载最新的IDE. https://www.jetbrains.com/idea/ 2017版本之后.

3. 安装IDEA之后, 安装Rust language support 插件.

4. 需要安装 Microsoft Visual C++ Build Tools 2017 或者Visual Studio 2017.


#### 在IDEA中开发第一个Rust Hello word

1. 打开IDEA, 配置Rust HOME并安装标准库, IDEA会自动完成.
2. 新建rust-demo
3. IDEA会自动生成工程以及main.rs文件. 如图
![](/images/blog/rust/rust-demo-pic1.png)
4. 用ctrl+shift+F10运行, 在Console会看到"Hello World!"结果.

####中科大Cargo 镜像

创建文件$HOME/.cargo/config
并在文件中加入以下内容
```
[registry]
index = "https://mirrors.ustc.edu.cn/crates.io-index/"
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'
[source.ustc]
registry = "https://mirrors.ustc.edu.cn/crates.io-index/"
```

####安装Racer 
在命令行执行
$ cargo install racer 
将$HOME/.cargo/bin加入PATH环境变量，即可使用Racer进行代码补全.

#### 分享Rust中文学习网站

分享一个Rust中文教程网站:
https://kaisery.gitbooks.io/rust-book-chinese/

Rust QQ交流群: 303838735



 