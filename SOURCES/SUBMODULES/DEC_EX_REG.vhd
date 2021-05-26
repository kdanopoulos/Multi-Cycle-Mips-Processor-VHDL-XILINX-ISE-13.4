----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:23:48 05/09/2021 
-- Design Name: 
-- Module Name:    DEC_EX_REG - Behavioral 
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

entity DEC_EX_REG is
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
		 -- IFSTAGE
		 branch_in : in STD_LOGIC;
		 branch_out : out STD_LOGIC;
		 branch_condition_in : in STD_LOGIC;
		 branch_condition_out : out STD_LOGIC;
		 -- EXSTAGE
		 ALU_Bin_sel_in : in STD_LOGIC;
		 ALU_Bin_sel_out : out STD_LOGIC;
		 ALU_func_in : in STD_LOGIC_VECTOR (3 downto 0);
		 ALU_func_out : out STD_LOGIC_VECTOR (3 downto 0);
		 Exstage_reg_we_in : in STD_LOGIC;
		 Exstage_reg_we_out : out STD_LOGIC;
		 -- MEMSTAGE
		 ByteOp_in : in STD_LOGIC;
		 ByteOp_out : out STD_LOGIC;
		 Mem_WrEn_in : in STD_LOGIC;
		 Mem_WrEn_out : out STD_LOGIC;
		 Memstage_reg_we_in : in STD_LOGIC;
		 Memstage_reg_we_out : out STD_LOGIC;
		 -- WRITE REGISTER
		 RF_WrEn_in : in STD_LOGIC;
		 RF_WrEn_out : out STD_LOGIC;
		 RF_WrData_sel_in : in STD_LOGIC;
		 RF_WrData_sel_out: out STD_LOGIC;
		 WE : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 RST : in STD_LOGIC);
end DEC_EX_REG;

architecture Structural of DEC_EX_REG is
	COMPONENT Reg_32 is
	Port ( Datain : in  STD_LOGIC_VECTOR (31 downto 0);
          Dataout : out  STD_LOGIC_VECTOR (31 downto 0);
          WE,CLK,RST : in  STD_LOGIC);
	END COMPONENT;
	
	COMPONENT Reg_16 is
	PORT ( Datain : in  STD_LOGIC_VECTOR (15 downto 0);
           Dataout : out  STD_LOGIC_VECTOR (15 downto 0);
           WE : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC);
	END COMPONENT;
	COMPONENT Reg_4 is
	PORT ( Datain : in  STD_LOGIC_VECTOR (3 downto 0);
           Dataout : out  STD_LOGIC_VECTOR (3 downto 0);
           WE : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC);
	END COMPONENT;
	COMPONENT Reg_1 is
	PORT ( Datain : in  STD_LOGIC;
           Dataout : out  STD_LOGIC;
           WE : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC);
	END COMPONENT;

begin
	Plus_4_Reg: Reg_32 PORT MAP (
		RST => RST,
		Datain => Plus_4_in,
		WE => WE,
		Dataout => Plus_4_out,
		CLK => CLK);
		
	RF_A_Reg: Reg_32 PORT MAP (
		RST => RST,
		Datain => RF_A_in,
		WE => WE,
		Dataout => RF_A_out,
		CLK => CLK);
		
	RF_B_Reg: Reg_32 PORT MAP (
		RST => RST,
		Datain => RF_B_in,
		WE => WE,
		Dataout => RF_B_out,
		CLK => CLK);
		
	Immed_32_Reg: Reg_32 PORT MAP (
		RST => RST,
		Datain => Immed_32_in,
		WE => WE,
		Dataout => Immed_32_out,
		CLK => CLK);
		
	Immed_16_Reg: Reg_16 PORT MAP (
		RST => RST,
		Datain => Immed_16_in,
		WE => WE,
		Dataout => Immed_16_out,
		CLK => CLK);
		
	ALU_Bin_sel_Reg: Reg_1 PORT MAP (
		RST => RST,
		Datain => ALU_Bin_sel_in,
		WE => WE,
		Dataout => ALU_Bin_sel_out,
		CLK => CLK);
		
	ALU_func_Reg: Reg_4 PORT MAP (
		RST => RST,
		Datain => ALU_func_in,
		WE => WE,
		Dataout => ALU_func_out,
		CLK => CLK);
		
	ByteOp_Reg: Reg_1 PORT MAP (
		RST => RST,
		Datain => ByteOp_in,
		WE => WE,
		Dataout => ByteOp_out,
		CLK => CLK);
		
	Mem_WrEn_Reg: Reg_1 PORT MAP (
		RST => RST,
		Datain => Mem_WrEn_in,
		WE => WE,
		Dataout => Mem_WrEn_out,
		CLK => CLK);
		
	RF_WrEn_Reg: Reg_1 PORT MAP (
		RST => RST,
		Datain => RF_WrEn_in,
		WE => WE,
		Dataout => RF_WrEn_out,
		CLK => CLK);
		
	RF_WrData_sel_Reg: Reg_1 PORT MAP (
		RST => RST,
		Datain => RF_WrData_sel_in,
		WE => WE,
		Dataout => RF_WrData_sel_out,
		CLK => CLK);
		
	branch_Reg: Reg_1 PORT MAP (
		RST => RST,
		Datain => branch_in,
		WE => WE,
		Dataout => branch_out,
		CLK => CLK);
	
	branch_condition_Reg: Reg_1 PORT MAP (
		RST => RST,
		Datain => branch_condition_in,
		WE => WE,
		Dataout => branch_condition_out,
		CLK => CLK);
		
	Exstage_reg_we_Reg: Reg_1 PORT MAP (
		RST => RST,
		Datain => Exstage_reg_we_in,
		WE => WE,
		Dataout => Exstage_reg_we_out,
		CLK => CLK);
	Memstage_reg_we_Reg: Reg_1 PORT MAP (
		RST => RST,
		Datain => Memstage_reg_we_in,
		WE => WE,
		Dataout => Memstage_reg_we_out,
		CLK => CLK);
	
	
end Structural;

