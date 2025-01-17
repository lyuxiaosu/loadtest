#!/bin/bash

function usage {
        echo "$0 [duration(s)] "
        exit 1
}

if [ $# != 1 ] ; then
        usage
        exit 1;
fi

duration=$1


image_name="5k"
scheduler="edf"

w1_rps=117
w2_rps=72
w3_rps=282

w1_rps_f=`echo "scale=2; $w1_rps * 0.33" | bc`
int_w1_rps=`echo $w1_rps_f | awk '{print int($1+0.5)}'`

w2_rps_f=`echo "scale=2; $w2_rps * 0.33" | bc`
int_w2_rps=`echo $w2_rps_f | awk '{print int($1+0.5)}'`

w3_rps_f=`echo "scale=2; $w3_rps * 0.33" | bc`
int_w3_rps=`echo $w3_rps_f | awk '{print int($1+0.5)}'`

rm -rf one_shoot.sh
touch one_shoot.sh
chmod +x one_shoot.sh
cat > one_shoot.sh << EOF
#!/bin/bash
EOF

#rps_list=(50 60 65 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96)
rps_list=(64 70 74 78 80 82 84 86 88 90 92 94 96 98 100)
for(( i=0;i<${#rps_list[@]};i++ )) do

	server_log="mix_"$scheduler"_"${rps_list[i]}".log"
	new_test="new_test_"${rps_list[i]}".sh"
	echo $new_test
	cat >> one_shoot.sh << EOF
./$new_test
EOF

	touch $new_test
	chmod +x $new_test
	cat > $new_test << EOF
#!/bin/bash
path="/users/xiaosuGW/sledge-serverless-framework/runtime/tests"
chmod 400 \$path/id_rsa

ssh -o stricthostkeychecking=no -i \$path/id_rsa xiaosuGW@10.10.1.1 "\$path/start-edf.sh $server_log >/dev/null 2>&1 &"

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
	js_file_w1=`./3w_generate_test_files.sh 1 $int_rps_w1 $duration $int_w1_concurrency ${rps_list[i]}`
	client_log_w1="mix_"$scheduler"_w1_"${rps_list[i]}".txt"

	js_file_w4=`./3w_generate_test_files.sh 4 $int_rps_w1 $duration $int_w1_concurrency ${rps_list[i]}`
	client_log_w4="mix_"$scheduler"_w4_"${rps_list[i]}".txt"

	js_file_w7=`./3w_generate_test_files.sh 7 $int_rps_w1 $duration $int_w1_concurrency ${rps_list[i]}`
        client_log_w7="mix_"$scheduler"_w7_"${rps_list[i]}".txt"

	
	#calculate rps
        rps_w2=`echo "scale=2; $int_w2_rps * ${rps_list[i]} / 100" | bc`
        int_rps_w2=`echo $rps_w2 | awk '{print int($1+0.5)}'`
        #calculate concurrency
        concurrency=`echo "scale=2; $int_rps_w2 / 50" | bc`
        int_w2_concurrency=`echo $concurrency | awk '{print int($1+0.5)}'`
	if [ $int_w2_concurrency -eq 0 ];
          then
            int_w2_concurrency=1
        fi

        #$(( $rps * $duration ))
        echo $int_rps_w2, $int_w2_concurrency
        js_file_w2=`./3w_generate_test_files.sh 2 $int_rps_w2 $duration $int_w2_concurrency ${rps_list[i]}`
        #echo ${rps_list[i]};
        client_log_w2="mix_"$scheduler"_w2_"${rps_list[i]}".txt"

	js_file_w5=`./3w_generate_test_files.sh 5 $int_rps_w2 $duration $int_w2_concurrency ${rps_list[i]}`
        #echo ${rps_list[i]};
        client_log_w5="mix_"$scheduler"_w5_"${rps_list[i]}".txt"

	js_file_w8=`./3w_generate_test_files.sh 8 $int_rps_w2 $duration $int_w2_concurrency ${rps_list[i]}`
        #echo ${rps_list[i]};
        client_log_w8="mix_"$scheduler"_w8_"${rps_list[i]}".txt"


	#calculate rps
        rps_w3=`echo "scale=2; $int_w3_rps * ${rps_list[i]} / 100" | bc`
        int_rps_w3=`echo $rps_w3 | awk '{print int($1+0.5)}'`
        #calculate concurrency
        concurrency=`echo "scale=2; $int_rps_w3 / 50" | bc`
        int_w3_concurrency=`echo $concurrency | awk '{print int($1+0.5)}'`
	if [ $int_w3_concurrency -eq 0 ];
          then
            int_w3_concurrency=1
        fi

        #$(( $rps * $duration ))
        echo $int_rps_w3, $int_w3_concurrency
        js_file_w3=`./3w_generate_test_files.sh 3 $int_rps_w3 $duration $int_w3_concurrency ${rps_list[i]}`
        #echo ${rps_list[i]};
        client_log_w3="mix_"$scheduler"_w3_"${rps_list[i]}".txt"

	js_file_w6=`./3w_generate_test_files.sh 6 $int_rps_w3 $duration $int_w3_concurrency ${rps_list[i]}`
        #echo ${rps_list[i]};
        client_log_w6="mix_"$scheduler"_w6_"${rps_list[i]}".txt"

	js_file_w9=`./3w_generate_test_files.sh 9 $int_rps_w3 $duration $int_w3_concurrency ${rps_list[i]}`
        #echo ${rps_list[i]};
        client_log_w9="mix_"$scheduler"_w9_"${rps_list[i]}".txt"

	cat >> $new_test << EOF
node sample/$js_file_w1 > $client_log_w1 2>&1 &
pid1=\$!
node sample/$js_file_w2 > $client_log_w2 2>&1 &
pid2=\$!
node sample/$js_file_w3 > $client_log_w3 2>&1 &
pid3=\$!
node sample/$js_file_w4 > $client_log_w4 2>&1 &
pid4=\$!
node sample/$js_file_w5 > $client_log_w5 2>&1 &
pid5=\$!
node sample/$js_file_w6 > $client_log_w6 2>&1 &
pid6=\$!
node sample/$js_file_w7 > $client_log_w7 2>&1 &
pid7=\$!
node sample/$js_file_w8 > $client_log_w8 2>&1 &
pid8=\$!
node sample/$js_file_w9 > $client_log_w9 2>&1 &
pid9=\$!

wait -f \$pid1
wait -f \$pid2
wait -f \$pid3
wait -f \$pid4
wait -f \$pid5
wait -f \$pid6
wait -f \$pid7
wait -f \$pid8
wait -f \$pid9

printf "[OK]\n"

ssh -o stricthostkeychecking=no -i \$path/id_rsa xiaosuGW@10.10.1.1 "\$path/kill_sledge.sh"

EOF

done
