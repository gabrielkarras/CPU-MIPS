--***************************************************************************************************
--
-- Author: Gabriel Karras
-- 
-- File: I_cache.vhd
--
-- Design Units:
--  Generic:
--      g_Width : width of instructions within the cache
--	Ports:
--      low_addr : Lower-order 5-bits taken form the PC Register which determines the address of
--                 the instruction within the Instruction cache
--      instr_out : Outputs a 32-bit machine level instruction based on the Mips ISA 
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
-- 	Date: 24 Nov 2020
-- 	Comments: 32 x 32-bit ROM Instruction cache for Mips-based CPU.
--            It’s contents may be “hardwired” to contain a program in machine code during the 
--            development and debugging stages
--**************************************************************************************************** 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity i_cache is
generic (
    g_WIDTH : natural := 32
); 
port(
    low_addr : in std_logic_vector(4 downto 0);
    instr_out : out std_logic_vector(31 downto 0)
);
end i_cache;

architecture arch_i_cache of i_cache is
-- Signal declaration and Type decleration
type r_file is array(0 to g_WIDTH-1) of std_logic_vector(g_WIDTH-1 downto 0); -- Creating an array of 32x5-bits for i-cache register
signal s_cache : r_file; -- signal of type i-cache

begin
-- Machine level code for: 
--     addi r3, r0, 0; 
--     addi r1, r0, 0; 
--     addi r2,r0,5; 
-- LOOP: add r1,r1,r2;  
--     addi r2, r2, -1;  
--     beq r2,r3 (+1); 
--     jump  LOOP; 
-- THERE: sw r1, 0(r0)   
--    lw r4, 0(r0);  
--    andi r4, r4, 0x000A; 
--    ori r4, r4, 0x0001;    
--    xori r4, r4 , 0xB;
--    xori r4, r4, 0x0;  

    -- Fetch instruction from cache
    instruction_fetch: process(s_cache)
    begin
        s_cache(0) <= "00100000000000110000000000000000";
        s_cache(1) <= "00100000000000010000000000000000";
        s_cache(2) <= "00100000000000100000000000000101";
        s_cache(3) <= "00000000001000100000100000100000";
        s_cache(4) <= "00100000010000101111111111111111";
        s_cache(5) <= "00010000010000110000000000000001";
        s_cache(6) <= "00001000000000000000000000000011";
        s_cache(7) <= "10101100000000010000000000000000";
        s_cache(8) <= "10001100000001000000000000000000";
        s_cache(9) <= "00110000100001000000000000001010";
        s_cache(10) <= "00110100100001000000000000000001";
        s_cache(11) <= "00111000100001000000000000001011";
        s_cache(12) <= "00111000100001000000000000000000";
        -- The rest are set to "00..00"
        for i in 13 to 31 loop 
            s_cache(i) <= (others => '0');
        end loop;
        
    end process;
    
    -- read from cache register specified by low_addr
    instr_out <= s_cache(to_integer(unsigned(low_addr)));
end arch_i_cache; -- arch_i_cache