node sample/sledge-w1-75.js > 105k_75.log 2>&1 &
pid1=$!
node sample/sledge-w2-75.js > 305k_75.log 2>&1 &
pid2=$!
node sample/sledge-w3-75.js > 5k_75.log 2>&1 &
pid3=$!
node sample/sledge-w4-75.js > 40k_75.log 2>&1 &
pid4=$!
wait -f $pid1
wait -f $pid2
wait -f $pid3
wait -f $pid4

printf "[OK]\n"