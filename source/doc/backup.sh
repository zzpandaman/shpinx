#==========用于jenkins构建任务中的发布操作=============
module_name=$1
#jenkins_project_name=$2
app_path=/usr/local/javaserver/spring/${module_name}
jar_path=${app_path}/target
bak_path=${app_path}/bak
mkdir $bak_path>>/dev/null 2>&1

if [ $# -eq 0 ];then
    echo "please input module_name"
    exit 1
fi
#==========首先备份jar，备份文件后缀为时间，精确到秒，例如20200622_143520表示2020年6月22日14点35分20秒============
#==========备份文件的后缀也作为版本号，用于回滚操作，仅保留最近五次发布的备份==========
DAT=`date +"%Y%m%d_%H%M%S"`
module_jar_num=`ls ${jar_path}|/usr/bin/egrep ".jar$|.war$"|wc -l`
if [[ $module_jar_num -ne 1 ]];then
    echo "there are not only one jar package"
#    exit 1
fi
module_jar=`ls ${jar_path}|/usr/bin/egrep ".jar$|.war$"`

/bin/cp -af ${jar_path}/${module_jar} ${bak_path}/${module_jar}.${DAT}
#version_num=`ls ${bak_path}|grep ${module_jar}|awk -F. '{print $NF}'|sort -n`
versions=`ls ${bak_path}|grep ${module_jar}|wc -l`
old=`ls ${bak_path}|grep ${module_jar}|awk -F. '{print $NF}'|sort -n|head -1`
if [ $versions -gt 5 ];then
	rm -f ${bak_path}/`ls ${bak_path}| grep $old`
fi
version_num=`ls ${bak_path}|grep ${module_jar}|awk -F. '{print $NF}'|sort -n`
echo "The lastest  five versions are:"
echo "${version_num}"