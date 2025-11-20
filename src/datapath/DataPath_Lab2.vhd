library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataPath_Extended is
    Port (
        CLK : in STD_LOGIC;
        RegSrc : in STD_LOGIC_VECTOR(1 downto 0);
        RegWrite : in STD_LOGIC;
        ImmSrc : in STD_LOGIC_VECTOR(1 downto 0);
        ALUSrc : in STD_LOGIC;
        ALUControl : in STD_LOGIC_VECTOR(1 downto 0);
        MemWrite : in STD_LOGIC;
        MemtoReg : in STD_LOGIC;
        ShiftEn : in STD_LOGIC;
        NoRegWrite : in STD_LOGIC;
        Instr : in STD_LOGIC_VECTOR(31 downto 0);
        ALUFlags : out STD_LOGIC_VECTOR(3 downto 0);
        Result : out STD_LOGIC_VECTOR(31 downto 0);
        -- Sorties pour debugging
        ALUResult_out : out STD_LOGIC_VECTOR(31 downto 0);
        RD2_out : out STD_LOGIC_VECTOR(31 downto 0);
        ReadData_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end DataPath_Extended;

architecture Behavioral of DataPath_Extended is
    component RegisterFile
        Port (
            CLK : in STD_LOGIC;
            WE3 : in STD_LOGIC;
            A1, A2, A3 : in STD_LOGIC_VECTOR(3 downto 0);
            WD3 : in STD_LOGIC_VECTOR(31 downto 0);
            R15 : in STD_LOGIC_VECTOR(31 downto 0);
            RD1, RD2 : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component Extend
        Port (
            Instr : in STD_LOGIC_VECTOR(23 downto 0);
            ImmSrc : in STD_LOGIC_VECTOR(1 downto 0);
            ExtImm : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component DataMemory
        Port (
            CLK : in STD_LOGIC;
            WE : in STD_LOGIC;
            A : in STD_LOGIC_VECTOR(31 downto 0);
            WD : in STD_LOGIC_VECTOR(31 downto 0);
            RD : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component ALU
        Port (
            A, B : in STD_LOGIC_VECTOR(31 downto 0);
            ALUControl : in STD_LOGIC_VECTOR(1 downto 0);
            Result : out STD_LOGIC_VECTOR(31 downto 0);
            ALUFlags : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
    component Shifter
        Port (
            Sh : in STD_LOGIC_VECTOR(1 downto 0);
            Shamt5 : in STD_LOGIC_VECTOR(4 downto 0);
            ShIn : in STD_LOGIC_VECTOR(31 downto 0);
            ShOut : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component mux2
        generic (WIDTH : integer := 32);
        Port (
            d0, d1 : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
            sel : in STD_LOGIC;
            y : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
        );
    end component;
    
    -- Signaux internes
    signal RA1, RA2 : STD_LOGIC_VECTOR(3 downto 0);
    signal RD1, RD2 : STD_LOGIC_VECTOR(31 downto 0);
    signal RD2_shifted : STD_LOGIC_VECTOR(31 downto 0);
    signal RD2_final : STD_LOGIC_VECTOR(31 downto 0);
    signal ExtImm : STD_LOGIC_VECTOR(31 downto 0);
    signal SrcB : STD_LOGIC_VECTOR(31 downto 0);
    signal ALUResult : STD_LOGIC_VECTOR(31 downto 0);
    signal ReadData : STD_LOGIC_VECTOR(31 downto 0);
    signal Result_internal : STD_LOGIC_VECTOR(31 downto 0);
    signal R15 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal RegWrite_final : STD_LOGIC;
    
begin
    -- Multiplexeurs pour s�lection des registres
    RA1_MUX: mux2 generic map(WIDTH => 4)
        port map(d0 => Instr(19 downto 16), d1 => "1111", 
                 sel => RegSrc(0), y => RA1);
    
    RA2_MUX: mux2 generic map(WIDTH => 4)
        port map(d0 => Instr(3 downto 0), d1 => Instr(15 downto 12), 
                 sel => RegSrc(1), y => RA2);
    
    -- Register File avec RegWrite conditionnel (pour CMP)
    RegWrite_final <= RegWrite and (not NoRegWrite);
    
    RF: RegisterFile port map(
        CLK => CLK,
        WE3 => RegWrite_final,
        A1 => RA1,
        A2 => RA2,
        A3 => Instr(15 downto 12),
        WD3 => Result_internal,
        R15 => R15,
        RD1 => RD1,
        RD2 => RD2
    );
    
    -- Shifter
    SHIFT: Shifter port map(
        Sh => Instr(6 downto 5),
        Shamt5 => Instr(11 downto 7),
        ShIn => RD2,
        ShOut => RD2_shifted
    );
    
    -- Multiplexeur pour RD2 shift� ou non
    SHIFT_MUX: mux2 port map(
        d0 => RD2,
        d1 => RD2_shifted,
        sel => ShiftEn,
        y => RD2_final
    );
    
    -- Extend
    EXT: Extend port map(
        Instr => Instr(23 downto 0),
        ImmSrc => ImmSrc,
        ExtImm => ExtImm
    );
    
    -- Multiplexeur pour SrcB
    SRCB_MUX: mux2 port map(
        d0 => RD2_final,
        d1 => ExtImm,
        sel => ALUSrc,
        y => SrcB
    );
    
    -- ALU
    ALU_INST: ALU port map(
        A => RD1,
        B => SrcB,
        ALUControl => ALUControl,
        Result => ALUResult,
        ALUFlags => ALUFlags
    );
    
    -- Data Memory
    DMEM: DataMemory port map(
        CLK => CLK,
        WE => MemWrite,
        A => ALUResult,
        WD => RD2,
        RD => ReadData
    );
    
    -- Multiplexeur pour Result
    RESULT_MUX: mux2 port map(
        d0 => ALUResult,
        d1 => ReadData,
        sel => MemtoReg,
        y => Result_internal
    );
    
    -- Sorties
    Result <= Result_internal;
    ALUResult_out <= ALUResult;
    RD2_out <= RD2;
    ReadData_out <= ReadData;
    
end Behavioral;
