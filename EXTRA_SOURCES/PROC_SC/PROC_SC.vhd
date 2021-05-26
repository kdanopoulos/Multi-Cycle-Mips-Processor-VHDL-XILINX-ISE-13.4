----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:06:44 04/14/2021 
-- Design Name: 
-- Module Name:    PROC_SC - Behavioral 
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

entity PROC_SC is
Port (reset : in STD_LOGIC;
		CLK : in STD_LOGIC);
end PROC_SC;

architecture Structural of PROC_SC is

	component DATAPATH is
	PORT(
		-- General Variables
		Clk : in  STD_LOGIC;		
		-- Control Variables
		Reset : in  STD_LOGIC;
		ifstage_pc_sel : in STD_LOGIC;
		ifstage_pc_LdEn : in STD_LOGIC;
		decstage_RF_WrEn : in STD_LOGIC;
		decstage_RF_WrData_sel : in STD_LOGIC;
		decstage_RF_B_sel : in STD_LOGIC;
		decstage_ImmExt: in STD_LOGIC_VECTOR(1 downto 0);
		exstage_ALU_Bin_sel : in STD_LOGIC;
		exstage_ALU_func : in STD_LOGIC_VECTOR (3 downto 0);
		exstage_ALU_zero : out STD_LOGIC;
		exstage_ALU_ovf : out STD_LOGIC;
		exstage_ALU_cout : inout STD_LOGIC;
		memstage_ByteOp : in STD_LOGIC;
		memstage_Mem_WrEn : in STD_LOGIC;
		-- Ram Variables
		ram_inst_dout : in STD_LOGIC_VECTOR (31 downto 0);
		ram_data_dout : in STD_LOGIC_VECTOR (31 downto 0);
		ram_inst_addr : out STD_LOGIC_VECTOR (10 downto 0);
		ram_data_WE : out STD_LOGIC;
		ram_data_addr : out STD_LOGIC_VECTOR (10 downto 0);
		ram_data_din : out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component CONTROL is
	Port (
		exstage_ALU_zero : in STD_LOGIC;
		exstage_ALU_ovf : in STD_LOGIC;
		exstage_ALU_cout : in STD_LOGIC;
		Instruction : in STD_LOGIC_VECTOR (31 downto 0);
		CLK : in STD_LOGIC;
		Reset : in STD_LOGIC; 
		control_signals : out STD_LOGIC_VECTOR (14 downto 0));
	end component;
	
	component RAM is
	port (
		clk : in std_logic;
		inst_addr : in std_logic_vector(10 downto 0);
		inst_dout : out std_logic_vector(31 downto 0);
		data_we : in std_logic;
		data_addr : in std_logic_vector(10 downto 0);
		data_din : in std_logic_vector(31 downto 0);
		data_dout : out std_logic_vector(31 downto 0));
	end component;


	signal temp_inst_addr,temp_data_addr : std_logic_vector(10 downto 0);
	signal temp_inst_dout,temp_data_din,temp_data_dout : std_logic_vector(31 downto 0);
	signal temp_data_we,temp_zero,temp_ovf,temp_cout : std_logic;
	signal temp_control_signals : std_logic_vector(14 downto 0);

begin

	my_datapath : DATAPATH PORT MAP(
		Clk => CLK,	
		Reset => reset,--temp_control_signals(0),
		ifstage_pc_sel => temp_control_signals(1), 
		ifstage_pc_LdEn => temp_control_signals(2),
		decstage_RF_WrEn => temp_control_signals(3),
		decstage_RF_WrData_sel => temp_control_signals(4),
		decstage_RF_B_sel => temp_control_signals(5),
		decstage_ImmExt => temp_control_signals(7 downto 6),
		exstage_ALU_Bin_sel => temp_control_signals(8),
		exstage_ALU_func => temp_control_signals(12 downto 9),
		exstage_ALU_zero => temp_zero,
		exstage_ALU_ovf => temp_ovf,
		exstage_ALU_cout => temp_cout,
		memstage_ByteOp => temp_control_signals(13),
		memstage_Mem_WrEn => temp_control_signals(14),
		ram_inst_dout => temp_inst_dout,
		ram_data_dout => temp_data_dout,
		ram_inst_addr => temp_inst_addr,
		ram_data_WE => temp_data_we,
		ram_data_addr => temp_data_addr,
		ram_data_din => temp_data_din);
	
	my_control : CONTROL PORT MAP(
		exstage_ALU_zero => temp_zero,
		exstage_ALU_ovf => temp_ovf,
		exstage_ALU_cout => temp_cout,
		Instruction => temp_inst_dout,
		CLK => CLK,
		Reset => reset,
		control_signals => temp_control_signals);
	
	my_ram : RAM PORT MAP(
		clk => CLK,
		inst_addr => temp_inst_addr,
		inst_dout => temp_inst_dout,
		data_we => temp_data_we,
		data_addr => temp_data_addr,
		data_din => temp_data_din,
		data_dout => temp_data_dout);

end Structural;

