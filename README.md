# soal-shift-sisop-modul-1-B01-2021

# Soal 1
Ryujin baru saja diterima sebagai IT support di perusahaan Bukapedia. Dia diberikan tugas untuk membuat laporan harian untuk aplikasi internal perusahaan, ticky. Terdapat 2 laporan yang harus dia buat, yaitu laporan **daftar peringkat pesan error** terbanyak yang dibuat oleh ticky dan laporan **penggunaan user** pada aplikasi ticky. Untuk membuat laporan tersebut, Ryujin harus melakukan beberapa hal berikut:
### 1.a
Mengumpulkan informasi dari log aplikasi yang terdapat pada file syslog.log. Informasi yang diperlukan antara lain: jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya menggunakan **regex**

Regex yang diperlukan : 
* Regex untuk mendapatkan kata INFO atau ERROR di setiap barisnya.
    ```
    reg_type_msg='(INFO|ERROR)'
    ```
* Regex untuk mendapat pesan log ERROR/INFO di setiap baris log yang didapatkan dari semua karakter setelah kata INFO/ERROR hingga sebelum karakter '('.
    ```
    reg_msgs='(?<=[INFO|ERROR] ).*(?=\()'
    ```
* Regex untuk mendapat pesan log ERROR di setiap baris yang didapatkan dari semua karakter setelah kata ERROR hingga sebelum karakter '('.
    ```
    reg_err_msgs='(?<=ERROR ).*(?=\()'
    ```
* Regex untuk mendapat pesan log INFO di setiap baris yang didapatkan dari semua karakter setelah kata INFO hingga sebelum karakter '('.
    ```
    reg_info_msgs='(?<=INFO ).*(?=\()'
    ```
* Regex untuk mendapat **username** di setiap baris log yang didapatkan dari semua karakter setelah karakter '(' hingga sebelum karakter ')'.
    ```
    reg_users='(?<=\().*(?=\))'
    ```

Variabel dari hasil setiap regex :
* Variabel `type_msgs` menyimpan kata INFO/ERROR ditiap baris dari file sylog.log
    ```
    type_msgs=$(grep -oP "($reg_type_msgs)" "$INPUT")
    ```
* Variabel `msgs` menyimpan pesan dari setiap jenis log yaitu error dan info dari tiap baris pada file sylog.log
    ```
    msgs=$(grep -oP "($reg_msgs)" "$INPUT")
    ```
* Variabel `err_msgs` menyimpan pesan dari setiap jenis log error dari tiap baris pada file sylog.log
    ```
    err_msgs=$(grep -oP "($reg_err_msgs)" "$INPUT")
    ```
* Variabel `info_msgs` menyimpan pesan dari setiap jenis log info dari tiap baris pada file sylog.log
    ```
    info_msgs=$(grep -oP "($reg_info_msgs)" "$INPUT")
    ```
* Variabel `users` menyimpan username dari tiap baris pada file sylog.log
    ```
    users=$(grep -oP "$reg_users" "$INPUT")
    ```


### 1.b
Ryujin harus menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.

```
grep -oP "($reg_err_msgs)" "$INPUT" | sort | uniq -c 
```
**Penjelasan :** mengambil pesan dari jenis log error dengan pesan yang sudah diurutkan sesuai abjad dengan command `sort` dan command  `uniq -c` untuk menampilkan pesan yang sama dan menghitung jumlahnya. Sehingga format perbarisnya menjadi `(jumlah) (pesan)`.

### 1.c
Ryujin juga harus dapat menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user-nya.

* regex untuk mendapatkan pesan dari jenis log error beserta usernamenya di tiap baris.
    ```
    reg_err='(?<=ERROR ).*(?=\))'
    ```
* regex untuk mendapatkan pesan dari jenis log info beserta usernamenya di tiap baris.
    ```
    reg_info='(?<=INFO ).*(?=\))'
    ```
* variabel `err` menyimpan hasil dari regex `reg_err`.
    ```
    err=$(grep -oP "($reg_err)" "$INPUT")
    ```
* variabel `info` menyimpan hasil dari regex `reg_info`.
    ```
    info=$(grep -oP "($reg_info)" "$INPUT")
    ```

**Penjelasan :**

