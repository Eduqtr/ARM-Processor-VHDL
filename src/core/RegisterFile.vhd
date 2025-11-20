library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
    Port (
        CLK : in STD_LOGIC;
        WE3 : in STD_LOGIC;
        A1, A2, A3 : in STD_LOGIC_VECTOR(3 downto 0);
        WD3 : in STD_LOGIC_VECTOR(31 downto 0);
        R15 : in STD_LOGIC_VECTOR(31 downto 0);
        RD1, RD2 : out STD_LOGIC_VECTOR(31 downto 0)
    );
end RegisterFile;

architecture Behavioral of RegisterFile is
    -- Type pour la RAM
    type ram_type is array (0 to 15) of STD_LOGIC_VECTOR(31 downto 0);
    
    -- Initialisation � 0 de tous les registres
    signal registers : ram_type := (others => (others => '0'));
    
begin
    -- Lecture asynchrone des registres
    process(A1, A2, R15, registers)
    begin
        -- Lecture du registre source 1
        if A1 = "1111" then
            RD1 <= R15;  -- R15 sp�cial (PC+8)
        else
            RD1 <= registers(to_integer(unsigned(A1)));
        end if;
        
        -- Lecture du registre source 2
        if A2 = "1111" then
            RD2 <= R15;  -- R15 sp�cial (PC+8)
        else
            RD2 <= registers(to_integer(unsigned(A2)));
        end if;
    end process;
    
    -- �criture synchrone
    process(CLK)
    begin
        if rising_edge(CLK) then
            if WE3 = '1' then
                if A3 /= "1111" then  -- Ne pas �crire dans R15
                    registers(to_integer(unsigned(A3))) <= WD3;
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;
