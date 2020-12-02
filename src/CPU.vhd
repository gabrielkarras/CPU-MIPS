--************************************************************************************************************
--
-- Author: Gabriel Karras
-- 
-- File: CPU.vhd
--
-- Design Units:
--	Ports: 
--      rs_out : 32-bit source register output from the register file
--      rt_out : 32-bit target register output from the register file 
--      pc_out : 32-bit current PC address outpu from the PC register
--      overflow : 1-bit overflow flag output
--      zero : 1-bit zero flag output
--      clk : System clock
--      reset : Asynchronous system reset
--
--	Architecture:
--		Port Maps:
--          ALU : 32-bit ALU with arithmetic, logical, slt(set less than) and lui(load upper immediate) operations
--          reg_file : 32 x 32 Register file(holds data for registers R0-R31)
--          next_addr_unit : Provides the next PC address
--          i_cache : ROM storage that holds the instructions of the program
--          d_cache : RAM storage that holds data
--          pc_reg : Holds current PC address
--          sign_extend_unit : Provides sign-extension or padding capabilities for the target address for 
--                             I-format instructions(immediate instructions)
--          control_unit : Manages all the control, read and write signals throughout the CPU
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
-- 	Version: 1.1
-- 	Date: 25 Nov 2020
-- 	Comments: Connect every component(ALU, register file, pc register, instruction cache, data cache,
--            next address unit, sign extend unit, control unit)
--************************************************************************************************************ 

library IEEE;
use IEEE.std_logic_1164.all;

entity cpu_v2 is 
port(
    clk : in std_logic;
    reset : in std_logic;
    rs_out, rt_out, pc_out : out std_logic_vector(31 downto 0);
    overflow : out std_logic;
	zero : out std_logic
);
end cpu_v2;


architecture arch_cpu_v2 of cpu_v2 is
-- Component Declaration
-- PC Register
component pc_reg
port(
    pc_in: in std_logic_vector(31 downto 0);
    clk : in std_logic;
    reset : in std_logic;
    pc_out : out std_logic_vector(31 downto 0)
);
end component;

-- Instruction cache
component i_cache
port(
    low_addr : in std_logic_vector(4 downto 0);
    instr_out : out std_logic_vector(31 downto 0)
);
end component;

-- Next Address Unit
component next_address
port(
    rt, rs : in std_logic_vector(31 downto 0);
    pc : in std_logic_vector(31 downto 0);
    target_address : in std_logic_vector(25 downto 0);
    branch_type : in std_logic_vector(1 downto 0);
    pc_sel : in std_logic_vector(1 downto 0);
    next_pc : out std_logic_vector(31 downto 0)    
);
end component;

-- Register File
component regfile
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
end component;

-- Sign-Extension Unit
component sign_extend
port(
    ta_in : in std_logic_vector(15 downto 0);
    func : in std_logic_vector(1 downto 0);
    ext_out : out std_logic_vector(31 downto 0)
);
end component;

-- ALU
component alu 
port(
    x, y : in std_logic_vector(31 downto 0);
	add_sub : in std_logic ;
	logic_func : in std_logic_vector(1 downto 0 );
	func : in std_logic_vector(1 downto 0 );
	output : out std_logic_vector(31 downto 0);
	overf : out std_logic;
    zero : out std_logic
);
end component;

-- Data cache
component d_cache
port( 
    din : in std_logic_vector(31 downto 0);
    addr : in std_logic_vector(4 downto 0);
    data_write : in std_logic;
    reset : in std_logic;
    clk : in std_logic;
    d_out : out std_logic_vector(31 downto 0)
);
end component;

-- Control unit
component control_unit
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
end component;
-- End of Component Declaration

-- Component configuration specification
for U1 : pc_reg use entity WORK.pc_reg(arch_pc_reg);
for U2 : i_cache use entity WORK.i_cache(arch_i_cache);
for U3 : next_address use entity WORK.next_address(arch_next_address);
for U4 : regfile use entity WORK.regfile(arch_regfile);
for U5 : alu use entity WORK.alu(arch_alu);
for U6 : d_cache use entity WORK.d_cache(arch_d_cache);
for U7 : sign_extend use entity WORK.sign_extend(arch_sign_extend);
for U8 : control_unit use entity WORK.control_unit(arch_control_unit);

