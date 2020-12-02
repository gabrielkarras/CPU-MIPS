#Adding 15855 + 495 = 16350 
echo " "
echo Adding
force x 16#00003DEF
force y 16#000001EF
force add_sub 0
force func 10
run 2
examine output
#Subtracting 15855 - 495 = 15360
echo " "
echo Subtracting
force add_sub 1
run 2
examine output
# 15855 AND 495 = 495 
echo " "
echo AND
force logic_func 00
force func 11
run 2
examine output
# 15855 OR 495 = 15855
echo " "
echo OR
force logic_func 01
run 2
examine output
# 15855 XOR 495 = 15360
echo " "
echo XOR
force logic_func 10
run 2
examine output
# 15855 NOR 495 = -15856 
echo " "
echo NOR
force logic_func 11
run 2
examine output
# slt instruction (000...00MSB)
echo " "
echo slt
force add_sub 0
force func 01
force x 16#FFFFFFFF
force y 16#00000000
run 2
examine add_sub_result output
# lui (y should be loaded)
echo " "
echo lui
force func 00
force y 16#0000AFFF
run 2
examine y output
# zero flag (A-A = 0)
echo " "
echo zero
force add_sub 1
force func 10
force x 16#0000000A
force y 16#0000000A
run 2
examine zero output
# overflow flag
echo " "
echo Overflow for Adder
force add_sub 0
force func 10
force x 16#7FFFFFFF
force y 16#7FFFFFFC
run 2
examine overf output
force x 16#80000000
force y 16#80000003
run 2
examine overf output
echo " "
echo Overflow for Subtractor
force add_sub 1
force func 10
force x 16#80000000
force y 16#000000BB
run 2
examine overf output
force x 16#7FFFFFFF
force y 16#80000003
run 2
examine overf output
quit
