INPUT=../../syslog.log
OUTPUT1=error_message.csv
OUTPUT2=user_statistic.csv

# 1a
reg_type_msg='(INFO|ERROR)'
reg_msgs='(?<=[INFO|ERROR] ).*(?=\()'
reg_err_msgs='(?<=ERROR ).*(?=\()'
reg_info_msgs='(?<=INFO ).*(?=\()'
reg_users='(?<=\().*(?=\))'

type_msgs=$(grep -oP "($reg_type_msgs)" "$INPUT")
msgs=$(grep -oP "($reg_msgs)" "$INPUT")
err_msgs=$(grep -oP "($reg_err_msgs)" "$INPUT")
info_msgs=$(grep -oP "($reg_info_msgs)" "$INPUT")
users=$(grep -oP "$reg_users" "$INPUT")

# 1b
grep -oP "($reg_err_msgs)" "$INPUT" | sort | uniq -c | while read count msg; 
do
    echo "$msg,$count"
done 

# 1c
reg_err='(?<=ERROR ).*(?=\))'
reg_info='(?<=INFO ).*(?=\))'
err=$(grep -oP "($reg_err)" "$INPUT")
info=$(grep -oP "($reg_info)" "$INPUT")

# 1d
echo "ERROR,COUNT" > "$OUTPUT1" 
grep -oP "($reg_err_msgs)" "$INPUT" | sort | uniq -c | sort -nr | while read count msg; 
do
    echo "$msg,$count" >> "$OUTPUT1"
done 

# 1e
echo "Username,INFO,ERROR" > "$OUTPUT2"
grep -oP "$reg_users" "$INPUT" | sort | uniq | while read user;
do
    count_error=$(grep -E "$user" <<< "$err" -c)
    count_info=$(grep -E "$user" <<< "$info" -c)
    echo "$user,$count_info,$count_error" >> "$OUTPUT2"
done