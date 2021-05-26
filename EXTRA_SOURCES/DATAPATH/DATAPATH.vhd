----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:49:18 04/07/2021 
-- Design Name: 
-- Module Name:    DATAPATH - Behavioral 
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

entity DATAPATH is
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
		ram_data_din : out STD_LOGIC_VECTOR (31 downto 0)
		
	);
end DATAPATH;

architecture Structural of DATAPATH is

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
	
	component MEMSTAGE is
	Port ( clk : in  STD_LOGIC;
           ByteOp : in  STD_LOGIC;
           Mem_WrEn : in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0); 
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0); 
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0); 
           MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0); 
           MM_WrEn : out  STD_LOGIC;
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0); 
           MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component Ram_Addr_32to11_Converter is 
	Port ( Input : in  STD_LOGIC_VECTOR (31 downto 0);
           Output : out  STD_LOGIC_VECTOR (10 downto 0));
	end component;
	
	signal temp_out_RF_A, temp_out_RF_B,temp_out_Immed,temp_out_ALU_out,memory_data_out : STD_LOGIC_VECTOR (31 downto 0);
	signal ram_inst_addr_32,ram_data_addr_32 : STD_LOGIC_VECTOR (31 downto 0);
begin

	my_ifstage : IFSTAGE PORT MAP(
		PC_Immed => ram_inst_dout(15 downto 0), -- from Instraction we want to put Immmidiate 16 bits
		PC_sel => ifstage_pc_sel,
		PC_LdEn => ifstage_pc_LdEn,
		Reset => Reset,
		Clk => Clk,
		PC_out => ram_inst_addr_32);
	
	my_decstage : DECSTAGE PORT MAP (
		Instr => ram_inst_dout, -- Instraction from instraction Memory 32 bits
      RF_WrEn => decstage_RF_WrEn,
      ALU_out => temp_out_ALU_out,
      MEM_out => memory_data_out,
      RF_WrData_sel => decstage_RF_WrData_sel, 
      RF_B_sel => decstage_RF_B_sel,
      ImmExt => decstage_ImmExt,
      Clk => Clk,
      Immed => temp_out_Immed,
      RF_A => temp_out_RF_A,
      RF_B => temp_out_RF_B,
		Reset => Reset);
	
	my_exstage : EXSTAGE PORT MAP (
		RF_A => temp_out_RF_A,
      RF_B => temp_out_RF_B,
      Immed => temp_out_Immed,
      ALU_Bin_sel => exstage_ALU_Bin_sel, 
      ALU_func => exstage_ALU_func,
      ALU_out => temp_out_ALU_out,
      ALU_zero => exstage_ALU_zero,
		ALU_ovf => exstage_ALU_ovf,
		ALU_cout => exstage_ALU_cout);
	
	my_memstage : MEMSTAGE PORT MAP (
		clk => Clk,
      ByteOp => memstage_ByteOp,
      Mem_WrEn => memstage_Mem_WrEn,
      ALU_MEM_Addr => temp_out_ALU_out, 
      MEM_DataIn => temp_out_RF_B,
      MEM_DataOut => memory_data_out,
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

