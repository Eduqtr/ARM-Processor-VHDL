library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MainDecoder_Extended is
    Port (
        Op : in STD_LOGIC_VECTOR(1 downto 0);
        Funct5 : in STD_LOGIC;
        Funct0 : in STD_LOGIC;
        Funct6 : in STD_LOGIC;  -- Bit 4 de Instr pour d�tecter shift
        Branch : out STD_LOGIC;
        MemtoReg : out STD_LOGIC;
        MemWrite : out STD_LOGIC;
        ALUSrc : out STD_LOGIC;
        ImmSrc : out STD_LOGIC_VECTOR(1 downto 0);
        RegWrite : out STD_LOGIC;
        RegSrc : out STD_LOGIC_VECTOR(1 downto 0);
        ALUOp : out STD_LOGIC;
        ShiftEn : out STD_LOGIC  -- Nouveau: active le shifter
    );
end MainDecoder_Extended;

architecture Behavioral of MainDecoder_Extended is
begin
    process(Op, Funct5, Funct0, Funct6)
    begin
        -- Valeurs par d�faut
        Branch <= '0';
        MemtoReg <= '0';
        MemWrite <= '0';
        ALUSrc <= '0';
        ImmSrc <= "00";
        RegWrite <= '0';
        RegSrc <= "00";
        ALUOp <= '0';
        ShiftEn <= '0';
        
        case Op is
            when "00" =>  -- Data Processing
                Branch <= '0';
                MemtoReg <= '0';
                MemWrite <= '0';
                RegWrite <= '1';
                
                if Funct5 = '0' then  -- DP Reg
                    ALUSrc <= '0';
                    ImmSrc <= "00";
                    RegSrc <= "00";
                    
                    -- D�tection du shift: bit 4 = 0 et bit 7 = 0
                    if Funct6 = '0' then
                        ShiftEn <= '1';  -- Active le shifter
                    end if;
                else  -- DP Imm
                    ALUSrc <= '1';
                    ImmSrc <= "00";
                    RegSrc <= "X0";
                end if;
                ALUOp <= '1';
                
            when "01" =>  -- Memory (LDR/STR)
                Branch <= '0';
                ALUSrc <= '1';
                ImmSrc <= "01";
                ALUOp <= '0';
                
                if Funct0 = '0' then  -- STR
                    MemtoReg <= '0';
                    MemWrite <= '1';
                    RegWrite <= '0';
                    RegSrc <= "10";
                else  -- LDR
                    MemtoReg <= '1';
                    MemWrite <= '0';
                    RegWrite <= '1';
                    RegSrc <= "X0";
                end if;
                
            when others =>
                -- Valeurs par d�faut
        end case;
    end process;
end Behavioral;
