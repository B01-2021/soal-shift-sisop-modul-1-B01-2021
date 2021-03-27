#!/bin/bash
parent="/mnt/c/Users/shidqi/sisop1"
cd $parent

download=`ls -1 | awk 'BEGIN{ x = 0; y = 0 } /^Kucing_/ { ++x } /^Kelinci_/ { ++y } END{ if ( x <= y ) { printf "Kucing_" } else { printf "Kelinci_" }}'`
datestr=`date +%d-%m-%Y`
dirname=$download$datestr
mkdir $dirname

x=1
while [ $x -le 23 ]
do
  if [ $download == 'Kucing_' ]
  then
    wget -o /dev/stdout -nv https://loremflickr.com/320/240/kitten | tee -a Foto.log
    x=$((x+1))
  else
    wget -o /dev/stdout -nv https://loremflickr.com/320/240/bunny | tee -a Foto.log
    x=$((x+1))
  fi
done

md5sum * | sort | awk 'BEGIN{hash = ""} $1 == hash {print $2} {hash = $1}' | xargs rm

num=1
for file in *
do
  if [[ $file == *"kitten"* || $file == *"bunny"* ]]
  then
    filename=`printf "Koleksi_%02d.jpg" $num`
    mv $file $filename
    num=$(($num+1))
  fi
done

mv Foto.log $dirname
for file in *
do
  if [[ $file == *Koleksi* ]]
  then
    mv $file $dirname
  fi
done
