#!/bin/bash

function usage {
        echo "$0 [func name index] [max rps] [duration(s)] "
        exit 1
}

if [ $# != 3 ] ; then
        usage
        exit 1;
fi

func_name_index=$1
func_name="w"$func_name_index
max_rps=$2
duration=$3


scheduler="edf-10m"

w1_rps_f=`echo "scale=2; $max_rps * 0.33" | bc`
int_w1_rps=`echo $w1_rps_f | awk '{print int($1+0.5)}'`


#rps_list=(50 60 65 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96)
rps_list=(64 70 74 78 80 82 84 86 88 90 92 94 96 98 100)
rm -rf one_shoot.sh
touch one_shoot.sh
chmod +x one_shoot.sh
cat > one_shoot.sh << EOF
#!/bin/bash
EOF

#rps_list=(100)
for(( i=0;i<${#rps_list[@]};i++ )) do

	server_log="single-different-deadlines_"$scheduler"_"${rps_list[i]}".log"
	new_test="new_test_"${rps_list[i]}".sh"
	cat >> one_shoot.sh << EOF
./$new_test
EOF
	echo $new_test
	touch $new_test
	chmod +x $new_test
	cat > $new_test << EOF
#!/bin/bash
path="/users/xiaosuGW/sledge-serverless-framework/runtime/tests"
chmod 400 \$path/id_rsa

ssh -o stricthostkeychecking=no -i \$path/id_rsa xiaosuGW@10.10.1.1 "\$path/start.sh $server_log >/dev/null 2>&1 &"

EOF


	#calculate rps
	rps_w1=`echo "scale=2; $int_w1_rps * ${rps_list[i]} / 100" | bc`
	int_rps_w1=`echo $rps_w1 | awk '{print int($1+0.5)}'`
	#calculate concurrency
	concurrency=`echo "scale=2; $int_rps_w1 / 50" | bc`
	int_w1_concurrency=`echo $concurrency | awk '{print int($1+0.5)}'`
	if [ $int_w1_concurrency -eq 0 ];
  	  then
	    int_w1_concurrency=1	
	fi	

	#$(( $rps * $duration ))
	echo $int_rps_w1, $int_w1_concurrency
	js_file_w1=`./generate_test_files.sh $func_name $int_rps_w1 $duration $int_w1_concurrency ${rps_list[i]}`
	client_log_w1="single-different-deadlines_"$scheduler"_"$func_name"_"${rps_list[i]}".txt"

	new_func_name_idx=`echo "$func_name_index + 4" | bc`
	new_func_name="w"$new_func_name_idx
	js_file_w2=`./generate_test_files.sh $new_func_name $int_rps_w1 $duration $int_w1_concurrency ${rps_list[i]}`
	client_log_w2="single-different-deadlines_"$scheduler"_"$new_func_name"_"${rps_list[i]}".txt"

	new_func_name_idx=`echo "$func_name_index + 8" | bc`
	new_func_name="w"$new_func_name_idx
	js_file_w3=`./generate_test_files.sh $new_func_name $int_rps_w1 $duration $int_w1_concurrency ${rps_list[i]}`
        client_log_w3="single-different-deadlines_"$scheduler"_"$new_func_name"_"${rps_list[i]}".txt"


	cat >> $new_test << EOF
node sample/$js_file_w1 > $client_log_w1 2>&1 &
pid1=\$!
node sample/$js_file_w2 > $client_log_w2 2>&1 &
pid2=\$!
node sample/$js_file_w3 > $client_log_w3 2>&1 &
pid3=\$!

wait -f \$pid1
wait -f \$pid2
wait -f \$pid3

printf "[OK]\n"

ssh -o stricthostkeychecking=no -i \$path/id_rsa xiaosuGW@10.10.1.1 "\$path/kill_sledge.sh"

EOF

done
