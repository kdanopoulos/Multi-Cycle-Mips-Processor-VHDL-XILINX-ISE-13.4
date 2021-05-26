----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:25:46 04/02/2021 
-- Design Name: 
-- Module Name:    IFSTAGE - Behavioral 
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

entity IFSTAGE is
	Port ( PC_Immed : in  STD_LOGIC_VECTOR (15 downto 0);
          PC_sel : in  STD_LOGIC;
          PC_LdEn : in  STD_LOGIC;
          Reset : in  STD_LOGIC;
          Clk : in  STD_LOGIC;
          PC_out : inout  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE;

architecture Structural of IFSTAGE is
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
	
	component Immediate_Converter is
	Port ( Input : in STD_LOGIC_VECTOR (15 downto 0);
			 Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	signal temp_out_mux, temp_out_plus4, temp_out_new_address,temp_out_immidiate_converter : STD_LOGIC_VECTOR (31 downto 0);
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
	
	my_immediate_converter : Immediate_Converter PORT MAP (
		Input => PC_Immed,
		Output => temp_out_immidiate_converter);
	
	new_addres_adder: adder PORT MAP (
		In0 => temp_out_immidiate_converter,
		In1 => temp_out_plus4,
		Output => temp_out_new_address);
		
	my_mux_2to1: Mux_2to1 PORT MAP (
		In0 => temp_out_plus4,
		In1 => temp_out_new_address,
		Sel => PC_sel,
		Output => temp_out_mux);			
	
end Structural;

