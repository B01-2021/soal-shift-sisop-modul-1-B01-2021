# !/bin/bash
x=1
while [ $x -le 23 ]
do
    wget -o /dev/stdout https://loremflickr.com/320/240/kitten | tee -a foto.log
    x=$(( $x + 1 ))
done 

for file in *
do
    if [[ $file == *"kitten"* ]]; 
    then
        for file2 in *
        do
            if [[ $file2 == *"kitten"* ]]; 
            then
                if [ "$file" != "$file2" ]
                then
                    if cmp -s $file $file2 
                    then 
                        rm $file2 
                    fi
                fi
            fi
        done
    fi
done

num=1
for file in *
do
    if [[ $file == *"kitten"* ]]; 
    then
        if [[ ${#num} -lt 2 ]] 
        then 
            filename="Koleksi_""0${num}"
        else
            filename="Koleksi_""${num}"
        fi
        mv $file $filename
        num=$(( $num + 1 ))
    fi
done
