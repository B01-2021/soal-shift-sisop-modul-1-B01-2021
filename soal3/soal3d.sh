#!/bin/bash
parent="/mnt/c/Users/shidqi/sisop1"
cd $parent

d=`date +%m%d%Y`

if [ $1 == "-u" ]
then
  unzip -P $d Koleksi
  rm *.zip
else
  zip -mr -P $d Koleksi . -i "*.jpg" "*.log"
  rm -d \Kucing*
  rm -d \Kelinci*
fi
