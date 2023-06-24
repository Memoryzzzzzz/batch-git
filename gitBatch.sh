#!/bin/bash
#################################################
#												#
# @Description 批量拉取指定的多个git项目			#
# @Author Zhong Yanghao							#
# @Date 2023/4/15 14:54							#
#												#
# 项目已存在更新，不存在则clone         			#
# Git链接文件：读取脚本所有目录配置文件				#
# 				(文件名：gitUrls)					#
# Git工作目录：默认读取脚本锁在目录(目录名：work)		#
# 				可以通过指定脚本后加上目录名来指定	#
# 				例：sh gitShell.sh demo			#
#												#
#################################################

# 脚本所有目录
dir=$(cd $(dirname $0); pwd)
# Git链接文件目录名
gitPathName="gitUrls.conf"
# Git工作目录名
gitWorkPathName="work"

# git clone
gitClone(){
	echo "############ $3 开始clone ############"
	cd $1
	git clone $2
	echo "############ $3 结束clone ############"
}

# git更新
gitPull(){
	echo "############ $2 开始更新 ############"
	cd $1
	git pull
	echo "############ $2 结束更新 ############"
}

# git工作目录是否存在
gitWorkPath(){
	pathName=$gitWorkPathName
	# 判断是否指定工作目录名称
	if [ $# -eq 1 ]; then
		pathName=$1
	fi
	workPath=$dir/$pathName
	if [ ! -e $workPath ]; then
		echo "############ Git工作目录($workPath)不存在，开始创建 ############"
		mkdir $workPath
		echo "############ Git工作目录($workPath)创建完成 ############"
	fi
}

# 判断文件夹是否存在，存在pull，不存在clone
pulGit(){
	echo "############ 配置文件第$2行开始 ############"
	gitWorkPath $3
	gitUrl=$1
	# 第一次截取，含有.git
	fileGit=${gitUrl##*/}
	# 第二次截取，去除.git
	gitPathName=${fileGit%%.*}
	# 加上目录前缀
	gitPath=$workPath/$gitPathName
	# 判断目录是否存在
	if [ -e $gitPath ]; then
		gitPull $gitPath $gitPathName
	else
		gitClone $workPath $gitUrl $gitPathName
	fi
	echo "############ 配置文件第$2行结束 ############ \n"
}

# 读取文件内容(末尾必须要有换行符)
readGitUrl(){
	i=1
	for line in `cat $1`
	do
		if [[ ${line##*.} == 'git' ]]; then
			pulGit $line $i $2
		fi
		let i++
	done < $1
}

# 判断文件是否存在
gitPath=$dir/$gitPathName
if [ -e $gitPath ]; then
	readGitUrl $gitPath $1
else
	cd $dir
	touch $gitPathName
	echo "# 支持注释" >> $gitPathName
	echo "git@gitee.com:ZyhWorkspace/batch-git.git" >> $gitPathName
	echo "# xx项目" >> $gitPathName
	echo "git@gitee.com:xxx/xxxx.git" >> $gitPathName
	echo "Git链接文件不存在，已自动创建，请在脚本目录($dir)找到Git链接文件($gitPathName)，添加git地址后再次运行此脚本"
fi