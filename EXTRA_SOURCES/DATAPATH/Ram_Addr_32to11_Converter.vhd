----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:30:44 04/10/2021 
-- Design Name: 
-- Module Name:    Ram_Addr_32to11_Converter - Behavioral 
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

entity Ram_Addr_32to11_Converter is
    Port ( Input : in  STD_LOGIC_VECTOR (31 downto 0);
           Output : out  STD_LOGIC_VECTOR (10 downto 0));
end Ram_Addr_32to11_Converter;

architecture Behavioral of Ram_Addr_32to11_Converter is

begin

process(Input)
variable outputv: STD_LOGIC_VECTOR (10 downto 0);
begin
	
	outputv := Input(12 downto 2);
	
	Output <= outputv;
	
end process;

end Behavioral;

