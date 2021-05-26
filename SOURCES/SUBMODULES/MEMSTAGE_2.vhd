----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:51:51 05/13/2021 
-- Design Name: 
-- Module Name:    MEMSTAGE_2 - Behavioral 
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

entity MEMSTAGE_2 is
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
end MEMSTAGE_2;

architecture Structural of MEMSTAGE_2 is
	component MEM_WR_REG is
	Port( MEM_DataOut_in : in STD_LOGIC_VECTOR (31 downto 0);
			MEM_DataOut_out : out STD_LOGIC_VECTOR (31 downto 0);
			ALU_out_in : in STD_LOGIC_VECTOR (31 downto 0);
			ALU_out_out : out STD_LOGIC_VECTOR (31 downto 0);
			RF_WrEn_in : in STD_LOGIC;
			RF_WrEn_out : out STD_LOGIC;
			RF_WrData_sel_in : in STD_LOGIC;
			RF_WrData_sel_out: out STD_LOGIC;
			WE : in STD_LOGIC;
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC);
	end component;
	
	component And_Gate is
	Port ( Input_1 : in STD_LOGIC;
			 Input_2 : in STD_LOGIC;
			 Output : out STD_LOGIC);
	end component;
	
	component Or_Gate is
	Port ( Input_1 : in  STD_LOGIC;
           Input_2 : in  STD_LOGIC;
           Input_3 : in  STD_LOGIC;
           Output : out  STD_LOGIC);
	end component;
	
	component Mux_2to1 is
	Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
           In1 : in  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component Mux_4to1 is
	Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
           In1 : in  STD_LOGIC_VECTOR (31 downto 0);
			  In2 : in  STD_LOGIC_VECTOR (31 downto 0);
			  In3 : in  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC_VECTOR(1 downto 0);
           Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	Component adder is
		Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
			   In1 : in  STD_LOGIC_VECTOR (31 downto 0);
               Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	signal MEM_DataOut_temp : STD_LOGIC_VECTOR (31 downto 0);
	signal bne_temp, beq_temp, branch_temp : STD_LOGIC;
begin
	MM_WrEn <= Mem_WrEn;
	
	offset_adder : adder PORT MAP (
		In0 => ALU_MEM_Addr,
		In1 => "00000000000000000000010000000000", -- 0x400 = 1024
		Output => MM_Addr);
		
	data_out_mux: Mux_4to1 PORT MAP (
		In0 => MM_RdData, -- 00 = lw
		In1 => "000000000000000000000000" & MM_RdData(7 downto 0), -- 01 = lb
		In2 => "00000000000000000000000000000000", -- 10 = sw -- x dont't care at store
		In3 => "00000000000000000000000000000000", -- 11 = sb -- x dont't care at store
		Sel => Mem_WrEn & ByteOp,
		Output =>MEM_DataOut_temp);
		
	data_in_mux: Mux_4to1 PORT MAP (
		In0 => "00000000000000000000000000000000", -- 00 = lw -- x dont't care at load
		In1 => "00000000000000000000000000000000", -- 01 = lb -- x dont't care at load
		In2 => MEM_DataIn, -- 10 = sw 
		In3 => "000000000000000000000000" & MEM_DataIn(7 downto 0), -- 11 = sb 
		Sel => Mem_WrEn & ByteOp,
		Output =>MM_WrData);
		
	my_MEM_WR_REG : MEM_WR_REG PORT MAP(
		MEM_DataOut_in => MEM_DataOut_temp,
		MEM_DataOut_out => MEM_DataOut_reg_out, 
		ALU_out_in => ALU_MEM_Addr,
		ALU_out_out => ALU_out_reg_out, 
		RF_WrEn_in => RF_WrEn_reg_in,
		RF_WrEn_out => RF_WrEn_reg_out,
		RF_WrData_sel_in => RF_WrData_sel_reg_in, 
		RF_WrData_sel_out => RF_WrData_sel_reg_out,
		WE => Reg_WE,
		CLK => clk,
		RST => Reset);
		
	-- branch = 1 & branch_condition = 0 -> BRANCH!
	-- branch = 0 & branch_condition = 1 -> BEQ!
	-- branch = 1 & branch_condition = 1 -> BNE!
	
	b_Gate : And_Gate PORT MAP ( -- BRANCH
		Input_1 => branch,
		Input_2 => not branch_condition,
		Output => branch_temp);
		
	beq_Gate : And_Gate PORT MAP ( -- BEQ
		Input_1 => ALU_zero_reg_in,
		Input_2 => (not branch) and branch_condition,
		Output => beq_temp);
		
	bne_Gate : And_Gate PORT MAP ( -- BNE
		Input_1 => not ALU_zero_reg_in,
		Input_2 => branch and branch_condition,
		Output => bne_temp);
		
	my_Or_Gate : Or_Gate PORT MAP (
		Input_1 => branch_temp,
		Input_2 => beq_temp,
		Input_3 => bne_temp,
		Output => ifstate_PC_sel);
	


end Structural;


