# Testing lui
echo " "
echo "Expect 0xFFAA0000"
force ta_in 16#FFAA
force func 00
run 2
examine -radix hex ext_out

# Testing slt
echo " "
echo "Expect 0xFFFFFFAA"
force ta_in 16#FFAA
force func 01
run 2
examine -radix hex ext_out
echo " "
echo "Expect 0x000011AA"
force ta_in 16#11AA
force func 01
run 2
examine -radix hex ext_out

# Testing arithmetic
echo " "
echo "Expect 0xFFFFFFAA"
force ta_in 16#FFAA
force func 10
run 2
examine -radix hex ext_out
echo " "
echo "Expect 0x000011AA"
force ta_in 16#11AA
force func 10
run 2
examine -radix hex ext_out

# Testing logical
echo " "
echo "Expect 0x0000FFAA"
force ta_in 16#FFAA
force func 11
run 2
examine -radix hex ext_out
quit