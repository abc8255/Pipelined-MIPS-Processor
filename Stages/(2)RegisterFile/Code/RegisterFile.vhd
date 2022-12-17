-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Aden Crimmins (abc8255@rit.edu)
--
-- Create Date : 2-9-21
-- Design Name : RegisterFile
-- Module Name : RegisterFile - behavioral
-- Project Name : Lab2
-- Target Devices : Basys3
--
-- Description : Register File unit
-- ----------------------------------------------------
library IEEE ;
use IEEE . STD_LOGIC_1164 .ALL ;
use IEEE . NUMERIC_STD .ALL;
entity RegFile is
GENERIC ( BIT_WIDTH : INTEGER := 32;
 LOG_PORT_DEPTH : INTEGER := 5 ) ; --bit width
PORT (
    we ,clk_n : IN std_logic;
	Addr1, Addr2, Addr3 : IN std_logic_vector(4 downto 0);
	wd : IN std_logic_vector(BIT_WIDTH-1 downto 0);
	RD1, RD2 : OUT std_logic_vector(BIT_WIDTH-1 downto 0)
) ;
end RegFile ;

architecture behavioral of RegFile is
    type mem_array is array ((2**LOG_PORT_DEPTH)-1 downto 0) of std_logic_vector (BIT_WIDTH -1 downto 0) ;
    signal aMEM : mem_array := ( others => ( others => '0'));
begin
    
    RD1 <= aMEM(to_integer(unsigned(Addr1)));
    RD2 <= aMEM(to_integer(unsigned(Addr2))); 
    
    process (clk_n, we, Addr3, wd) is
        begin
        if (falling_edge (clk_n)) then
            if we = '1' then
                if (to_integer(unsigned(Addr3)) /= 0) then
                    aMEM(to_integer(unsigned(Addr3))) <= wd;
                end if;
            end if;
            
        end if;
    end process;

end architecture behavioral;