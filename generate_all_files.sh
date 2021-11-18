#!/bin/bash
function usage {
        echo "$0 [rps list] [duration(s)] [percentage]"
        exit 1
}

if [ $# != 6 ] ; then
        usage
        exit 1;
fi

w1_rps=$1
w2_rps=$2
w3_rps=$3
w4_rps=$4

duration=$5
percentage=$6
echo $percentage
./generate_test_files.sh "w1" $w1_rps $duration $percentage
./generate_test_files.sh "w2" $w2_rps $duration $percentage 
./generate_test_files.sh "w3" $w3_rps $duration $percentage
./generate_test_files.sh "w4" $w4_rps $duration $percentage

#test script name
script_name="test_"$percentage".sh"
cp ./test_65.sh ./$script_name

sed -i "s/65/$percentage/g" ./$script_name
