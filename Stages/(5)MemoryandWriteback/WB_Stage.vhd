-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Aden Crimmins (abc8255@rit.edu)
--
-- Create Date : 4-6-21
-- Design Name : Writeback_Stage
-- Module Name : Writeback_Stage - behavioral
-- Project Name : Lab5
-- Target Devices : Basys3
--
-- Description : data memory unit
-- ----------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Writeback_Stage is
Port (  WriteReg : IN std_logic_vector (4 downto 0);
        RegWrite, MemtoReg : IN std_logic;
        RegData, MemData : IN std_logic_vector (31 downto 0); -- MemData = ReadData
        Result : OUT std_logic_vector (31 downto 0);
        WriteRegOut : OUT std_logic_vector (4 downto 0);
        WbEn : OUT std_logic
);
end Writeback_Stage;

architecture Behavioral of Writeback_Stage is    
     
begin
    WriteRegOut <= WriteReg;
    WbEn <= NOT RegWrite;
    
    MemRead : process (MemtoReg, MemData, RegData) is begin
        if (MemtoReg = '1') then
            Result <= MemData;
        else
            Result <= RegData;
        end if;
    end process;


end Behavioral;
