-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

  ENTITY PROCESSOR_MC_TB IS
  END PROCESSOR_MC_TB;

  ARCHITECTURE behavior OF PROCESSOR_MC_TB IS 

  -- Component Declaration
  COMPONENT PROCESSOR_MC
    PORT(
         reset : IN  std_logic;
         CLK : IN  std_logic
        );
    END COMPONENT; 

	--Inputs
   signal reset : std_logic := '0';
   signal CLK : std_logic := '0';

   -- Clock period definitions
   constant CLK_period : time := 80 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PROCESSOR_MC PORT MAP (
          reset => reset,
          CLK => CLK
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
      reset <= '1';
		wait for clk_period*1;
		
		Reset <= '0';
		wait for clk_period*1;
		Reset <= '0';
      wait;
   end process;

END;