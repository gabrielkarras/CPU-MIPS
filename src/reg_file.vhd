--***************************************************************************************************
--
-- Author: Gabriel Karras
-- 
-- File: reg_file.vhd
--
-- Design Units:
-- 	Generics:
--		r_WIDTH: 32 to represent width of the register file
--	Ports:
--		din: 32-bit input to write into registers
-- 		reset: Resets all registers to '0' if reset='1'
--		clk: Clock
--		write: Write signal: if write='1' then it enables writing into registers
--		read_a: Specifies register that will be outputted in out_a
--		read_b: Specifies register that will be outputted in out_b
--		write_address: Specifies register that will be written
-- 		out_a: Outputs register content specified by read_a
--		out_b: Outputs register content specified by read_b
--
--	Architecture:
--
-- Library/Packages:
--	IEEE.std_logic_1164:
-- 	IEEE.numeric_std:
--
-- Synthesis and Verification:
--	Synthesis software: Vivado
--	Simulation software: Modelsim
--	Options/Scripts: .do file for Modelsim simulation, .tcl and .xdc for Vivavo synthesis tools
--	Target Technology: Nexys A7 FPGA Board
--
-- Revision History:
-- 	Version: 1.0
-- 	Date: 30 Oct 2020
-- 	Comments: Design for a 32x32 register file. One of the sub-component for a MIPS-based CPU.
--**************************************************************************************************** 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regfile is
generic (
	g_WIDTH : natural := 32
);
port( 
	din : in std_logic_vector(31 downto 0);
	reset : in std_logic;
	clk : in std_logic;
	write : in std_logic;
	read_a : in std_logic_vector(4 downto 0);
	read_b : in std_logic_vector(4 downto 0);
	write_address : in std_logic_vector(4 downto 0);
	out_a : out std_logic_vector(31 downto 0);
	out_b : out std_logic_vector(31 downto 0)
);
end regfile;

architecture arch_regfile of regfile is
-- Signal and Type declaration
type r_file is array(0 to g_WIDTH-1) of std_logic_vector(g_WIDTH-1 downto 0); -- Creating an array of 32x32 for register file
signal reg : r_file;

begin
	write_process: process(clk, reset)
	begin
		-- async reset
		if(reset='1') then
			-- FOR LOOP
			for i in reg'range loop
			-- reset all registers to 0
				reg(i) <= (others => '0');
			end loop;
		-- on rising edge of clok
		elsif rising_edge(clk) then
			-- if write is enabled
			if(write = '1') then
				--write to register
				reg(to_integer(unsigned(write_address))) <= din;
			end if;
		end if;
	end process;

	-- read from registers specified by read_a
	out_a <= reg(to_integer(unsigned(read_a)));
	-- read from registers specified by read_b
	out_b <= reg(to_integer(unsigned(read_b)));
	
end arch_regfile;