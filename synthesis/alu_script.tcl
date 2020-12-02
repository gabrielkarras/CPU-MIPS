# TCL script for running vivado in batch mode to synthesize ALU.vhd
# Gabriel Karras
# 27 October 2020

# To run the script first source the Vivado env file:
# source /CMC/tools/xilinx/Vivado_2018.2/Vivado/2018.2/settings64_CMC_central_license.csh
# Then issue the following command from the Linux prompt:
# vivado -log alu_synth.log -mode batch -source alu_script.tcl

# read in the VHDL source code files and the xdc constraints file
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]

read_vhdl  { ../../Code/Lab1/adder_sub_unit.vhd  ../../Code/Lab1/logic_unit.vhd ../../Code/Lab1/overflow_unit.vhd ../../Code/Lab1/ALU.vhd }
read_xdc alu_script.xdc

# the -top refers to the top level VHDL entity name
# the -part specfies the target Xilinx FPGA
synth_design -top alu -part xc7a100tcsg324-1

opt_design
place_design
route_design

report_timing_summary

# generate the bitsteam file
write_bitstream -force alu_circuit.bit

