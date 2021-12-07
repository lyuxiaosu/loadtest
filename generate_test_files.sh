#!/bin/bash
function usage {
        echo "$0 [workload name] [rps] [duration(s)] [concurrency] [percentage]"
        exit 1
}

if [ $# != 5 ] ; then
        usage
        exit 1;
fi

w_name=$1
rps=$2
duration=$3
concurrency=$4
percentage=$5


json_fname="sledge_"$w_name"_"$percentage".json"
js_fname="sledge-"$w_name"-"$percentage".js"
echo $js_fname
tmp_js_fname="sledge-"$w_name"-tmp.js"
tmp_json_fname="sledge_w_tmp.json"
tmp_json_fake_name="sledge_"$w_name"_tmp.json"
#calcuate total requests number
rq=$(( $rps * $duration ))
warmup_requests=$(( 5 * 20 * $concurrency ))
#generate .js file
cp sample/$tmp_js_fname sample/$js_fname
sed -i "s/$tmp_json_fake_name/$json_fname/g" sample/$js_fname
sed -i "s/concurrency: 1,/concurrency: $concurrency,/g" sample/$js_fname
sed -i "s/rps.reduce((a, b) => a + b, 0),/rps.reduce((a, b) => a + b, 0) + $warmup_requests,/g" sample/$js_fname

#generate .json file
cp sample/$tmp_json_fname sample/$json_fname
sed -i "s/1111/$rq/g" sample/$json_fname
sed -i "s/2222/$duration/g" sample/$json_fname


