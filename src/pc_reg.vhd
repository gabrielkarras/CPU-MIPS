--***************************************************************************************************
--
-- Author: Gabriel Karras
-- 
-- File: pc_reg.vhd
--
-- Design Units:
--	Ports:
--      pc_in: Next address for PC
--      clk : System clock
--      reset : Asynchronous reset which will reset PC to 0x00000000
--      pc_out : Outputs currently stored PC address
-- 		
--	Architecture:
--
-- Library/Packages:
--	IEEE.std_logic_1164:
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
-- 	Comments: 32-bit PC register for Mips-based CPU.
--**************************************************************************************************** 

library IEEE;
use IEEE.std_logic_1164.all;

entity pc_reg is 
port(
    pc_in: in std_logic_vector(31 downto 0);
    clk : in std_logic;
    reset : in std_logic;
    pc_out : out std_logic_vector(31 downto 0)
);
end pc_reg;

architecture arch_pc_reg of pc_reg is

-- Signal declaration
signal reg_pc : std_logic_vector(31 downto 0); -- 32-bit wide PC register

begin
    
    -- For reset and update PC Register
    pc_update: process(clk, reset)
    begin
		-- async reset
		if(reset='1') then
		    -- reset PC register to 0
            reg_pc <= (others => '0');
		-- on rising edge of clock update PC with next address
		elsif rising_edge(clk) then
			reg_pc <= pc_in;
		end if;
    end process;
    
    -- PC Register output
    pc_out <= reg_pc;

end arch_pc_reg ; -- arch_pc_reg