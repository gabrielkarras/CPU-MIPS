--***************************************************************************************************
--
-- Author: Gabriel Karras
-- 
-- File: ALU.vhd
--
-- Design Units:
--	Ports:
--		x: 32-bit input as one of the operands for the ALU
-- 		y: 32-bit input as one of the operands for the ALU
--		add_sub: 1-bit select signal for the arithmetic unit where 0 = add & 1 = sub(in signed 2's compliment)
--		logic_func: 2-bit select signal for the logic unit where 00 = AND, 01 = OR , 10 = XOR & 11 = NOR
--		func: 2-bit select signal which will specify which instruction the ALU will output
--			  Where 00 = lui, 01 = setless , 10 = arith & 11 = logic
--		output: 32-bit which will output the result of the ALU  
--		overf: 1-bit Overflow flag where  1 = Overflow was detected & 0 = Otherwise
--		zero: 1-bit Zero flag where 1 = Zero was detected & 0 = Otherwise
--
--	Architecture:
--		Port Maps:
--			logic: Maps the logic operation unit into the ALU
--			adder_sub: Maps the arithmetic operation unit into the ALU
--			overflow: Maps the overflow operation unit into the ALU
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
-- 	Comments: Design a 32-bit ALU
--**************************************************************************************************** 

library IEEE;
use IEEE.std_logic_1164.all;

entity alu is
port(
	x, y : in std_logic_vector(31 downto 0);
	add_sub : in std_logic ;
	logic_func : in std_logic_vector(1 downto 0 );
	func : in std_logic_vector(1 downto 0 );
	output : out std_logic_vector(31 downto 0);
	overf : out std_logic;
	zero : out std_logic
);
end alu ;

architecture arch_alu of alu is

-- Component Decleration
-- Logic unit
component logic
port(
	x, y : in std_logic_vector(31 downto 0);
	sel : in std_logic_vector(1 downto 0);
	output : out std_logic_vector(31 downto 0)
);
end component;

-- Adder and subtractor unit 
component adder_sub
port(
	x, y : in std_logic_vector(31 downto 0); 
	sel : in std_logic;
	output : out std_logic_vector(31 downto 0)
);
end component;

-- Overflow detection unit
component overflow 
port(
	x, y, r : in std_logic_vector(31 downto 0); 
	sel : in std_logic; 
	overflow : out std_logic
);
end component;

-- Component configuration specification
for U1 : adder_sub use entity WORK.adder_sub(arch_adder_sub);
for U2 : logic use entity WORK.logic(arch_logic);
for U3 : overflow use entity WORK.overflow(arch_overflow);

-- Signal Declaration
signal add_sub_result, logic_result: std_logic_vector(31 downto 0); -- result signals

-- Constant Declaration and definition
constant Zero_Const: std_logic_vector(31 downto 0):= ( others=> '0'); -- 32bit vector to represent 0
	
begin
-- Adder/Subtractor
U1: adder_sub port map(x => x, y => y, sel => add_sub, output => add_sub_result);

-- Logic
U2: logic port map(x => x, y => y, sel => logic_func, output => logic_result);

-- ALU Multiplexer
with func select
	output <= y when "00", -- lui
			  ( Zero_Const(31 downto 1) & add_sub_result(31) ) when "01", -- verify slt
			  add_sub_result when "10", -- add/sub result
			  logic_result when others; -- logic result	

-- Zero
zero <= '1' when ( add_sub_result = Zero_Const ) else -- zero set
		'0'; -- zero not set
		
-- Overflow
U3: overflow port map(x => x, y => y, r => add_sub_result, sel => add_sub, overflow => overf);

end arch_alu; -- arch_alu
