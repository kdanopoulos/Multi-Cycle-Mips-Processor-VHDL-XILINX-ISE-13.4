--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:56:35 04/20/2021
-- Design Name:   
-- Module Name:   C:/Users/user/Documents/Xilinx/fash1/DATAPATH_TB.vhd
-- Project Name:  fash1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DATAPATH
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
 
ENTITY DATAPATH_TB IS
END DATAPATH_TB;
 
ARCHITECTURE behavior OF DATAPATH_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DATAPATH
    PORT(
         Clk : IN  std_logic;
         Reset : IN  std_logic;
         ifstage_pc_sel : IN  std_logic;
         ifstage_pc_LdEn : IN  std_logic;
         decstage_RF_WrEn : IN  std_logic;
         decstage_RF_WrData_sel : IN  std_logic;
         decstage_RF_B_sel : IN  std_logic;
         decstage_ImmExt : IN  std_logic_vector(1 downto 0);
         exstage_ALU_Bin_sel : IN  std_logic;
         exstage_ALU_func : IN  std_logic_vector(3 downto 0);
         exstage_ALU_zero : OUT  std_logic;
         exstage_ALU_ovf : OUT  std_logic;
         exstage_ALU_cout : INOUT  std_logic;
         memstage_ByteOp : IN  std_logic;
         memstage_Mem_WrEn : IN  std_logic;
         ram_inst_dout : IN  std_logic_vector(31 downto 0);
         ram_data_dout : IN  std_logic_vector(31 downto 0);
         ram_inst_addr : OUT  std_logic_vector(10 downto 0);
         ram_data_WE : OUT  std_logic;
         ram_data_addr : OUT  std_logic_vector(10 downto 0);
         ram_data_din : OUT  std_logic_vector(31 downto 0)
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
   signal Clk : std_logic := '0';
   signal Reset : std_logic := '0';
   signal ifstage_pc_sel : std_logic := '0';
   signal ifstage_pc_LdEn : std_logic := '0';
   signal decstage_RF_WrEn : std_logic := '0';
   signal decstage_RF_WrData_sel : std_logic := '0';
   signal decstage_RF_B_sel : std_logic := '0';
   signal decstage_ImmExt : std_logic_vector(1 downto 0) := (others => '0');
   signal exstage_ALU_Bin_sel : std_logic := '0';
   signal exstage_ALU_func : std_logic_vector(3 downto 0) := (others => '0');
   signal memstage_ByteOp : std_logic := '0';
   signal memstage_Mem_WrEn : std_logic := '0';
   signal ram_inst_dout : std_logic_vector(31 downto 0) := (others => '0');
   signal ram_data_dout : std_logic_vector(31 downto 0) := (others => '0');

	--BiDirs
   signal exstage_ALU_cout : std_logic;

 	--Outputs
   signal exstage_ALU_zero : std_logic;
   signal exstage_ALU_ovf : std_logic;
   signal ram_inst_addr : std_logic_vector(10 downto 0);
   signal ram_data_WE : std_logic;
   signal ram_data_addr : std_logic_vector(10 downto 0);
   signal ram_data_din : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DATAPATH PORT MAP (
          Clk => Clk,
          Reset => Reset,
          ifstage_pc_sel => ifstage_pc_sel,
          ifstage_pc_LdEn => ifstage_pc_LdEn,
          decstage_RF_WrEn => decstage_RF_WrEn,
          decstage_RF_WrData_sel => decstage_RF_WrData_sel,
          decstage_RF_B_sel => decstage_RF_B_sel,
          decstage_ImmExt => decstage_ImmExt,
          exstage_ALU_Bin_sel => exstage_ALU_Bin_sel,
          exstage_ALU_func => exstage_ALU_func,
          exstage_ALU_zero => exstage_ALU_zero,
          exstage_ALU_ovf => exstage_ALU_ovf,
          exstage_ALU_cout => exstage_ALU_cout,
          memstage_ByteOp => memstage_ByteOp,
          memstage_Mem_WrEn => memstage_Mem_WrEn,
          ram_inst_dout => ram_inst_dout,
          ram_data_dout => ram_data_dout,
          ram_inst_addr => ram_inst_addr,
          ram_data_WE => ram_data_WE,
          ram_data_addr => ram_data_addr,
          ram_data_din => ram_data_din
        );
		  
	my_ram : RAM PORT MAP(
		clk => Clk,
		inst_addr => ram_inst_addr,
		inst_dout => ram_inst_dout,
		data_we => ram_data_WE,
		data_addr => ram_data_addr,
		data_din => ram_data_din,
		data_dout => ram_data_dout);

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
		Reset <= '1';
		decstage_RF_WrData_sel <= '1'; 
		wait for clk_period*1;
		
		--ifstage_pc_sel <='0'; 
		--ifstage_pc_LdEn <='1'; 
		--Reset <= '0';
		--wait for clk_period*1;
		Reset <= '0';
		--wait for clk_period*1;


		-- addi r5,r0,8
		ifstage_pc_sel <= '0'; --(PC+4)
		ifstage_pc_LdEn <= '1'; 
		decstage_RF_WrEn <= '1';-- RF[rd] <- RF[rs] + SignExtend(Imm)
		decstage_RF_WrData_sel <= '0'; --Alu out 
		decstage_RF_B_sel <= '0';-- don't care about RF_B (second value register)
		decstage_ImmExt <= "01";-- sign extention
		exstage_ALU_Bin_sel <= '1'; -- we want to pass the Immed value
		exstage_ALU_func <= "0000"; --add
		memstage_ByteOp <= '0';	-- don't care (we don't use the memory at all)	
		memstage_Mem_WrEn <= '0'; -- we don't write to the memory
		wait for clk_period*1;
		
		-- ori r3,r0,ABCD
		ifstage_pc_sel <= '0'; --(PC+4)
		ifstage_pc_LdEn <= '1';
		decstage_RF_WrEn <= '1'; -- RF[rd] <- RF[rs] | ZeroFill(Imm)
		--decstage_RF_WrData_sel <= '0'; --(ALU)
		decstage_RF_B_sel <= '0'; -- don't care about RF_B (second value register)
		decstage_ImmExt <= "10"; -- zero fill
		exstage_ALU_Bin_sel <= '1'; -- we want to pass the Immed value
		exstage_ALU_func <= "0011"; -- or
		memstage_ByteOp <= '0'; -- don't care (we don't use the memory at all)
		memstage_Mem_WrEn <= '0'; -- we don't write to the memory
		wait for clk_period*1;
		

		
		-- sw r3 4(r0)
		ifstage_pc_sel <= '0'; -- (PC+4)
		ifstage_pc_LdEn <= '1';
		decstage_RF_WrEn <= '0'; -- MEM[RF[rs] + SignExtend(Imm)] <- RF[rd] 
		--decstage_RF_WrData_sel <= '0'; -- don't care
		decstage_RF_B_sel <= '1'; -- we want to store the register rd = r3
		decstage_ImmExt <= "01"; -- sign extention
		exstage_ALU_Bin_sel <= '1'; -- we want Immed as value
		exstage_ALU_func <= "0000"; -- add RF[rs]+SignExtend(Imm)
		memstage_ByteOp <= '0'; -- lw/sw
		memstage_Mem_WrEn <= '1'; -- we want to write to memory
		wait for clk_period*1;
		


		-- lw r10,-4(r5)
		ifstage_pc_sel <= '0'; --(PC+4)
		ifstage_pc_LdEn <= '1';
		decstage_RF_WrEn <= '1'; -- RF[rd] <- MEM[RF[rs] + SignExtend(Imm)]
		decstage_RF_WrData_sel <= '1';-- memory
		decstage_RF_B_sel <= '0'; -- don't care for second register we will use the immm16
		decstage_ImmExt <= "01"; -- sign extention
		exstage_ALU_Bin_sel <= '1'; -- we want Immed as value 
		exstage_ALU_func <= "0000"; -- add RF[rs]+SignExtend(Imm)
		memstage_ByteOp <= '0'; -- lw/sw
		memstage_Mem_WrEn <= '0'; -- we don't write at memory
		wait for clk_period*1;
		 

		
		-- lb r16 4(r0)
		ifstage_pc_sel <= '0'; --(PC+4)
		ifstage_pc_LdEn <= '1';
		decstage_RF_WrEn <= '1'; -- RF[rd] <- ZeroFill(31 downto 8) & MEM[ RF[rs]+SignExtend(Imm) ](7 downto 0)		decstage_RF_WrData_sel <= '1'; -- memory
		decstage_RF_B_sel <= '0'; -- don't care for second register we will use the immm16
		decstage_ImmExt <= "01"; -- sign extention
		exstage_ALU_Bin_sel <= '1'; -- we want Immed as value 
		exstage_ALU_func <= "0000"; -- add RF[rs]+SignExtend(Imm)
		memstage_ByteOp <= '1'; -- lb/sb
		memstage_Mem_WrEn <= '0'; -- we don't write at memory
		wait for clk_period*1;
		
		-- nand r4,r0,r16
		ifstage_pc_sel <= '0'; --(PC+4)
		ifstage_pc_LdEn <= '1';
		decstage_RF_WrEn <= '1';		decstage_RF_WrData_sel <= '0';
		decstage_RF_B_sel <= '0';
		decstage_ImmExt <= "00"; 
		exstage_ALU_Bin_sel <= '0'; 
		exstage_ALU_func <= "0101";
		memstage_ByteOp <= '0';
		memstage_Mem_WrEn <= '0';



      wait;
   end process;

END;
