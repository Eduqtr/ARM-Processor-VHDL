library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataMemory is
    Port (
        CLK : in STD_LOGIC;
        WE : in STD_LOGIC;
        A : in STD_LOGIC_VECTOR(31 downto 0);
        WD : in STD_LOGIC_VECTOR(31 downto 0);
        RD : out STD_LOGIC_VECTOR(31 downto 0)
    );
end DataMemory;

architecture Behavioral of DataMemory is
    -- 64 mots de 32 bits
    type ram_type is array (0 to 63) of STD_LOGIC_VECTOR(31 downto 0);
    
    -- Initialisation � 0
    signal memory : ram_type := (others => (others => '0'));
    
begin
    -- Lecture asynchrone (utilise seulement A[5:0])
    RD <= memory(to_integer(unsigned(A(5 downto 0))));
    
    -- �criture synchrone
    process(CLK)
    begin
        if rising_edge(CLK) then
            if WE = '1' then
                memory(to_integer(unsigned(A(5 downto 0)))) <= WD;
            end if;
        end if;
    end process;
    
end Behavioral;
