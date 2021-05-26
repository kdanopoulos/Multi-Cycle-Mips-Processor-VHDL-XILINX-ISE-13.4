----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:49:33 05/22/2021 
-- Design Name: 
-- Module Name:    PROCESSOR_MC - Behavioral 
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

entity PROCESSOR_MC is
Port (reset : in STD_LOGIC;
		CLK : in STD_LOGIC);
end PROCESSOR_MC;

architecture Structural of PROCESSOR_MC is
	
	component DATAPATH_MC is
	PORT(
		Clk : in  STD_LOGIC;
		Reset : in  STD_LOGIC;
		ifstage_pc_sel : in STD_LOGIC;
		ifstage_pc_LdEn : in STD_LOGIC;
		decstage_RF_WrEn : in STD_LOGIC;
		decstage_RF_WrData_sel : in STD_LOGIC;
		decstage_RF_B_sel : in STD_LOGIC;
		decstage_ImmExt: in STD_LOGIC_VECTOR(1 downto 0);
		exstage_ALU_Bin_sel : in STD_LOGIC;
		exstage_ALU_func : in STD_LOGIC_VECTOR (3 downto 0);
		ALU_zero_reg_out : out STD_LOGIC;
		exstage_ALU_ovf : out STD_LOGIC;
		exstage_ALU_cout : inout STD_LOGIC;	
		memstage_ByteOp : in STD_LOGIC;
		memstage_Mem_WrEn : in STD_LOGIC;
		ALU_zero_reg_WE : in STD_LOGIC;
		instr_reg_WE : in STD_LOGIC;
		instr_reg_out : inout STD_LOGIC_VECTOR (31 downto 0);
		RF_A_reg_WE : in STD_LOGIC;
		RF_B_reg_WE : in STD_LOGIC;
		Immed_32_reg_WE : in STD_LOGIC;
		ALU_out_reg_WE : in STD_LOGIC;
		MEM_DataOut_reg_WE : in STD_LOGIC;
		
		ram_inst_dout : in STD_LOGIC_VECTOR (31 downto 0);
		ram_data_dout : in STD_LOGIC_VECTOR (31 downto 0);	
		ram_inst_addr : out STD_LOGIC_VECTOR (10 downto 0);
		ram_data_WE : out STD_LOGIC;
		ram_data_addr : out STD_LOGIC_VECTOR (10 downto 0);
		ram_data_din : out STD_LOGIC_VECTOR (31 downto 0)
		
	);
	end component;
	
	component CONTROL_MC is
	Port (	Reset : in STD_LOGIC;
			CLK : in STD_LOGIC;
			ALU_zero_reg_out : in STD_LOGIC;
			Instruction : in STD_LOGIC_VECTOR (31 downto 0);
			ifstage_pc_sel : out STD_LOGIC;
			ifstage_pc_LdEn : out STD_LOGIC;
			decstage_RF_WrEn : out STD_LOGIC;
			decstage_RF_WrData_sel : out STD_LOGIC;
			decstage_RF_B_sel : out STD_LOGIC;
			decstage_ImmExt: out STD_LOGIC_VECTOR(1 downto 0);
			exstage_ALU_Bin_sel : out STD_LOGIC;
			exstage_ALU_func : out STD_LOGIC_VECTOR (3 downto 0);
			memstage_ByteOp : out STD_LOGIC;
			memstage_Mem_WrEn : out STD_LOGIC;
			ALU_zero_reg_WE : out STD_LOGIC;
			instr_reg_WE : out STD_LOGIC;
			RF_A_reg_WE : out STD_LOGIC;
			RF_B_reg_WE : out STD_LOGIC;
			Immed_32_reg_WE : out STD_LOGIC;
			ALU_out_reg_WE : out STD_LOGIC;
			MEM_DataOut_reg_WE : out STD_LOGIC);
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
	
	-- RAM
	signal temp_ram_inst_addr, temp_ram_data_addr : std_logic_vector(10 downto 0);
	signal temp_ram_inst_dout, temp_ram_data_dout, temp_ram_data_din :  std_logic_vector(31 downto 0);
	signal temp_ram_data_WE : std_logic;
	-- Others
	signal temp_ifstage_pc_sel, temp_ifstage_pc_LdEn, temp_decstage_RF_WrEn, temp_decstage_RF_WrData_sel, temp_decstage_RF_B_sel : std_logic;
	signal temp_decstage_ImmExt : std_logic_vector(1 downto 0);
	signal temp_exstage_ALU_Bin_sel, temp_memstage_ByteOp, temp_memstage_Mem_WrEn, temp_ALU_zero_reg_out : std_logic;
	signal temp_exstage_ALU_func : std_logic_vector(3 downto 0);
	signal temp_ALU_zero_reg_WE, temp_instr_reg_WE, temp_RF_A_reg_WE, temp_RF_B_reg_WE, temp_Immed_32_reg_WE, temp_ALU_out_reg_WE, temp_MEM_DataOut_reg_WE : std_logic;
	signal temp_instr_reg_out : std_logic_vector(31 downto 0);
