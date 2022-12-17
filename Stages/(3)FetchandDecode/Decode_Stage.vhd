 ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Aden Crimmins (abc8255@rit.edu)
--
-- Create Date : 3-8-21
-- Design Name : Instr_Decode
-- Module Name : Instr_Decode - behavioral
-- Project Name : Lab3_part_2
-- Target Devices : Basys3
--
-- Description : Register File unit
-- ----------------------------------------------------
library IEEE ;
use IEEE . STD_LOGIC_1164 .ALL ;
use IEEE . NUMERIC_STD .ALL;
entity Instr_Decode is
GENERIC ( BIT_WIDTH : INTEGER := 32);
PORT (
    RegWriteEn ,clk : IN std_logic;
	Instruction, RegWriteData : IN std_logic_vector(31 downto 0);
	RegWriteAddr : IN std_logic_vector(4 downto 0);
	RegWrite ,MemtoReg, MemWrite, ALUSrc, RegDst : OUT std_logic;
	RD1, RD2, ImmOut : OUT std_logic_vector(31 downto 0);
	RtDest, RdDest : OUT std_logic_vector(4 downto 0);
	ALUControl: OUT std_logic_vector(3 downto 0)
) ;
end Instr_Decode ;

architecture behavioral of Instr_Decode is
    signal Opcode : std_logic_vector(5 downto 0) := ( others => '0');
    signal tempTest : std_logic_vector(5 downto 0) := ( others => '0');
    signal Funct : std_logic_vector(5 downto 0) := ( others => '0');
	signal Addr1, Addr2, Addr3 : std_logic_vector(4 downto 0) := ( others => '0');
	signal RegDst_temp : std_logic := '0';
	


    component Control_Unit
        port (
            Opcode, Funct : IN std_logic_vector(5 downto 0);
	        RegWrite ,MemtoReg, MemWrite, ALUSrc, RegDst : OUT std_logic;
	        ALUControl: OUT std_logic_vector(3 downto 0)
        );
    end component;
    
    component RegFile
        port (
            we ,clk_n : IN std_logic;
	        Addr1, Addr2, Addr3 : IN std_logic_vector(4 downto 0);
	        wd : IN std_logic_vector(BIT_WIDTH-1 downto 0);
	        RD1, RD2 : OUT std_logic_vector(BIT_WIDTH-1 downto 0)
        );
    end component;
    
begin
   
   CtrlUnit1 : Control_Unit
    port map(Opcode => Opcode,
             Funct => Funct,
             RegWrite => RegWrite,
             MemtoReg => MemtoReg,
             MemWrite => MemWrite,
             ALUSrc => ALUSrc,
             RegDst => RegDst_temp,
             ALUControl => ALUControl);
             
   RegFile1 : RegFile
    port map(we => RegWriteEn,
             clk_n => clk,
             Addr3 => RegWriteAddr,
             Addr1 => Addr1,
             Addr2 => Addr2,
             wd => RegWriteData,
             RD1 => RD1,
             RD2 => RD2);
   
--    Opcode <= Instruction(31 downto 26);
--    Funct <= Instruction(5 downto 0);
--    RegDst <= RegDst_temp;
    RegDst <= RegDst_temp;
    Opcode <= Instruction(31 downto 26);
    tempTest <= Instruction(5 downto 0);
    
    main_proc : process (clk, Opcode, Instruction, tempTest) is begin
        if (falling_edge(clk)) then
            --Opcode <= Instruction(31 downto 26);
            Funct <= Instruction(5 downto 0);
            
            Addr1 <= Instruction(25 downto 21);
            --tempTest <= Instruction(5 downto 0);
            --case for SLL, SRA, SRL
            if ((Opcode = "000000") AND (tempTest = "000000" OR tempTest = "000011" OR tempTest = "000010")) then
                if (Instruction(10) = '1') then
                    ImmOut <= X"ffffff"& "111" & Instruction(10 downto 6);
                else 
                    ImmOut <= X"000000" & "000" & Instruction(10 downto 6);
                end if;
            else
                if (Instruction(15) = '1') then
                    ImmOut <= X"ffff" & Instruction(15 downto 0);
                else 
                    ImmOut <= X"0000" & Instruction(15 downto 0);
                end if;
            end if;
            
           
        end if;
    end process;
    
    reg_proc : process (RegDst_temp, clk) is begin
    if (falling_edge(clk)) then
        if (RegDst_temp = '0') then
                Addr2 <= "00000";
                RtDest <= Instruction(20 downto 16);
                RdDest <= (others => '0'); 
            else
                Addr2 <= Instruction(20 downto 16); 
                RtDest <= Instruction(20 downto 16);
                RdDest <= Instruction(15 downto 11);       
        end if;
    end if;
    end process;

end architecture behavioral;