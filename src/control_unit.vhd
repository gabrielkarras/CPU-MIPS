--************************************************************************************************************
--
-- Author: Gabriel Karras
-- 
-- File: control_unit.vhd
--
-- Design Units:
--	Ports:
--      opcode:  
--      func_in: 
--      reg_write: 
--      red_dest: 
--      reg_in_src: 
--      alu_src: 
--      add_sub: 
--      data_write: 
--      logic_func:
--      func_out: 
--      branch_type: 
--      pc_sel: 
--     
--
--	Architecture:
--		Port Maps:		
--
-- Library/Packages:
--	IEEE.std_logic_1164
-- 	IEEE.numeric_std
--
-- Synthesis and Verification:
--	Synthesis software: Vivado
--	Simulation software: Modelsim
--	Options/Scripts: .do file for Modelsim simulation, .tcl and .xdc for Vivavo synthesis tools
--	Target Technology: Nexys A7 FPGA Board
--
-- Revision History:
-- 	Version: 1.0
-- 	Date: 26 Nov 2020
-- 	Comments: Manages all the control, read and write signals throughout the CPU
--************************************************************************************************************ 

library IEEE;
use IEEE.std_logic_1164.all;

entity control_unit is 
port(
    opcode : in std_logic_vector(5 downto 0);
    func_in : in std_logic_vector(5 downto 0);
    reg_write : out std_logic;
    reg_dest : out std_logic;
    reg_in_src : out std_logic;
    alu_src: out std_logic;
    add_sub : out std_logic;
    data_write : out std_logic;
    logic_func : out std_logic_vector(1 downto 0);
    func_out : out std_logic_vector(1 downto 0);
    branch_type : out std_logic_vector(1 downto 0);
    pc_sel : out std_logic_vector(1 downto 0)
);
end control_unit;


architecture arch_control_unit of control_unit is

-- Signal declaration
signal s_func, s_opcode : std_logic_vector(13 downto 0); -- 14 bits in total for all the control signals combined

begin
-- Select using the lower-order 6 bits(funct) from R-format instruction
with func_in select
    s_func <= "11100000100000" when "100000", -- add
              "11101000100000" when "100010", -- sub
              "11101000010000" when "101010", -- slt
              "11100000110000" when "100100", -- AND
              "11100001110000" when "100101", -- OR
              "11100010110000" when "100110", -- XOR
              "11100011110000" when "100111", -- NOR
              "00000000000010" when "001000", -- jr(not R-format but guidelines asked it to be mapped with function bits)
              "00000000000000" when others; -- default

-- Select using the upper-order 6-bits(opcode) from any instruction format(from all instructions)
with opcode select
s_opcode <= s_func when "000000", -- R-format
            "10110000000000" when "001111", -- lui
            "10110000100000" when "001000", -- addi
            "10111010010000" when "001010", -- slti
            "10110000110000" when "001100", -- andi
            "10110001110000" when "001101", -- ori
            "10110010110000" when "001110", -- xori
            "10010000100000" when "100011", -- lw
            "00010100100000" when "101011", -- sw
            "00000000000001" when "000010", -- j
            "00000000001100" when "000001", -- bltz
            "00000000000100" when "000100", -- beq
            "00000000001000" when "000101", -- bne
            "00000000000000" when others; -- default

-- Assign control signal
reg_write <= s_opcode(13);
reg_dest <= s_opcode(12);
reg_in_src <= s_opcode(11);
alu_src <= s_opcode(10);
add_sub <= s_opcode(9);
data_write <= s_opcode(8); 
logic_func <= s_opcode(7 downto 6);
func_out <= s_opcode(5 downto 4);
branch_type <= s_opcode(3 downto 2);
pc_sel <= s_opcode(1 downto 0);

end arch_control_unit; -- arch_control_unit