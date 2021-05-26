----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:12:46 04/02/2021 
-- Design Name: 
-- Module Name:    RF - Behavioral 
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

entity RF is
	Port ( Adr1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Adr2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
			  Rst : in STD_LOGIC);
end RF;


architecture Structural of RF is
	COMPONENT Dec_5to32
	PORT ( Input : in  STD_LOGIC_VECTOR (4 downto 0);
           Output : out  STD_LOGIC_VECTOR (31 downto 0));
   END COMPONENT;
   
   COMPONENT Reg is
	PORT ( Datain : in  STD_LOGIC_VECTOR (31 downto 0);
           Dataout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE,CLK,RST : in  STD_LOGIC);
	END COMPONENT;
	
	COMPONENT Mux_32to1 is
	PORT ( In0 : in STD_LOGIC_VECTOR (31 downto 0);
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
	END COMPONENT;
	
	signal unused_signal : std_logic;
	signal temp_dec_out,temp_we : std_logic_vector (31 downto 1);
	type array_type is array (0 to 31) of std_logic_vector (31 downto 0);
	signal array_Dout_Reg : array_type;

begin
	Dec: Dec_5to32 PORT MAP (
		Input => Awr,
		Output(0) => unused_signal,
		Output(31 downto 1) => temp_dec_out);
		
	Reg0: Reg PORT MAP (
		RST => Rst,
		CLK => clk,
		WE => '1',
		Dataout => array_Dout_Reg(0),
		Datain => (31 downto 0 => '0'));
		
	generate_loop: For i in 1 to 31 generate
		temp_we(i) <= temp_dec_out(i) and WrEn;-- after 2ns;
		My_Reg: Reg PORT MAP (
		RST => Rst,
		CLK => clk,
		WE => temp_we(i),
		Dataout => array_Dout_Reg(i),
		Datain => Din);
	end generate;
	
	My_Mux_32to1_1: Mux_32to1 port map (
	   In0 => array_Dout_Reg(0),
	   In1 => array_Dout_Reg(1), 
	   In2 => array_Dout_Reg(2),
	   In3 => array_Dout_Reg(3),
	   In4 => array_Dout_Reg(4),
	   In5 => array_Dout_Reg(5),
	   In6 => array_Dout_Reg(6),
	   In7 => array_Dout_Reg(7),
	   In8 => array_Dout_Reg(8),
	   In9 => array_Dout_Reg(9),
	   In10 => array_Dout_Reg(10),
	   In11 => array_Dout_Reg(11),
	   In12 => array_Dout_Reg(12),
	   In13 => array_Dout_Reg(13),
	   In14 => array_Dout_Reg(14),
	   In15 => array_Dout_Reg(15),
	   In16 => array_Dout_Reg(16),
	   In17 => array_Dout_Reg(17),
	   In18 => array_Dout_Reg(18),
	   In19 => array_Dout_Reg(19),
	   In20 => array_Dout_Reg(20),
	   In21 => array_Dout_Reg(21),
	   In22 => array_Dout_Reg(22),
	   In23 => array_Dout_Reg(23),
	   In24 => array_Dout_Reg(24),
	   In25 => array_Dout_Reg(25),
	   In26 => array_Dout_Reg(26),
	   In27 => array_Dout_Reg(27),
	   In28 => array_Dout_Reg(28),
	   In29 => array_Dout_Reg(29),
	   In30 => array_Dout_Reg(30),
	   In31 => array_Dout_Reg(31),
	   Output => Dout1,
       Sel => Adr1); 

	My_Mux_32to1_2: Mux_32to1 port map (
	   In0 => array_Dout_Reg(0),
	   In1 => array_Dout_Reg(1), 
	   In2 => array_Dout_Reg(2),
	   In3 => array_Dout_Reg(3),
	   In4 => array_Dout_Reg(4),
	   In5 => array_Dout_Reg(5),
	   In6 => array_Dout_Reg(6),
	   In7 => array_Dout_Reg(7),
	   In8 => array_Dout_Reg(8),
	   In9 => array_Dout_Reg(9),
	   In10 => array_Dout_Reg(10),
	   In11 => array_Dout_Reg(11),
	   In12 => array_Dout_Reg(12),
	   In13 => array_Dout_Reg(13),
	   In14 => array_Dout_Reg(14),
	   In15 => array_Dout_Reg(15),
	   In16 => array_Dout_Reg(16),
	   In17 => array_Dout_Reg(17),
	   In18 => array_Dout_Reg(18),
	   In19 => array_Dout_Reg(19),
	   In20 => array_Dout_Reg(20),
	   In21 => array_Dout_Reg(21),
	   In22 => array_Dout_Reg(22),
	   In23 => array_Dout_Reg(23),
	   In24 => array_Dout_Reg(24),
	   In25 => array_Dout_Reg(25),
	   In26 => array_Dout_Reg(26),
	   In27 => array_Dout_Reg(27),
	   In28 => array_Dout_Reg(28),
	   In29 => array_Dout_Reg(29),
	   In30 => array_Dout_Reg(30),
	   In31 => array_Dout_Reg(31),
	   Output => Dout2,
	   Sel => Adr2); 

	
end Structural;