Mengambil semua username yang ada pada syslog.log
```
grep -oP "$reg_users" "$INPUT" | sort | uniq
```
Melakukan perulangan while untuk setiap baris dari hasil `grep` sebelumnya dengan variabel `$user` di setiap barisnya.
```
while read user;
do
    count_error=$(grep -w "$user" <<< "$err" -c) #menghitung banyaknya error tiap `$user`
    count_info=$(grep -w "$user" <<< "$info" -c) #menghitung banyaknya info tiap `$user`
    echo "$user,$count_info,$count_error"
done
```

### 1.d
Memasukkan hasil dari soal 1.b ke file `OUTPUT1=error_message.csv` sesuai ketentuan soal.

### 1.e
Memasukkan hasil dari soal 1.c ke file `OUTPUT2=user_statistic.csv` sesuai ketentuan soal.


# Soal 2
Steven dan Manis mendirikan sebuah startup bernama “TokoShiSop”. Sedangkan kamu dan Clemong adalah karyawan pertama dari TokoShiSop. Setelah tiga tahun bekerja, Clemong diangkat menjadi manajer penjualan TokoShiSop, sedangkan kamu menjadi kepala gudang yang mengatur keluar masuknya barang.

Tiap tahunnya, TokoShiSop mengadakan Rapat Kerja yang membahas bagaimana hasil penjualan dan strategi kedepannya yang akan diterapkan. Kamu sudah sangat menyiapkan sangat matang untuk raker tahun ini. Tetapi tiba-tiba, Steven, Manis, dan Clemong meminta kamu untuk mencari beberapa kesimpulan dari data penjualan “Laporan-TokoShiSop.tsv”.

### 2.a
Steven ingin mengapresiasi kinerja karyawannya selama ini dengan mengetahui **Row ID** dan **profit percentage terbesar** (jika hasil profit percentage terbesar lebih dari 1, maka ambil Row ID yang paling besar). Karena kamu bingung, Clemong memberikan definisi dari profit percentage, yaitu:

```
Profit Percentage = (Profit - Cost Price) * 100
```

Cost Price didapatkan dari pengurangan Sales dengan Profit. (Quantity diabaikan).

**Code** :
```
awk -F "[\t]" '
BEGIN {
    max_profit=0; 
    max_id=0;
} 
NR>1 {
    cost_price=$(NF-3)-$(NF);
    profit_percentage=($(NF)/cost_price)*100; 
    trans_id[$1]=$2;
    if(profit_percentage > max_profit) {
        max_profit=profit_percentage; 
        max_id=$1;
    } else if(profit_percentage == max_profit && max_id < $1) 
    {
        max_id=$1
    }
} 
END {
    print "Transaksi terakhir dengan profit percentage terbesar yaitu "trans_id[max_id]" dengan presetase "max_profit"% \n"
}' $DIR >> $NAMA_FILE
```

## 2.b
Clemong memiliki rencana promosi di Albuquerque menggunakan metode MLM. Oleh karena itu, Clemong membutuhkan daftar **nama customer pada transaksi tahun 2017 di Albuquerque**.

**Code** :
```
awk -F "[\t]" '
BEGIN {
    print "Daftar nama customer di Albuquerque pada tahun 2017 antara lain: "
}
/Albuquerque/ {
    if(index($2, "2017") != 0) 
        a[$7]++
} 
END {
    for (b in a) { 
        print b 
    }; 
    printf"\n";
}' $DIR >> $NAMA_FILE
```

## 2.c
TokoShiSop berfokus tiga segment customer, antara lain: Home Office, Customer, dan Corporate. Clemong ingin meningkatkan penjualan pada segmen customer yang paling sedikit. Oleh karena itu, Clemong membutuhkan **segment customer** dan **jumlah transaksinya yang paling sedikit**.

**Code** :
```
awk -F "[\t]" '
BEGIN {
    Segmen["Consumer"]=0; 
    Segmen["Home Office"]=0; 
    Segmen["Corporate"]=0; 
    min=1000000;} 
NR>1 {
    for(type in Segmen) 
        if($8==type) 
            Segmen[type]=Segmen[type] + $(NF-2); 
} 
END {
    for(type in Segmen) 
        if(min>Segmen[type]) {
            min=Segmen[type];
            min_type=type;
        } 
    print "Tipe segmen customer yang penjualannya paling sedikit adalah "min_type " dengan jumlah transaksi " min "\n"; 
}' $DIR >> $NAMA_FILE
```

