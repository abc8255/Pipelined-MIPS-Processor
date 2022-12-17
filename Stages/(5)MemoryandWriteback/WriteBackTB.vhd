-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Aden Crimmins (abc8255@rit.edu)
--
-- Create Date : 4-13-21
-- Design Name : WriteBackTB
-- Module Name : WriteBackTB - behavioral
-- Project Name : Lab5
-- Target Devices : Basys3
--
-- Description : WriteBack Stage TB
-- ----------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity WriteBackTB is
end WriteBackTB;

architecture Behavioral of WriteBackTB is
type test_vector is record
    MemWbIdx : std_logic_vector (4 downto 0);
    MemWr : std_logic;
    MemRd : std_logic;
    RegData : std_logic_vector (31 downto 0);
    MemData : std_logic_vector (31 downto 0);
    WbData : std_logic_vector (31 downto 0);
    WbIdx : std_logic_vector (4 downto 0);
    WbEn : std_logic;
end record;

type test_array is array (natural range <>) of test_vector;
constant test_vector_array : test_array := (
    (MemWbIdx => b"00000", MemWr => '0', MemRd => '0', RegData => x"00000000", MemData => x"FFFFFFFF", WbData => x"00000000", WbIdx => b"00000", WbEn => '1' ),
    (MemWbIdx => b"00000", MemWr => '0', MemRd => '1', RegData => x"00000000", MemData => x"FFFFFFFF", WbData => x"FFFFFFFF", WbIdx => b"00000", WbEn => '1' ),
    (MemWbIdx => b"11111", MemWr => '1', MemRd => '0', RegData => x"55555555", MemData => x"AAAAAAAA", WbData => x"55555555" , WbIdx => b"11111", WbEn => '0'),
    (MemWbIdx => b"11111", MemWr => '1', MemRd => '1', RegData => x"55555555", MemData => x"AAAAAAAA", WbData => x"AAAAAAAA" , WbIdx => b"11111" , WbEn => '0')
);

component Writeback_Stage
  port (
        MemWbIdx : IN std_logic_vector (4 downto 0);
        MemWr : IN std_logic;
        MemRd : IN std_logic;
        RegData : IN std_logic_vector (31 downto 0);
        MemData : IN std_logic_vector (31 downto 0);
        WbData : OUT std_logic_vector (31 downto 0);
        WbIdx : OUT std_logic_vector (4 downto 0);
        WbEn : OUT std_logic
  );
end component;

	    signal MemWbIdx : std_logic_vector (4 downto 0);
        signal MemWr : std_logic;
        signal MemRd : std_logic;
        signal RegData : std_logic_vector (31 downto 0);
        signal MemData : std_logic_vector (31 downto 0);
        signal WbData : std_logic_vector (31 downto 0);
        signal WbIdx : std_logic_vector (4 downto 0);
        signal WbEn : std_logic;
        
begin

uut : Writeback_Stage
    port map (
        MemWbIdx => MemWbIdx,
        MemWr => MemWr,
        MemRd => MemRd,
        RegData => RegData,
        MemData => MemData,
        WbData => WbData,
        WbIdx => WbIdx,
        WbEn => WbEn
    );

stim_proc:process
begin

	for i in test_vector_array'range loop
		MemWbIdx <= test_vector_array(i).MemWbIdx;
		MemWr <= test_vector_array(i).MemWr;
		MemRd <= test_vector_array(i).MemRd;
		RegData <= test_vector_array(i).RegData;
		MemData <= test_vector_array(i).MemData;
		wait for 100 ns;
	   assert  WbData <= test_vector_array(i).WbData report "WbData was wrong";
	   assert  WbIdx <= test_vector_array(i).WbIdx report "WbIdx was wrong";
	   assert  WbEn <= test_vector_array(i).WbEn report "WbEn was wrong"; 
	end loop;

	assert false
		report "Testbench Concluded"
		severity failure;


end process;

end Behavioral;