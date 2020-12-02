add wave *
# Testing reset
echo " "
echo reset
echo "Expect to see registers initialized to 0"
force reset 1
force clk 0
run 2
#examine -radix hex clk reset
#examine -radix hex overflow zero
#examine -radix hex pc_out 
#examine -radix hex rs_out rt_out

# Unassert Reset signal
force reset 0
run 2

# Run Clock for 
force clk 1 2 -r 4
force clk 0 4 -r 4

echo " "
echo "Program Start"
#examine s_icache_out
#examine -radix hex clk reset
#examine -radix hex overflow zero
#examine -radix hex pc_out 
#examine -radix hex rs_out rt_out

run 150
echo " "
echo "Program Terminated"
#examine s_icache_out
#examine -radix hex clk reset
#examine -radix hex overflow zero
#examine -radix hex pc_out 
#examine -radix hex rs_out rt_out
#quit