--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:28:03 04/19/2021
-- Design Name:   
-- Module Name:   C:/Users/user/Documents/Xilinx/fash1/MEMSTAGE_TB.vhd
-- Project Name:  fash1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEMSTAGE
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
 
ENTITY MEMSTAGE_TB IS
END MEMSTAGE_TB;
 
ARCHITECTURE behavior OF MEMSTAGE_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEMSTAGE
    PORT(
         clk : IN  std_logic;
         ByteOp : IN  std_logic;
         Mem_WrEn : IN  std_logic;
         ALU_MEM_Addr : IN  std_logic_vector(31 downto 0);
         MEM_DataIn : IN  std_logic_vector(31 downto 0);
         MEM_DataOut : OUT  std_logic_vector(31 downto 0);
         MM_Addr : OUT  std_logic_vector(31 downto 0);
         MM_WrEn : OUT  std_logic;
         MM_WrData : OUT  std_logic_vector(31 downto 0);
         MM_RdData : IN  std_logic_vector(31 downto 0)
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
   signal clk : std_logic := '0';
   signal ByteOp : std_logic := '0';
   signal Mem_WrEn : std_logic := '0';
   signal ALU_MEM_Addr : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_DataIn : std_logic_vector(31 downto 0) := (others => '0');
   signal MM_RdData : std_logic_vector(31 downto 0) := (others => '0');
	
	--ram Inputs 
	signal ram_data_addr : std_logic_vector(10 downto 0) := (others => '0');
	

 	--Outputs
   signal MEM_DataOut : std_logic_vector(31 downto 0);
   signal MM_Addr : std_logic_vector(31 downto 0);
   signal MM_WrEn : std_logic;
   signal MM_WrData : std_logic_vector(31 downto 0);
	

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEMSTAGE PORT MAP (
          clk => clk,
          ByteOp => ByteOp,
          Mem_WrEn => Mem_WrEn,
          ALU_MEM_Addr => ALU_MEM_Addr,
          MEM_DataIn => MEM_DataIn,
          MEM_DataOut => MEM_DataOut,
          MM_Addr => MM_Addr,
          MM_WrEn => MM_WrEn,
          MM_WrData => MM_WrData,
          MM_RdData => MM_RdData
        );
	ram_data_addr <= MM_Addr(12 downto 2);
	
	my_ram : RAM PORT MAP(
		clk => Clk,
		inst_addr => "00000000000",
		inst_dout => open,
		data_we => MM_WrEn,
		data_addr => ram_data_addr,
		data_din => MM_WrData,
		data_dout => MM_RdData);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		-- reset
		ByteOp <= '0';
		Mem_WrEn <= '0';
		ALU_MEM_Addr <= "00000000000000000000000000000000";
		MEM_DataIn <= "00000000000000000000000000000000";
		wait for Clk_period * 1;
		
		
		-- sw r3,987 
		-- 987 = 00 0000000000 0000000000 1111011011
		ByteOp <= '0'; -- lw/sw
		Mem_WrEn <= '1'; -- store
		ALU_MEM_Addr <= "00000000000000000000001111011011";
		MEM_DataIn <= "11111000000000000000000000001001"; -- what price we will store 
		wait for Clk_period * 1;
		
		-- lw previous value
		ByteOp <= '0'; -- lw/sw
		Mem_WrEn <= '0'; -- load
		ALU_MEM_Addr <= "00000000000000000000001111011011";
		MEM_DataIn <= "00000001000100001000000100001001"; -- trash value
		wait for Clk_period * 1;
		
		-- lb previous value
		ByteOp <= '1'; -- lb/sb
		Mem_WrEn <= '0'; -- load
		ALU_MEM_Addr <= "00000000000000000000001111011011";
		MEM_DataIn <= "00000001000100001000000100001001"; -- trash value
		wait for Clk_period * 1;
		
		-- sb 
		ByteOp <= '1'; -- lb/sb
		Mem_WrEn <= '1'; -- store
		ALU_MEM_Addr <= "00000000000000000000001111011100";
		MEM_DataIn <= "11111111111111111111111111111111"; 
		wait for Clk_period * 1;
		
		-- lw previous value
		ByteOp <= '0'; -- lw/sw
		Mem_WrEn <= '0'; -- load
		ALU_MEM_Addr <= "00000000000000000000001111011100";
		MEM_DataIn <= "00000001000100001000000100001001"; -- trash value
		wait for Clk_period * 1;
		
		
		
		wait;
   end process;

END;
