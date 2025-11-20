library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity InstructionMemory is
    Port (
        A : in STD_LOGIC_VECTOR(31 downto 0);
        RD : out STD_LOGIC_VECTOR(31 downto 0)
    );
end InstructionMemory;

architecture Behavioral of InstructionMemory is
    type ram_type is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    
    -- Fonction pour initialiser depuis le fichier
    impure function init_memory_from_file return ram_type is
        file text_file : text open read_mode is "C:\Users\dagoe\labo_4\Instructions.txt";
        variable text_line : line;
        variable ram_content : ram_type := (others => X"00000000");
        variable i : integer := 0;
        variable instruction : STD_LOGIC_VECTOR(31 downto 0);
    begin
        while not endfile(text_file) and i < 32 loop
            readline(text_file, text_line);
            read(text_line, instruction);
            ram_content(i) := instruction;
            i := i + 1;
        end loop;
        file_close(text_file);
        return ram_content;
    end function;
    
    signal memory : ram_type := init_memory_from_file;
    
begin
    -- Lecture � l'adresse PC[6:2]
    RD <= memory(to_integer(unsigned(A(6 downto 2))));
end Behavioral;
