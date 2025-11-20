library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Shifter is
    Port (
        Sh : in STD_LOGIC_VECTOR(1 downto 0);   -- Type de shift
        Shamt5 : in STD_LOGIC_VECTOR(4 downto 0);  -- Montant du shift
        ShIn : in STD_LOGIC_VECTOR(31 downto 0);   -- Entr�e
        ShOut : out STD_LOGIC_VECTOR(31 downto 0)  -- Sortie
    );
end Shifter;

architecture Behavioral of Shifter is
begin
    process(Sh, Shamt5, ShIn)
        variable shift_amount : integer;
    begin
        shift_amount := to_integer(unsigned(Shamt5));
        
        case Sh is
            when "00" =>  -- LSL (Logical Shift Left)
                ShOut <= std_logic_vector(shift_left(unsigned(ShIn), shift_amount));
                
            when "01" =>  -- LSR (Logical Shift Right)
                ShOut <= std_logic_vector(shift_right(unsigned(ShIn), shift_amount));
                
            when "10" =>  -- ASR (Arithmetic Shift Right)
                ShOut <= std_logic_vector(shift_right(signed(ShIn), shift_amount));
                
            when "11" =>  -- ROR (Rotate Right) - bonus
                ShOut <= std_logic_vector(rotate_right(unsigned(ShIn), shift_amount));
                
            when others =>
                ShOut <= ShIn;
        end case;
    end process;
end Behavioral;
