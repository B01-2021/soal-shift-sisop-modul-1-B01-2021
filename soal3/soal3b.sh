#!/bin/bash
parent="/mnt/c/Users/shidqi/sisop1"
cd $parent

download=`ls -1 | awk 'BEGIN{ x = 0; y = 0 } /^Kucing_/ { ++x } /^Kelinci_/ { ++y } END{ if ( x <= y ) { printf "Kucing_" } else { printf "Kelinci_" }}'`
datestr=`date +%d-%m-%Y`
dirname=$download$datestr
mkdir $dirname

if [ $download == 'Kucing_' ]
then
  bash soal3a.sh
else
  bash soal3c.sh
fi

mv Foto.log $dirname
for file in *
do
  if [[ $file == *Koleksi* ]]
  then
    mv $file $dirname
  fi
done


