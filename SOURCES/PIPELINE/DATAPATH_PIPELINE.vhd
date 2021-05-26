----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:14:01 05/14/2021 
-- Design Name: 
-- Module Name:    DATAPATH_PIPELINE - Behavioral 
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

entity DATAPATH_PIPELINE is
	Port(	Clk : in  STD_LOGIC;	
		Reset : in  STD_LOGIC;
		ifstage_branch : in STD_LOGIC;
		ifstage_branch_condition : in STD_LOGIC;
		ifstage_reg_we_var_in : in STD_LOGIC;
		ifstage_PC_LdEn_var_in : STD_LOGIC;
		decstage_RF_WrEn : in STD_LOGIC;
		decstage_RF_WrData_sel : in STD_LOGIC;
		decstage_RF_B_sel : in STD_LOGIC;
		decstage_ImmExt: in STD_LOGIC_VECTOR(1 downto 0);
		decstage_reg_we : in STD_LOGIC;
		exstage_ALU_Bin_sel : in STD_LOGIC;
		exstage_ALU_func : in STD_LOGIC_VECTOR (3 downto 0);
		exstage_ALU_zero : out STD_LOGIC;
		exstage_reg_we : in STD_LOGIC;
		memstage_ByteOp : in STD_LOGIC;
		memstage_Mem_WrEn : in STD_LOGIC;
		memstage_reg_we : in STD_LOGIC;
		ram_inst_dout : in STD_LOGIC_VECTOR (31 downto 0);
		ram_data_dout : in STD_LOGIC_VECTOR (31 downto 0);
		ram_inst_addr : out STD_LOGIC_VECTOR (10 downto 0);
		ram_data_WE : out STD_LOGIC;
		ram_data_addr : out STD_LOGIC_VECTOR (10 downto 0);
		ram_data_din : out STD_LOGIC_VECTOR (31 downto 0));
end DATAPATH_PIPELINE;

