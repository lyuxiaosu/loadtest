path="/users/xiaosuGW/sledge-serverless-framework/runtime/tests"
chmod 400 $path/id_rsa


#test single c10
server_log_file="srsf_60.log"
#vmstat_file="30cpucore_single1_vmstat.txt"
#pidstat_file="30cpucore_single1_pidstat.txt"
ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/start.sh $server_log_file >/dev/null 2>&1 &"
#ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/start_monitor.sh $vmstat_file $pidstat_file"
./test.sh
ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/kill_sledge.sh"
#ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/stop_monitor.sh"

############# 65 ############
server_log_file="srsf_65.log"
#vmstat_file="30cpucore_single1_vmstat.txt"
#pidstat_file="30cpucore_single1_pidstat.txt"
ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/start.sh $server_log_file >/dev/null 2>&1 &"
#ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/start_monitor.sh $vmstat_file $pidstat_file"
./test_65.sh
ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/kill_sledge.sh"
#ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/stop_monitor.sh"

############# 70 ############
server_log_file="srsf_70.log"
#vmstat_file="30cpucore_single1_vmstat.txt"
#pidstat_file="30cpucore_single1_pidstat.txt"
ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/start.sh $server_log_file >/dev/null 2>&1 &"
#ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/start_monitor.sh $vmstat_file $pidstat_file"
./test_70.sh
ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/kill_sledge.sh"
#ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/stop_monitor.sh"


############# 75 ############
server_log_file="srsf_75.log"
#vmstat_file="30cpucore_single1_vmstat.txt"
#pidstat_file="30cpucore_single1_pidstat.txt"
ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/start.sh $server_log_file >/dev/null 2>&1 &"
#ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/start_monitor.sh $vmstat_file $pidstat_file"
./test_75.sh
ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/kill_sledge.sh"
#ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/stop_monitor.sh"

############# 80 ############
server_log_file="srsf_80.log"
#vmstat_file="30cpucore_single1_vmstat.txt"
#pidstat_file="30cpucore_single1_pidstat.txt"
ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/start.sh $server_log_file >/dev/null 2>&1 &"
#ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/start_monitor.sh $vmstat_file $pidstat_file"
./test_80.sh
ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/kill_sledge.sh"
#ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/stop_monitor.sh"

