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
-- Description : N-bit arithmetic Right shift (SRA) unit
-- ----------------------------------------------------
library IEEE ;
use IEEE . STD_LOGIC_1164 .ALL ;
use IEEE . NUMERIC_STD .ALL;
entity sraN is
GENERIC ( N : INTEGER := 4) ; --bit width
PORT (
A : IN std_logic_vector (N -1 downto 0) ;
SHIFT_AMT : IN std_logic_vector (N -1 downto 0) ;
Y : OUT std_logic_vector (N -1 downto 0)
) ;
end sraN ;
architecture behavioral of sraN is
    type shifty_array is array (N -1 downto 0) of std_logic_vector (N -1 downto 0) ;
signal aSRA : shifty_array ;
begin
    --creating the shifted values and storing them in an array
    generateSRA : for i in 0 to N -1 generate
        aSRA ( i ) (N-1-i downto 0 ) <= A (N -1 downto i) ;
        left_fill : if i > 0 generate
            aSRA (i) (N-1 downto N-i) <= ( others => A(N-1));
        end generate left_fill ;
    end generate generateSRA ;
    --choosing the shifted bits by the shift amount
    Y <= aSRA ( to_integer ( unsigned ( SHIFT_AMT ) ) ) when
        (to_integer ( unsigned ( SHIFT_AMT ) ) < 32) else ( others => '0') ;
end behavioral ;