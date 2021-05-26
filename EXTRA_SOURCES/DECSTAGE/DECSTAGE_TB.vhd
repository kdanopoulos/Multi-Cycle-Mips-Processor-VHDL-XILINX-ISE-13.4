--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:33:18 04/19/2021
-- Design Name:   
-- Module Name:   C:/Users/user/Documents/Xilinx/fash1/DECSTAGE_TB.vhd
-- Project Name:  fash1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DECSTAGE
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
 
ENTITY DECSTAGE_TB IS
END DECSTAGE_TB;
 
ARCHITECTURE behavior OF DECSTAGE_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DECSTAGE
    PORT(
         Instr : IN  std_logic_vector(31 downto 0);
         RF_WrEn : IN  std_logic;
         ALU_out : IN  std_logic_vector(31 downto 0);
         MEM_out : IN  std_logic_vector(31 downto 0);
         RF_WrData_sel : IN  std_logic;
         RF_B_sel : IN  std_logic;
         ImmExt : IN  std_logic_vector(1 downto 0);
         Clk : IN  std_logic;
         Immed : OUT  std_logic_vector(31 downto 0);
         RF_A : OUT  std_logic_vector(31 downto 0);
         RF_B : OUT  std_logic_vector(31 downto 0);
			Reset : IN  STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrEn : std_logic := '0';
   signal ALU_out : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_out : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrData_sel : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal ImmExt : std_logic_vector(1 downto 0) := (others => '0');
   signal Clk : std_logic := '0';
	signal Reset : std_logic := '0';

 	--Outputs
   signal Immed : std_logic_vector(31 downto 0);
   signal RF_A : std_logic_vector(31 downto 0);
   signal RF_B : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DECSTAGE PORT MAP (
          Instr => Instr,
          RF_WrEn => RF_WrEn,
          ALU_out => ALU_out,
          MEM_out => MEM_out,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          ImmExt => ImmExt,
          Clk => Clk,
          Immed => Immed,
          RF_A => RF_A,
          RF_B => RF_B,
			 Reset => Reset
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
		Reset <= '1';
		wait for Clk_period * 1;
		Reset <= '0';
		-- RF_A always is register [rs]
		-- RF_B [rt](RF_B_sel = 0) or [rd](RF_B_sel = 1)
	
		-- addi r5,r0,8
		-- r5 = 0 + 8
		Instr <= "11000000000001010000000000001000";
		RF_WrEn <= '1'; -- write at register
		ALU_out <= "00000000000000000000000000001000"; -- the result from the addition = 8 (32 bits)
		MEM_out <= "11000000000001010000000000001000"; -- trash values from memory
		RF_WrData_sel <= '0'; -- we choose data from ALU
		RF_B_sel <= '0'; -- we don't care we want the immed value
		ImmExt <= "01"; -- SignExtend(Imm)
		wait for Clk_period * 1;
		
		-- opcode is trash values (decstage don't use it at all)
		-- RF_A =  r5
		-- RF_B = r5
		-- Immed(16) = 1000000000000000
		-- ImmExt = 01 = signexted = Immed(32) = 11111111111111111000000000000000
		Instr <= "11111100101001011000000000000000";
		RF_WrEn <= '0'; -- write at register
		ALU_out <= "00000000000000000000000000001000"; -- trash values from ALU
		MEM_out <= "11000000000001010000000000001000"; -- trash values from memory
		RF_WrData_sel <= '0'; -- we choose data from ALU
		RF_B_sel <= '1'; -- RF_B = [rd]
		ImmExt <= "01"; -- SignExtend(Imm)
		wait for Clk_period * 1;
		
		-- opcode is trash values (decstage don't use it at all)
		-- RF_A =  r0
		-- RF_B = r5
		-- Immed(16) = 1000000000000000
		-- ImmExt = 10 = zerofill = Immed(32) = 00000000000000001000000000000000
		Instr <= "11111100000001011000000000000000";
		RF_WrEn <= '0'; -- write at register
		ALU_out <= "00000000000000000000000000001000"; -- trash values from ALU
		MEM_out <= "11000000000001010000000000001000"; -- trash values from memory
		RF_WrData_sel <= '0'; -- we choose data from ALU
		RF_B_sel <= '1'; -- RF_B = [rd]
		ImmExt <= "10"; -- zerofill(Imm)
		wait for Clk_period * 1;
		
		-- opcode is trash values (decstage don't use it at all)
		-- RF_A =  r5
		-- RF_B = r0
		-- Immed(16) = 1000000000000000
		-- ImmExt = 11 = shift & zerofill(32) = 10000000000000000000000000000000
		Instr <= "11111100101000001000000000000000";
		RF_WrEn <= '0'; -- write at register
		ALU_out <= "00000000000000000000000000001000"; -- trash values from ALU
		MEM_out <= "11000000000001010000000000001000"; -- trash values from memory
		RF_WrData_sel <= '0'; -- we choose data from ALU
		RF_B_sel <= '1'; -- RF_B = [rd]
		ImmExt <= "11"; -- shift & zerofill(Imm)
		wait for Clk_period * 1;
		
		-- opcode is trash values (decstage don't use it at all)
		-- RF_A =  r5
		-- RF_B = r0
		-- Immed(16) = 1000000000000000
		-- ImmExt = 00 = don't care = 00000000000000000000000000000000
		Instr <= "11111100101000001000000000000000";
		RF_WrEn <= '0'; -- write at register
		ALU_out <= "00000000000000000000000000001000"; -- trash values from ALU
		MEM_out <= "11000000000001010000000000001000"; -- trash values from memory
		RF_WrData_sel <= '0'; -- we choose data from ALU
		RF_B_sel <= '1'; -- RF_B = [rd]
		ImmExt <= "00";
		wait for Clk_period * 1;

      wait;
   end process;

END;
