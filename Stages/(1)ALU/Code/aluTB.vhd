-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Aden Crimmins ( abc8255@rit.edu)
--
-- Create Date : 2-02-21
-- Design Name : aluTB
-- Module Name : aluTB - behavioral
-- Project Name : tester
--
-- Description : Test bench for Partial 32 - bit ALU
-- ----------------------------------------------------
library IEEE ;
use IEEE . STD_LOGIC_1164 .ALL ;
use IEEE . NUMERIC_STD .ALL;
entity aluTB is
end aluTB ;
architecture Behavioral of aluTB is
-- Declare the ALU component
    Component alu32 is
        PORT (
            A : IN std_logic_vector (31 downto 0) ;
            B : IN std_logic_vector (31 downto 0) ;
            OP : IN std_logic_vector (3 downto 0) ;
            Y : OUT std_logic_vector (31 downto 0)
        ) ;
    end Component ;
    constant delay : time := 20 ns ;
    signal A , B , Y : std_logic_vector (31 downto 0) := ( others => '0') ;
    signal OP : std_logic_vector (3 downto 0) := "0000";
begin
    -- Instantiate an instance of the ALU
    alu_inst : alu32 PORT MAP (
        A => A ,
        B => B ,
        OP => OP ,
        Y => Y
    ) ;
    
    data_proc : process is
    begin
    wait for delay ; 
    --testing the SRL
    A <= x"00000006" ;
    B <= x"00000002" ;
    OP <= "1101" ;
    wait for delay ;
    --Testing the SRA
    B <= std_logic_vector ( unsigned ( B ) - 1) ;
    OP <= "1110" ;
    wait for delay ;
    B <= std_logic_vector ( unsigned ( B ) + 1) ;
    wait for delay ;
    A <= x"F0000000" ;
    B <= std_logic_vector ( unsigned ( B ) - 1) ;
    wait for delay ;
    --testing the OR
    A <= x"00000000" ;
    B <= x"00000000" ;
    OP <= "1000" ;
    wait for delay ;
    B <= x"0000000F" ;
    wait for delay ;
    A <= x"0000000F" ;
    wait for delay ;
    A <= x"00000005" ;
    B <= x"0000000A" ;
    wait for delay ;
    A <= x"0000000A" ;
    B <= x"00000005" ;
    wait for delay ;
    --Testing the XOR
    A <= x"00000000" ;
    B <= x"00000000" ;
    OP <= "1011" ;
    wait for delay ;
    B <= x"0000000F" ;
    wait for delay ;
    A <= x"0000000F" ;
    B <= x"00000000" ;
    wait for delay ;
    B <= x"0000000F" ;
    wait for delay ;
    A <= x"00000005" ;
    B <= x"0000000A" ;
    wait for delay ;
    A <= x"0000000A" ;
    B <= x"00000005" ;
    wait for delay ;
    --Testing the AND
    A <= x"00000000" ;
    B <= x"00000000" ;
    OP <= "1010" ;
    wait for delay ;
    B <= x"0000000F" ;
    wait for delay ;
    A <= x"0000000F" ;
    B <= x"00000000" ;
    wait for delay ;
    B <= x"0000000F" ;
    wait for delay ;
    A <= x"00000000" ;
    B <= x"00000000" ;
    --General OR Tests
    OP <= "1000" ;
    for i in 0 to 1 loop
        A <= std_logic_vector ( unsigned ( A ) + i);
        for j in 0 to 1 loop
            wait for delay ;
            B <= std_logic_vector (( unsigned ( B ) + j) mod 4) ;
        end loop ;
        B <= x"00000000" ;
    end loop ;
    --General AND Tests
    OP <= "1010" ;
    for i in 0 to 1 loop
        A <= std_logic_vector ( unsigned ( A ) + i);
        for j in 0 to 1 loop
            wait for delay ;
            B <= std_logic_vector (( unsigned ( B ) + j) mod 4) ;
        end loop ;
        B <= x"00000000" ;
    end loop ;
    --General XOR Tests
    OP <= "1011" ;
    for i in 0 to 1 loop
        A <= std_logic_vector ( unsigned ( A ) + i);
        for j in 0 to 1 loop
            wait for delay ;
            B <= std_logic_vector (( unsigned ( B ) + j) mod 4) ;
        end loop ;
        B <= x"00000000" ;
    end loop ;
    --testing SLL
    OP <= "1100" ;
    for j in 0 to 3 loop
    A <= x"0000000F";
        wait for delay ;
        B <= std_logic_vector (( unsigned ( B ) + j) mod 4) ;
    end loop ;
    B <= x"00000000" ;
    --testing SRL
    OP <= "1101" ;
    for j in 0 to 3 loop
    A <= x"0000000F";
        wait for delay ;
        B <= std_logic_vector (( unsigned ( B ) + j) mod 4) ;
    end loop ;
    B <= x"00000000" ;
    --testing SRA
    OP <= "1110" ;
    for j in 0 to 3 loop
    A <= x"0000000F";
        wait for delay ;
        B <= std_logic_vector (( unsigned ( B ) + j) mod 4) ;
    end loop ;
    B <= x"00000000" ;
    wait ;
    
    end process ;
end Behavioral ;