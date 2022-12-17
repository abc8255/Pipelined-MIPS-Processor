----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2021 07:30:58 PM
-- Design Name: 
-- Module Name: Pipeline_MIPS - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pipeline_MIPS is
GENERIC ( N : Integer := 32);
Port (  rst, clk : IN std_logic; --
        ALUResultOut, Instruct_Out : OUT std_logic_vector (N-1 downto 0)
);
end Pipeline_MIPS;

architecture Behavioral of Pipeline_MIPS is

--Instruction Fetch Stage
component Instr_Fetch
    PORT (
        clk, rst: IN std_logic;
        Instruction : OUT std_logic_vector(31 downto 0)
    ) ;
end component;
signal InstructionF                             : std_logic_vector(31 downto 0);

--Instruction Decode Stage
component Instr_Decode
    Port (
        RegWriteEn ,clk : IN std_logic;
        Instruction, RegWriteData : IN std_logic_vector(31 downto 0);
        RegWriteAddr : IN std_logic_vector(4 downto 0);
        RegWrite ,MemtoReg, MemWrite, ALUSrc, RegDst : OUT std_logic;
        RD1, RD2, ImmOut : OUT std_logic_vector(31 downto 0);
        RtDest, RdDest : OUT std_logic_vector(4 downto 0);
        ALUControl: OUT std_logic_vector(3 downto 0)
    );
end component;
    signal RegWriteEnD                  : std_logic;
    signal InstructionD                 : std_logic_vector(31 downto 0);
    signal RegWriteDataD                : std_logic_vector(31 downto 0);
    signal RegWriteAddrD                : std_logic_vector(4 downto 0);
    signal RegWriteD                    : std_logic;
    signal MemtoRegD                    : std_logic;
    signal MemWriteD                    : std_logic;
    signal ALUSrcD                      : std_logic;
    signal RegDstD                      : std_logic;
    signal RD1D                         : std_logic_vector(31 downto 0);
    signal RD2D                         : std_logic_vector(31 downto 0);
    signal ImmOutD                      : std_logic_vector(31 downto 0);
    signal RtDestD                      : std_logic_vector(4 downto 0);
    signal RdDestD                      : std_logic_vector(4 downto 0);
    signal ALUControlD                  : std_logic_vector(3 downto 0);
 
--Execute Stage
component ExecuteStage is
    GENERIC ( N : INTEGER := N) ; -- bit width
    Port (  RegWrite, MemtoReg, MemWrite, ALUSrc, RegDst : IN std_logic;
            ALUControl : IN std_logic_vector ( 3 downto 0 );
            RtDest, RdDest : IN std_logic_vector ( 4 downto 0 );
            RegSrcA, RegSrcB, SignImm : IN std_logic_vector (N-1 downto 0 );
            RegWriteOut, MemtoRegOut, MemWriteOut : OUT std_logic;
            ALUResult, WriteData : OUT std_logic_vector ( N-1 downto 0 );
            WriteReg : OUT std_logic_vector ( 4 downto 0 )
    );
end component;
    signal RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE    : std_logic;
    signal ALUControlE                                          : std_logic_vector ( 3 downto 0 );
    signal RtDestE, RdDestE                                     : std_logic_vector ( 4 downto 0 );
    signal RegSrcAE, RegSrcBE, SignImmE                         : std_logic_vector (N-1 downto 0 );
    signal RegWriteOutE, MemtoRegOutE, MemWriteOutE             : std_logic;
    signal ALUResultE, WriteDataE                               : std_logic_vector ( N-1 downto 0 );
    signal WriteRegE                                            : std_logic_vector ( 4 downto 0 );
 
--Memory Stage
component Memory_Stage
          GENERIC ( N : Integer := 32);
          port (
            MemWrite, RegWrite, MemtoReg, clk   :IN std_logic; --
            WriteReg                            :IN std_logic_vector (4 downto 0); --
            ALUResult, WriteData                :IN std_logic_vector (N-1 downto 0); --
            RegWriteOut, MemtoRegOut            :OUT std_logic; --
            WriteRegOut                         :OUT std_logic_vector (4 downto 0); --
            MemOut, ALUResultOut                :OUT std_logic_vector (N-1 downto 0) --
      );
    end component; 
    signal MemWriteM, RegWriteM, MemtoRegM  : std_logic;
    signal WriteRegM                         : std_logic_vector (4 downto 0); --
    signal ALUResultM, WriteDataM             : std_logic_vector (N-1 downto 0);
    signal RegWriteOutM, MemtoRegOutM         : std_logic;
    signal WriteRegOutM                      : std_logic_vector (4 downto 0);
    signal MemOutM, ALUOutM                  : std_logic_vector (N-1 downto 0);
 
--Writeback Stage                                            
component Writeback_Stage                       
    Port( 
        WriteReg : IN std_logic_vector (4 downto 0);
        RegWrite, MemtoReg : IN std_logic;        
        RegData, MemData : IN std_logic_vector (31 downto 0);
        Result : OUT std_logic_vector (31 downto 0);
        WriteRegOut : OUT std_logic_vector (4 downto 0);
        WbEn : OUT std_logic                
    );                                          
    end component;                              
    signal MemtoRegW, RegWriteW         : std_logic;
    signal RegDataW, ReadDataW          : std_logic_vector (31 downto 0);
    signal ResultW                      : std_logic_vector (31 downto 0);
    signal WriteRegOutW, WriteRegW      : std_logic_vector (4 downto 0);
    signal WbEn                         : std_logic;

