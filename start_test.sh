path="/users/xiaosuGW/sledge-serverless-framework/runtime/tests"
chmod 400 $path/id_rsa


#test single c10
server_log_file="srsf_match.log"
#vmstat_file="30cpucore_single1_vmstat.txt"
#pidstat_file="30cpucore_single1_pidstat.txt"
ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/start.sh $server_log_file >/dev/null 2>&1 &"
#ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/start_monitor.sh $vmstat_file $pidstat_file"
./test.sh
ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/kill_sledge.sh"
#ssh -o stricthostkeychecking=no -i $path/id_rsa xiaosuGW@10.10.1.1 "$path/stop_monitor.sh"

