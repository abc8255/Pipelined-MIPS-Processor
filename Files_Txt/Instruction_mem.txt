----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2021 12:44:39 PM
-- Design Name: 
-- Module Name: Instruction_mem - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE . NUMERIC_STD .ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instruction_mem is
PORT (
    Addr: IN std_logic_vector(27 downto 0);
	d_out : OUT std_logic_vector(31 downto 0)
) ;
end Instruction_mem;

architecture Behavioral of Instruction_mem is
    --creating the memory array to store the values
    type mem_array is array (0 to 1023) of std_logic_vector (7 downto 0) ;
    --initially flling the array with '0's to avoid null errors
    signal aMEM : mem_array := ( x"00", x"00", x"00", x"00",
    --setup and 1st 2 terms
     x"21", x"4A", x"00", x"01", 
     x"21", x"6B", x"00", x"01", 
     x"21", x"8C", x"00", x"02", 
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"AD", x"69", x"00", x"00", 
     x"AD", x"8A", x"00", x"00",  
     x"21", x"8C", x"00", x"01", 
     --term 3 
     x"01", x"2A", x"50", x"20", 
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"01", x"49", x"48", x"22",  
     x"AD", x"8A", x"00", x"00", 
     x"21", x"8C", x"00", x"01",
     --term 4
     x"01", x"2A", x"50", x"20", 
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"01", x"49", x"48", x"22",
     x"AD", x"8A", x"00", x"00", 
     x"21", x"8C", x"00", x"01",
     --term 5
     x"01", x"2A", x"50", x"20", 
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"01", x"49", x"48", x"22",
     x"AD", x"8A", x"00", x"00", 
     x"21", x"8C", x"00", x"01",
     --term 6 
     x"01", x"2A", x"50", x"20",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00", 
     x"01", x"49", x"48", x"22",
     x"AD", x"8A", x"00", x"00", 
     x"21", x"8C", x"00", x"01",
     --term 7 
     x"01", x"2A", x"50", x"20",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00", 
     x"01", x"49", x"48", x"22",
     x"AD", x"8A", x"00", x"00", 
     x"21", x"8C", x"00", x"01",
     --term 8 
     x"01", x"2A", x"50", x"20",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00", 
     x"01", x"49", x"48", x"22",
     x"AD", x"8A", x"00", x"00", 
     x"21", x"8C", x"00", x"01",
     --term 9 
     x"01", x"2A", x"50", x"20", 
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"01", x"49", x"48", x"22", 
     x"AD", x"8A", x"00", x"00", 
     x"21", x"8C", x"00", x"01",
     --term 10 
     x"01", x"2A", x"50", x"20",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00",
     x"00", x"00", x"00", x"00", 
     x"01", x"49", x"48", x"22", 
     x"AD", x"8A", x"00", x"00", 
     
     others => ( others => '0'));
begin
    -- Assigning the outputs based on the selects
    mem_process: process (Addr, aMEM) is begin
          if (Addr > 1023) then
            d_out <= (others => '0');
          elsif Addr = 1023 then
            d_out <= (aMEM(to_integer(unsigned(Addr))) & aMEM(to_integer(unsigned(Addr+1))) & 
          aMEM(0) & aMEM(1));
          elsif (Addr = 1022) then
            d_out <= (aMEM(to_integer(unsigned(Addr))) & aMEM(to_integer(unsigned(Addr+1))) & 
          aMEM(0) & aMEM(1));
          elsif (Addr = 1021) then
            d_out <= (aMEM(to_integer(unsigned(Addr))) & aMEM(to_integer(unsigned(Addr+1))) & 
          aMEM(to_integer(unsigned(Addr+2))) & aMEM(0));
          else
            d_out <= (aMEM(to_integer(unsigned(Addr))) & aMEM(to_integer(unsigned(Addr+1))) & 
          aMEM(to_integer(unsigned(Addr+2))) & aMEM(to_integer(unsigned(Addr+3))));
          end if;
    end process;
end Behavioral;
