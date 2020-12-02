--***************************************************************************************************
--
-- Author: Gabriel Karras
-- 
-- File: sign_extend_unit.vhd
--
-- Design Units:
--	Ports:
--      ta_in : target address coming from the lower-order 16-bits of an instruction(which comes from the Instruction cache)
--      func : 2-bit select signal which specifies four extension/padding possibilities 
--             00 = for load upper immediate instructions where we pad lower-order with '0's
--             01 = for set less immediate instructions where we sign extend the 16th bit
--             10 = for arithmetic op instructions where we sign extend the 16th bit
--             11 = for logical op instructions where we pad higher-order with '0's
--      ext_out : 32-bit output of the padded or sign-extended target address input
--	
--	Architecture:
--
-- Library/Packages:
--	IEEE.std_logic_1164
--
-- Synthesis and Verification:
--	Synthesis software: Vivado
--	Simulation software: Modelsim
--	Options/Scripts: .do file for Modelsim simulation, .tcl and .xdc for Vivavo synthesis tools
--	Target Technology: Nexys A7 FPGA Board
--
-- Revision History:
-- 	Version: 1.0
-- 	Date: 24 Nov 2020
-- 	Comments: A sign-extension unit for which it takes a 16-bit input target address
--**************************************************************************************************** 

library IEEE;
use IEEE.std_logic_1164.all;

entity sign_extend is 
port(
    ta_in : in std_logic_vector(15 downto 0);
    func : in std_logic_vector(1 downto 0);
    ext_out : out std_logic_vector(31 downto 0)
);
end sign_extend;

architecture arch_sign_extend of sign_extend is

-- Signal declaration
signal target_address_extended : std_logic_vector(31 downto 0); -- intermediate signal for sign-extension detection
-- Constant declaration and definition
constant SignExtendOne_Const : std_logic_vector(15 downto 0):= (others=> '1'); -- Constant representing all '1's in 16-bit for sign-extension (or 0xFFFF) 
constant SignExtendZero_Const : std_logic_vector(15 downto 0):= (others=> '0'); -- Constant representing a '0' in 16-bit for sign-extension and padding

begin
-- Sign Extension
-- If 16th bit of the target adress is 1(this indicates a negative number), then sign extend with 0xFFFF, else sign-extend with all '0's
target_address_extended <= (SignExtendOne_Const & ta_in) when (ta_in(15)='1') else -- Extend with '1's
                           (SignExtendZero_Const & ta_in); -- Extend with '0's

with func select
    ext_out <= (ta_in & SignExtendZero_Const) when "00", -- load upper immediate-> pad lower-order with '0's
               (target_address_extended) when "01", -- set less immediate-> sign extend the 16th bit
               (target_address_extended) when "10", -- arithmetic op-> sign extend the 16th bit
               (SignExtendZero_Const & ta_in) when others; -- logical op-> pad higher-order with '0's

end arch_sign_extend ; -- arch_sign_extend