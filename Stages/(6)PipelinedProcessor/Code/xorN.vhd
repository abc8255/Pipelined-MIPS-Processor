-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Aden Crimmins (abc8255@rit.edu)
--
-- Create Date : 01-27-21
-- Design Name : xorN
-- Module Name : xorN - dataflow
-- Project Name : tester
-- Target Devices : Basys3
--
-- Description : N-bit bitwise XOR unit
-- ----------------------------------------------------
library IEEE ;
use IEEE . STD_LOGIC_1164 .ALL ;
entity xorN is
GENERIC ( N : INTEGER := 4) ; --bit width
PORT (
A, B : IN std_logic_vector (N -1 downto 0) ;
Y : OUT std_logic_vector (N -1 downto 0)
) ;
end xorN ;
architecture dataflow of xorN is
begin
Y <= A XOR B ;
end dataflow ;