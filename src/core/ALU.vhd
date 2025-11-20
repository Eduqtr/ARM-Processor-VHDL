library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        A, B : in STD_LOGIC_VECTOR(31 downto 0);
        ALUControl : in STD_LOGIC_VECTOR(1 downto 0);
        Result : out STD_LOGIC_VECTOR(31 downto 0);
        ALUFlags : out STD_LOGIC_VECTOR(3 downto 0)  -- [3]=N, [2]=Z, [1]=C, [0]=V
    );
end ALU;

architecture Behavioral of ALU is
    -- Déclaration des composants
    component adder32
        Port (
            a, b : in STD_LOGIC_VECTOR(31 downto 0);
            cin : in STD_LOGIC;
            sum : out STD_LOGIC_VECTOR(31 downto 0);
            cout : out STD_LOGIC
        );
    end component;
    
    component mux4_32bit
        Port (
            d0, d1, d2, d3 : in STD_LOGIC_VECTOR(31 downto 0);
            sel : in STD_LOGIC_VECTOR(1 downto 0);
            y : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    -- Signaux internes
    signal B_inverted : STD_LOGIC_VECTOR(31 downto 0);
    signal sum_result : STD_LOGIC_VECTOR(31 downto 0);
    signal and_result : STD_LOGIC_VECTOR(31 downto 0);
    signal or_result : STD_LOGIC_VECTOR(31 downto 0);
    signal result_internal : STD_LOGIC_VECTOR(31 downto 0);
    signal carry_out : STD_LOGIC;
    signal carry_in : STD_LOGIC;
    
    -- Flags
    signal flag_negative : STD_LOGIC;
    signal flag_zero : STD_LOGIC;
    signal flag_carry : STD_LOGIC;
    signal flag_overflow : STD_LOGIC;
    
begin
    -- Inversion de B pour soustraction
    carry_in <= ALUControl(0);  -- 0 pour ADD, 1 pour SUB
    B_inverted <= not B when ALUControl(0) = '1' else B;
    
    -- Additionneur
    ADDER: adder32 port map(
        a => A,
        b => B_inverted,
        cin => carry_in,
        sum => sum_result,
        cout => carry_out
    );
    
    -- Opérations logiques
    and_result <= A and B;
    or_result <= A or B;
    
    -- Multiplexeur de sélection d'opération
    MUX: mux4_32bit port map(
        d0 => sum_result,  -- 00: ADD
        d1 => sum_result,  -- 01: SUB
        d2 => and_result,  -- 10: AND
        d3 => or_result,   -- 11: ORR
        sel => ALUControl,
        y => result_internal
    );
    
    Result <= result_internal;
    
    -- ========================================
    -- CALCUL DES FLAGS
    -- ========================================
    
    -- Flag N (Negative): bit de signe du résultat
    flag_negative <= result_internal(31);
    
    -- Flag Z (Zero): résultat = 0
    flag_zero <= '1' when result_internal = X"00000000" else '0';
    
    -- Flag C (Carry): carry out pour ADD/SUB uniquement
    flag_carry <= carry_out when ALUControl(1) = '0' else '0';
    
    -- Flag V (Overflow): débordement signé pour ADD/SUB
    -- Overflow si: (A[31] == B[31]) && (Result[31] != A[31])
    flag_overflow <= (A(31) and B_inverted(31) and not result_internal(31)) or
                     (not A(31) and not B_inverted(31) and result_internal(31))
                     when ALUControl(1) = '0' else '0';
    
    -- Sortie des flags: N Z C V
    ALUFlags <= flag_negative & flag_zero & flag_carry & flag_overflow;
    
end Behavioral;
