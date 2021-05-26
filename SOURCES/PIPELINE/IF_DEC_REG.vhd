----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:12:15 05/09/2021 
-- Design Name: 
-- Module Name:    IF_DEC_REG - Behavioral 
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

entity IF_DEC_REG is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_plus_4 : in  STD_LOGIC_VECTOR (31 downto 0);
			  Reset: in STD_LOGIC;
			  WE: in STD_LOGIC;
			  CLK : in STD_LOGIC;
           Instr_out : out  STD_LOGIC_VECTOR (31 downto 0);
           PC_plus_4_out : out  STD_LOGIC_VECTOR (31 downto 0));
end IF_DEC_REG;

architecture Structural of IF_DEC_REG is
	COMPONENT Reg_32 is
	Port ( Datain : in  STD_LOGIC_VECTOR (31 downto 0);
          Dataout : out  STD_LOGIC_VECTOR (31 downto 0);
          WE,CLK,RST : in  STD_LOGIC);
	END COMPONENT;

begin

	Instr_Reg: Reg_32 PORT MAP (
		RST => Reset,
		Datain => Instr,
		WE => WE,
		Dataout => Instr_out,
		CLK => Clk);
		
	PC_plus_4_Reg: Reg_32 PORT MAP (
		RST => Reset,
		Datain => PC_plus_4,
		WE => WE,
		Dataout => PC_plus_4_out,
		CLK => Clk);


end Structural;

