# Testing I-format and J-format
echo " "
echo "Expect all 0s"
force func_in 000000
force opcode 000000
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 10110000000000"
force opcode 001111
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 10110000100000"
force opcode 001000
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 10111010010000"
force opcode 001010
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 10110000110000"
force opcode 001100
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 10110001110000"
force opcode 001101
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 10110010110000"
force opcode 001110
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 10010000100000"
force opcode 100011
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 00010100100000"
force opcode 101011
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 00000000000001"
force opcode 000010
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 00000000001100"
force opcode 000001
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 00000000000100"
force opcode 000100
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 00000000001000"
force opcode 000101
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

# Testing R-format
echo " "
echo "Expect 00000000000000"
force opcode 000000
force func_in 000000
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 11100000100000"
force func_in 100000
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 11101000100000"
force func_in 100010
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 11101000010000"
force func_in 101010
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 11100000110000"
force func_in 100100
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 11100001110000"
force func_in 100101
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 11100010110000"
force func_in 100110
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 11100011110000"
force func_in 100111
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel

echo " "
echo "Expect 00000000000010"
force func_in 001000
run 2
examine reg_write reg_dest reg_in_src alu_src add_sub data_write logic_func func_out branch_type pc_sel
quit