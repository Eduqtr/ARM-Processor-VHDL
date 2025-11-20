library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ARM_Complete is
    Port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        PC : out STD_LOGIC_VECTOR(31 downto 0);
        Instr : out STD_LOGIC_VECTOR(31 downto 0);
        ALUResult : out STD_LOGIC_VECTOR(31 downto 0);
        WriteData : out STD_LOGIC_VECTOR(31 downto 0);
        ReadData : out STD_LOGIC_VECTOR(31 downto 0)
    );
end ARM_Complete;

architecture Behavioral of ARM_Complete is
    component InstructionMemory
        Port (
            A : in STD_LOGIC_VECTOR(31 downto 0);
            RD : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component PCRegister
        Port (
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            PCNext : in STD_LOGIC_VECTOR(31 downto 0);
            PC : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component adder
        port(a, b: in STD_LOGIC_VECTOR(31 downto 0);
             y: out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    
    component ControlUnit_Extended
        Port (
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            Instr : in STD_LOGIC_VECTOR(31 downto 0);
            ALUFlags : in STD_LOGIC_VECTOR(3 downto 0);
            PCSrc : out STD_LOGIC;
            MemtoReg : out STD_LOGIC;
            MemWrite : out STD_LOGIC;
            ALUSrc : out STD_LOGIC;
            ImmSrc : out STD_LOGIC_VECTOR(1 downto 0);
            RegWrite : out STD_LOGIC;
            RegSrc : out STD_LOGIC_VECTOR(1 downto 0);
            ALUControl : out STD_LOGIC_VECTOR(1 downto 0);
            ShiftEn : out STD_LOGIC;
            NoRegWrite : out STD_LOGIC
        );
    end component;
    
    component DataPath_Extended
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
            ALUResult_out : out STD_LOGIC_VECTOR(31 downto 0);
            RD2_out : out STD_LOGIC_VECTOR(31 downto 0);
            ReadData_out : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    -- Signaux internes
    signal PC_internal, PCPlus4, PCPlus8, PCNext : STD_LOGIC_VECTOR(31 downto 0);
    signal Instr_internal : STD_LOGIC_VECTOR(31 downto 0);
    signal PCSrc : STD_LOGIC;
    signal RegSrc : STD_LOGIC_VECTOR(1 downto 0);
    signal RegWrite : STD_LOGIC;
    signal ImmSrc : STD_LOGIC_VECTOR(1 downto 0);
    signal ALUSrc : STD_LOGIC;
    signal ALUControl : STD_LOGIC_VECTOR(1 downto 0);
    signal MemWrite : STD_LOGIC;
    signal MemtoReg : STD_LOGIC;
    signal ShiftEn : STD_LOGIC;
    signal NoRegWrite : STD_LOGIC;
    signal ALUFlags : STD_LOGIC_VECTOR(3 downto 0);
    signal Result : STD_LOGIC_VECTOR(31 downto 0);
    signal ALUResult_internal : STD_LOGIC_VECTOR(31 downto 0);
    signal RD2_internal : STD_LOGIC_VECTOR(31 downto 0);
    signal ReadData_internal : STD_LOGIC_VECTOR(31 downto 0);
    
begin
    -- PC Register
    PCREG: PCRegister port map(
        CLK => CLK,
        RST => RST,
        PCNext => PCNext,
        PC => PC_internal
    );
    
    -- Instruction Memory
    IMEM: InstructionMemory port map(
        A => PC_internal,
        RD => Instr_internal
    );
    
    -- PC + 4
    PCADD1: adder port map(
        a => PC_internal,
        b => X"00000004",
        y => PCPlus4
    );
    
    -- PC + 8
    PCADD2: adder port map(
        a => PCPlus4,
        b => X"00000004",
        y => PCPlus8
    );
    
    PCNext <= PCPlus4;
    
    -- Control Unit Extended
    CU: ControlUnit_Extended port map(
        CLK => CLK,
        RST => RST,
        Instr => Instr_internal,
        ALUFlags => ALUFlags,
        PCSrc => PCSrc,
        MemtoReg => MemtoReg,
        MemWrite => MemWrite,
        ALUSrc => ALUSrc,
        ImmSrc => ImmSrc,
        RegWrite => RegWrite,
        RegSrc => RegSrc,
        ALUControl => ALUControl,
        ShiftEn => ShiftEn,
        NoRegWrite => NoRegWrite
    );
    
    -- DataPath Extended
    DP: DataPath_Extended port map(
        CLK => CLK,
        RegSrc => RegSrc,
        RegWrite => RegWrite,
        ImmSrc => ImmSrc,
        ALUSrc => ALUSrc,
        ALUControl => ALUControl,
        MemWrite => MemWrite,
        MemtoReg => MemtoReg,
        ShiftEn => ShiftEn,
        NoRegWrite => NoRegWrite,
        Instr => Instr_internal,
        ALUFlags => ALUFlags,
        Result => Result,
        ALUResult_out => ALUResult_internal,
        RD2_out => RD2_internal,
        ReadData_out => ReadData_internal
    );
    
    -- Sorties
    PC <= PC_internal;
    Instr <= Instr_internal;
    ALUResult <= ALUResult_internal;
    WriteData <= RD2_internal;
    ReadData <= ReadData_internal;
    
end Behavioral;
