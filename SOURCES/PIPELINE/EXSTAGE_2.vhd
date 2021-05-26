----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:05:48 05/09/2021 
-- Design Name: 
-- Module Name:    EXSTAGE_2 - Behavioral 
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

entity EXSTAGE_2 is
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
end EXSTAGE_2;

architecture Structural of EXSTAGE_2 is
	component EX_MEM_REG is
	Port(
	branch_adder_in : in STD_LOGIC_VECTOR (31 downto 0);
	branch_adder_out : out STD_LOGIC_VECTOR (31 downto 0);
	ALU_out_in : in STD_LOGIC_VECTOR (31 downto 0);
	ALU_out_out : out STD_LOGIC_VECTOR (31 downto 0);
	ALU_zero_in : in STD_LOGIC;
	ALU_zero_out : out STD_LOGIC;
	RF_B_in : in STD_LOGIC_VECTOR (31 downto 0);
	RF_B_out : out STD_LOGIC_VECTOR (31 downto 0);
	branch_in : in STD_LOGIC;
	branch_out : out STD_LOGIC;
	branch_condition_in : in STD_LOGIC;
	branch_condition_out : out STD_LOGIC;
	ByteOp_in : in STD_LOGIC;
	ByteOp_out : out STD_LOGIC;
	Mem_WrEn_in : in STD_LOGIC;
	Mem_WrEn_out : out STD_LOGIC;
	Memstage_reg_we_in : in STD_LOGIC;
	Memstage_reg_we_out : out STD_LOGIC;
	RF_WrEn_in : in STD_LOGIC;
	RF_WrEn_out : out STD_LOGIC;
	RF_WrData_sel_in : in STD_LOGIC;
	RF_WrData_sel_out: out STD_LOGIC;
	WE : in STD_LOGIC;
	CLK : in STD_LOGIC;
	RST : in STD_LOGIC);
	end component;
	
	component Mux_2to1 is
	Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
           In1 : in  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component ALU is
	Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           Output : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : inout  STD_LOGIC;
           Ovf : out  STD_LOGIC);
	end component;
	
	Component adder is
		Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
			    In1 : in  STD_LOGIC_VECTOR (31 downto 0);
             Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component Immediate_Converter is
	Port ( Input : in STD_LOGIC_VECTOR (15 downto 0);
			 Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	signal mux_temp_out, immediate_converter_temp_out, adder_temp_out, ALU_out_temp : STD_LOGIC_VECTOR (31 downto 0);
	signal ALU_zero_temp : STD_LOGIC;

begin
	my_alu: ALU PORT MAP(
	A => RF_A_reg_in,
	B => mux_temp_out,
	Op => ALU_func,
	Output => ALU_out_temp,
	Zero => ALU_zero_temp,
	Cout => ALU_cout,
	Ovf => ALU_ovf);
	
	my_mux: Mux_2to1 PORT MAP(
	In0 => RF_B_reg_in,
	In1 => Immed_32_reg_in,
	Sel => ALU_Bin_sel,
	Output => mux_temp_out);
	
	my_immediate_converter : Immediate_Converter PORT MAP (
	Input => Immed_16_reg_in,
	Output => immediate_converter_temp_out);
	
	branch_adder: adder PORT MAP (
	In0 => PC_plus_4_reg_in,
	In1 => immediate_converter_temp_out,
	Output => adder_temp_out);
	
	my_EX_MEM_REG: EX_MEM_REG PORT MAP(
		branch_adder_in => adder_temp_out,
		branch_adder_out => branch_adder_reg_out, 
		ALU_out_in => ALU_out_temp,
		ALU_out_out => ALU_out_reg_out,
		ALU_zero_in => ALU_zero_temp,
		ALU_zero_out => ALU_zero_reg_out,
		RF_B_in => RF_B_reg_in,
		RF_B_out => RF_B_reg_out,
		branch_in => branch_reg_in,
		branch_out => branch_reg_out,
		branch_condition_in => branch_condition_reg_in,
		branch_condition_out => branch_condition_reg_out,
		ByteOp_in => ByteOp_reg_in,
		ByteOp_out => ByteOp_reg_out, 
		Mem_WrEn_in => Mem_WrEn_reg_in,
		Mem_WrEn_out => Mem_WrEn_reg_out,
		Memstage_reg_we_in => Memstage_reg_we_reg_in,
		Memstage_reg_we_out => Memstage_reg_we_reg_out,
		RF_WrEn_in => RF_WrEn_reg_in,
		RF_WrEn_out => RF_WrEn_reg_out,
		RF_WrData_sel_in => RF_WrData_sel_reg_in, 
		RF_WrData_sel_out => RF_WrData_sel_reg_out,
		WE => Reg_WE,
		CLK => Clk,
		RST => Reset
	);


end Structural;
