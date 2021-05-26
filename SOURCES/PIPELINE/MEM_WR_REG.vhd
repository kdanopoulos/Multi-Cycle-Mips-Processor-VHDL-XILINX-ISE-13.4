----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:56:31 05/13/2021 
-- Design Name: 
-- Module Name:    MEM_WR_REG - Behavioral 
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

entity MEM_WR_REG is
Port( 
	MEM_DataOut_in : in STD_LOGIC_VECTOR (31 downto 0);
	MEM_DataOut_out : out STD_LOGIC_VECTOR (31 downto 0);
	ALU_out_in : in STD_LOGIC_VECTOR (31 downto 0);
	ALU_out_out : out STD_LOGIC_VECTOR (31 downto 0);
	-- WRITE REGISTER
	RF_WrEn_in : in STD_LOGIC;
	RF_WrEn_out : out STD_LOGIC;
	RF_WrData_sel_in : in STD_LOGIC;
	RF_WrData_sel_out: out STD_LOGIC;
	WE : in STD_LOGIC;
	CLK : in STD_LOGIC;
	RST : in STD_LOGIC);
end MEM_WR_REG;

architecture Structural of MEM_WR_REG is
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
	MEM_DataOut_Reg: Reg_32 PORT MAP (
		RST => RST,
		Datain => MEM_DataOut_in,
		WE => WE,
		Dataout => MEM_DataOut_out,
		CLK => CLK);
		
	ALU_out_Reg: Reg_32 PORT MAP (
		RST => RST,
		Datain => ALU_out_in,
		WE => WE,
		Dataout => ALU_out_out,
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

