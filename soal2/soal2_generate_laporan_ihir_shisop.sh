#!/bin/bash

NAMA_FILE=hasil.txt
DIR=../../Laporan-TokoShiSop.tsv

# 2a
awk -F "[\t]" 'BEGIN {max_profit=0; max_id=0;} NR>1 {cost_price=$(NF-3) * $(NF); profit_percentage=($(NF)/cost_price)*100; if(profit_percentage > max_profit) {max_profit=profit_percentage; max_id=$1;} else if(profit_percentage == max_profit && max_id < $1) {max_id=$1}} END {print "Transaksi terakhir dengan profit percentage terbesar yaitu "max_id" dengan presetase "max_profit"% \n"}' $DIR >> $NAMA_FILE

# 2b
awk -F "[\t]" 'BEGIN{print "Daftar nama customer di Albuquerque pada tahun 2017 antara lain: "}/Albuquerque/ {if(index($2, "2017") != 0) print $7} END {print"\n"}' $DIR >> $NAMA_FILE

# 2c
awk -F "[\t]" 'BEGIN {Segmen["Consumer"]=0; Segmen["Home Office"]=0; Segmen["Corporate"]=0; min=1000000;} NR>1 {for(type in Segmen) if($8==type) Segmen[type]++; } END {for(type in Segmen) if(min>Segmen[type]) {min=Segmen[type];min_type=type;} print "Tipe segmen customer yang penjualannya paling sedikit adalah "min_type " dengan jumlah transaksi " min "\n"; }' $DIR >> $NAMA_FILE

# 2d
awk -F "[\t]" 'BEGIN {Reg["Central"]=0; Reg["West"]=0; Reg["South"]=0; Reg["East"]=0; min=1000000;} NR>1 {for(i in Reg) if($13==i) Reg[i] = $(NF); } END {for(i in Reg) if(min>Reg[i]) {min=Reg[i]; min_reg=i;} print "Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah "min_reg " dengan total keuntungan " min; }' $DIR >> $NAMA_FILE