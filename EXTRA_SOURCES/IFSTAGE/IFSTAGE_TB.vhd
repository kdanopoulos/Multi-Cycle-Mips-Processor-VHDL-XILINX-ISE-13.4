--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:27:59 04/19/2021
-- Design Name:   
-- Module Name:   C:/Users/user/Documents/Xilinx/fash1/IFSTAGE_TB.vhd
-- Project Name:  fash1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IFSTAGE
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
 
ENTITY IFSTAGE_TB IS
END IFSTAGE_TB;
 
ARCHITECTURE behavior OF IFSTAGE_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IFSTAGE
    PORT(
         PC_Immed : IN  std_logic_vector(15 downto 0);
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         Reset : IN  std_logic;
         Clk : IN  std_logic;
         PC_out : INOUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	 
	 COMPONENT RAM
	 port (
		clk : in std_logic;
		inst_addr : in std_logic_vector(10 downto 0);
		inst_dout : out std_logic_vector(31 downto 0);
		data_we : in std_logic;
		data_addr : in std_logic_vector(10 downto 0);
		data_din : in std_logic_vector(31 downto 0);
		data_dout : out std_logic_vector(31 downto 0));
	 END COMPONENT;
    

   --Inputs
   signal PC_Immed : std_logic_vector(15 downto 0) := (others => '0');
   signal PC_sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal Reset : std_logic := '0';
   signal Clk : std_logic := '0';

	--BiDirs
   signal PC_out : std_logic_vector(31 downto 0);
	signal temp_inst_addr : std_logic_vector(10 downto 0);
	signal inst_dout : std_logic_vector(31 downto 0);

	

   -- Clock period definitions
   constant Clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IFSTAGE PORT MAP (
          PC_Immed => PC_Immed,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          Reset => Reset,
          Clk => Clk,
          PC_out => PC_out
        );
		  
	temp_inst_addr <= PC_out(12 downto 2);
	
	my_ram : RAM PORT MAP(
		clk => Clk,
		inst_addr => temp_inst_addr,
		inst_dout => inst_dout,
		data_we => '0',
		data_addr => "00000000000",
		data_din => "00000000000000000000000000000000",
		data_dout => open);

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
      -- hold reset state for 100 ns.
		-- Reset
		PC_Immed <= "0000000000000000";
		PC_sel <= '0';
		PC_LdEn <= '0';
		Reset <= '1';
		wait for Clk_period * 1;
		
		-- PC_out = 0 + 4  = 4
		PC_Immed <= "0000000000000000";
		PC_sel <= '0'; -- previous pc_out + 4
		PC_LdEn <= '1'; --  load this value as the next instr_addr
		Reset <= '0';
		wait for Clk_period * 1;
		
		-- PC_out = 4 + 4  = 8
		PC_Immed <= "0000000000000000";
		PC_sel <= '0'; -- previous pc_out + 4
		PC_LdEn <= '1'; --  load this value as the next instr_addr
		Reset <= '0';
		wait for Clk_period * 1;
		
		-- PC_out = 4 + 8  = 12
		PC_Immed <= "0000000000000000";
		PC_sel <= '0'; -- previous pc_out + 4
		PC_LdEn <= '1'; --  load this value as the next instr_addr
		Reset <= '0';
		wait for Clk_period * 1;
		
		-- PC_out = 12 (do nothing) 
		PC_Immed <= "0000000000000000";
		PC_sel <= '0'; -- previous pc_out + 4
		PC_LdEn <= '0'; --  load this value as the next instr_addr
		Reset <= '0';
		wait for Clk_period * 5;
		
		-- PC_out = 12 + 8  = 20
		PC_Immed <= "0000000000000001"; -- Immed(16) = 1 -> Immed(32) = 4
		PC_sel <= '1'; -- previous pc_out + 4 + Immed(32) = previous pc_out + 8
		PC_LdEn <= '1'; --  load this value as the next instr_addr
		Reset <= '0';
		wait for Clk_period * 1;
		
		
		

		

      wait;
   end process;

END;
