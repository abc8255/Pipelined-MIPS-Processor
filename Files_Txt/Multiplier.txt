----------------------------------------------------------------------------------
-- Company: Student(RIT)
-- Engineer: Aden Crimmins
-- 
-- Create Date: 03/18/2021 08:01:03 AM
-- Design Name: MIPS Excecution
-- Module Name: Multiplier - Behavioral
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
use IEEE . NUMERIC_STD .ALL;

entity Multiplier is
    GENERIC ( N : INTEGER := 32) ; --bit width
    Port (  A, B : IN std_logic_vector ( (N/2)-1 downto 0);
            Product : OUT std_logic_vector ( N-1 downto 0)
    );
end Multiplier;

architecture Structural of Multiplier is
type N_array is array (0 to (N/2)-2) of std_logic_vector(0 to (N/2)-1); 
type sum_array is array (0 to (N/2)-1) of std_logic_vector(0 to (N/2)-1);
    signal S, C, AandB: sum_array := ( others => ( others => '0'));
    --signal AandB: N_array := ( others => ( others => '0'));
    Component OneBitFullAdder is
        PORT (
            signal A, B, Cin : in STD_LOGIC; 
   		    signal S, Cout   : out STD_LOGIC);
    end Component ;
begin
--    Carry: for i in 0 to ((N/2) - 1) generate
--        C(i)(0) <= '0';
--    end generate;
    Product(0) <= AandB(0)(0);
    
    FullAdderCreator: for row in 0 to ((N/2)-1) generate
        Individual : for col in 0 to ((N/2) - 1) generate
            -- Equivalent to having a row 0
            AandB(row)(col) <= A(col) and B(row);
            
            --Generation of Row 1
            R1C0: if (col = 0 and row = 1) generate
                FullAddN: OneBitFullAdder PORT MAP(A => AandB(row)(col), B => AandB(row-1)(col+1), Cin => '0', S => S(row)(col), Cout =>C(row)(col)); 
                Product(row) <= S(row)(0);
            end generate;
            R1CMid:  if (col > 0 and col < (N/2)-1 and row = 1) generate
                FullAddN: OneBitFullAdder PORT MAP(A => AandB(row)(col), B => AandB(row-1)(col+1), Cin => C(row)(col-1), S => S(row)(col), Cout =>C(row)(col));
            end generate;
            R1Cend:  if (col = (N/2)-1 and row = 1) generate
                FullAddN: OneBitFullAdder PORT MAP(A => AandB(row)(col), B => '0', Cin => C(row)(col-1), S => S(row)(col), Cout =>C(row)(col));
            end generate;  
            
            -- Generation of row < N-1 Rows
            RNC0: if (col = 0 and row > 1 and row < (N/2)-1) generate
                FullAddN: OneBitFullAdder PORT MAP(A => AandB(row)(col), B => S(row-1)(col+1), Cin => '0', S => S(row)(col), Cout =>C(row)(col)); 
                Product(row) <= S(row)(0);
            end generate;
            RNCMid:  if (col > 0 and col < (N/2)-1 and row > 1 and row < (N/2)-1) generate
                FullAddN: OneBitFullAdder PORT MAP(A => AandB(row)(col), B => S(row-1)(col+1), Cin => C(row)(col-1), S => S(row)(col), Cout =>C(row)(col));
            end generate;
            RNCend:  if (col = (N/2)-1 and row > 1 and row < (N/2)-1) generate
                FullAddN: OneBitFullAdder PORT MAP(A => AandB(row)(col), B => C(row-1)(col), Cin => C(row)(col-1), S => S(row)(col), Cout =>C(row)(col));
            end generate; 
            
            -- Generation of the last Row
            RendC0: if (col = 0 and row = (N/2)-1) generate
                FullAddN: OneBitFullAdder PORT MAP(A => AandB(row)(col), B => S(row-1)(col+1), Cin => '0', S => S(row)(col), Cout =>C(row)(col)); 
                Product(row) <= S(row)(0);
            end generate;
            RendCMid:  if (col > 0 and col < (N/2)-1 and row = (N/2)-1) generate
                FullAddN: OneBitFullAdder PORT MAP(A => AandB(row)(col), B => S(row-1)(col+1), Cin => C(row)(col-1), S => S(row)(col), Cout =>C(row)(col));
                Product(row + col) <= S(row)(col);
            end generate;
            RendCend:  if (col = ((N/2)-1) and row = (N/2)-1) generate
                FullAddN: OneBitFullAdder PORT MAP(A => AandB(row)(col), B => C(row-1)(col), Cin => C(row)(col-1), S => S(row)(col), Cout =>C(row)(col));
                Product(row + col) <= S(row)(col);
                Product(N-1) <= C(row)(col);
            end generate; 
        end generate;
    end generate; 


end Structural;
