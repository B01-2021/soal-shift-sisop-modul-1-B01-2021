INPUT=../../syslog.log
OUTPUT1=error_message.csv

declare -a count

reg_type_msg='(INFO|ERROR)'
reg_msgs='(?<=[INFO|ERROR] ).*(?=\()'
reg_err_msgs='(?<=ERROR ).*(?=\()'
reg_info_msgs='(?<=INFO ).*(?=\()'
reg_users='(?<=\().*(?=\))'

err_msgs=$(grep -oP "($reg_err_msgs)" "$INPUT")
msgs=$(grep -oP "($reg_msgs)" "$INPUT")
info_msgs=$(grep -oP "($reg_info_msgs)" "$INPUT")
users=$(grep -oP "$reg_users" "$INPUT")


echo "ERROR,COUNT" > "$OUTPUT1" 
grep -oP "($reg_err_msgs)" "$INPUT" | sort | uniq -c | sort -nr | while read count msg; 
do
    echo "$msg,$count" >> "$OUTPUT1"
done 
