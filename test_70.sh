node sample/sledge-w1-70.js > 105k_70.log 2>&1 &
pid1=$!
node sample/sledge-w2-70.js > 305k_70.log 2>&1 &
pid2=$!
node sample/sledge-w3-70.js > 5k_70.log 2>&1 &
pid3=$!
node sample/sledge-w4-70.js > 40k_70.log 2>&1 &
pid4=$!
wait -f $pid1
wait -f $pid2
wait -f $pid3
wait -f $pid4

printf "[OK]\n"
