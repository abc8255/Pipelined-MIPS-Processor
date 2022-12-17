-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Aden Crimmins (abc8255@rit.edu)
--
-- Create Date : 1-28-21
-- Design Name : srlN
-- Module Name : srlN - behavioral
-- Project Name : tester
-- Target Devices : Basys3
--
-- Description : N-bit logical Right shift (SRL ) unit
-- ----------------------------------------------------
library IEEE ;
use IEEE . STD_LOGIC_1164 .ALL ;
use IEEE . NUMERIC_STD .ALL;
entity srlN is
GENERIC ( N : INTEGER := 4) ; --bit width
PORT (
A : IN std_logic_vector (N -1 downto 0) ;
SHIFT_AMT : IN std_logic_vector (N -1 downto 0) ;
Y : OUT std_logic_vector (N -1 downto 0)
) ;
end srlN ;
architecture behavioral of srlN is
    type shifty_array is array (N -1 downto 0) of std_logic_vector (N -1 downto 0) ;
signal aSRL : shifty_array ;
begin
    --creating the shifted values and storing them in an array
    generateSRL : for i in 0 to N -1 generate
        aSRL ( i ) (N-1-i downto 0 ) <= A (N -1 downto i) ;
        left_fill : if i > 0 generate
            aSRL (i) (N-1 downto N-i) <= ( others => '0');
        end generate left_fill ;
    end generate generateSRL ;
    --choosing the shifted bits by the shift amount
    Y <= aSRL ( to_integer ( unsigned ( SHIFT_AMT ) ) ) when
        (to_integer ( unsigned ( SHIFT_AMT ) ) < 32) else ( others => '0') ;
end behavioral ;