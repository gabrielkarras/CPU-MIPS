--***************************************************************************************************
--
-- Author: Gabriel Karras
-- 
-- File: next_addr_unit.vhd
--
-- Design Units:
--	Ports:
--		rt: 32-bit register input to designate Register Target operand(used for testing conditional branching instructions)
--      rs: 32-bit register input to designate Register Source operand(used for testing conditional branching instructions)
--      pc: 32-bit input from PC register(Program Counter)
--      target_address: 26-bit target address used for jump instructions(will be extended to 32-bit with six 0s as padding bits)
--      branch_type: 2-bit select signal which specifies four possible branch instructions where
--                   00 = no branching(add 1 to PC),
--                   01 = beq-conditional branch equal to 0(1+offset or else 1 to PC),
--                   10 = bne-conditional branch not equal to 0(1+offset or else 1 to PC),
--                   11 = bltz-conditional branch less than zero(1+offset or else 1 to PC)
--      pc_sel: 2-bit select signal where
--              00 = no unconditional jump(arithmetic, logical and branching instructions will be set to this), 
--              01 = jump(will use target_address for pseudo-inderict jump to address location)
--              10 = jump register(will load address in rs-Register Source operand)
--              11 = NOP(not used)
--      next_pc: 32-bit output which will determine the PC's new value
-- 		
--  Architecture:
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
-- 	Date: 11 Nov 2020
-- 	Comments: Design a next address unit. One of the sub-component for a MIPS-based CPU.
--**************************************************************************************************** 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity next_address is
port(
    rt, rs : in std_logic_vector(31 downto 0);
    pc : in std_logic_vector(31 downto 0);
    target_address : in std_logic_vector(25 downto 0);
    branch_type : in std_logic_vector(1 downto 0);
    pc_sel : in std_logic_vector(1 downto 0);
    next_pc : out std_logic_vector(31 downto 0)
);
end next_address;


architecture arch_next_address of next_address is

-- Signal declaration
signal signed1_sig, signed2_sig: signed(31 downto 0); -- temporary signed signal to help with BLTZ comparison(Note:Clearly not the most efficient method)
signal offset_sig,target_address_extended: std_logic_vector(31 downto 0); -- signals for to calculate offset for branching operations
signal branch_sig, beq_sig, bne_sig, bltz_sig: std_logic_vector(31 downto 0); -- signals for branching operations
signal nojmp_sig, jmp_sig, jr_sig, nop_sig: std_logic_vector(31 downto 0); -- signals for PC select 
-- Constant declaration and definition
constant One_Const: std_logic_vector(31 downto 0):= (0 => '1', others=> '0'); -- Constant representing a '1' in 32-bit
constant SignExtend_Const: std_logic_vector(15 downto 0):= (others=> '1'); -- Constant representing a 0xFFFF in 16-bit for sign-extension
constant Zero6bit_Const: std_logic_vector(5 downto 0):= (others=> '0'); -- Constant representing a '0' in 6-bit for jump instruction's padding
constant Zero32bit_Const: std_logic_vector(31 downto 0):= (others=> '0'); -- Constant representing a '0' in 32-bit for bltz comparison

begin
-- Offset Calculation
-- If 15th bit of target adress is 1(means it's negative), then sign extend with 0xFFFF, else extend with all '0'
target_address_extended <= (SignExtend_Const & target_address(15 downto 0)) when (target_address(15)='1') else
                           (Zero32bit_Const(15 downto 0) & target_address(15 downto 0));
-- Add '1' to extended target address
offset_sig <= std_logic_vector(signed(target_address_extended) + 1);

-- pre branch select verification and operations
-- beq: if true then 1+offset, else 1
beq_sig <= offset_sig when (rs=rt) else
           One_Const; 

-- bne: if true then 1+offset, else 1
bne_sig <= offset_sig when (rs/=rt) else
           One_Const; 

-- bltz: if true then 1+offset, else 1
signed1_sig <= signed(rs);
signed2_sig <= signed(Zero32bit_Const);
bltz_sig <= offset_sig when (signed1_sig<signed2_sig) else
            One_Const; 
-- select from branch instructions
-- branch signal result will be added to PC
with branch_type select
    branch_sig <= One_Const when "00", -- no branch
                  beq_sig when "01", -- beq instruction
                  bne_sig when "10", -- bne instruction
                  bltz_sig when others; -- bltz instruction

-- pre pc_select operations
nojmp_sig <= std_logic_vector(signed(pc) + signed(branch_sig)); -- adder: adding appropriate value to PC 
jmp_sig <= Zero6bit_Const & target_address; -- extend target_address to 32-bits with '0' as padding
jr_sig <= rs; -- jump immediately to address location specified by content in rs
nop_sig <= (others=>'0'); -- NOP assignment (TODO: verify NOP's signal assignment)

-- select what next_pc will output(PC's new value)
with pc_sel select
next_pc <= nojmp_sig when "00", -- no unconditional jumps
           jmp_sig when "01", -- jump instruction
           jr_sig when "10", -- jump register instruction
           nop_sig when others; -- NOP (TODO: verify NOP's signal assignment)
                                
end arch_next_address ;