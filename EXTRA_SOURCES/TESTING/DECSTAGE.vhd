----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:05:36 04/03/2021 
-- Design Name: 
-- Module Name:    DECSTAGE - Behavioral 
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

entity DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
           Clk : in  STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
			  Reset : in  STD_LOGIC);
end DECSTAGE;

architecture Structural of DECSTAGE is
	component Immed_handler is
	Port ( immediate : in  STD_LOGIC_VECTOR (15 downto 0);
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
           immediate_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  clk : in STD_LOGIC);
	end component;
	
	component Mux_2to1 is
	Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
           In1 : in  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component Mux_2to1_5bits is
	Port ( In0 : in  STD_LOGIC_VECTOR (4 downto 0);
           In1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Sel : in  STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR (4 downto 0));
	end component;
	
	
	component RF is
	Port ( Adr1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Adr2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
			  Rst : in STD_LOGIC);
	end component;
	
	signal mux_temp_out1 : STD_LOGIC_VECTOR (4 downto 0);
	signal mux_temp_out2 : STD_LOGIC_VECTOR (31 downto 0);

begin

	my_immed_handler : Immed_handler PORT MAP (
	immediate => Instr(15 downto 0),
	ImmExt => ImmExt,
	immediate_out => Immed,
	clk => Clk);

	my_rf: RF PORT MAP(
	Adr1 => Instr(25 downto 21), -- always the 1st register is [rs] = Instr(25-21)
	Adr2 => mux_temp_out1, -- 2nd register =  [rt](RF_B_sel = 0) or [rd](RF_B_sel = 1)
	Awr => Instr(20 downto 16), -- always [rd] = Instr(20-16)
	Dout1 => RF_A,
	Dout2 => RF_B,
	Din => mux_temp_out2,
	WrEn => RF_WrEn, -- here is write enable for RF
	Clk => Clk,
	Rst => Reset);
	
	my_mux_1 : Mux_2to1_5bits PORT MAP(
	In0 => Instr(15 downto 11),
	In1 => Instr(20 downto 16),
	Sel => RF_B_sel,
	Output => mux_temp_out1);
	
	my_mux_2 : Mux_2to1 PORT MAP(
	In0 => ALU_out,
	In1 => MEM_out,
	Sel => RF_WrData_sel,
	Output => mux_temp_out2);


end Structural;

