library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CondCheck is
    Port (
        Cond : in STD_LOGIC_VECTOR(3 downto 0);
        Flags : in STD_LOGIC_VECTOR(3 downto 0);
        CondEx : out STD_LOGIC
    );
end CondCheck;

architecture Behavioral of CondCheck is
    signal N, Z, C, V : STD_LOGIC;
begin
    -- Extraction des flags
    N <= Flags(3);  -- Negative
    Z <= Flags(2);  -- Zero
    C <= Flags(1);  -- Carry
    V <= Flags(0);  -- Overflow
    
    -- Logique conditionnelle selon le tableau 1
    process(Cond, N, Z, C, V)
    begin
        case Cond is
            when "0000" =>  -- EQ: Z
                CondEx <= Z;
                
            when "0001" =>  -- NE: NOT Z
                CondEx <= not Z;
                
            when "0010" =>  -- CS/HS: C
                CondEx <= C;
                
            when "0011" =>  -- CC/LO: NOT C
                CondEx <= not C;
                
            when "0100" =>  -- MI: N
                CondEx <= N;
                
            when "0101" =>  -- PL: NOT N
                CondEx <= not N;
                
            when "0110" =>  -- VS: V
                CondEx <= V;
                
            when "0111" =>  -- VC: NOT V
                CondEx <= not V;
                
            when "1000" =>  -- HI: C AND NOT Z
                CondEx <= C and (not Z);
                
            when "1001" =>  -- LS: NOT C OR Z
                CondEx <= (not C) or Z;
                
            when "1010" =>  -- GE: N XNOR V
                CondEx <= not (N xor V);
                
            when "1011" =>  -- LT: N XOR V
                CondEx <= N xor V;
                
            when "1100" =>  -- GT: NOT Z AND (N XNOR V)
                CondEx <= (not Z) and (not (N xor V));
                
            when "1101" =>  -- LE: Z OR (N XOR V)
                CondEx <= Z or (N xor V);
                
            when "1110" =>  -- AL: Always
                CondEx <= '1';
                
            when others =>
                CondEx <= '1';
        end case;
    end process;
end Behavioral;
