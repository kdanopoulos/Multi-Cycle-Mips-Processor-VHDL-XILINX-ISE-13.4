----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:02:43 04/10/2021 
-- Design Name: 
-- Module Name:    Immediate_Converter - Behavioral 
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

entity Immediate_Converter is
    Port ( Input : in  STD_LOGIC_VECTOR (15 downto 0);
           Output : out  STD_LOGIC_VECTOR (31 downto 0));
end Immediate_Converter;

architecture Behavioral of Immediate_Converter is

begin
process(Input)
begin
	
	Output <= Input(15) & Input(15) & Input(15) & Input(15) & Input(15) & Input(15) & Input(15) & Input(15) 
					& Input(15) & Input(15) & Input(15) & Input(15) & Input(15) & Input(15) & Input & "00"; -- Sign Extend(Imm) << 2 = Sign Extend(Imm)*4
	
end process;

end Behavioral;

