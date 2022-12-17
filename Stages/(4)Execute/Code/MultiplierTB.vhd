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

entity MultiplierTB is
    Generic ( N : integer := 32 );
end MultiplierTB;

architecture tb of MultiplierTB is

component Multiplier IS
    GENERIC ( N : INTEGER := N) ; --bit width
    Port (  A, B : IN std_logic_vector ((N/2)-1 downto 0);
            Product : OUT std_logic_vector (N-1 downto 0)
          );
end component;

signal A : std_logic_vector((N/2)-1 downto 0);
signal B : std_logic_vector((N/2)-1 downto 0);
signal Product : std_logic_vector(N-1 downto 0);

type Multiplier_tests is record
	-- Test Inputs
	A : std_logic_vector((N/2)-1 downto 0);
    B : std_logic_vector((N/2)-1 downto 0);
	-- Test Outputs
    Product : std_logic_vector(N-1 downto 0);
end record;

constant num_tests : integer := 4;
type test_array is array (0 to num_tests-1) of Multiplier_tests;

--TODO: Add at least 2 cases for each operation in the ALU
constant test_vector_array : test_array :=(
	(A => x"0002", B => x"0004", Product => x"00000008"),
	(A => x"0002", B => x"0010", Product => x"00000020"),
	(A => x"00F0", B => x"00F0", Product => x"0000E100"),
	(A => x"1110", B => x"1011", Product => x"01122210")
);

begin


MultiplierN_0 : Multiplier
    port map (
			 A => A,  
			 B => B,
            Product => Product
		);

	stim_proc:process
	begin

		for i in test_array'range loop
		--TODO:	signal assignments and assert statements
			A <= test_vector_array(i).A;
			B <= test_vector_array(i).B;
			wait for 100 ns;
			assert Product <= test_vector_array(i).Product report "Output was incorrect";
		end loop;


		assert false
		  report "Testbench Concluded."
		  severity failure;

	end process;
end tb;