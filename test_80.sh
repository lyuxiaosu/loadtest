node sample/sledge-w1-80.js > 105k_80.log 2>&1 &
pid1=$!
node sample/sledge-w2-80.js > 305k_80.log 2>&1 &
pid2=$!
node sample/sledge-w3-80.js > 5k_80.log 2>&1 &
pid3=$!
node sample/sledge-w4-80.js > 40k_80.log 2>&1 &
pid4=$!
wait -f $pid1
wait -f $pid2
wait -f $pid3
wait -f $pid4

printf "[OK]\n"
