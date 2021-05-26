--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:58:03 04/21/2021
-- Design Name:   
-- Module Name:   C:/Users/user/Documents/Xilinx/fash1/Ifstage_Decstage_Exstage_Ram_test.vhd
-- Project Name:  fash1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IFSTAGE_DECSTAGE_EXSTAGE_RAM
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
 
ENTITY Ifstage_Decstage_Exstage_Ram_test IS
END Ifstage_Decstage_Exstage_Ram_test;
 
ARCHITECTURE behavior OF Ifstage_Decstage_Exstage_Ram_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IFSTAGE_DECSTAGE_EXSTAGE_RAM
    PORT(
         CLK : IN  std_logic;
         Reset : IN  std_logic;
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         RF_WrEn : IN  std_logic;
         RF_WrData_sel : IN  std_logic;
         RF_B_sel : IN  std_logic;
         ImmExt : IN  std_logic_vector(1 downto 0);
         ALU_Bin_sel : IN  std_logic;
         ALU_func : IN  std_logic_vector(3 downto 0);
         ALU_zero : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Reset : std_logic := '0';
   signal PC_sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal RF_WrEn : std_logic := '0';
   signal RF_WrData_sel : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal ImmExt : std_logic_vector(1 downto 0) := (others => '0');
   signal ALU_Bin_sel : std_logic := '0';
   signal ALU_func : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal ALU_zero : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IFSTAGE_DECSTAGE_EXSTAGE_RAM PORT MAP (
          CLK => CLK,
          Reset => Reset,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          RF_WrEn => RF_WrEn,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          ImmExt => ImmExt,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_func => ALU_func,
          ALU_zero => ALU_zero
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
		wait for clk_period*1;
		Reset <= '0';
		
		-- addi r5,r0,8
		PC_sel <= '0'; --(PC+4)
		PC_LdEn <= '1'; 
		RF_WrEn <= '1';-- RF[rd] <- RF[rs] + SignExtend(Imm)
		RF_WrData_sel <= '0'; --Alu out 
		RF_B_sel <= '0';-- don't care about RF_B (second value register)
		ImmExt <= "01";-- sign extention
		ALU_Bin_sel <= '1'; -- we want to pass the Immed value
		ALU_func <= "0000"; --add
		wait for clk_period*1;
		
		-- ori r3,r0,ABCD
		PC_sel <= '0'; --(PC+4)
		PC_LdEn <= '1';
		RF_WrEn <= '1'; -- RF[rd] <- RF[rs] | ZeroFill(Imm)
		RF_WrData_sel <= '0'; --(ALU)
		RF_B_sel <= '0'; -- don't care about RF_B (second value register)
		ImmExt <= "10"; -- zero fill
		ALU_Bin_sel <= '1'; -- we want to pass the Immed value
		ALU_func <= "0011"; -- or
		wait for clk_period*1;

      wait;
   end process;

END;
