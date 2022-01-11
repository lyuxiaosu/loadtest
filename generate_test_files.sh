#!/bin/bash
function usage {
        echo "$0 [workload index] [rps] [duration(s)] [concurrency] [percentage]"
        exit 1
}

if [ $# != 5 ] ; then
        usage
        exit 1;
fi

w_index=$1
w_name="w"$w_index
rps=$2
duration=$3
concurrency=$4
percentage=$5

tmp_index=$(($w_index%4))

#The name of the target json file
json_fname="sledge_"$w_name"_"$percentage".json"
js_fname="sledge-"$w_name"-"$percentage".js"
echo $js_fname
tmp_js_fname="sledge-w"$tmp_index"-tmp.js"
tmp_json_fname="sledge_w_tmp.json"
#original fake json file name in templete file
tmp_json_fake_name="sledge_w"$tmp_index"_tmp.json"
#calcuate total requests number
rq=$(( $rps * $duration ))
warmup_requests=$(( 5 * 20 * $concurrency ))
#generate .js file, copy base tmp js file to target js file
cp sample/$tmp_js_fname sample/$js_fname
#replace the fake json file name with the correct json file name in js file
sed -i "s/$tmp_json_fake_name/$json_fname/g" sample/$js_fname
sed -i "s/concurrency: 1,/concurrency: $concurrency,/g" sample/$js_fname
sed -i "s/rps.reduce((a, b) => a + b, 0),/rps.reduce((a, b) => a + b, 0) + $warmup_requests,/g" sample/$js_fname
#calculate the port number and replace the old one
port_num=$((10000 + ($w_index - 1) * 3))
sed -i "s/const IP = '10000';/const IP = '$port_num';/g" sample/$js_fname

#generate .json file
cp sample/$tmp_json_fname sample/$json_fname
sed -i "s/1111/$rq/g" sample/$json_fname
sed -i "s/2222/$duration/g" sample/$json_fname


