# Testing reset
# Expect to see registers 0 to 31 to be all "00...00"
echo " "
echo reset
echo "Expect to see registers initialized to 0"
force reset 1
force clk 0
run 2
examine -radix hex clk reset reg(1) reg(2) reg(30) reg(31)

# Unassert Reset signal
force reset 0
run 2

# Run Clock for 9 periods
force clk 1 2 -r 4
force clk 0 4 -r 4

# Testing Write
# Expect to see reg(1) contain 0xFAFA3B3B
echo " "
echo Writing1 
echo "Expect to see reg(1) contain 0xFAFA3B3B"
force din 16#FAFA3B3B
force write 1
force write_address 00001
force read_a 00000
force read_b 00001
run 4
examine -radix hex reset clk write write_address read_a read_b reg(0) reg(1)

# Testing Write
# Expect to see reg(0) contain 0xFAFA3B3B 
echo " "
echo Writing2
echo "Expect to see reg(0) contain 0xFAAAFAAA"
force din 16#FAAAFAAA
force write 1
force write_address 00000
force read_a 00000
force read_b 00001
run 4
examine -radix hex reset clk write write_address read_a read_b reg(0) reg(1)

# Testing Read
# Expect to see out_a output content for reg(0):= 0xFAAAFAAA
# Expect to see out_b output content for reg(1):= 0xFAFA3B3B
echo " "
echo Read
echo "Expect to see out_a:=0xFAAAFAAA and out_b:=0xFAFA3B3B"
force write 0
force read_a 00000
force read_b 00001
run 2
examine -radix hex reset clk write din reg(0) reg(1) out_a out_b
run 30
quit

