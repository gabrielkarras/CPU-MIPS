# TCL script for running vivado in batch mode to synthesize next_addr_unit.vhd
# Gabriel Karras
# 11 November 2020

# To run the script first source the Vivado env file:
# source /CMC/tools/xilinx/Vivado_2018.2/Vivado/2018.2/settings64_CMC_central_license.csh
# Then issue the following command from the Linux prompt:
# vivado -log next_addr_unit.log -mode batch -source next_addr_unit.tcl

# read in the VHDL source code files and the xdc constraints file
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]

read_vhdl  { ../../Code/Lab3/next_addr_unit.vhd   }
read_xdc next_addr_unit.xdc

# the -top refers to the top level VHDL entity name
# the -part specfies the target Xilinx FPGA
synth_design -top next_address -part xc7a100tcsg324-1
opt_design
place_design
route_design

report_timing_summary

# generate the bitsteam file
write_bitstream -force next_addr_unit.bit