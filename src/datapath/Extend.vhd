library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Extend is
    Port (
        Instr : in STD_LOGIC_VECTOR(23 downto 0);
        ImmSrc : in STD_LOGIC_VECTOR(1 downto 0);
        ExtImm : out STD_LOGIC_VECTOR(31 downto 0)
    );
end Extend;

architecture Behavioral of Extend is
begin
    process(Instr, ImmSrc)
    begin
        case ImmSrc is
            when "00" =>  -- Imm8: 24 z�ros + 8 LSB
                ExtImm <= X"000000" & Instr(7 downto 0);
                
            when "01" =>  -- Imm12: 20 z�ros + 12 LSB
                ExtImm <= X"00000" & Instr(11 downto 0);
                
            when "10" =>  -- Imm24 (branch): 8 z�ros + 24 bits
                ExtImm <= X"00" & Instr(23 downto 0);
                
            when others =>
                ExtImm <= (others => '0');
        end case;
    end process;
end Behavioral;
