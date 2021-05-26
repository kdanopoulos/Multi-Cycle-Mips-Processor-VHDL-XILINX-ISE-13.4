----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:43:54 04/03/2021 
-- Design Name: 
-- Module Name:    Immed_handler - Behavioral 
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

entity Immed_handler is
    Port ( immediate : in  STD_LOGIC_VECTOR (15 downto 0);
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
           immediate_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  clk : in STD_LOGIC);
end Immed_handler;

architecture Behavioral of Immed_handler is

begin

Immed_proc: process (immediate, ImmExt,clk)
	begin
		immediate_out <= "00000000000000000000000000000000";
		if(CLK='1') then
			case ImmExt is 
				when "01" => -- sign extension
					immediate_out <= immediate(15) & immediate(15) & immediate(15) & immediate(15) & immediate(15) & immediate(15) & immediate(15) & immediate(15) 
					& immediate(15) & immediate(15) & immediate(15) & immediate(15) & immediate(15) & immediate(15) & immediate(15) & immediate(15) & immediate;
				when "10" =>
					immediate_out <= "0000000000000000" & immediate; --zero fill
				when "11"  => 
					immediate_out <= immediate & "0000000000000000"; -- shift 16 and zero fill
				when others => immediate_out <= "00000000000000000000000000000000";
			end case;
		end if;
	end process;


end Behavioral;

