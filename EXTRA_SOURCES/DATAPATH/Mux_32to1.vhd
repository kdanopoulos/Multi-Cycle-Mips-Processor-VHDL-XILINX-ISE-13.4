----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:04:33 04/02/2021 
-- Design Name: 
-- Module Name:    Mux_32to1 - Behavioral 
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

entity Mux_32to1 is
	Port ( In0 : in STD_LOGIC_VECTOR (31 downto 0);
		   In1 : in STD_LOGIC_VECTOR (31 downto 0);
		   In2 : in STD_LOGIC_VECTOR (31 downto 0);
		   In3 : in STD_LOGIC_VECTOR (31 downto 0);
		   In4 : in STD_LOGIC_VECTOR (31 downto 0);
		   In5 : in STD_LOGIC_VECTOR (31 downto 0);
		   In6 : in STD_LOGIC_VECTOR (31 downto 0);
		   In7 : in STD_LOGIC_VECTOR (31 downto 0);
	      In8 : in STD_LOGIC_VECTOR (31 downto 0);
		   In9 : in STD_LOGIC_VECTOR (31 downto 0);
	      In10 : in STD_LOGIC_VECTOR (31 downto 0);
	      In11 : in STD_LOGIC_VECTOR (31 downto 0);
	      In12 : in STD_LOGIC_VECTOR (31 downto 0);
	      In13 : in STD_LOGIC_VECTOR (31 downto 0);
	      In14 : in STD_LOGIC_VECTOR (31 downto 0);
	      In15 : in STD_LOGIC_VECTOR (31 downto 0);
	      In16 : in STD_LOGIC_VECTOR (31 downto 0);
	      In17 : in STD_LOGIC_VECTOR (31 downto 0);
	      In18 : in STD_LOGIC_VECTOR (31 downto 0);
	      In19 : in STD_LOGIC_VECTOR (31 downto 0);
	      In20 : in STD_LOGIC_VECTOR (31 downto 0);
	      In21 : in STD_LOGIC_VECTOR (31 downto 0);
		   In22 : in STD_LOGIC_VECTOR (31 downto 0);
		   In23 : in STD_LOGIC_VECTOR (31 downto 0);
		   In24 : in STD_LOGIC_VECTOR (31 downto 0);
		   In25 : in STD_LOGIC_VECTOR (31 downto 0);
		   In26 : in STD_LOGIC_VECTOR (31 downto 0);
		   In27 : in STD_LOGIC_VECTOR (31 downto 0);
		   In28 : in STD_LOGIC_VECTOR (31 downto 0);
		   In29 : in STD_LOGIC_VECTOR (31 downto 0);
		   In30 : in STD_LOGIC_VECTOR (31 downto 0);
		   In31 : in STD_LOGIC_VECTOR (31 downto 0);
		   Output : out  STD_LOGIC_VECTOR (31 downto 0);
         Sel : in  STD_LOGIC_VECTOR (4 downto 0));
end Mux_32to1;

architecture Behavioral of Mux_32to1 is

begin


Mux_32to1_proc: process (Sel, In0, In1, In2, In3, In4, In5, In6, In7, In8, In9, In10, 
	In11, In12, In13, In14, In15, In16, In17, In18, In19, In20, In21, In22, In23, In24, In25, In26,
	In27, In28, In29, In30, In31)
	begin
		case Sel is 
			when "00000" => Output <= In0 after 5ns;--10ns;
			when "00001" => Output <= In1 after 5ns;--10ns;
			when "00010" => Output <= In2 after 5ns;--10ns;
			when "00011" => Output <= In3 after 5ns;--10ns;
			when "00100" => Output <= In4 after 5ns;--10ns;
			when "00101" => Output <= In5 after 5ns;--10ns;
			when "00110" => Output <= In6 after 5ns;--10ns;
			when "00111" => Output <= In7 after 5ns;--10ns;
			when "01000" => Output <= In8 after 5ns;--10ns;
			when "01001" => Output <= In9 after 5ns;--10ns;
			when "01010" => Output <= In10 after 5ns;--10ns;
			when "01011" => Output <= In11 after 5ns;--10ns;
			when "01100" => Output <= In12 after 5ns;--10ns;
			when "01101" => Output <= In13 after 5ns;--10ns;
			when "01110" => Output <= In14 after 5ns;--10ns;
			when "01111" => Output <= In15 after 5ns;--10ns;
			when "10000" => Output <= In16 after 5ns;--10ns;
			when "10001" => Output <= In17 after 5ns;--10ns;
			when "10010" => Output <= In18 after 5ns;--10ns;
			when "10011" => Output <= In19 after 5ns;--10ns;
			when "10100" => Output <= In20 after 5ns;--10ns;
			when "10101" => Output <= In21 after 5ns;--10ns;
			when "10110" => Output <= In22 after 5ns;--10ns;
			when "10111" => Output <= In23 after 5ns;--10ns;
			when "11000" => Output <= In24 after 5ns;--10ns;
			when "11001" => Output <= In25 after 5ns;--10ns;
			when "11010" => Output <= In26 after 5ns;--10ns;
			when "11011" => Output <= In27 after 5ns;--10ns;
			when "11100" => Output <= In28 after 5ns;--10ns;
			when "11101" => Output <= In29 after 5ns;--10ns;
			when "11110" => Output <= In30 after 5ns;--10ns;
			when "11111" => Output <= In31 after 5ns;--10ns;
			when others => Output <= "00000000000000000000000000000000" after 5ns;--10ns;
		end case;
	end process;


end Behavioral;