architecture Structural of DATAPATH_PIPELINE is
	component IFSTAGE_2 is
	Port ( Branch_addr : in STD_LOGIC_VECTOR (31 downto 0);
			 PC_sel : in  STD_LOGIC;
          PC_LdEn : in  STD_LOGIC;
          Reset : in  STD_LOGIC;
          Clk : in  STD_LOGIC;
			 Reg_WE: in STD_LOGIC;
          PC_out : inout  STD_LOGIC_VECTOR (31 downto 0);
			 Instr : in  STD_LOGIC_VECTOR (31 downto 0);
			 Instr_reg_out : out  STD_LOGIC_VECTOR (31 downto 0);
			 PC_plus_4_reg_out : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component DECSTAGE_2 is
	Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
			  PC_plus_4_reg_in : in STD_LOGIC_VECTOR (31 downto 0);
			  PC_plus_4_reg_out : out STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out_reg_in : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out_reg_in : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
           Clk : in  STD_LOGIC;
           Immed_32_reg_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  Immed_16_reg_out : out  STD_LOGIC_VECTOR (15 downto 0);
           RF_A_reg_out : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B_reg_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  branch_control_in : in STD_LOGIC;
			  branch_reg_out : out STD_LOGIC;
			  branch_condition_control_in : in STD_LOGIC;
			  branch_condition_reg_out : out STD_LOGIC;
			  ALU_Bin_sel_control_in : in STD_LOGIC;
			  ALU_Bin_sel_reg_out : out STD_LOGIC;
			  ALU_func_control_in : in STD_LOGIC_VECTOR (3 downto 0);
			  ALU_func_reg_out : out STD_LOGIC_VECTOR (3 downto 0);
			  Exstage_reg_we_control_in : in STD_LOGIC;
			  Exstage_reg_we_reg_out : out STD_LOGIC;
			  ByteOp_control_in : in STD_LOGIC;
			  ByteOp_reg_out : out STD_LOGIC;
			  Mem_WrEn_control_in : in STD_LOGIC;
			  Mem_WrEn_reg_out : out STD_LOGIC;
			  Memstage_reg_we_control_in : in STD_LOGIC;
			  Memstage_reg_we_reg_out : out STD_LOGIC;
			  RF_WrEn_control_in : in STD_LOGIC;
			  RF_WrEn_reg_out : out STD_LOGIC;
			  RF_WrData_sel_control_in : in STD_LOGIC;
			  RF_WrData_sel_reg_out : out STD_LOGIC;
			  Reg_WE: in STD_LOGIC;
			  Reset : in  STD_LOGIC);
	end component;
	
	component EXSTAGE_2 is
	Port ( RF_A_reg_in : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B_reg_in : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed_32_reg_in : in  STD_LOGIC_VECTOR (31 downto 0);
			  Immed_16_reg_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  PC_plus_4_reg_in : in STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out_reg_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  branch_adder_reg_out : out STD_LOGIC_VECTOR (31 downto 0);
			  RF_B_reg_out : out STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero_reg_out : out  STD_LOGIC;
			  ALU_ovf : out  STD_LOGIC;
			  branch_reg_in : in STD_LOGIC;
			  branch_reg_out : out STD_LOGIC;
		     branch_condition_reg_in : in STD_LOGIC;
			  branch_condition_reg_out : out STD_LOGIC;
			  ByteOp_reg_in : in STD_LOGIC;
			  ByteOp_reg_out : out STD_LOGIC;
			  Mem_WrEn_reg_in : in STD_LOGIC;
			  Mem_WrEn_reg_out : out STD_LOGIC;
			  Memstage_reg_we_reg_in : in STD_LOGIC;
			  Memstage_reg_we_reg_out : out STD_LOGIC;
			  RF_WrEn_reg_in : in STD_LOGIC;
			  RF_WrEn_reg_out : out STD_LOGIC;
			  RF_WrData_sel_reg_in : in STD_LOGIC;
			  RF_WrData_sel_reg_out : out STD_LOGIC;
			  Reset : in STD_LOGIC;
			  Reg_WE: in STD_LOGIC;
			  Clk : in  STD_LOGIC;
			  ALU_cout : inout STD_LOGIC);
	end component;
	
	component MEMSTAGE_2 is
	Port ( clk : in  STD_LOGIC;
           ByteOp : in  STD_LOGIC;
           Mem_WrEn : in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0); 
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0); 
           MEM_DataOut_reg_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  ALU_out_reg_out : out STD_LOGIC_VECTOR (31 downto 0);
			  ALU_zero_reg_in : in STD_LOGIC;
			  branch : in STD_LOGIC;
			  branch_condition : in STD_LOGIC;
			  ifstate_PC_sel : out STD_LOGIC;
			  RF_WrEn_reg_in : in STD_LOGIC;
			  RF_WrEn_reg_out : out STD_LOGIC;
			  RF_WrData_sel_reg_in : in STD_LOGIC;
			  RF_WrData_sel_reg_out : out STD_LOGIC;
			  Reg_WE: in STD_LOGIC;
			  Reset : in STD_LOGIC;
           MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0); 
           MM_WrEn : out  STD_LOGIC;
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0); 
           MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0)); 
	end component;
	
	component Ram_Addr_32to11_Converter is 
	Port ( Input : in  STD_LOGIC_VECTOR (31 downto 0);
           Output : out  STD_LOGIC_VECTOR (10 downto 0));
	end component;
	
	
	signal ram_inst_addr_32,ram_data_addr_32 : STD_LOGIC_VECTOR (31 downto 0);
	signal instr_reg_out_temp, PC_plus_4_reg_1, PC_plus_4_reg_2, ALU_out_temp, ALU_out_temp_2, MEM_out_temp  : STD_LOGIC_VECTOR (31 downto 0);
	signal Immed_32_reg_temp, RF_A_reg_temp, RF_B_reg_temp, RF_B_reg_temp_2, branch_adder_reg_1 : STD_LOGIC_VECTOR (31 downto 0);
	signal Immed_16_reg_temp : STD_LOGIC_VECTOR (15 downto 0);
	signal ALU_func_temp : STD_LOGIC_VECTOR (3 downto 0);
	signal RF_WrEn_temp, RF_WrData_sel_temp, ALU_Bin_sel_temp, ByteOp_reg_1, ByteOp_reg_2, Mem_WrEn_reg_1, Mem_WrEn_reg_2 : STD_LOGIC;
	signal branch_1, branch_2, branch_condition_1, branch_condition_2, RF_WrEn_reg_1, RF_WrEn_reg_2, RF_WrData_sel_reg_1, RF_WrData_sel_reg_2 : STD_LOGIC;
	signal ALU_zero_reg_temp, Exstage_reg_we_temp  : STD_LOGIC;
	signal Memstage_reg_we_1, Memstage_reg_we_2, PC_sel_temp : STD_LOGIC;
