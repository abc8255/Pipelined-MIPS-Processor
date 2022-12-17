-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Aden Crimmins (abc8255@rit.edu)
--
-- Create Date : 4-13-21
-- Design Name : DataMemTB
-- Module Name : DataMemTB - behavioral
-- Project Name : Lab5
-- Target Devices : Basys3
--
-- Description : data memory TB
-- ----------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity DataMemTB is
GENERIC ( N : INTEGER := 32;
          ADDR_BITS : Integer := 10  );
end DataMemTB;

architecture Behavioral of DataMemTB is
type test_vector is record
	w_en :  std_logic;
	Addr :  std_logic_vector(ADDR_BITS-1 downto 0);
	d_in :  std_logic_vector(N-1 downto 0);
	d_out :  std_logic_vector(N-1 downto 0);
end record;

--TODO: Add additional 5 cases to test table
type test_array is array (natural range <>) of test_vector;
constant test_vector_array : test_array := (
	(w_en => '1', Addr => 10ux"1B", d_in => 32ux"AAAA5555", d_out => x"00000000"),
	(w_en => '1', Addr => 10ux"1C", d_in => 32ux"5555AAAA", d_out => x"00000000"),
	(w_en => '0', Addr => 10ux"1B", d_in => 32ux"00000000", d_out => x"aaaa5555"),
	(w_en => '1', Addr => 10ux"1C", d_in => 32ux"00000000", d_out => x"5555aaaa")
);

component data_memory
  port (
    w_en : IN std_logic;
    clk_n : IN std_logic;
	Addr : IN std_logic_vector(ADDR_BITS-1 downto 0);
	d_in : IN std_logic_vector(N-1 downto 0);
	d_out : OUT std_logic_vector(N-1 downto 0)
  );
end component;

	signal w_en ,clk_n : std_logic;
	signal Addr : std_logic_vector(ADDR_BITS-1 downto 0);
	signal d_in : std_logic_vector(N-1 downto 0);
	signal d_out : std_logic_vector(N-1 downto 0);
begin

uut : data_memory
    port map (
        w_en => w_en,
        clk_n => clk_n,
        Addr => Addr,
        d_in => d_in,
        d_out => d_out
    );

clk_proc:process
begin
	clk_n <= '0';
	wait for 50 ns;
	clk_n <= '1';
	wait for 50 ns;
end process;

stim_proc:process
begin
  wait until clk_n ='0';

	for i in test_vector_array'range loop
		w_en <= test_vector_array(i).w_en;
		Addr <= test_vector_array(i).Addr;
		d_in <= test_vector_array(i).d_in;
		wait for 100 ns;
	   assert  d_out <= test_vector_array(i).d_out report "d_out was wrong"; 
	end loop;

	assert false
		report "Testbench Concluded"
		severity failure;


end process;

end Behavioral;
