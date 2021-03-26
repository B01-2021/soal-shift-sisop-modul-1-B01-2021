#!/bin/bash

datestr=`date +%d-%m-%Y`
mkdir $datestr

mv Foto.log $datestr
for file in *
do
  if [[ $file == *Koleksi* ]]
  then
    mv $file $datestr
  fi
done