begin

	my_datapath : DATAPATH_MC PORT MAP (
		Clk => CLK,
		Reset => reset, 
		ifstage_pc_sel => temp_ifstage_pc_sel,
		ifstage_pc_LdEn => temp_ifstage_pc_LdEn,
		decstage_RF_WrEn => temp_decstage_RF_WrEn,
		decstage_RF_WrData_sel => temp_decstage_RF_WrData_sel,
		decstage_RF_B_sel => temp_decstage_RF_B_sel,
		decstage_ImmExt => temp_decstage_ImmExt,
		exstage_ALU_Bin_sel => temp_exstage_ALU_Bin_sel,
		exstage_ALU_func => temp_exstage_ALU_func,
		ALU_zero_reg_out => temp_ALU_zero_reg_out,
		exstage_ALU_ovf => open,
		exstage_ALU_cout => open,
		memstage_ByteOp => temp_memstage_ByteOp,
		memstage_Mem_WrEn => temp_memstage_Mem_WrEn,
		ALU_zero_reg_WE => temp_ALU_zero_reg_WE,
		instr_reg_WE => temp_instr_reg_WE,
		instr_reg_out => temp_instr_reg_out,
		RF_A_reg_WE => temp_RF_A_reg_WE,
		RF_B_reg_WE => temp_RF_B_reg_WE,
		Immed_32_reg_WE => temp_Immed_32_reg_WE,
		ALU_out_reg_WE => temp_ALU_out_reg_WE,
		MEM_DataOut_reg_WE => temp_MEM_DataOut_reg_WE,
		
		ram_inst_dout => temp_ram_inst_dout,
		ram_data_dout => temp_ram_data_dout,
		ram_inst_addr => temp_ram_inst_addr,
		ram_data_WE => temp_ram_data_WE,
		ram_data_addr => temp_ram_data_addr,
		ram_data_din => temp_ram_data_din);
	
	my_control : CONTROL_MC PORT MAP(
		Reset => reset,
		CLK => CLK,
		ALU_zero_reg_out => temp_ALU_zero_reg_out,
		Instruction => temp_instr_reg_out,
		ifstage_pc_sel => temp_ifstage_pc_sel,
		ifstage_pc_LdEn => temp_ifstage_pc_LdEn,
		decstage_RF_WrEn => temp_decstage_RF_WrEn,
		decstage_RF_WrData_sel => temp_decstage_RF_WrData_sel,
		decstage_RF_B_sel => temp_decstage_RF_B_sel,
		decstage_ImmExt => temp_decstage_ImmExt,
		exstage_ALU_Bin_sel => temp_exstage_ALU_Bin_sel,
		exstage_ALU_func => temp_exstage_ALU_func,
		memstage_ByteOp => temp_memstage_ByteOp,
		memstage_Mem_WrEn => temp_memstage_Mem_WrEn,
		ALU_zero_reg_WE => temp_ALU_zero_reg_WE,
		instr_reg_WE => temp_instr_reg_WE,
		RF_A_reg_WE => temp_RF_A_reg_WE,
		RF_B_reg_WE => temp_RF_B_reg_WE,
		Immed_32_reg_WE => temp_Immed_32_reg_WE,
		ALU_out_reg_WE => temp_ALU_out_reg_WE,
		MEM_DataOut_reg_WE => temp_MEM_DataOut_reg_WE);

	my_ram : RAM PORT MAP(
		clk => CLK,
		inst_addr => temp_ram_inst_addr,
		inst_dout => temp_ram_inst_dout,
		data_we => temp_ram_data_WE,
		data_addr => temp_ram_data_addr,
		data_din => temp_ram_data_din,
		data_dout => temp_ram_data_dout);


end Structural;

