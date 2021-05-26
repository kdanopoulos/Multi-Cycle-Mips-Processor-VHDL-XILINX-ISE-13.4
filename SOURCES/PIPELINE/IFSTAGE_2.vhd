----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:02:41 05/09/2021 
-- Design Name: 
-- Module Name:    IFSTAGE_2 - Behavioral 
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

entity IFSTAGE_2 is
Port ( 	 Branch_addr : in STD_LOGIC_VECTOR (31 downto 0);
			 PC_sel : in  STD_LOGIC;
          PC_LdEn : in  STD_LOGIC;
          Reset : in  STD_LOGIC;
          Clk : in  STD_LOGIC;
			 Reg_WE: in STD_LOGIC;
          PC_out : inout  STD_LOGIC_VECTOR (31 downto 0);
			 Instr : in  STD_LOGIC_VECTOR (31 downto 0);
			 Instr_reg_out : out  STD_LOGIC_VECTOR (31 downto 0);
			 PC_plus_4_reg_out : out  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE_2;

architecture Structural of IFSTAGE_2 is
	Component IF_DEC_REG is
		Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
				 PC_plus_4 : in  STD_LOGIC_VECTOR (31 downto 0);
				 Reset: in STD_LOGIC;
			    WE: in STD_LOGIC;
			    CLK : in STD_LOGIC;
             Instr_out : out  STD_LOGIC_VECTOR (31 downto 0);
             PC_plus_4_out : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	Component adder is
		Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
			    In1 : in  STD_LOGIC_VECTOR (31 downto 0);
             Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	COMPONENT Reg is
	Port ( Datain : in  STD_LOGIC_VECTOR (31 downto 0);
          Dataout : out  STD_LOGIC_VECTOR (31 downto 0);
          WE,CLK,RST : in  STD_LOGIC);
	END COMPONENT;
	
	component Mux_2to1 is
	Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
          In1 : in  STD_LOGIC_VECTOR (31 downto 0);
          Sel : in  STD_LOGIC;
          Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	
	signal temp_out_mux,temp_out_plus4 : STD_LOGIC_VECTOR (31 downto 0);
begin

	PC: Reg PORT MAP (
		RST => Reset,
		Datain => temp_out_mux,
		WE => PC_LdEn,
		Dataout => PC_out,
		CLK => Clk);
	
	plus4_adder : adder PORT MAP (
		In0 => PC_out,
		In1 => "00000000000000000000000000000100", -- number 4
		Output => temp_out_plus4);
		
	my_mux_2to1: Mux_2to1 PORT MAP (
		In0 => temp_out_plus4,
		In1 => Branch_addr,
		Sel => PC_sel,
		Output => temp_out_mux);
		
  my_IF_DEC_REG: IF_DEC_REG PORT MAP(
		Instr => Instr,
		PC_plus_4 => temp_out_plus4,
		Reset => Reset,
		WE => Reg_WE,
		CLK => Clk,
      Instr_out => Instr_reg_out,
      PC_plus_4_out => PC_plus_4_reg_out);		
	
end Structural;

