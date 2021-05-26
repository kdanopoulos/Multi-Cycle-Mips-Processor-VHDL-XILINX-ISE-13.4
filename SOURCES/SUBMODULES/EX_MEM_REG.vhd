----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:33:34 05/09/2021 
-- Design Name: 
-- Module Name:    EX_MEM_REG - Behavioral 
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

entity EX_MEM_REG is
Port(
	branch_adder_in : in STD_LOGIC_VECTOR (31 downto 0);
	branch_adder_out : out STD_LOGIC_VECTOR (31 downto 0);
	ALU_out_in : in STD_LOGIC_VECTOR (31 downto 0);
	ALU_out_out : out STD_LOGIC_VECTOR (31 downto 0);
	ALU_zero_in : in STD_LOGIC;
	ALU_zero_out : out STD_LOGIC;
	RF_B_in : in STD_LOGIC_VECTOR (31 downto 0);
	RF_B_out : out STD_LOGIC_VECTOR (31 downto 0);
	-- IFSTAGE
	branch_in : in STD_LOGIC;
	branch_out : out STD_LOGIC;
	branch_condition_in : in STD_LOGIC;
	branch_condition_out : out STD_LOGIC;
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

end EX_MEM_REG;

architecture Structural of EX_MEM_REG is
	COMPONENT Reg_32 is
	Port ( Datain : in  STD_LOGIC_VECTOR (31 downto 0);
          Dataout : out  STD_LOGIC_VECTOR (31 downto 0);
          WE,CLK,RST : in  STD_LOGIC);
	END COMPONENT;
	COMPONENT Reg_1 is
	PORT ( Datain : in  STD_LOGIC;
           Dataout : out  STD_LOGIC;
           WE : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC);
	END COMPONENT;

begin
	branch_adder_Reg: Reg_32 PORT MAP (
		RST => RST,
		Datain => branch_adder_in,
		WE => WE,
		Dataout => branch_adder_out,
		CLK => CLK);
		
		ALU_out_Reg: Reg_32 PORT MAP (
		RST => RST,
		Datain => ALU_out_in,
		WE => WE,
		Dataout => ALU_out_out,
		CLK => CLK);
		
		ALU_zero_Reg: Reg_1 PORT MAP (
		RST => RST,
		Datain => ALU_zero_in,
		WE => WE,
		Dataout => ALU_zero_out,
		CLK => CLK);
		
		RF_B_Reg: Reg_32 PORT MAP (
		RST => RST,
		Datain => RF_B_in,
		WE => WE,
		Dataout => RF_B_out,
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
		
		Memstage_reg_we_Reg: Reg_1 PORT MAP (
		RST => RST,
		Datain => Memstage_reg_we_in,
		WE => WE,
		Dataout => Memstage_reg_we_out,
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


end Structural;

