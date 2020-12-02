# TCL script for running vivado in batch mode to synthesize CPU.vhd
# Gabriel Karras
# 25 November 2020

# To run the script first source the Vivado env file:
# source /CMC/tools/xilinx/Vivado_2018.2/Vivado/2018.2/settings64_CMC_central_license.csh
# Then issue the following command from the Linux prompt:
# vivado -log CPU.log -mode batch -source CPU.tcl

# read in the VHDL source code files and the xdc constraints file
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]

read_vhdl  { ../../Code/Lab4/logic_unit.vhd ../../Code/Lab4/adder_sub_unit.vhd ../../Code/Lab4/overflow_unit.vhd ../../Code/Lab4/ALU.vhd ../../Code/Lab4/next_addr_unit.vhd  
             ../../Code/Lab4/d_cache.vhd ../../Code/Lab4/i_cache.vhd ../../Code/Lab4/pc_reg.vhd ../../Code/Lab4/reg_file.vhd ../../Code/Lab4/sign_extend_unit.vhd
             ../../Code/Lab4/control_unit.vhd ../../Code/Lab4/CPU.vhd }
read_xdc CPU.xdc

# the -top refers to the top level VHDL entity name
# the -part specfies the target Xilinx FPGA
synth_design -top cpu_v2 -part xc7a100tcsg324-1
opt_design
place_design
route_design

report_timing_summary

# generate the bitsteam file
write_bitstream -force CPU.bit