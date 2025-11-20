library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder32 is
    Port (
        a, b : in STD_LOGIC_VECTOR(31 downto 0);
        cin : in STD_LOGIC;
        sum : out STD_LOGIC_VECTOR(31 downto 0);
        cout : out STD_LOGIC
    );
end adder32;

architecture Behavioral of adder32 is
    signal carry : STD_LOGIC_VECTOR(32 downto 0);
begin
    carry(0) <= cin;
    
    gen_adder: for i in 0 to 31 generate
        sum(i) <= a(i) xor b(i) xor carry(i);
        carry(i+1) <= (a(i) and b(i)) or (carry(i) and (a(i) xor b(i)));
    end generate;
    
    cout <= carry(32);
end Behavioral;
