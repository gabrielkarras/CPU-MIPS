# Testing reset
echo " "
echo reset
echo "Expect to see registers initialized to 0"
force reset 1
force clk 0
run 2
examine -radix hex clk reset data_write
examine -radix hex addr 
examine -radix hex s_data(0) s_data(1) s_data(30) s_data(31)

# Unassert Reset signal
force reset 0
run 2

# Run Clock for 9 periods
force clk 1 2 -r 4
force clk 0 4 -r 4

# Testing Write
echo " "
echo Writing1 
echo "Expect to see cache(1) contain 0xFAFA3B3B"
force din 16#FAFA3B3B
force data_write 1
force addr 00001
run 4
examine -radix hex clk reset data_write
examine -radix hex addr
examine -radix hex din 
examine -radix hex s_data(1)
examine -radix hex d_out 

echo " "
echo Writing2
echo "Expect to see cache(0) contain 0xFAAAFAAA"
force din 16#FAAAFAAA
force data_write 1
force addr 00000
run 4
examine -radix hex clk reset data_write
examine -radix hex addr
examine -radix hex din 
examine -radix hex s_data(0)
examine -radix hex d_out 

run 30
examine -radix hex s_data(0) s_data(0) s_data(1) s_data(30) s_data(31)
quit