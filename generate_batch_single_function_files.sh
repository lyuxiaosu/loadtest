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


image_name="5k"
scheduler="edf"

p_60=`echo "scale=2; $maximum_rps * 0.6" | bc`
int_p_60=`echo $p_60 | awk '{print int($1+0.5)}'`

p_25=`echo "scale=2; $maximum_rps * 0.25" | bc`
int_p_25=`echo $p_25 | awk '{print int($1+0.5)}'`

p_10=`echo "scale=2; $maximum_rps * 0.1" | bc`
int_p_10=`echo $p_10 | awk '{print int($1+0.5)}'`

p_5=`echo "scale=2; $maximum_rps * 0.05" | bc`
int_p_5=`echo $p_5 | awk '{print int($1+0.5)}'`


#rps_list=(50 60 65 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96)
rps_list=(100)
for(( i=0;i<${#rps_list[@]};i++ )) do

	server_log=$image_name"_"$scheduler"_"${rps_list[i]}".log"
	new_test="new_test_"${rps_list[i]}".sh"
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
	rps_60=`echo "scale=2; $int_p_60 * ${rps_list[i]} / 100" | bc`
	int_rps_60=`echo $rps_60 | awk '{print int($1+0.5)}'`
	#calculate concurrency
	concurrency=`echo "scale=2; $int_rps_60 / 50" | bc`
	int_60_concurrency=`echo $concurrency | awk '{print int($1+0.5)}'`
	if [ $int_60_concurrency -eq 0 ];
  	  then
	    int_60_concurrency=1	
	fi	

	#$(( $rps * $duration ))
	echo $int_rps_60, $int_60_concurrency
	js_file_60=`./generate_test_files.sh $w_name $int_rps_60 $duration $int_60_concurrency "60-"${rps_list[i]}`
	client_log_60=$image_name"_"$scheduler"_60_"${rps_list[i]}".txt"
	
	#calculate rps
        rps_25=`echo "scale=2; $int_p_25 * ${rps_list[i]} / 100" | bc`
        int_rps_25=`echo $rps_25 | awk '{print int($1+0.5)}'`
        #calculate concurrency
        concurrency=`echo "scale=2; $int_rps_25 / 50" | bc`
        int_25_concurrency=`echo $concurrency | awk '{print int($1+0.5)}'`
	if [ $int_25_concurrency -eq 0 ];
          then
            int_25_concurrency=1
        fi

        #$(( $rps * $duration ))
        echo $int_rps_25, $int_25_concurrency
        js_file_25=`./generate_test_files.sh $w_name $int_rps_25 $duration $int_25_concurrency "25-"${rps_list[i]}`
        #echo ${rps_list[i]};
        client_log_25=$image_name"_"$scheduler"_25_"${rps_list[i]}".txt"


	#calculate rps
        rps_10=`echo "scale=2; $int_p_10 * ${rps_list[i]} / 100" | bc`
        int_rps_10=`echo $rps_10 | awk '{print int($1+0.5)}'`
        #calculate concurrency
        concurrency=`echo "scale=2; $int_rps_10 / 50" | bc`
        int_10_concurrency=`echo $concurrency | awk '{print int($1+0.5)}'`
	if [ $int_10_concurrency -eq 0 ];
          then
            int_10_concurrency=1
        fi

        #$(( $rps * $duration ))
        echo $int_rps_10, $int_10_concurrency
        js_file_10=`./generate_test_files.sh $w_name $int_rps_10 $duration $int_10_concurrency "10-"${rps_list[i]}`
        #echo ${rps_list[i]};
        client_log_10=$image_name"_"$scheduler"_10_"${rps_list[i]}".txt"


	#calculate rps
        rps_5=`echo "scale=2; $int_p_5 * ${rps_list[i]} / 100" | bc`
        int_rps_5=`echo $rps_5 | awk '{print int($1+0.5)}'`
        #calculate concurrency
        concurrency=`echo "scale=2; $int_rps_5 / 50" | bc`
        int_5_concurrency=`echo $concurrency | awk '{print int($1+0.5)}'`
	if [ $int_5_concurrency -eq 0 ];
          then
            int_5_concurrency=1
        fi

        #$(( $rps * $duration ))
        echo $int_rps_5, $int_5_concurrency
        js_file_5=`./generate_test_files.sh $w_name $int_rps_5 $duration $int_5_concurrency "5-"${rps_list[i]}`
        #echo ${rps_list[i]};
        client_log_5=$image_name"_"$scheduler"_5_"${rps_list[i]}".txt"


	cat >> $new_test << EOF
node sample/$js_file_60 > $client_log_60 2>&1 &
pid1=\$!
node sample/$js_file_25 > $client_log_25 2>&1 &
pid2=\$!
node sample/$js_file_10 > $client_log_10 2>&1 &
pid3=\$!
node sample/$js_file_5 > $client_log_5 2>&1 &
#pid4=\$!
wait -f \$pid1
wait -f \$pid2
wait -f \$pid3
wait -f \$pid4

printf "[OK]\n"

ssh -o stricthostkeychecking=no -i \$path/id_rsa xiaosuGW@10.10.1.1 "\$path/kill_sledge.sh"

EOF

done
