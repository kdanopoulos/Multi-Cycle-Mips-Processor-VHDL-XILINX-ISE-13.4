----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:11:39 04/02/2021 
-- Design Name: 
-- Module Name:    Reg - Behavioral 
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

entity Reg is
	Port ( Datain : in  STD_LOGIC_VECTOR (31 downto 0);
           Dataout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE,CLK,RST : in  STD_LOGIC);
end Reg;

architecture Behavioral of Reg is

begin

process_Reg: process(CLK)
begin
	if rising_edge(CLK) then
		if RST = '1' then Dataout <= (31 downto 0 => '0');
		--elsif WE = '1' then Dataout <= Datain;
		end if;
	else
		if WE = '1' then Dataout <= Datain;
		end if;
	end if;
end process process_Reg;


end Behavioral;

