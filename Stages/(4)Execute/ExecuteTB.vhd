-------------------------------------------------
--  File:          aluTB.vhd
--
--  Entity:        ExecuteTB
--  Architecture:  Testbench
--  Author:        Aden Crimmins
--  Created:       03/24/21
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 ExecuteTB
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ExecuteTB is
    Generic ( N : integer := 32 );
end ExecuteTB;

architecture tb of ExecuteTB is

component ExecuteStage IS
    Port (  RegWrite, MemtoReg, MemWrite, ALUSrc, RegDst : IN std_logic;
            ALUControl : IN std_logic_vector ( 3 downto 0 );
            RtDest, RdDest : IN std_logic_vector ( 4 downto 0 );
            RegSrcA, RegSrcB, SignImm : IN std_logic_vector (N-1 downto 0 );
            RegWriteOut, MemtoRegOut, MemWriteOut : OUT std_logic;
            ALUResult, WriteData : OUT std_logic_vector ( N-1 downto 0 );
            WriteReg : OUT std_logic_vector ( 4 downto 0 )
          );
end component;

signal RegWrite, MemtoReg, MemWrite, ALUSrc, RegDst : std_logic;
signal ALUControl : std_logic_vector ( 3 downto 0 );
signal RtDest, RdDest : std_logic_vector ( 4 downto 0 );
signal RegSrcA, RegSrcB, SignImm : std_logic_vector (N-1 downto 0 );
signal RegWriteOut, MemtoRegOut, MemWriteOut : std_logic;
signal ALUResult, WriteData : std_logic_vector ( N-1 downto 0 );
signal WriteReg : std_logic_vector ( 4 downto 0 );

type execute_tests is record
	-- Test Inputs
	RegWrite, MemtoReg, MemWrite, ALUSrc, RegDst : std_logic;
    ALUControl : std_logic_vector ( 3 downto 0 );
    RtDest, RdDest : std_logic_vector ( 4 downto 0 );
    RegSrcA, RegSrcB, SignImm : std_logic_vector (N-1 downto 0 );
    -- Test Outputs
	RegWriteOut, MemtoRegOut, MemWriteOut : std_logic;
    ALUResult, WriteData : std_logic_vector ( N-1 downto 0 );
    WriteReg : std_logic_vector ( 4 downto 0 );
end record;

constant num_tests : integer := 28;
type test_array is array (0 to num_tests-1) of execute_tests;