begin
-- instantiation of the Instruction Fetch Stage
    Fetch_Stage : Instr_Fetch port map(
            clk => clk,
            rst => rst,
            Instruction => InstructionF
    );
    
-- instantiation of the Instruction Decode Stage
    Decode_Stage : Instr_Decode port map(
        RegWriteEn => RegWriteEnD,
        clk => clk,
        Instruction => InstructionD,
        RegWriteData => RegWriteDataD,
        RegWriteAddr => RegWriteAddrD,
        RegWrite => RegWriteD,
        MemtoReg => MemtoRegD,
        MemWrite => MemWriteD,
        ALUSrc => ALUSrcD,
        RegDst => RegDstD,
        RD1 => RD1D,
        RD2 => RD2D,
        ImmOut => ImmOutD,
        RtDest => RtDestD,
        RdDest => RdDestD,
        ALUControl => ALUControlD
    );
    
-- instantiation of the Execute Stage
    Execute_Stage : ExecuteStage port map(
        RegWrite => RegWriteE,
        MemtoReg => MemtoRegE,
        MemWrite => MemWriteE,
        ALUSrc => ALUSrcE,
        RegDst => RegDstE,
        ALUControl => ALUControlE,
        RtDest => RtDestE,
        RdDest => RdDestE,
        RegSrcA => RegSrcAE,
        RegSrcB => RegSrcBE,
        SignImm => SignImmE,
        RegWriteOut => RegWriteOutE,
        MemtoRegOut => MemtoRegOutE,
        MemWriteOut => MemWriteOutE,
        ALUResult => ALUResultE,
        WriteData => WriteDataE,
        WriteReg => WriteRegE
    );        

-- instantiation of the Memory_Stage
    Mem_Stage : Memory_Stage port map (
        MemWrite => MemWriteM,
        RegWrite => RegWriteM,
        MemtoReg => MemtoRegM,
        clk => clk,
        WriteReg => WriteRegM,
        ALUResult => ALUResultM,
        WriteData => WriteDataM,
        RegWriteOut => RegWriteOutM,
        MemtoRegOut => MemtoRegOutM,
        WriteRegOut => WriteRegOutM,
        MemOut => MemOutM,
        ALUResultOut => ALUOutM
            
    );
-- instantiation of the Writeback_Stage
    WB_Stage : Writeback_Stage port map (
        WriteReg => WriteRegW,
        RegWrite => RegWriteW,
        MemtoReg => MemtoRegW,
        RegData => RegDataW,
        MemData => ReadDataW,
        Result => ResultW,
        WriteRegOut => WriteRegOutW,
        WbEn => WbEn
    ); 
    
---- moving Fetch stage outputs to Decode on the clock
--    Clk_Proc_1 : process (clk, InstructionF) is begin
--        if (rising_edge(clk)) then
--            InstructionD <= InstructionF;
--        end if;
--    end process;    
    
-- moving Decode stage outputs to Execute on the clock
    Clk_Proc_2 : process (clk) is begin
        if (rising_edge(clk)) then
        -- moving Memory stage outputs to Writeback on the clock
            WriteRegW <= WriteRegM;
            RegWriteW <= RegWriteM;
            MemtoRegW <= MemtoRegM;
            RegDataW <= WriteDataM;
            ReadDataW <= ALUOutM;
        -- moving Execute stage outputs to Memory on the clock
            RegWriteM <= RegWriteE;
            MemtoRegM <= MemtoRegE;
            MemWriteM <= MemWriteE;
            WriteRegM <= WriteRegE;
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
        -- moving Decode stage outputs to Execute on the clock
            RegWriteE <= RegWriteD;
            MemtoRegE <= MemtoRegD;
            MemWriteE <= MemWriteD;
            ALUSrcE <= ALUSrcD;
            RegDstE <= RegDstD;
            ALUControlE <= ALUControlD;
            RtDestE <= RtDestD;
            RdDestE <= RdDestD;
            RegSrcAE <= RD1D;
            RegSrcBE <= RD2D;
            SignImmE <= ImmOutD;
        -- moving Fetch stage outputs to Decode on the clock     
            InstructionD <= InstructionF;
        end if;
    end process;

---- moving Execute stage outputs to Memory on the clock
--    Clk_Proc_3 : process (clk) is begin
--        if (rising_edge(clk)) then
--            RegWriteM <= RegWriteE;
--            MemtoRegM <= MemtoRegE;
--            MemWriteM <= MemWriteE;
--            WriteRegM <= WriteRegE;
--            ALUResultM <= ALUResultE;
--            WriteDataM <= WriteDataE;
--        end if;
--    end process;

---- moving Memory stage outputs to Writeback on the clock
--    Clk_Proc_4 : process (clk) is begin
--        if (rising_edge(clk)) then
--            WriteRegW <= WriteRegM;
--            RegWriteW <= RegWriteM;
--            MemtoRegW <= MemtoRegM;
--            RegDataW <= WriteDataM;
--            ReadDataW <= ALUOutM;
--        end if;
--    end process;    

-- assigning lines outside of clock restrictions
    RegWriteDataD <= ResultW;
    ALUResultOut <= ALUResultE;
    RegWriteEnD <= RegWriteW;
    RegWriteAddrD <= WriteRegW;
    Instruct_Out <= InstructionF;
    
end Behavioral;
