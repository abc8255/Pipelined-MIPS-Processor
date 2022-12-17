-------------------------------------------------
--  File:          aluTB.vhd
--
--  Entity:        aluTB
--  Architecture:  Testbench
--  Author:        Jason Blocklove
--  Created:       07/29/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                aluTB
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity aluTB is
    Generic ( N : integer := 32 );
end aluTB;

architecture tb of aluTB is

component ALU IS
    Port ( in1 : in  std_logic_vector(N-1 downto 0);
           in2 : in  std_logic_vector(N-1 downto 0);
           control : in  std_logic_vector(3 downto 0);
           out1    : out std_logic_vector(N-1 downto 0)
          );
end component;

signal in1 : std_logic_vector(N-1 downto 0);
signal in2 : std_logic_vector(N-1 downto 0);
signal control : std_logic_vector(3 downto 0);
signal out1 : std_logic_vector(N-1 downto 0);

type alu_tests is record
	-- Test Inputs
	in1 : std_logic_vector(N-1 downto 0);
	in2 : std_logic_vector(N-1 downto 0);
	control : std_logic_vector(3 downto 0);
	-- Test Outputs
	out1 : std_logic_vector(N-1 downto 0);
end record;

constant num_tests : integer := 18;
type test_array is array (0 to num_tests-1) of alu_tests;

--TODO: Add at least 2 cases for each operation in the ALU
constant test_vector_array : test_array :=(
	(in1 => x"00000001", in2 => x"00000001", control => "1010", out1 => x"00000001"), -- AND
	(in1 => x"00000001", in2 => x"00000000", control => "1010", out1 => x"00000000"), -- AND
	(in1 => x"00000001", in2 => x"00001110", control => "0100", out1 => x"00001111"), -- ADD
	(in1 => x"00000000", in2 => x"11100000", control => "0100", out1 => x"11100000"), -- ADD
	(in1 => x"00000001", in2 => x"00000011", control => "1000", out1 => x"00000011"), -- OR
	(in1 => x"10101010", in2 => x"01010101", control => "1000", out1 => x"11111111"), -- OR
	(in1 => x"00000001", in2 => x"00000011", control => "1011", out1 => x"00000010"), -- XOR
	(in1 => x"11111111", in2 => x"10101010", control => "1011", out1 => x"01010101"), -- XOR
	(in1 => x"00000001", in2 => x"00000001", control => "1100", out1 => x"00000002"), -- SLL
	(in1 => x"0000000F", in2 => x"00000004", control => "1100", out1 => x"00000100"), -- SLL
	(in1 => x"00000001", in2 => x"00000001", control => "1110", out1 => x"00000000"), -- SRA
	(in1 => x"F0000001", in2 => x"00000010", control => "1110", out1 => x"fffff000"), -- SRA
	(in1 => x"00000001", in2 => x"00000001", control => "1101", out1 => x"00000000"), -- SRL
	(in1 => x"10000001", in2 => x"00000010", control => "1101", out1 => x"00001000"), -- SRL
	(in1 => x"00000001", in2 => x"00000001", control => "0101", out1 => x"00000000"), -- SUB
	(in1 => x"00001101", in2 => x"00000101", control => "0101", out1 => x"00001000"),  -- SUB
	(in1 => x"00000011", in2 => x"00000010", control => "0110", out1 => x"00000110"),
	(in1 => x"00001110", in2 => x"00001011", control => "0110", out1 => x"01122210")
);

begin


aluN_0 : ALU
    port map (
			in1  => in1,
			in2  => in2,
            control  => control,
            out1     => out1
		);

	stim_proc:process
	begin

		for i in test_array'range loop
		--TODO:	signal assignments and assert statements
			in1 <= test_vector_array(i).in1;
			in2 <= test_vector_array(i).in2;
			control <= test_vector_array(i).control;
			wait for 100 ns;
			assert out1 <= test_vector_array(i).out1 report "Output was incorrect";
		end loop;


		assert false
		  report "Testbench Concluded."
		  severity failure;

	end process;
end tb;
