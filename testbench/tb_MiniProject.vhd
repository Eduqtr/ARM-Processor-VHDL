library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity tb_MiniProject is
end tb_MiniProject;

architecture Behavioral of tb_MiniProject is
    component ARM_Complete
        Port (
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            PC : out STD_LOGIC_VECTOR(31 downto 0);
            Instr : out STD_LOGIC_VECTOR(31 downto 0);
            ALUResult : out STD_LOGIC_VECTOR(31 downto 0);
            WriteData : out STD_LOGIC_VECTOR(31 downto 0);
            ReadData : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    signal CLK : STD_LOGIC := '0';
    signal RST : STD_LOGIC := '1';
    signal PC : STD_LOGIC_VECTOR(31 downto 0);
    signal Instr : STD_LOGIC_VECTOR(31 downto 0);
    signal ALUResult : STD_LOGIC_VECTOR(31 downto 0);
    signal WriteData : STD_LOGIC_VECTOR(31 downto 0);
    signal ReadData : STD_LOGIC_VECTOR(31 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
    file output_file : text;
    
begin
    UUT: ARM_Complete port map(
        CLK => CLK,
        RST => RST,
        PC => PC,
        Instr => Instr,
        ALUResult => ALUResult,
        WriteData => WriteData,
        ReadData => ReadData
    );
    
    -- G�n�ration horloge
    CLK_process: process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    -- Test
    test_process: process
        variable outline : line;
    begin
        file_open(output_file, "miniproject_results.txt", write_mode);
        
 RST <= '1';
        wait for 2 ns;
        RST <= '0';
        wait until rising_edge(CLK);
        wait for 1 ns;
        
        -- 20 instructions
        for i in 1 to 20 loop
            wait for 1 ns;
            
            -- Format binaire: ALUResult_WriteData
            write(outline, ALUResult);
            write(outline, string'("_"));
            write(outline, WriteData);
            writeline(output_file, outline);
            
            wait until rising_edge(CLK);
        end loop;
        
        file_close(output_file);
        
        
        wait;
    end process;
    
end Behavioral;

