# Vivado does not support old UCF syntax
# must use XDC syntax

# Input ports of rt, rs, pc, target_address, branch_type and pc_sel are unspecified
# Output port next_pc is unspecified

# Gabriel Karras
# 11 November 2020
# XDC file for next_addr_unit.vhd

# set_property BITSTREAM.General.UnconstrainedPins {Allow} [current_design]

# Inputs
set_property  IOSTANDARD LVCMOS33  [ get_ports { rt }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { rs }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { pc }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { target_address }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { branch_type }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { pc_sel }  ] ;

# Outputs
set_property  IOSTANDARD LVCMOS33  [ get_ports { next_pc }  ] ;
