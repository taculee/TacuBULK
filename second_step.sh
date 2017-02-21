#!/bin/bash

# Author:TacuLEE
# Version:V1.1
# Date:2016-9-10
# Function: 重命名pdf文件。

#选项
base=
file=
#临时文件，用完删除
tempfile1="titlelist.txt" 

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

echo $?

while read -r title; read -r arnumber #重命名
do 
  #title=`echo $title | cut -d "\"" -f 2 | cut -d "," -f 1 | sed 's/\///'`
  title=`echo $title | cut -d "\"" -f 2 | sed 's/\///'` #不会去除“，”。
  arnumber=`echo $arnumber | cut -d "=" -f 2`
  cd ./Papers  
  if [ ${#arnumber} = 4 ];then
     #echo "len=4"	 
     mv "0000$arnumber.pdf" "$title.pdf"
  fi
  if [ ${#arnumber} = 5 ];then
     #echo "len=5"
     mv "000$arnumber.pdf" "$title.pdf"
  fi
  if [ ${#arnumber} = 6 ];then
     #echo "len=6"
     mv "00$arnumber.pdf" "$title.pdf"
  fi
  if [ ${#arnumber} = 7 ];then
     #echo "len=7"
     mv "0$arnumber.pdf" "$title.pdf"
  fi
  cd ..
done < "$tempfile1" 