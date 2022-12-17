-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Aden Crimmins (abc8255@rit.edu)
--
-- Create Date : 01-27-21
-- Design Name : orN
-- Module Name : orN - dataflow
-- Project Name : tester
-- Target Devices : Basys3
--
-- Description : N-bit bitwise or unit
-- ----------------------------------------------------
library IEEE ;
use IEEE . STD_LOGIC_1164 .ALL ;
entity orN is
GENERIC ( N : INTEGER := 4) ; --bit width
PORT (
A, B : IN std_logic_vector (N -1 downto 0) ;
Y : OUT std_logic_vector (N -1 downto 0)
) ;
end orN ;
architecture dataflow of orN is
begin
Y <= A OR B ;
end dataflow ;