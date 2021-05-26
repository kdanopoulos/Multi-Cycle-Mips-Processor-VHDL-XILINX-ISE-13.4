--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:28:19 04/02/2021
-- Design Name:   
-- Module Name:   C:/Users/user/Documents/Xilinx/fash1/ALU_test.vhd
-- Project Name:  fash1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY ALU_test IS
END ALU_test;
 
ARCHITECTURE behavior OF ALU_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Op : IN  std_logic_vector(3 downto 0);
         Output : OUT  std_logic_vector(31 downto 0);
         Zero : OUT  std_logic;
         Cout : INOUT  std_logic;
         Ovf : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal Op : std_logic_vector(3 downto 0) := (others => '0');

	--BiDirs
   signal Cout : std_logic;

 	--Outputs
   signal Output : std_logic_vector(31 downto 0);
   signal Zero : std_logic;
   signal Ovf : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          B => B,
          Op => Op,
          Output => Output,
          Zero => Zero,
          Cout => Cout,
          Ovf => Ovf
        );
 

   -- Stimulus process
   stim_proc: process
   begin
		-- addition
		Op <= "0000";
		
		-- 2+1=3
		A <= "00000000000000000000000000000010";
		B <= "00000000000000000000000000000001";
      wait for 100 ns;
		
		-- check ovf
		A <= "01111111111111111111111111111111";
		B <= "01111111111111111111111111111111";
      wait for 100 ns;
		
		-- check cout/ovf
		A <= "10000000000000000000000000000010";
		B <= "10000000000000000000000000000001";
      wait for 100 ns;
		
		-- substraction
		Op <= "0001";
		
		-- 2-1=1
		A <= "00000000000000000000000000000010";
		B <= "00000000000000000000000000000001";
      wait for 100 ns;

		-- check ovf
		A <= "00000000000000000000000000000001";
		B <= "10000000000000000000000000000001";
      wait for 100 ns;
		------------------------------------------
		
		A <= "11001011101110111110101010101010";
		B <= "00101011011000101111100101010101";
		
		-- nand
		Op <= "0010";
		wait for 100 ns;
		
		-- or
		Op <= "0011";
		wait for 100 ns;
		
		-- not
		Op <= "0100";
		wait for 100 ns;
		
		-----------------------------------------
		
		A <= "00101011101010101010101010111010";
		
		-- right shift arithmetic
		Op <= "1000";
		wait for 100 ns;
		
		-- right shift logical
		Op <= "1001";
		wait for 100 ns;
		
		-- left shift logical
		Op <= "1010";
		wait for 100 ns;
		
		-- rotate left
		Op <= "1100";
		wait for 100 ns;
		
		-- rotate right
		Op <= "1101";
		wait for 100 ns;

      wait;
   end process;

END;
