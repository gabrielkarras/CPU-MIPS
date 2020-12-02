# TCL script for running vivado in batch mode to synthesize reg_file.vhd
# Gabriel Karras
# 09 November 2020

# To run the script first source the Vivado env file:
# source /CMC/tools/xilinx/Vivado_2018.2/Vivado/2018.2/settings64_CMC_central_license.csh
# Then issue the following command from the Linux prompt:
# vivado -log alu_synth.log -mode batch -source reg_file.tcl

# read in the VHDL source code files and the xdc constraints file
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]

read_vhdl  { ../../Code/Lab2/reg_file.vhd   }
read_xdc reg_file.xdc

# the -top refers to the top level VHDL entity name
# the -part specfies the target Xilinx FPGA
synth_design -top regfile -part xc7a100tcsg324-1
opt_design
place_design
route_design

report_timing_summary

# generate the bitsteam file
write_bitstream -force reg_file.bit