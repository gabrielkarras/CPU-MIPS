# Testing fetching multiple instruction
run 2
echo " "
echo "Fetch instruction 0"
echo "Expect: 00100000000000110000000000000000 "
force low_addr 00000
run 1
examine instr_out

echo " "
echo "Fetch instruction 1"
echo "Expect: 00100000000000010000000000000000 "
force low_addr 00001
run 1
examine instr_out

echo " "
echo "Fetch instruction 2"
echo "Expect: 00100000000000100000000000000101 "
force low_addr 00010
run 1
examine instr_out

echo " "
echo "Fetch instruction 12"
echo "Expect: 00111000100001000000000000000000 "
force low_addr 01100
run 1
examine instr_out

echo " "
echo "Fetch instruction 13"
echo "Expect: 00000000000000000000000000000000 "
force low_addr 01101
run 1
examine instr_out

echo " "
echo "Fetch instruction 31"
echo "Expect: 00000000000000000000000000000000 "
force low_addr 11111
run 1
examine instr_out
quit