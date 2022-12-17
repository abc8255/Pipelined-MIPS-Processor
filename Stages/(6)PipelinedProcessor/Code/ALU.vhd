----------------------------------------------------------------------------------
-- Company: Student(RIT)
-- Engineer: Aden Crimmins
-- 
-- Create Date: 03/18/2021 08:01:03 AM
-- Design Name: MIPS Excecution
-- Module Name: ALU - Behavioral
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

entity ALU is
 GENERIC ( N : INTEGER := 32) ; --bit width
 Port (in1, in2 : IN std_logic_vector ( N-1 downto 0 );
       control : IN std_logic_vector ( 3 downto 0);
       out1 : OUT std_logic_vector ( N-1 downto 0 ) 
        );
end ALU;

architecture structural of ALU is
-- Declare the inverter component
    Component notN is
        GENERIC ( N : INTEGER := N) ; -- bit width
        PORT (
            A : IN std_logic_vector (N -1 downto 0) ;
            Y : OUT std_logic_vector (N -1 downto 0)
        ) ;
    end Component ;
-- Declare the OR component
    Component orN is
        GENERIC ( N : INTEGER := N) ; -- bit width
        PORT (
            A,B : IN std_logic_vector (N -1 downto 0) ;
            Y : OUT std_logic_vector (N -1 downto 0)
        ) ;
    end Component ;
-- Declare the AND component
    Component andN is
        GENERIC ( N : INTEGER := N) ; -- bit width
        PORT (
            A,B : IN std_logic_vector (N -1 downto 0) ;
            Y : OUT std_logic_vector (N -1 downto 0)
        ) ;
    end Component ;
-- Declare the XOR component
    Component xorN is
        GENERIC ( N : INTEGER := N) ; -- bit width
        PORT (
            A,B : IN std_logic_vector (N -1 downto 0) ;
            Y : OUT std_logic_vector (N -1 downto 0)
        ) ;
    end Component ;
-- Declare the shift left component
    Component sllN is
        GENERIC ( N : INTEGER := N) ; --bit width
        PORT (
            A : IN std_logic_vector (N -1 downto 0) ;
            SHIFT_AMT : IN std_logic_vector (N -1 downto 0) ;
            Y : OUT std_logic_vector (N -1 downto 0)
        ) ;
    end Component ;
-- Declare the shift right component
    Component srlN is
        GENERIC ( N : INTEGER := N) ; --bit width
        PORT (
            A : IN std_logic_vector (N -1 downto 0) ;
            SHIFT_AMT : IN std_logic_vector (N -1 downto 0) ;
            Y : OUT std_logic_vector (N -1 downto 0)
        ) ;
    end Component ;
-- Declare the arithmetic shift right component
    Component sraN is
        GENERIC ( N : INTEGER := N) ; --bit width
        PORT (
            A : IN std_logic_vector (N -1 downto 0) ;
            SHIFT_AMT : IN std_logic_vector (N -1 downto 0) ;
            Y : OUT std_logic_vector (N -1 downto 0)
        ) ;
    end Component ;
-- Declare the RCFAdder Component    
    Component RCFAdder is
        GENERIC ( N : INTEGER := N) ; --bit width
        PORT (
            A, B : IN std_logic_vector (N -1 downto 0) ;
            OP : IN std_logic ;
            Sum : OUT std_logic_vector (N -1 downto 0)
        ) ;
    end Component ;    
    Component Multiplier is
    GENERIC ( N : INTEGER := 32) ; --bit width
    Port (  A, B : IN std_logic_vector ( (N/2)-1 downto 0);
            Product : OUT std_logic_vector ( N-1 downto 0)
    );
    end Component;
    signal not_result : std_logic_vector (N-1 downto 0) ;
    signal or_result : std_logic_vector (N-1 downto 0) ;
    signal and_result : std_logic_vector (N-1 downto 0) ;
    signal xor_result : std_logic_vector (N-1 downto 0) ;
    signal sll_result : std_logic_vector (N-1 downto 0) ;
    signal srl_result : std_logic_vector (N-1 downto 0) ;
    signal sra_result : std_logic_vector (N-1 downto 0) ;
    signal multu_result : std_logic_vector (N-1 downto 0) ;
    signal add_result : std_logic_vector (N-1 downto 0) ;
    signal no_result : std_logic_vector (N-1 downto 0) ;
    signal mul_input1, mul_input2 :  std_logic_vector (((n/2)-1) downto 0);
    
begin
    mul_input1 <= in1(((n/2)-1) downto 0);
    mul_input2 <= in2(((n/2)-1) downto 0);
    no_result <= in1;
    -- Instantiate the inverter
    not_comp : notN
        generic map ( N => N)
        port map ( A => in1 , Y => not_result ) ;
    -- Instantiate the OR
    or_comp : orN
        generic map ( N => N)
        port map ( A => in1, B => in2 , Y => or_result ) ;
    -- Instantiate the AND
    and_comp : andN
        generic map ( N => N)
        port map ( A => in1, B => in2 , Y => and_result ) ;
    -- Instantiate the XOR
    xor_comp : xorN
        generic map ( N => N)
        port map ( A => in1, B => in2 , Y => xor_result ) ;    
    -- Instantiate the SLL unit
    sll_comp : sllN
        generic map ( N => N)
        port map ( A => in1 , SHIFT_AMT => in2 , Y => sll_result ) ;
    -- Instantiate the SRL unit
    srl_comp : srlN
        generic map ( N => N)
        port map ( A => in1 , SHIFT_AMT => in2 , Y => srl_result ) ;
    -- Instantiate the SRA unit
    sra_comp : sraN
        generic map ( N => N)
        port map ( A => in1 , SHIFT_AMT => in2 , Y => sra_result ) ;
    add_comp : RCFAdder
        generic map ( N => N)
        port map ( A => in1 , B => in2, OP => Control(0), Sum => add_result ) ;
    mul_comp : Multiplier
        generic map ( N => N)
        port map( A => mul_input1, B => mul_input2, Product => multu_result );
    
    -- Use control to control which operation to show / perform
    out1 <= or_result when control = "1000" else-- OR
            xor_result when control = "1011" else-- XOR
            sll_result when control = "1100" else-- SLL
            srl_result when control = "1101" else-- SRL
            sra_result when control = "1110" else-- SRA
            multu_result when control = "0110" else-- MULTU
            add_result when control = "0100" else-- ADD
            add_result when control = "0101" else-- SUB
            not_result when control = "1111" else -- NOT
            and_result when control = "1010" else -- AND
            and_result; --NO_OP
end structural;
