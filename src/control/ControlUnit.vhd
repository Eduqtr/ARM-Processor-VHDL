library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit_Extended is
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
end ControlUnit_Extended;

architecture Behavioral of ControlUnit_Extended is
    component MainDecoder_Extended
        Port (
            Op : in STD_LOGIC_VECTOR(1 downto 0);
            Funct5 : in STD_LOGIC;
            Funct0 : in STD_LOGIC;
            Funct6 : in STD_LOGIC;
            Branch : out STD_LOGIC;
            MemtoReg : out STD_LOGIC;
            MemWrite : out STD_LOGIC;
            ALUSrc : out STD_LOGIC;
            ImmSrc : out STD_LOGIC_VECTOR(1 downto 0);
            RegWrite : out STD_LOGIC;
            RegSrc : out STD_LOGIC_VECTOR(1 downto 0);
            ALUOp : out STD_LOGIC;
            ShiftEn : out STD_LOGIC
        );
    end component;
    
    component ALUDecoder_Extended
        Port (
            ALUOp : in STD_LOGIC;
            Funct : in STD_LOGIC_VECTOR(4 downto 0);
            ALUControl : out STD_LOGIC_VECTOR(1 downto 0);
            FlagW : out STD_LOGIC_VECTOR(1 downto 0);
            NoRegWrite : out STD_LOGIC
        );
    end component;
    
    component FlagRegister
        Port (
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            FlagWrite : in STD_LOGIC_VECTOR(1 downto 0);
            ALUFlags : in STD_LOGIC_VECTOR(3 downto 0);
            CondEx : in STD_LOGIC;
            Flags : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
    component CondCheck
        Port (
            Cond : in STD_LOGIC_VECTOR(3 downto 0);
            Flags : in STD_LOGIC_VECTOR(3 downto 0);
            CondEx : out STD_LOGIC
        );
    end component;
    
    signal Branch, CondEx, ALUOp : STD_LOGIC;
    signal FlagW : STD_LOGIC_VECTOR(1 downto 0);
    signal Flags : STD_LOGIC_VECTOR(3 downto 0);
    signal RegWrite_internal, MemWrite_internal : STD_LOGIC;
    
begin
    -- Main Decoder
    MD: MainDecoder_Extended port map(
        Op => Instr(27 downto 26),
        Funct5 => Instr(25),
        Funct0 => Instr(20),
        Funct6 => Instr(4),
        Branch => Branch,
        MemtoReg => MemtoReg,
        MemWrite => MemWrite_internal,
        ALUSrc => ALUSrc,
        ImmSrc => ImmSrc,
        RegWrite => RegWrite_internal,
        RegSrc => RegSrc,
        ALUOp => ALUOp,
        ShiftEn => ShiftEn
    );
    
    -- ALU Decoder
    AD: ALUDecoder_Extended port map(
        ALUOp => ALUOp,
        Funct => Instr(24 downto 20),
        ALUControl => ALUControl,
        FlagW => FlagW,
        NoRegWrite => NoRegWrite
    );
    
    -- Flag Registers
    FREG: FlagRegister port map(
        CLK => CLK,
        RST => RST,
        FlagWrite => FlagW,
        ALUFlags => ALUFlags,
        CondEx => CondEx,
        Flags => Flags
    );
    
    -- Condition Check
    CC: CondCheck port map(
        Cond => Instr(31 downto 28),
        Flags => Flags,
        CondEx => CondEx
    );
    
    -- Signaux de contr�le conditionnels
    PCSrc <= Branch and CondEx;
    RegWrite <= RegWrite_internal and CondEx;
    MemWrite <= MemWrite_internal and CondEx;
    
end Behavioral;
