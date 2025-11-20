library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux2 is
    generic (WIDTH : integer := 32);
    Port (
        d0, d1 : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        sel : in STD_LOGIC;
        y : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
end mux2;

architecture Behavioral of mux2 is
begin
    y <= d1 when sel = '1' else d0;
end Behavioral;
