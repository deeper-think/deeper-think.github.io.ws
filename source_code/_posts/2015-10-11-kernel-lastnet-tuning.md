---
layout: post
title: 内核组件：最后一公里传输优化测试
category: 内核组件
tags: [内核、TCP传输优化]
keywords: 内核、传输优化
description:
---


> 用正确的工具，做正确的事情

## 1 测试环境及方法

### 1.1 测试环境

测试客户端：上海广电家庭宽带环境的一台测试机（win环境）；
服务器端：上海广电网络环境的三台服务器并分别部署不同的内核：58.216.23.36(219.233.31.72) --mp内核，58.216.23.37(219.233.63.133) --fast内核，58.216.23.38(219.233.31.74)-cdn内核。

测试客户端到三台服务器之间的链路质量如下图所示：

![测试客户端到服务器端的链路质量](http://7u2rbh.com1.z0.glb.clouddn.com/ping时延.png)


### 1.2 测试脚本

客户端重复分别向三台服务器下载不同大小的文件，测试脚本如下：

	import os
	import time
	
	SERVER_PATHS=['219.233.31.72:8090/down','219.233.63.133:8090/down','219.233.31.74:8090/down']
	
	#SERVER_PATHS=['58.216.23.36:8090/down','58.216.23.37:8090/down','58.216.23.38:8090/down']
	
	CMD_LINE_TIMEOUT='--connect-timeout 10 -m 100'
	CMD_LINE_OUTPUT='-w %{http_code},%{time_total} -o F:\\xuc\\data 2>F:\\xuc\\data1'
	RESULT_MPTCP='result_mptcp.log'
	
	LOG_NAME='F:\\xuc\\result.log'
	
	FILES=['4K','16K','64K','1M','16M','64M']
	
	ISOTIMEFORMAT='%Y-%m-%d %X'
	
	
	output = open(LOG_NAME, 'a')
	
	try:
	
		while 1:
			for file in FILES:
				for server_path in SERVER_PATHS:
					cmd="curl "+server_path+"/"+file+" "+CMD_LINE_TIMEOUT+" "+CMD_LINE_OUTPUT
					#print cmd
					result = os.popen(cmd).readlines()
					#print result
					output.write(time.strftime(ISOTIMEFORMAT,time.localtime())+': '+server_path+': '+file+': '+result[0]+'\n')
					output.flush()
	finally:
		output.close()    

## 2 测试结果

### 2.1 4K文件下载测试对比

![4K文件下载测试对比](http://7u2rbh.com1.z0.glb.clouddn.com/lastnet_4k.png)

### 2.2 16K文件下载测试对比

![16K文件下载测试对比](http://7u2rbh.com1.z0.glb.clouddn.com/lastnet_16K.png)

### 2.3 64K文件下载测试对比

![64K文件下载测试对比](http://7u2rbh.com1.z0.glb.clouddn.com/lastnet_64K.png)

### 2.4 1M文件下载测试对比

![1M文件下载测试对比](http://7u2rbh.com1.z0.glb.clouddn.com/lastnet_1M.png)

### 2.5 16M文件下载测试对比

![16M文件下载测试对比](http://7u2rbh.com1.z0.glb.clouddn.com/lastnet_16M.png)

### 2.6 64M文件下载测试对比

![64M文件下载测试对比](http://7u2rbh.com1.z0.glb.clouddn.com/lastnet_64M.png)

### 2.7 不同大小文件平均下载时间

![64M文件下载测试对比](http://7u2rbh.com1.z0.glb.clouddn.com/ave_download_time.png)

## 3 结论

根据本轮上述测试数据，最后一公里传输优化效果最好的是CDN内核，其次是FAST内核，然后是MP内核。


