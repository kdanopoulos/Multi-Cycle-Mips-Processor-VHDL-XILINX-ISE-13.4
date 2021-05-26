----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:40:57 05/16/2021 
-- Design Name: 
-- Module Name:    Or_Gate - Behavioral 
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

entity Or_Gate is
    Port ( Input_1 : in  STD_LOGIC;
           Input_2 : in  STD_LOGIC;
           Input_3 : in  STD_LOGIC;
           Output : out  STD_LOGIC);
end Or_Gate;

architecture Behavioral of Or_Gate is

begin

Output <= Input_1 or Input_2 or Input_3 after 2ns;

end Behavioral;

