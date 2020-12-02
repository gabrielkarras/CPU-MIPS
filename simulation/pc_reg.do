# Testing reset
echo " "
echo Reset
echo "Expect to see PC register:=0x0..00"
force reset 1
force clk 0
run 2
examine -radix hex clk reset
examine -radix hex reg_pc
examine -radix hex pc_in pc_out

# Unassert Reset signal
force reset 0
run 2

# Run Clock for 9 periods
force clk 1 2 -r 4
force clk 0 4 -r 4

# Testing register
echo " "
echo Update PC 
echo "Expect to see PC:= 0xFAFA3B3B"
force pc_in 16#FAFA3B3B
run 4
examine -radix hex clk reset 
examine -radix hex reg_pc
examine -radix hex pc_in pc_out

echo " "
echo "Expect to see PC:= 0xAAAAAAAA"
force pc_in 16#AAAAAAAA
run 4
examine -radix hex clk reset reg_pc
examine -radix hex reg_pc
examine -radix hex pc_in pc_out
run 30
quit