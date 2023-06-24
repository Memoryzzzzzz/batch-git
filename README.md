# 批量Git

#### 介绍
项目已存在更新，不存在则clone

#### 使用说明
1. 下载shell脚本和配置文件(gitUrls)
2. 配置文件中添加git地址，一行一个
3. 执行sh gitBatch.sh

#### 内容解释
Git链接文件：读取脚本所有目录配置文件(文件名：gitUrls)
Git工作目录：默认读取脚本锁在目录(目录名：work)，可以通过指定脚本后加上目录名来指定
			例：sh gitBatch.sh demo	

#### Git获取clone地址
##### GitLab
1. 请求项目列表接口，得到返回结果的JSON
2. 使用正则匹配项目路径("relative_path":"(.*?)",)
3. 地址拼接
	3.1 ssh：前缀拼上git@域名:，后缀拼上.git
	3.2 http：前缀拼上http://@域名/，后缀拼上.git