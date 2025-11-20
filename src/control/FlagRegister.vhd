library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FlagRegister is
    Port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;  -- Reset asynchrone
        FlagWrite : in STD_LOGIC_VECTOR(1 downto 0);
        ALUFlags : in STD_LOGIC_VECTOR(3 downto 0);
        CondEx : in STD_LOGIC;
        Flags : out STD_LOGIC_VECTOR(3 downto 0)
    );
end FlagRegister;

architecture Behavioral of FlagRegister is
    signal flags_reg : STD_LOGIC_VECTOR(3 downto 0);
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            -- Reset asynchrone: tous les flags � 0
            flags_reg <= (others => '0');
        elsif rising_edge(CLK) then
            -- Mise � jour conditionnelle des flags
            -- FlagWrite[1] contr�le N et Z (bits 3:2)
            if FlagWrite(1) = '1' and CondEx = '1' then
                flags_reg(3 downto 2) <= ALUFlags(3 downto 2);
            end if;
            
            -- FlagWrite[0] contr�le C et V (bits 1:0)
            if FlagWrite(0) = '1' and CondEx = '1' then
                flags_reg(1 downto 0) <= ALUFlags(1 downto 0);
            end if;
        end if;
    end process;
    
    Flags <= flags_reg;
end Behavioral;
