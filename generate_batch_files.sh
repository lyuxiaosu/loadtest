#!/bin/bash

function usage {
        echo "$0 [workload name] [maximum rps] [duration(s)] "
        exit 1
}

if [ $# != 3 ] ; then
        usage
        exit 1;
fi

w_name=$1
maximum_rps=$2
duration=$3

touch new_test.sh
chmod +x new_test.sh

echo "#!/bin/bash

path="/users/xiaosuGW/sledge-serverless-framework/runtime/tests"
chmod 400 \$path/id_rsa

" > new_test.sh

image_name="5k"
scheduler="edf"
rps_list=(50 60 65 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96)
for(( i=0;i<${#rps_list[@]};i++ )) do
	#calculate rps
	rps=`echo "scale=2; $maximum_rps * ${rps_list[i]} / 100" | bc`
	int_rps=`echo $rps | awk '{print int($1+0.5)}'`
	#calculate concurrency
	concurrency=`echo "scale=2; $int_rps / 50" | bc`
	int_concurrency=`echo $concurrency | awk '{print int($1+0.5)}'`
	#$(( $rps * $duration ))
	echo $int_rps, $int_concurrency
	./generate_test_files.sh $w_name $int_rps $duration $int_concurrency ${rps_list[i]}
	#echo ${rps_list[i]};
	client_log=$image_name"_"$scheduler"_"${rps_list[i]}".txt"
	server_log=$image_name"_"$scheduler"_"${rps_list[i]}".log"

	cat >> new_test.sh << EOF
client_log=$client_log
server_log_file=$server_log
#vmstat_file="30cpucore_single1_vmstat.txt"
#pidstat_file="30cpucore_single1_pidstat.txt"
ssh -o stricthostkeychecking=no -i \$path/id_rsa xiaosuGW@10.10.1.1 "\$path/start.sh \$server_log_file >/dev/null 2>&1 &"
#ssh -o stricthostkeychecking=no -i \$path/id_rsa xiaosuGW@10.10.1.1 "\$path/start_monitor.sh \$vmstat_file \$pidstat_file"
node sample/sledge-w3-50.js > $client_log
ssh -o stricthostkeychecking=no -i \$path/id_rsa xiaosuGW@10.10.1.1 "\$path/kill_sledge.sh"
#ssh -o stricthostkeychecking=no -i \$path/id_rsa xiaosuGW@10.10.1.1 "\$path/stop_monitor.sh"


EOF

done;
