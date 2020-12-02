# Vivado does not support old UCF syntax
# must use XDC syntax

# Input ports of reset, write, read_a, read_b, write_address, and din are unspecified
# Clock ports clk is unspecified
# Output ports out_a, and out_b are unspecified

# Gabriel Karras
# 27 October 2020
# XDC file for reg_file.vhd

# set_property BITSTREAM.General.UnconstrainedPins {Allow} [current_design]

# Inputs
set_property  IOSTANDARD LVCMOS33  [ get_ports { clk }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { reset }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { write }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { read_a }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { read_b }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { write_address}  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { din }  ] ;

# Outputs
set_property  IOSTANDARD LVCMOS33  [ get_ports { out_a }  ] ;
set_property  IOSTANDARD LVCMOS33  [ get_ports { out_b }  ] ;