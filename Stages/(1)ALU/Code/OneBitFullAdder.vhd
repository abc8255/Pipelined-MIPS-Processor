----------------------------------------------------------------------------------
-- Company: Student(RIT)
-- Engineer: Aden Crimmins
-- 
-- Create Date: 03/18/2021 08:01:03 AM
-- Design Name: MIPS Excecution
-- Module Name: OneBitFullAdder - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity OneBitFullAdder is
 Port ( signal A, B, Cin : in STD_LOGIC; -- defining the inputs and the outputs for this entity
   		signal S, Cout   : out STD_LOGIC);
end OneBitFullAdder;

architecture Behavioral of OneBitFullAdder is
begin
    S <= (A XOR B) XOR Cin;
	Cout <=  (A AND B) OR (A AND Cin) OR (B AND Cin);

end Behavioral;
