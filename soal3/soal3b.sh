#!/bin/bash
parent="/mnt/c/Users/shidqi/sisop1"
cd $parent

bash soal3a.sh

dirname=`date +%d-%m-%Y`
mkdir $dirname

mv Foto.log $dirname
for file in *
do
  if [[ $file == *Koleksi* ]]
  then
    mv $file $dirname
  fi
done
