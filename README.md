# soal-shift-sisop-modul-1-B01-2021

## Soal 1
### 1.a
```
reg_type_msg='(INFO|ERROR)'
```
merupakan regex untuk mendapatkan kata INFO atau ERROR di setiap barisnya.
```
reg_msgs='(?<=[INFO|ERROR] ).*(?=\()'
```
merupakan regex untuk mendapat pesan error/info di setiap baris log yang didapatkan dari semua karakter setelah kata INFO/ERROR hingga sebelum karakter '('.
```
reg_err_msgs='(?<=ERROR ).*(?=\()'
```
merupakan regex untuk mendapat pesan dari jenis log error di setiap baris yang didapatkan dari semua karakter setelah kata ERROR hingga sebelum karakter '('.
```
reg_info_msgs='(?<=INFO ).*(?=\()'
```
merupakan regex untuk mendapat pesan dari jenis log info di setiap baris yang didapatkan dari semua karakter setelah kata INFO hingga sebelum karakter '('.
```
reg_users='(?<=\().*(?=\))'
```
merupakan regex untuk mendapat username di setiap baris log yang didapatkan dari semua karakter setelah karakter '(' hingga sebelum karakter ')'.

```
type_msgs=$(grep -oP "($reg_type_msgs)" "$INPUT")
```
variabel `type_msgs` menyimpan kata INFO/ERROR ditiap baris dari file sylog.log
```
msgs=$(grep -oP "($reg_msgs)" "$INPUT")
```
variabel `msgs` menyimpan pesan dari setiap jenis log yaitu error dan info dari tiap baris pada file sylog.log
```
err_msgs=$(grep -oP "($reg_err_msgs)" "$INPUT")
```
variabel `err_msgs` menyimpan pesan dari setiap jenis log error dari tiap baris pada file sylog.log
```
info_msgs=$(grep -oP "($reg_info_msgs)" "$INPUT")
```
variabel `info_msgs` menyimpan pesan dari setiap jenis log info dari tiap baris pada file sylog.log
```
users=$(grep -oP "$reg_users" "$INPUT")
```
variabel `users` menyimpan username dari tiap baris pada file sylog.log

### 1.b
```
grep -oP "($reg_err_msgs)" "$INPUT" | sort | uniq -c 
```
mengambil pesan dari jenis log error dengan pesan yang sudah diurutkan sesuai abjad dengan command `sort` dan command  `uniq -c` untuk menampilkan pesan yang sama dan menghitung jumlahnya. Sehingga format perbarisnya menjadi `(jumlah) (pesan)`.

### 1.c


