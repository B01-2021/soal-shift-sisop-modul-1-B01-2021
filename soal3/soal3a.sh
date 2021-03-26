# !/bin/bash
parent="/mnt/c/Users/shidqi/sisop1"
cd $parent

x=1
while [ $x -le 23 ]
do
    wget -o /dev/stdout -nv https://loremflickr.com/320/240/kitten | tee -a foto.log
    x=$(( $x + 1 ))
done 

md5sum * | sort | awk 'BEGIN{hash = ""} $1 == hash {print $2} {hash = $1}' | xargs rm

num=1
for file in *
do
    if [[ $file == *"kitten"* ]]
    then
        filename=`printf "Koleksi_%02d.jpg" $num`
        mv $file $filename
        num=$(($num+1))
    fi
done
