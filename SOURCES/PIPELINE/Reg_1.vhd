----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:50:34 05/09/2021 
-- Design Name: 
-- Module Name:    Reg_1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reg_1 is
    Port ( Datain : in  STD_LOGIC;
           Dataout : out  STD_LOGIC;
           WE : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC);
end Reg_1;

architecture Behavioral of Reg_1 is

begin

process_Reg: process(CLK,RST,WE,Datain)
begin
	if CLK = '1' then
		if RST = '1' then 
			Dataout <= '0';
		elsif WE = '1' then
			 Dataout <= Datain;
		end if;
	end if;	
end process process_Reg;


end Behavioral;

