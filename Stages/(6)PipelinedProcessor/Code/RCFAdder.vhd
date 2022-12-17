----------------------------------------------------------------------------------
-- Company: Student(RIT)
-- Engineer: Aden Crimmins
-- 
-- Create Date: 03/18/2021 08:01:03 AM
-- Design Name: MIPS Excecution
-- Module Name: RCFAdder - Behavioral
-- Project Name: Excecute Stage
-- Target Devices: BASYS 3
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCFAdder is
    GENERIC ( N : INTEGER := 32) ; --bit width
    Port (  A, B: IN std_logic_vector ( N-1 downto 0);
            OP : IN std_logic;
            Sum : OUT std_logic_vector ( N-1 downto 0)
    );
end RCFAdder;

architecture Structural of RCFAdder is

    Component OneBitFullAdder is
        PORT (
            signal A, B, Cin : in STD_LOGIC; 
   		    signal S, Cout   : out STD_LOGIC);
    end Component ;
    
    signal carry: std_logic_vector(N downto 0);
    signal B_comp : std_logic_vector(N-1 downto 0);
begin
    carry(0) <= OP; -- OP = 1 for subtraction
    
    FA : for i in 0 to N-1 generate
        B_comp(i) <= B(i) xor OP; -- Determines whether the 2's compliment is added or if it is the normal bit.
        FA_i: OneBitFullAdder PORT MAP(A => A(i),
                                        B => B_comp(i),
                                        Cin => carry(i),
                                        S => Sum(i),
                                        Cout => carry(i+1)); 
    end generate;
    
end Structural;
