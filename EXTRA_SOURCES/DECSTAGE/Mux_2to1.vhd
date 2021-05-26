----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:24:34 04/02/2021 
-- Design Name: 
-- Module Name:    Mux_2to1 - Behavioral 
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

entity Mux_2to1 is
	Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
           In1 : in  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR (31 downto 0));
end Mux_2to1;

architecture Behavioral of Mux_2to1 is

begin

Mux_2to1_proc: process (Sel, In0, In1)
	begin
		case Sel is 
			when '0' => Output <= In0 after 5ns;--10ns;
			when '1' => Output <= In1 after 5ns;--10ns;
			when others => Output <= "00000000000000000000000000000000" after 5ns;--10ns
		end case;
	end process;


end Behavioral;

