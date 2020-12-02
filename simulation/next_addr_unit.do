add wave *
# Testing jump
echo " "
echo "Jump to 0xFFAABB"
echo "Expect to see PC=0x00FFAABB"
force rs 16#00000000
force rt 16#00000000
force branch_type 00
force pc 16#00000000
force target_address 16#FFAABB
force pc_sel 01
run 4
examine -radix bin pc_sel
examine -radix hex target_address 
examine -radix hex next_pc

# Testing jump register Rs 
echo " "
echo " "
echo "Jump to register Rs"
echo "Expect to see PC=0xFFFFAAAA"
force rs 16#FFFFAAAA
force pc_sel 10
run 4
examine -radix bin pc_sel
examine -radix hex next_pc

# Testing Conditionals
# Testing no branching
echo " "
echo " "
echo "No branching"
echo "Expect to see PC=0x00000001"
force pc 16#00000000
force pc_sel 00
force branch_type 00
run 4
examine -radix bin pc_sel branch_type
examine -radix hex next_pc

# Testing BEQ
echo " "
echo " "
echo "Branch if equal(rs=rt) to offset:ABC0 + 1"
echo "Expect to see PC=0xFFFFABC1"
force pc 16#00000000
force rs 16#0000AAAA
force rt 16#0000AAAA
force target_address 16#0ABC0
force branch_type 01
run 4
examine -radix bin pc_sel branch_type
examine -radix hex target_address
examine -radix hex next_pc
examine -radix hex beq_sig bne_sig bltz_sig

echo "Branch if equal(rs=rt) to offset:0x4BC0 + 1"
echo "Expect to see PC=0x00004BC1"
force target_address 16#04BC0
force branch_type 01
run 4
examine -radix bin pc_sel branch_type
examine -radix hex target_address
examine -radix hex next_pc

# Testing BNE
echo " "
echo " "
echo "Branch if not equal(rs!=rt) to offset:0xABC0 + 1"
echo "Expect to see PC=0xFFFFABC1"
force pc 16#00000000
force rs 16#0000AAAA
force rt 16#0000BBBB
force target_address 16#0ABC0
force branch_type 10
run 4
examine -radix bin pc_sel branch_type
examine -radix hex target_address
examine -radix hex next_pc
examine -radix hex branch_type beq_sig bne_sig bltz_sig

echo "Branch if not equal(rs!=rt) to offset:0x4BC0 + 1"
echo "Expect to see PC=0x00004BC1"
force target_address 16#04BC0
force branch_type 10
run 4
examine -radix bin pc_sel branch_type
examine -radix hex target_address
examine -radix hex next_pc

# Testing BLTZ
echo " "
echo " "
echo "Branch if rs < 0 to offset:ABC0 + 1"
echo "Expect to see PC=0xFFFFABC1"
force pc 16#00000000
force rs 16#FFFFFAA0
force rt 16#0000AAAA
force target_address 16#0ABC0
force branch_type 11
run 4
examine -radix bin pc_sel branch_type
examine -radix hex target_address
examine -radix hex next_pc
examine -radix hex branch_type beq_sig bne_sig bltz_sig

echo "Branch if rs < 0 offset:0x4BC0 + 1"
echo "Expect to see PC=0x00004BC1"
force target_address 16#04BC0
force branch_type 11
run 4
examine -radix bin pc_sel branch_type
examine -radix hex target_address
examine -radix hex next_pc
quit