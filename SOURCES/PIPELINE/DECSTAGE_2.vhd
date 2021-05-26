----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:07:53 05/09/2021 
-- Design Name: 
-- Module Name:    DECSTAGE_2 - Behavioral 
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

entity DECSTAGE_2 is
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
end DECSTAGE_2;

architecture Structural of DECSTAGE_2 is
component DEC_EX_REG is
Port ( Plus_4_in : in  STD_LOGIC_VECTOR (31 downto 0);
		 Plus_4_out : out  STD_LOGIC_VECTOR (31 downto 0);
		 RF_A_in : in  STD_LOGIC_VECTOR (31 downto 0);
		 RF_A_out : out  STD_LOGIC_VECTOR (31 downto 0);
		 RF_B_in : in  STD_LOGIC_VECTOR (31 downto 0);
		 RF_B_out : out  STD_LOGIC_VECTOR (31 downto 0);
		 Immed_32_in : in  STD_LOGIC_VECTOR (31 downto 0);
		 Immed_32_out : out  STD_LOGIC_VECTOR (31 downto 0);
		 Immed_16_in : in  STD_LOGIC_VECTOR (15 downto 0);
		 Immed_16_out : out  STD_LOGIC_VECTOR (15 downto 0);
		 branch_in : in STD_LOGIC;
		 branch_out : out STD_LOGIC;
		 branch_condition_in : in STD_LOGIC;
		 branch_condition_out : out STD_LOGIC;
		 ALU_Bin_sel_in : in STD_LOGIC;
		 ALU_Bin_sel_out : out STD_LOGIC;
		 ALU_func_in : in STD_LOGIC_VECTOR (3 downto 0);
		 ALU_func_out : out STD_LOGIC_VECTOR (3 downto 0);
		 Exstage_reg_we_in : in STD_LOGIC;
		 Exstage_reg_we_out : out STD_LOGIC;
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
	signal mux_temp_out2,RF_A_temp,RF_B_temp,Immed_32_temp : STD_LOGIC_VECTOR (31 downto 0);

begin

	my_immed_handler : Immed_handler PORT MAP (
	immediate => Instr(15 downto 0),
	ImmExt => ImmExt,
	immediate_out => Immed_32_temp,
	clk => Clk);

	my_rf: RF PORT MAP(
	Adr1 => Instr(25 downto 21), -- always the 1st register is [rs] = Instr(25-21)
	Adr2 => mux_temp_out1, -- 2nd register =  [rt](RF_B_sel = 0) or [rd](RF_B_sel = 1)
	Awr => Instr(20 downto 16), -- always [rd] = Instr(20-16)
	Dout1 => RF_A_temp,
	Dout2 => RF_B_temp,
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
	In0 => ALU_out_reg_in,
	In1 => MEM_out_reg_in,
	Sel => RF_WrData_sel,
	Output => mux_temp_out2);
	
	my_DEC_EX_REG : DEC_EX_REG PORT MAP(
	    Plus_4_in => PC_plus_4_reg_in,
		 Plus_4_out => PC_plus_4_reg_out,
		 RF_A_in => RF_A_temp,
		 RF_A_out => RF_A_reg_out,
		 RF_B_in => RF_B_temp,
		 RF_B_out => RF_B_reg_out,
		 Immed_32_in => Immed_32_temp,
		 Immed_32_out => Immed_32_reg_out,
		 Immed_16_in => Instr(15 downto 0),
		 Immed_16_out => Immed_16_reg_out,
		 branch_in => branch_control_in,
		 branch_out => branch_reg_out,
		 branch_condition_in => branch_condition_control_in,
		 branch_condition_out => branch_condition_reg_out,
		 ALU_Bin_sel_in => ALU_Bin_sel_control_in,
		 ALU_Bin_sel_out => ALU_Bin_sel_reg_out,
		 ALU_func_in => ALU_func_control_in,
		 ALU_func_out => ALU_func_reg_out,
		 Exstage_reg_we_in => Exstage_reg_we_control_in,
		 Exstage_reg_we_out => Exstage_reg_we_reg_out,
		 ByteOp_in => ByteOp_control_in,
		 ByteOp_out => ByteOp_reg_out,
		 Mem_WrEn_in => Mem_WrEn_control_in,
		 Mem_WrEn_out => Mem_WrEn_reg_out,
		 Memstage_reg_we_in => Memstage_reg_we_control_in,
		 Memstage_reg_we_out => Memstage_reg_we_reg_out,
		 RF_WrEn_in => RF_WrEn_control_in,
		 RF_WrEn_out => RF_WrEn_reg_out, 
		 RF_WrData_sel_in => RF_WrData_sel_control_in,
		 RF_WrData_sel_out => RF_WrData_sel_reg_out,
		 WE => Reg_WE,
		 CLK => Clk,
		 RST => Reset);

end Structural;

