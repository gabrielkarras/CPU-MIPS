# Vivado does not support old UCF syntax
# must use XDC syntax

# Gabriel Karras
# 25 November 2020
# XDC file for CPU.vhd

# set_property BITSTREAM.General.UnconstrainedPins {Allow} [current_design]

# Inputs(unspecified)
set_property  IOSTANDARD LVCMOS33  [ get_ports { clk }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { reset }  ] ;

# Outputs(unspecified)
set_property  IOSTANDARD LVCMOS33  [ get_ports { overflow }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { zero }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { rs_out }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { rt_out }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { pc_out }  ] ;