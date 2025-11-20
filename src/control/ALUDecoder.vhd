library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALUDecoder_Extended is
    Port (
        ALUOp : in STD_LOGIC;
        Funct : in STD_LOGIC_VECTOR(4 downto 0);
        ALUControl : out STD_LOGIC_VECTOR(1 downto 0);
        FlagW : out STD_LOGIC_VECTOR(1 downto 0);
        NoRegWrite : out STD_LOGIC  -- Nouveau signal pour CMP
    );
end ALUDecoder_Extended;

architecture Behavioral of ALUDecoder_Extended is
    signal cmd : STD_LOGIC_VECTOR(3 downto 0);
    signal S : STD_LOGIC;
begin
    cmd <= Funct(4 downto 1);
    S <= Funct(0);
    
    process(ALUOp, cmd, S)
    begin
        NoRegWrite <= '0';  -- Par d�faut, �criture autoris�e
        
        if ALUOp = '0' then
            -- Not Data Processing
            ALUControl <= "00";  -- ADD
            FlagW <= "00";
        else
            -- Data Processing
            case cmd is
                when "0100" =>  -- ADD
                    ALUControl <= "00";
                    if S = '1' then
                        FlagW <= "11";
                    else
                        FlagW <= "00";
                    end if;
                    
                when "0010" =>  -- SUB
                    ALUControl <= "01";
                    if S = '1' then
                        FlagW <= "11";
                    else
                        FlagW <= "00";
                    end if;
                    
                when "0000" =>  -- AND
                    ALUControl <= "10";
                    if S = '1' then
                        FlagW <= "10";
                    else
                        FlagW <= "00";
                    end if;
                    
                when "1100" =>  -- ORR
                    ALUControl <= "11";
                    if S = '1' then
                        FlagW <= "10";
                    else
                        FlagW <= "00";
                    end if;
                
                when "1010" =>  -- CMP (Compare) - Nouveau!
                    ALUControl <= "01";  -- Soustraction
                    FlagW <= "11";       -- Toujours mettre � jour les flags
                    NoRegWrite <= '1';   -- Ne pas �crire dans le registre
                    
                when others =>
                    ALUControl <= "00";
                    FlagW <= "00";
            end case;
        end if;
    end process;
end Behavioral;
