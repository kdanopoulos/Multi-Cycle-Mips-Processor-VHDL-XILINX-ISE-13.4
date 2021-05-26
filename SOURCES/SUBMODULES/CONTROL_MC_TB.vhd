--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:48:32 05/23/2021
-- Design Name:   
-- Module Name:   C:/Users/user/Documents/Xilinx/fash1/CONTROL_MC_TB.vhd
-- Project Name:  fash1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CONTROL_MC
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY CONTROL_MC_TB IS
END CONTROL_MC_TB;
 
ARCHITECTURE behavior OF CONTROL_MC_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CONTROL_MC
    PORT(
         Reset : IN  std_logic;
         CLK : IN  std_logic;
         ALU_zero_reg_out : IN  std_logic;
         Instruction : IN  std_logic_vector(31 downto 0);
         ifstage_pc_sel : OUT  std_logic;
         ifstage_pc_LdEn : OUT  std_logic;
         decstage_RF_WrEn : OUT  std_logic;
         decstage_RF_WrData_sel : OUT  std_logic;
         decstage_RF_B_sel : OUT  std_logic;
         decstage_ImmExt : OUT  std_logic_vector(1 downto 0);
         exstage_ALU_Bin_sel : OUT  std_logic;
         exstage_ALU_func : OUT  std_logic_vector(3 downto 0);
         memstage_ByteOp : OUT  std_logic;
         memstage_Mem_WrEn : OUT  std_logic;
         ALU_zero_reg_WE : OUT  std_logic;
         instr_reg_WE : OUT  std_logic;
         RF_A_reg_WE : OUT  std_logic;
         RF_B_reg_WE : OUT  std_logic;
         Immed_32_reg_WE : OUT  std_logic;
         ALU_out_reg_WE : OUT  std_logic;
         MEM_DataOut_reg_WE : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Reset : std_logic := '0';
   signal CLK : std_logic := '0';
   signal ALU_zero_reg_out : std_logic := '0';
   signal Instruction : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal ifstage_pc_sel : std_logic;
   signal ifstage_pc_LdEn : std_logic;
   signal decstage_RF_WrEn : std_logic;
   signal decstage_RF_WrData_sel : std_logic;
   signal decstage_RF_B_sel : std_logic;
   signal decstage_ImmExt : std_logic_vector(1 downto 0);
   signal exstage_ALU_Bin_sel : std_logic;
   signal exstage_ALU_func : std_logic_vector(3 downto 0);
   signal memstage_ByteOp : std_logic;
   signal memstage_Mem_WrEn : std_logic;
   signal ALU_zero_reg_WE : std_logic;
   signal instr_reg_WE : std_logic;
   signal RF_A_reg_WE : std_logic;
   signal RF_B_reg_WE : std_logic;
   signal Immed_32_reg_WE : std_logic;
   signal ALU_out_reg_WE : std_logic;
   signal MEM_DataOut_reg_WE : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CONTROL_MC PORT MAP (
          Reset => Reset,
          CLK => CLK,
          ALU_zero_reg_out => ALU_zero_reg_out,
          Instruction => Instruction,
          ifstage_pc_sel => ifstage_pc_sel,
          ifstage_pc_LdEn => ifstage_pc_LdEn,
          decstage_RF_WrEn => decstage_RF_WrEn,
          decstage_RF_WrData_sel => decstage_RF_WrData_sel,
          decstage_RF_B_sel => decstage_RF_B_sel,
          decstage_ImmExt => decstage_ImmExt,
          exstage_ALU_Bin_sel => exstage_ALU_Bin_sel,
          exstage_ALU_func => exstage_ALU_func,
          memstage_ByteOp => memstage_ByteOp,
          memstage_Mem_WrEn => memstage_Mem_WrEn,
          ALU_zero_reg_WE => ALU_zero_reg_WE,
          instr_reg_WE => instr_reg_WE,
          RF_A_reg_WE => RF_A_reg_WE,
          RF_B_reg_WE => RF_B_reg_WE,
          Immed_32_reg_WE => Immed_32_reg_WE,
          ALU_out_reg_WE => ALU_out_reg_WE,
          MEM_DataOut_reg_WE => MEM_DataOut_reg_WE
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		

		Reset <= '1';
		Instruction <= "00000000000000000000000000000000";
		ALU_zero_reg_out <= '0';
		wait for CLK_period*2;
		--------------------------------------
		wait for 10ns;
		Reset <= '0';
		wait for clk_period*1;
		--------------------------------------
		
		-- addi r5, r0, 8
		Instruction <= "11000000000001010000000000001000";
		ALU_zero_reg_out <= '0';
		wait for clk_period*4; -- Decstage -> Exstage -> Write Register -> Ifstage
		
		-- ori r3,r0,ABCD
		Instruction <= "11001100000000111010101111001101";
		ALU_zero_reg_out <= '0';
		wait for clk_period*4; -- Decstage -> Exstage -> Write Register -> Ifstage
		
		-- sw r3,4(r0) 
		Instruction <= "01111100000000110000000000000100";
		ALU_zero_reg_out <= '0';
		wait for clk_period*4; -- Decstage -> Exstage -> Memstage -> Ifstage
		
		-- lw r10,-4(r5)
		Instruction <= "00111100101010101111111111111100";
		ALU_zero_reg_out <= '0';
		wait for clk_period*5; -- Decstage -> Exstage -> Memstage -> Write Register -> Ifstage
		
		-- lb r16,4(r0) 
		Instruction <= "00001100000100000000000000000100";
		ALU_zero_reg_out <= '0';
		wait for clk_period*5; -- Decstage -> Exstage -> Memstage -> Write Register -> Ifstage
		
		-- b -2 
		Instruction <= "11111100000000001111111111111110";
		ALU_zero_reg_out <= '0';
		wait for clk_period*2; -- Decstage -> Ifstage
		
		-- beq r5,r5,8 
		Instruction <= "00000000101001010000000000001000";
		ALU_zero_reg_out <= '0';
		wait for clk_period*2; -- Decstage -> Exstage
		ALU_zero_reg_out <= '1';
		wait for clk_period*1; -- Ifstage
		
		-- nand r4,r10,r16
		Instruction <= "10000001010001001000000000110101";
		ALU_zero_reg_out <= '0';
		-- Decstage -> Exstage -> Write Register -> Ifstage

      wait;
   end process;

END;

