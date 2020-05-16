#!/bin/bash
echo "START"
if echo ${1} | grep -q Defunct; then
 echo "This is Defunct log"
 FILE=`echo "${1}" | sed -e "s/.\{8\}$//"`
elif echo ${1} | grep -q PowerOff; then
 echo "This is PowerOff log"
 FILE=`echo "${1}" | sed -e "s/.\{9\}$//"`
else
 FILE=${1}
fi
LAST=${FILE: -1}
#echo "FILE is $FILE , Last character is $LAST"
if [ $LAST == L ] ; then
 echo "This is lzop format"
 openssl enc -d -aes256 -in ${1} -out ${1}.tar.lzo -k 1048toshibatec
 ./lzop -d ${1}.tar.lzo
 tar xvf ${1}.tar
else
 echo "This is tar.gz format"
 openssl enc -d -aes256 -in ${1} -out ${1}.tar.gz -k 1048toshibatec
 tar zxvf ${1}.tar.gz
fi
echo "FINISH"
