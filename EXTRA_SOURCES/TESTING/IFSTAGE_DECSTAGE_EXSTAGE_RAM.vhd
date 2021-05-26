----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:31:03 04/21/2021 
-- Design Name: 
-- Module Name:    IFSTAGE_DECSTAGE_EXSTAGE_RAM - Behavioral 
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

entity IFSTAGE_DECSTAGE_EXSTAGE_RAM is
	PORT (
	CLK : in STD_LOGIC;
	Reset : in STD_LOGIC;
	PC_sel : in STD_LOGIC;
	PC_LdEn : in STD_LOGIC;
	RF_WrEn : in STD_LOGIC;
	RF_WrData_sel : in STD_LOGIC;
	RF_B_sel : in STD_LOGIC;
	ImmExt : in STD_LOGIC_VECTOR(1 downto 0);
	ALU_Bin_sel : in STD_LOGIC;
	ALU_func : in STD_LOGIC_VECTOR(3 downto 0);
	ALU_zero : out STD_LOGIC
	);
end IFSTAGE_DECSTAGE_EXSTAGE_RAM;

architecture Structural of IFSTAGE_DECSTAGE_EXSTAGE_RAM is
	component IFSTAGE is
	Port ( PC_Immed : in  STD_LOGIC_VECTOR (15 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           PC_out : inout  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component DECSTAGE is
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
	end component;
	
	component EXSTAGE is
	Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero,ALU_ovf : out  STD_LOGIC;
			  ALU_cout : inout STD_LOGIC);
	end component;
	
	component Ram_Addr_32to11_Converter is 
	Port ( Input : in  STD_LOGIC_VECTOR (31 downto 0);
           Output : out  STD_LOGIC_VECTOR (10 downto 0));
	end component;
	
	component RAM
	 port (
		clk : in std_logic;
		inst_addr : in std_logic_vector(10 downto 0);
		inst_dout : out std_logic_vector(31 downto 0);
		data_we : in std_logic;
		data_addr : in std_logic_vector(10 downto 0);
		data_din : in std_logic_vector(31 downto 0);
		data_dout : out std_logic_vector(31 downto 0));
	 end component;
	
	signal ram_inst_dout,ram_inst_addr_32,temp_ALU_out,temp_out_Immed_32,temp_out_RF_A,temp_out_RF_B : std_logic_vector(31 downto 0);
	signal ram_inst_addr_11 : std_logic_vector(10 downto 0);
begin

	my_ifstage : IFSTAGE PORT MAP(
		PC_Immed => ram_inst_dout(15 downto 0), -- from Instraction we want to put Immmidiate 16 bits
		PC_sel => PC_sel,
		PC_LdEn => PC_LdEn,
		Reset => Reset,
		Clk => CLK,
		PC_out => ram_inst_addr_32);
	
	my_decstage : DECSTAGE PORT MAP (
		Instr => ram_inst_dout, 
      RF_WrEn => RF_WrEn,
      ALU_out => temp_ALU_out,
      MEM_out => "00000000000000000000000000000000",
      RF_WrData_sel => RF_WrData_sel, 
      RF_B_sel => RF_B_sel,
      ImmExt => ImmExt,
      Clk => CLK,
      Immed => temp_out_Immed_32,
      RF_A => temp_out_RF_A,
      RF_B => temp_out_RF_B,
		Reset => Reset);
	
	my_exstage : EXSTAGE PORT MAP (
		RF_A => temp_out_RF_A,
      RF_B => temp_out_RF_B,
      Immed => temp_out_Immed_32,
      ALU_Bin_sel => ALU_Bin_sel, 
      ALU_func => ALU_func,
      ALU_out => temp_ALU_out,
      ALU_zero => ALU_zero,
		ALU_ovf => open,
		ALU_cout => open);
		
	my_ram_addr_32to11_converter_instr : Ram_Addr_32to11_Converter PORT MAP (
		Input =>ram_inst_addr_32,
		Output =>ram_inst_addr_11);
		
	my_ram : RAM PORT MAP(
		clk => CLK,
		inst_addr => ram_inst_addr_11,
		inst_dout => ram_inst_dout,
		data_we => '0',
		data_addr => "00000000000",
		data_din => "00000000000000000000000000000000",
		data_dout => open);


end Structural;

