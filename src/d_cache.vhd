--***************************************************************************************************
--
-- Author: Gabriel Karras
-- 
-- File: d_cache.vhd
--
-- Design Units:
-- 	Generics:
--		r_WIDTH: 32-bits to represent width of the data field within the cache
--	Ports:
--		din : 32-bit data input we wish to write into the data cache
--      addr : 5-bit address location of data cache(2^5 for 32 addresses)
--      data_write : Signal for enabling writing data to registers within cache
--      reset : Asynchronous reset to reset all 32 registers within cache to 0x00000000
--      clk : System clock
--      d_out : 32-bit data output from data cache(register specified by input addr)
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
-- 	Comments: Design for a 32 x 32-bit RAM-like data cache for Mips-based CPU.
--**************************************************************************************************** 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity d_cache is
generic (
	g_WIDTH : natural := 32
);
port( 
	din : in std_logic_vector(31 downto 0);
	addr : in std_logic_vector(4 downto 0);
	data_write : in std_logic;
	reset : in std_logic;
	clk : in std_logic;
	d_out : out std_logic_vector(31 downto 0)
);
end d_cache;

architecture arch_d_cache of d_cache is
-- Signal and Type declaration
type r_file is array(0 to g_WIDTH-1) of std_logic_vector(g_WIDTH-1 downto 0); -- Creating an array of 32x32 for the data cache
signal s_data : r_file; -- signal of type data cache

begin
    -- Write into cache or reset registers in cache
	write_reset_cache: process(clk, reset)
	begin
		-- async reset
		if(reset='1') then
			-- FOR LOOP
			for i in s_data'range loop
			-- reset all registers to 0
				s_data(i) <= (others => '0');
			end loop;
		-- on rising edge of clok
		elsif rising_edge(clk) then
			-- if write is enabled
			if(data_write = '1') then
				--write to data cache
				s_data(to_integer(unsigned(addr))) <= din;
			end if;
		end if;
	end process;

	-- read from cache register at specified address location
	d_out <= s_data(to_integer(unsigned(addr)));
	
end arch_d_cache;