-- Signal declaration
signal s_nextpc, s_pc_out, s_icache_out, s_regf_rs, s_regf_rt, s_regf_din: std_logic_vector(31 downto 0);
signal s_alu_out, s_dcache_out, s_alu_yin, s_ext_out: std_logic_vector(31 downto 0);
signal s_ta_in : std_logic_vector(15 downto 0);
signal s_nextaddr_ta : std_logic_vector(25 downto 0);
signal s_opcode_in, s_func_in : std_logic_vector(5 downto 0);
signal s_pc_out_addr, s_icache_out_rs, s_icache_out_rt, s_icache_out_rd: std_logic_vector(4 downto 0);
signal s_dcache_in, s_regf_in_addr: std_logic_vector(4 downto 0);
signal s_pc_sel, s_branch_type, s_logic_func, s_func : std_logic_vector(1 downto 0);
signal s_reg_write, s_reg_dest, s_reg_in_src, s_alu_src, s_add_sub, s_data_write : std_logic;
   
begin

-- PC
U1: pc_reg port map(pc_in => s_nextpc, clk => clk, reset => reset, pc_out => s_pc_out );

--I-cache
s_pc_out_addr <= s_pc_out(4 downto 0);
U2: i_cache port map(low_addr => s_pc_out_addr, instr_out => s_icache_out);

-- Next address
s_nextaddr_ta <= s_icache_out(25 downto 0);
U3: next_address port map(rt => s_regf_rt, rs => s_regf_rs, pc => s_pc_out, target_address => s_nextaddr_ta,
                          branch_type => s_branch_type, pc_sel => s_pc_sel, next_pc => s_nextpc);

-- Register file
s_icache_out_rs <= s_icache_out(25 downto 21); -- instruction output[25-21]-> address location for source register
s_icache_out_rt <= s_icache_out(20 downto 16); -- instruction output[20-16]-> address location for target register
s_icache_out_rd <= s_icache_out(15 downto 11); -- instruction output[15-21]-> address location for destination register

-- Select between target register(rt) or destination register(rd)
s_regf_in_addr <= s_icache_out_rd when (s_reg_dest = '1') else -- choose to write to destination register
                  s_icache_out_rt; -- choose to write to target register

-- Select between which result will be written in register file
-- Between read data from the data cache or operation result output from the ALU
s_regf_din <= s_dcache_out when (s_reg_in_src = '0') else -- choose to write read data from data cache
              s_alu_out; -- choose to write result from ALU

U4: regfile port map(din => s_regf_din, reset => reset, clk => clk, write => s_reg_write, read_a => s_icache_out_rs,
                     read_b => s_icache_out_rt, write_address => s_regf_in_addr, out_a => s_regf_rs, out_b => s_regf_rt);

-- ALU
-- Select between target register(rt) or sign-extended target address(ta)
s_alu_yin <= s_regf_rt when (s_alu_src = '0') else -- choose target register for arithmetic or logical ops
             s_ext_out; -- choose sign-extended target address for branching instructions

U5: alu port map(x => s_regf_rs, y => s_alu_yin, add_sub => s_add_sub, logic_func => s_logic_func, func => s_func, output => s_alu_out,
                 overf => overflow, zero => zero);

-- D-cache
s_dcache_in <= s_alu_out(4 downto 0);
U6: d_cache port map(din => s_regf_rt, addr => s_dcache_in, data_write => s_data_write, reset => reset, clk => clk,
                     d_out => s_dcache_out);

-- Sign extend
s_ta_in <= s_icache_out(15 downto 0); -- instruction output[15-0]-> target address for conditional/unconditional branching instructions
U7: sign_extend port map(ta_in => s_ta_in, func => s_func, ext_out => s_ext_out);

-- Control unit
s_opcode_in <= s_icache_out(31 downto 26); -- opcode bits from higher-order 6-bits from instruction
s_func_in <= s_icache_out(5 downto 0); -- function bits from lower-order 6-bits from instruction(for R-format instructions)
U8: control_unit port map(opcode => s_opcode_in, func_in => s_func_in, reg_write => s_reg_write, reg_dest => s_reg_dest, 
                          reg_in_src => s_reg_in_src, alu_src => s_alu_src, add_sub => s_add_sub, data_write => s_data_write, 
                          logic_func => s_logic_func, func_out => s_func, branch_type => s_branch_type, pc_sel => s_pc_sel);

-- Configuring system outputs
rs_out <= s_regf_rs; -- source register output
rt_out <= s_regf_rt; -- target register output
pc_out <= s_pc_out; -- PC register output

end arch_cpu_v2; -- arch_cpu_v2