library IEEE;
use IEEE.std_logic_1164.all;

entity logic is
port(
	x, y : in std_logic_vector(31 downto 0); -- 32 bit inputs
	sel : in std_logic_vector(1 downto 0);
	output : out std_logic_vector(31 downto 0)  -- 32 bit output
	);
end logic ;

architecture arch_logic of logic is
begin
with sel select
	output <= (x and y) when "00",
			  (x or y) when "01",
			  (x xor y) when "10",
			  (x nor y) when others;
end arch_logic;