--TODO: Add at least 2 cases for each operation in the ALU
constant test_vector_array : test_array :=(
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00000001", ALUControl => "1010", ALUResult => x"00000001", WriteData => x"00000001", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- AND
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00000000", ALUControl => "1010", ALUResult => x"00000000", WriteData => x"00000000", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- AND
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00001110", ALUControl => "0100", ALUResult => x"00001111", WriteData => x"00001111", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- ADD
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000000", RegSrcB => x"11100000", ALUControl => "0100", ALUResult => x"11100000", WriteData => x"11100000", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- ADD
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00000011", ALUControl => "1000", ALUResult => x"00000011", WriteData => x"00000011", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- OR
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"10101010", RegSrcB => x"01010101", ALUControl => "1000", ALUResult => x"11111111", WriteData => x"11111111", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- OR
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00000011", ALUControl => "1011", ALUResult => x"00000010", WriteData => x"00000010", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- XOR
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"11111111", RegSrcB => x"10101010", ALUControl => "1011", ALUResult => x"01010101", WriteData => x"01010101", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- XOR
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00000001", ALUControl => "1100", ALUResult => x"00000002", WriteData => x"00000002", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- SLL
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"0000000F", RegSrcB => x"00000004", ALUControl => "1100", ALUResult => x"00000100", WriteData => x"00000100", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- SLL
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00000001", ALUControl => "1110", ALUResult => x"00000000", WriteData => x"00000000", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- SRA
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"F0000001", RegSrcB => x"00000010", ALUControl => "1110", ALUResult => x"fffff000", WriteData => x"fffff000", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- SRA
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00000001", ALUControl => "1101", ALUResult => x"00000000", WriteData => x"00000000", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- SRL
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"10000001", RegSrcB => x"00000010", ALUControl => "1101", ALUResult => x"00001000", WriteData => x"00001000", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- SRL
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00000001", ALUControl => "0101", ALUResult => x"00000000", WriteData => x"00000000", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- SUB
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00001101", RegSrcB => x"00000101", ALUControl => "0101", ALUResult => x"00001000", WriteData => x"00001000", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'),  -- SUB
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '1', RegDst => '0',SignImm => x"00001111", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00000001", ALUControl => "1010", ALUResult => x"00000001", WriteData => x"00000001", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- ANDI
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '1', RegDst => '0',SignImm => x"00001111", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00000000", ALUControl => "1010", ALUResult => x"00000000", WriteData => x"00000000", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- ANDI
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '1', RegDst => '0',SignImm => x"000000E1", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00001110", ALUControl => "0100", ALUResult => x"00001111", WriteData => x"00001111", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- ADDI
	(RegWrite => '0', MemtoReg => '0', MemWrite => '1', ALUSrc => '1', RegDst => '0',SignImm => x"33333333", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000000", RegSrcB => x"11100000", ALUControl => "0100", ALUResult => x"11100000", WriteData => x"11100000", WriteReg => "00001", RegWriteOut => '0', MemtoRegOut => '0', MemWriteOut => '1'), -- SW
	(RegWrite => '1', MemtoReg => '1', MemWrite => '0', ALUSrc => '1', RegDst => '0',SignImm => x"33333333", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000000", RegSrcB => x"11100000", ALUControl => "0100", ALUResult => x"11100000", WriteData => x"11100000", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '1', MemWriteOut => '0'), -- LW
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '1', RegDst => '0',SignImm => x"000000FF", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00000011", ALUControl => "1000", ALUResult => x"00000011", WriteData => x"00000011", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- ORI
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '1', RegDst => '0',SignImm => x"FF000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"10101010", RegSrcB => x"01010101", ALUControl => "1000", ALUResult => x"11111111", WriteData => x"11111111", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- ORI
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '1', RegDst => '0',SignImm => x"00000012", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000001", RegSrcB => x"00000011", ALUControl => "1011", ALUResult => x"00000010", WriteData => x"00000010", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- XORI
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '1', RegDst => '0',SignImm => x"10101010", RtDest => "00000", RdDest => "00000", RegSrcA => x"11111111", RegSrcB => x"10101010", ALUControl => "1011", ALUResult => x"01010101", WriteData => x"01010101", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- XORI
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '1', RegDst => '0',SignImm => x"00000002", RtDest => "00000", RdDest => "00000", RegSrcA => x"0000000F", RegSrcB => x"00000001", ALUControl => "0101", ALUResult => x"0000000E", WriteData => x"0000000E", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- SUBI
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00000011", RegSrcB => x"00000010", ALUControl => "0110", ALUResult => x"00000110", WriteData => x"00000110", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0'), -- MULTU
	(RegWrite => '1', MemtoReg => '0', MemWrite => '0', ALUSrc => '0', RegDst => '1',SignImm => x"00000000", RtDest => "00000", RdDest => "00000", RegSrcA => x"00001110", RegSrcB => x"00001011", ALUControl => "0110", ALUResult => x"10011010", WriteData => x"10011010", WriteReg => "00001", RegWriteOut => '1', MemtoRegOut => '0', MemWriteOut => '0') -- MULTU
);

begin


ExecuteN_0 : ExecuteStage
    port map (
            RegWrite  => RegWrite, 
            MemtoReg => MemtoReg,  
            MemWrite  => MemWrite, 
            ALUSrc  => ALUSrc, 
            RegDst  => RegDst,
            ALUControl  => ALUControl,
            RtDest  => RtDest,
            RdDest  => RdDest,
            RegSrcA  => RegSrcA, 
            RegSrcB  => RegSrcB, 
            SignImm  => SignImm,
            -- Test Outputs
            RegWriteOut  => RegWriteOut, 
            MemtoRegOut  => MemtoRegOut, 
            MemWriteOut  => MemWriteOut,
            ALUResult  => ALUResult,
            WriteData  => WriteData,
            WriteReg  => WriteReg
		);

	stim_proc:process
	begin

		for i in test_array'range loop
		--TODO:	signal assignments and assert statements
			RegWrite <= test_vector_array(i).RegWrite;
			MemtoReg <= test_vector_array(i).MemtoReg;
			MemWrite <= test_vector_array(i).MemWrite;
			ALUSrc <= test_vector_array(i).ALUSrc;
			RegDst <= test_vector_array(i).RegDst;
			ALUControl <= test_vector_array(i).ALUControl;
			RtDest <= test_vector_array(i).RtDest;
			RdDest <= test_vector_array(i).RdDest;
			RegSrcA <= test_vector_array(i).RegSrcA;
			RegSrcB <= test_vector_array(i).RegSrcB;
			SignImm <= test_vector_array(i).SignImm;
			wait for 100 ns;
			assert RegWriteOut <= test_vector_array(i).RegWriteOut report "RegWriteBit was incorrect";
			assert MemtoRegOut <= test_vector_array(i).MemtoRegOut report "MemtoRegBit was incorrect";
			assert MemWriteOut <= test_vector_array(i).MemWriteOut report "MemWriteBit was incorrect";
			assert ALUResult <= test_vector_array(i).ALUResult report "ALUResult was incorrect";
			assert WriteData <= test_vector_array(i).WriteData report "WriteData was incorrect";
			assert WriteReg <= test_vector_array(i).WriteReg report "WriteReg was incorrect";
		end loop;


		assert false
		  report "Testbench Concluded."
		  severity failure;

	end process;
end tb;

