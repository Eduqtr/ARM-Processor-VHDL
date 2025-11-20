library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux4_32bit is
    Port (
        d0, d1, d2, d3 : in STD_LOGIC_VECTOR(31 downto 0);
        sel : in STD_LOGIC_VECTOR(1 downto 0);
        y : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mux4_32bit;

architecture Behavioral of mux4_32bit is
begin
    with sel select y <=
        d0 when "00",
        d1 when "01",
        d2 when "10",
        d3 when "11",
        (others => '0') when others;
end Behavioral;
