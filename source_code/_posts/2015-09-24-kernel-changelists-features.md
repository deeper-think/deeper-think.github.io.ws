---
layout: post
title: 内核：Changelist、Features
category: 内核组件
tags: [徐超]
keywords: 内核、传输优化、传输加密
description:
---


## 1.1. Changelist

### 1.1.1 ftcp-3.14.19 分支

#### 1.1.1.1 ftcp-3.14.19-4.x86_64.rpm
 
- 修复了mscc_r算法中的bug，默认是nss=1,即以2G的方式增加窗口，现改为nss=0，拥塞窗口增加的更快些。

- 修改了checkOSconfig中参数获取方式，原来是从/etc/sysctl.conf中获取，现在改为从/proc/sys/net/ipv4下获取。

- 修改了stadmind脚本中的一些代码，将$MODE = 1 to "x$MODE"="x1"，功能性方法没做任何改变。
- 剃除reboot_enable和grubonce功能，这个功能在网络不通的情况下会重启机器，重启后内核切换为2.6.18。

- 安装内核时自动安装kdump工具。

### 1.1.2 mtcp-tos-2.6.37 分支

#### 1.1.2.1 mtcp-tos-2.6.37-49.x86_64.rpm

- 增加应用程序版本查询接口：service ipv4_log status 接口可查看
l 采用第三方日志管理软件，不再保证某一分钟内的日志一定在同一个文件内，日志监
控处理时请注意（已提前沟通、知会过），详阅大包内的readme.txt


## 1.2. 功能特性及配置说明

### 1.2.1. 传输加密功能


### 1.2.2. mp功能


### 1.2.3. 内核默认配置文件