begin
	my_ifstage : IFSTAGE_2 PORT MAP(
		Branch_addr => branch_adder_reg_1,
		PC_sel => PC_sel_temp,
      PC_LdEn => ifstage_PC_LdEn_var_in,
      Reset => Reset,
      Clk => Clk,
		Reg_WE => ifstage_reg_we_var_in,
		PC_out => ram_inst_addr_32,
		Instr => ram_inst_dout,
		Instr_reg_out => instr_reg_out_temp,
		PC_plus_4_reg_out => PC_plus_4_reg_1);
	
	my_decstage : DECSTAGE_2 PORT MAP (
		Instr => instr_reg_out_temp,
		PC_plus_4_reg_in => PC_plus_4_reg_1,
		PC_plus_4_reg_out => PC_plus_4_reg_2,
      RF_WrEn => RF_WrEn_temp,
      ALU_out_reg_in => ALU_out_temp,
      MEM_out_reg_in => MEM_out_temp,
      RF_WrData_sel => RF_WrData_sel_temp,
      RF_B_sel => decstage_RF_B_sel,
      ImmExt => decstage_ImmExt,
      Clk => Clk,
      Immed_32_reg_out => Immed_32_reg_temp,
		Immed_16_reg_out => Immed_16_reg_temp,
      RF_A_reg_out => RF_A_reg_temp,
      RF_B_reg_out => RF_B_reg_temp,
		branch_control_in => ifstage_branch,
		branch_reg_out => branch_1,
		branch_condition_control_in => ifstage_branch_condition,
		branch_condition_reg_out => branch_condition_1,
		ALU_Bin_sel_control_in => exstage_ALU_Bin_sel,
		ALU_Bin_sel_reg_out => ALU_Bin_sel_temp,
		ALU_func_control_in => exstage_ALU_func,
		ALU_func_reg_out => ALU_func_temp,
		Exstage_reg_we_control_in => exstage_reg_we,
		Exstage_reg_we_reg_out => Exstage_reg_we_temp, 
		ByteOp_control_in => memstage_ByteOp,
		ByteOp_reg_out => ByteOp_reg_1,
		Mem_WrEn_control_in => memstage_Mem_WrEn, 
		Mem_WrEn_reg_out => Mem_WrEn_reg_1,
		Memstage_reg_we_control_in => memstage_reg_we,
		Memstage_reg_we_reg_out => Mem_WrEn_reg_1,
		RF_WrEn_control_in => decstage_RF_WrEn,
		RF_WrEn_reg_out => RF_WrEn_reg_1,
		RF_WrData_sel_control_in => decstage_RF_WrData_sel,
		RF_WrData_sel_reg_out => RF_WrData_sel_reg_1,
		Reg_WE => decstage_reg_we,
		Reset => Reset);
	
	my_exstage : EXSTAGE_2 PORT MAP (
		RF_A_reg_in => RF_A_reg_temp,
      RF_B_reg_in => RF_B_reg_temp,
      Immed_32_reg_in => Immed_32_reg_temp,
		Immed_16_reg_in => Immed_16_reg_temp,
		PC_plus_4_reg_in => PC_plus_4_reg_2,
      ALU_Bin_sel => ALU_Bin_sel_temp,
      ALU_func => ALU_func_temp,
      ALU_out_reg_out => ALU_out_temp_2,
		branch_adder_reg_out => branch_adder_reg_1, 
		RF_B_reg_out => RF_B_reg_temp_2,
      ALU_zero_reg_out => ALU_zero_reg_temp,
		ALU_ovf => open, -- not used!!!!!!!!!!!!!!!!!!!!!!!!
		branch_reg_in => branch_1,
		branch_reg_out => branch_2,
		branch_condition_reg_in => branch_condition_1,
		branch_condition_reg_out => branch_condition_2,
		ByteOp_reg_in => ByteOp_reg_1,
		ByteOp_reg_out => ByteOp_reg_2,
		Mem_WrEn_reg_in => Mem_WrEn_reg_1,
		Mem_WrEn_reg_out => Mem_WrEn_reg_2,
		Memstage_reg_we_reg_in => Memstage_reg_we_1, 
		Memstage_reg_we_reg_out => Memstage_reg_we_2,
		RF_WrEn_reg_in => RF_WrEn_reg_1,
		RF_WrEn_reg_out => RF_WrEn_reg_2,
		RF_WrData_sel_reg_in => RF_WrData_sel_reg_1,
		RF_WrData_sel_reg_out => RF_WrData_sel_reg_2,
		Reset => Reset,
		Reg_WE => Exstage_reg_we_temp,
		Clk => Clk,
		ALU_cout => open);-- not used!!!!!!!!!!!!!!!!!!!!!!!!
	
	my_memstage : MEMSTAGE_2 PORT MAP (
		clk => Clk,
      ByteOp => ByteOp_reg_2,
      Mem_WrEn => Mem_WrEn_reg_2,
      ALU_MEM_Addr => ALU_out_temp_2,
      MEM_DataIn => RF_B_reg_temp_2,
      MEM_DataOut_reg_out => MEM_out_temp,
		ALU_out_reg_out => ALU_out_temp,
		ALU_zero_reg_in => ALU_zero_reg_temp,
		branch => branch_2,
		branch_condition => branch_condition_2,
		ifstate_PC_sel => PC_sel_temp,
		RF_WrEn_reg_in => RF_WrEn_reg_2,
		RF_WrEn_reg_out => RF_WrEn_temp,
		RF_WrData_sel_reg_in => RF_WrData_sel_reg_2,
		RF_WrData_sel_reg_out => RF_WrData_sel_temp,
		Reg_WE => Memstage_reg_we_2,
		Reset => Reset,
      MM_Addr => ram_data_addr_32,
      MM_WrEn => ram_data_WE,
      MM_WrData => ram_data_din,
      MM_RdData => ram_data_dout);
		
	my_ram_addr_32to11_converter_instr : Ram_Addr_32to11_Converter PORT MAP (
		Input =>ram_inst_addr_32,
		Output =>ram_inst_addr);
		
	my_ram_addr_32to11_converter_data : Ram_Addr_32to11_Converter PORT MAP (
		Input =>ram_data_addr_32,
		Output =>ram_data_addr);


end Structural;

