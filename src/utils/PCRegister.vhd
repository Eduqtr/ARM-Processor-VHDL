library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PCRegister is
    Port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        PCNext : in STD_LOGIC_VECTOR(31 downto 0);
        PC : out STD_LOGIC_VECTOR(31 downto 0)
    );
end PCRegister;

architecture Behavioral of PCRegister is
    signal pc_reg : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            -- Reset asynchrone: PC � 0
            pc_reg <= (others => '0');
        elsif rising_edge(CLK) then
            pc_reg <= PCNext;
        end if;
    end process;
    
    PC <= pc_reg;
end Behavioral;