## 2.d
TokoShiSop membagi wilayah bagian (region) penjualan menjadi empat bagian, antara lain: Central, East, South, dan West. Manis ingin mencari **wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit** dan **total keuntungan wilayah tersebut.**

**Code** :
```
awk -F "[\t]" '
BEGIN {
    Reg["Central"]=0; 
    Reg["West"]=0; 
    Reg["South"]=0; 
    Reg["East"]=0; 
    min=1000000;
} 
NR>1 {
    for(i in Reg) 
        if($13==i) 
            Reg[i] = Reg[i] + $(NF); 
    } 
END {
    for(i in Reg) 
        if(min>Reg[i]) {
            min=Reg[i]; 
            min_reg=i;
        } 
    print "Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah "min_reg " dengan total keuntungan " min "\n"; 
}' $DIR >> $NAMA_FILE
```

# Soal 3
### 3.a 
Membuat script untuk **mengunduh** 23 gambar dari "https://loremflickr.com/320/240/kitten" serta **menyimpan** log-nya ke file "Foto.log". Karena gambar yang diunduh acak, ada kemungkinan gambar yang sama terunduh lebih dari sekali, oleh karena itu kalian harus **menghapus** gambar yang sama (tidak perlu **mengunduh** gambar lagi untuk menggantinya). Kemudian **menyimpan** gambar-gambar tersebut dengan nama "Koleksi_XX" dengan nomor yang berurutan tanpa ada nomor yang hilang (contoh : Koleksi_01, Koleksi_02, ...)
```
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
```

### 3.b
Karena Kuuhaku malas untuk menjalankan script tersebut secara manual, ia juga meminta kalian untuk menjalankan script tersebut **sehari sekali pada jam 8 malam** untuk tanggal-tanggal tertentu setiap bulan, yaitu dari **tanggal 1 tujuh hari sekali (1,8,...)**, serta dari **tanggal 2 empat hari sekali(2,6,...)**. Supaya lebih rapi, gambar yang telah diunduh beserta **log-nya, dipindahkan ke folder** dengan nama **tanggal unduhnya** dengan **format "DD-MM-YYYY"** (contoh : "13-03-2023").

**File soal3b.sh**
```
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
```

**Cron cron3b.tab**
```
0 20 1-31/7,2-31/4 * * bash mnt/c/Users/shidqi/sisop1/soal3b.sh
```

### 3.c
Agar kuuhaku tidak bosan dengan gambar anak kucing, ia juga memintamu untuk **mengunduh** gambar kelinci dari "https://loremflickr.com/320/240/bunny". Kuuhaku memintamu mengunduh gambar kucing dan kelinci secara **bergantian** (yang pertama bebas. contoh : tanggal 30 kucing > tanggal 31 kelinci > tanggal 1 kucing > ... ). Untuk membedakan folder yang berisi gambar kucing dan gambar kelinci, **nama folder diberi awalan** "Kucing_" atau "Kelinci_" (contoh : "Kucing_13-03-2023").

```
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
```

### 3.d
Untuk mengamankan koleksi Foto dari Steven, Kuuhaku memintamu untuk membuat script yang akan **memindahkan seluruh folder ke zip** yang diberi nama “Koleksi.zip” dan **mengunci** zip tersebut dengan **password** berupa tanggal saat ini dengan format "MMDDYYYY" (contoh : “03032003”).

**File soal3d.sh**
```
#!/bin/bash
parent="/mnt/c/Users/shidqi/sisop1"
cd $parent

d=$(date +%m%d%Y)

zip -mr -P $d Koleksi . -i "*.jpg" "*.log"
rm -d \Kucing*
rm -d \Kelinci*
```

### 3.e
Karena kuuhaku hanya bertemu Steven pada saat kuliah saja, yaitu setiap hari kecuali sabtu dan minggu, dari jam 7 pagi sampai 6 sore, ia memintamu untuk membuat koleksinya **ter-zip** saat kuliah saja, selain dari waktu yang disebutkan, ia ingin koleksinya **ter-unzip** dan **tidak ada file zip** sama sekali.

**Cron cron3e.tab**
```
0 7 * * 1-5 bash /mnt/c/Users/shidqi/sisop1/soal3d.sh
0 18 * * 1-5 unzip -P $(date +%m%d%Y) /mnt/c/Users/shidqi/sisop1/Koleksi && rm "mnt/c/Users/shidqi/sisop1/*.zip"
```
