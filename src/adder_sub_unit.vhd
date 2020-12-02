library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder_sub is
port(
	x, y : in std_logic_vector(31 downto 0); -- 32 bit inputs
	sel : in std_logic; -- 0 for add; 1 for sub 
	output : out std_logic_vector(31 downto 0) -- 32 bit output
	);
end adder_sub;

architecture arch_adder_sub of adder_sub is
	signal local_sum, local_diff: std_logic_vector(31 downto 0); -- intermediate signed signals
begin
	local_sum <= std_logic_vector(signed(x) + signed(y)); -- verify type casting
	local_diff <= std_logic_vector(signed(x) - signed(y));
	output <= local_sum when sel = '0' else
			  local_diff;	
end arch_adder_sub;
