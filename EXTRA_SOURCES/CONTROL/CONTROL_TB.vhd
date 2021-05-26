--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:12:16 04/19/2021
-- Design Name:   
-- Module Name:   C:/Users/user/Documents/Xilinx/fash1/CONTROL_TB.vhd
-- Project Name:  fash1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CONTROL
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
 
ENTITY CONTROL_TB IS
END CONTROL_TB;
 
ARCHITECTURE behavior OF CONTROL_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CONTROL
    PORT(
         exstage_ALU_zero : IN  std_logic;
         exstage_ALU_ovf : IN  std_logic;
         exstage_ALU_cout : IN  std_logic;
         Instruction : IN  std_logic_vector(31 downto 0);
         CLK : IN  std_logic;
         Reset : IN  std_logic;
         control_signals : OUT  std_logic_vector(14 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal exstage_ALU_zero : std_logic := '0';
   signal exstage_ALU_ovf : std_logic := '0';
   signal exstage_ALU_cout : std_logic := '0';
   signal Instruction : std_logic_vector(31 downto 0) := (others => '0');
   signal CLK : std_logic := '0';
   signal Reset : std_logic := '0';

 	--Outputs
   signal control_signals : std_logic_vector(14 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CONTROL PORT MAP (
          exstage_ALU_zero => exstage_ALU_zero,
          exstage_ALU_ovf => exstage_ALU_ovf,
          exstage_ALU_cout => exstage_ALU_cout,
          Instruction => Instruction,
          CLK => CLK,
          Reset => Reset,
          control_signals => control_signals
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
      -- hold reset state for 100 ns.
		Reset <= '1';
		Instruction <= "00000000000000000000000000000000";
		exstage_ALU_zero <= '0';
		exstage_ALU_ovf <= '0';
      exstage_ALU_cout <= '0';
		wait for CLK_period*1;
		--------------------------------------
		Reset <= '0';
		wait for clk_period*1;
		--wait for 10 ns ;
		Reset <= '0';
		
		-- addi r5, r0, 8
		Instruction <= "11000000000001010000000000001000";
		exstage_ALU_zero <= '0';
		exstage_ALU_ovf <= '0';
      exstage_ALU_cout <= '0';
		wait for clk_period*1;
		
		-- ori r3,r0,ABCD
		Instruction <= "11001100000000111010101111001101";
		exstage_ALU_zero <= '0';
		exstage_ALU_ovf <= '0';
      exstage_ALU_cout <= '0';
		wait for clk_period*1;
		
		-- sw r3,4(r0) 
		Instruction <= "01111100000000110000000000000100";
		exstage_ALU_zero <= '0';
		exstage_ALU_ovf <= '0';
      exstage_ALU_cout <= '0';
		wait for clk_period*1;
		
		-- lw r10,-4(r5)
		Instruction <= "00111100101010101111111111111100";
		exstage_ALU_zero <= '0';
		exstage_ALU_ovf <= '0';
      exstage_ALU_cout <= '0';
		wait for clk_period*1;
		
		-- lb r16,4(r0) 
		Instruction <= "00001100000100000000000000000100";
		exstage_ALU_zero <= '0';
		exstage_ALU_ovf <= '0';
      exstage_ALU_cout <= '0';
		wait for clk_period*1;
		
		-- nand r4,r10,r16
		Instruction <= "10000001010001001000000000110101";
		exstage_ALU_zero <= '0';
		exstage_ALU_ovf <= '0';
      exstage_ALU_cout <= '0';
		

      wait;
   end process;

END;
