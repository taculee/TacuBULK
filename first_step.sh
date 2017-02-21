#!/bin/bash

# Author:TacuLEE
# Version:V1.1
# Date:2016-9-10
# Function: 解析“downloadCitation.txt”获取下载链接；解析下载的文件"stamp*"，获取pdf下载路径；下载pdf文件并重命名。

#选项
base=
file=
#临时文件，用完删除
tempfile1="arnumber_isnumber_list.txt" 
tempfile2="urls.txt"
tempfile3="titlelist.txt"
tempfile4="pdf_urls.txt"
tempfile5="tmp_titlelist.txt"

#运行前清空"Papers"和"Temp"文件夹
direc="./Papers"
rm -if $direc/*
for dir2del in $direc/* ; do
 if [ -d $dir2del ]; then
  rm -rf $dir2del 
 fi
done
direc="./Temp"
rm -if $direc/*
for dir2del in $direc/* ; do
 if [ -d $dir2del ]; then
  rm -rf $dir2del 
 fi
done	

#判断并清除临时文件
if [ -f $tempfile1 ]; then
    rm $tempfile1
fi

if [ -f $tempfile2 ]; then
    rm $tempfile2
fi

if [ -f $tempfile3 ]; then
    rm $tempfile3
fi

if [ -f $tempfile4 ]; then
    rm $tempfile4
fi

usage()
{
    echo "Usage: `basename $0` -b url_base_string -f input_file [-h help]"
    exit 1
}

while getopts "b:f:h" arg #选项后面的冒号表示该选项需要参数
do
    case $arg in
         b)
            base=$OPTARG
            ;;
         f)
            file=$OPTARG
            ;;
         h)
            usage
            ;;
         ?)  #当有不认识的选项的时候arg为?
        echo "unkonw argument"
    exit 1
    ;;
    esac
done

if [ -z "$base" ]; then   #该脚本必须提供-b选项
    echo "You must specify base with -b option"
    exit
fi

if [ -z "$file" ]; then   #该脚本必须提供-f选项
    echo "You must specify file with -f option"
    exit
fi

cat $file | grep -o -e "arnumber=[0-9]*" -e "isnumber=[0-9]*" >> "$tempfile1" #grep arnumber and isnumber
cat $file | grep -o -e "arnumber=[0-9]*" -e '".*"' >> "$tempfile3" #grep title, 适配“”内的所有内容

while read -r arnumber; read -r isnumber #looping through all the arnumber
do 
  arnumber=`echo $arnumber | cut -d "=" -f 2`
  isnumber=`echo $isnumber | cut -d "=" -f 2`
  echo "$base$arnumber&isnumber=$isnumber" >> "$tempfile2" #这里先生成所有下载链接，然后保存到临时文件
done < "$tempfile1"

wget -P ./Temp -i $tempfile2

while read -r arnumber; read -r isnumber #looping through all the arnumber
do 
  arnumber=`echo $arnumber | cut -d "=" -f 2`
  isnumber=`echo $isnumber | cut -d "=" -f 2`
  cat "./Temp/stamp.jsp@tp=&arnumber=$arnumber&isnumber=$isnumber" | grep -o -e "http://ieeexplore.ieee.org/ielx[^\.pdf]*.pdf" >> "$tempfile4" #grep pdf url
done < "$tempfile1"

wget -P ./Papers -i $tempfile4

sed 's/\//\\/g' $tempfile3 >> $tempfile5
rm $tempfile3
sed 's/\\/-/g' $tempfile5 >> $tempfile3
rm $tempfile5
sed 's/,//g' $tempfile3 >> $tempfile5
rm $tempfile3
mv $tempfile5 $tempfile3

./second_step.sh

echo $?

if [ -f $tempfile1 ]; then
   rm $tempfile1
fi

if [ -f $tempfile2 ]; then
   rm $tempfile2
fi

if [ -f $tempfile3 ]; then
   rm $tempfile3
fi

if [ -f $tempfile4 ]; then
   rm $tempfile4
fi

if [ -f $tempfile5 ]; then
   rm $tempfile5
fi