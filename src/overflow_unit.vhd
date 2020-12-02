library IEEE;
use IEEE.std_logic_1164.all;

entity overflow is
port(
	x, y, r : in std_logic_vector(31 downto 0);  -- 32 bit inputs
	sel : in std_logic; -- 0 for add op overflow detection; 1 for sub op overflow detection
	overflow : out std_logic -- set(1) if overflow, otherwise no set(0)
	);
end overflow;

architecture arch_overflow of overflow is
	signal local_addovf, local_subovf : std_logic;
begin
	local_addovf <= ( x(31) and y(31) ) xor r(31); -- verify
	local_subovf <= ( r(31) and y(31) ) xor x(31);
	overflow <= local_addovf when sel = '0' else
			  local_subovf;
end arch_overflow;
