#!/bin/bash
parent="/mnt/c/Users/shidqi/sisop1"
cd $parent

d=$(date +%m%d%Y)

zip -mr -P $d Koleksi . -i "*.jpg" "*.log"
rm -d \Kucing*
rm -d \Kelinci*
