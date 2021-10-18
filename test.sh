node sample/sledge-variable-rps1.js > 105k.log 2>&1 &
pid1=$!
node sample/sledge-variable-rps2.js > 305k.log 2>&1 &
pid2=$!
node sample/sledge-variable-rps3.js > 5k.log 2>&1 &
pid3=$!
node sample/sledge-variable-rps4.js > 40k.log 2>&1 &
pid4=$!
wait -f $pid1
wait -f $pid2
wait -f $pid3
wait -f $pid4

printf "[OK]\n"
