----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:50:51 05/16/2021 
-- Design Name: 
-- Module Name:    CONTROL_PIPELINE - Behavioral 
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

entity CONTROL_PIPELINE is
Port ( CLK : in STD_LOGIC;
		Reset : in STD_LOGIC;
		exstage_ALU_zero : in STD_LOGIC;
		Instruction : in STD_LOGIC_VECTOR (31 downto 0);
		ifstage_branch : out STD_LOGIC;
		ifstage_branch_condition : out STD_LOGIC;	
		decstage_RF_WrEn : out STD_LOGIC;
		decstage_RF_WrData_sel : out STD_LOGIC;
		decstage_RF_B_sel : out STD_LOGIC;
		decstage_ImmExt: out STD_LOGIC_VECTOR(1 downto 0);
		decstage_reg_we : out STD_LOGIC;
		exstage_ALU_Bin_sel : out STD_LOGIC;
		exstage_ALU_func : out STD_LOGIC_VECTOR (3 downto 0);
		exstage_reg_we : out STD_LOGIC;
		memstage_ByteOp : out STD_LOGIC;
		memstage_Mem_WrEn : out STD_LOGIC;
		memstage_reg_we : out STD_LOGIC);
end CONTROL_PIPELINE;

architecture Behavioral of CONTROL_PIPELINE is
begin
	control_process: process(CLK,Instruction)
	variable opcode : std_logic_vector (5 downto 0);
	variable func : std_logic_vector (5 downto 0);
	begin
		-- Variable Initialization
		opcode := Instruction(31 downto 26);
		func := Instruction(5 downto 0);
		if(CLK='1') then
			if(Reset='1') then 
				ifstage_branch <= '0';
				ifstage_branch_condition <= '0';
				decstage_RF_WrEn <= '0';
				decstage_RF_WrData_sel <= '0';
				decstage_RF_B_sel <= '0';
				decstage_ImmExt <= "00";
				decstage_reg_we <= '0';
				exstage_ALU_Bin_sel <= '0';
				exstage_ALU_func <= "0000";
				exstage_reg_we <= '0';
				memstage_ByteOp <= '0';
				memstage_Mem_WrEn <= '0';
				memstage_reg_we <= '0';
			else
			case opcode is 
					when "100000" => -- ALU Func Operations
					ifstage_branch <= '0';
					ifstage_branch_condition <= '0';
					decstage_reg_we <= '1';
					decstage_RF_WrEn <= '1'; -- all ALU Fucn Operations write at register [rd] the result of the operation
					decstage_RF_WrData_sel <= '0'; -- all ALU Fucn Operations write at [rd] from ALU and not from memory
					decstage_RF_B_sel <= '0'; -- all ALU Func Operations have as RF_B the register [rt] or don't have RF_B at all (never gonna need the [rd] register)
					decstage_ImmExt <= "00"; -- all ALU Func Operations don't have at all Immediate so we don't care what is the value of ImmExt
					exstage_ALU_Bin_sel <= '0'; -- all ALU Func Operations need RF_B([rt]) as input or don't want second input at all (never gonna need the Immed value)
					memstage_ByteOp <= '0'; -- all ALU Func Operations don't use at all the memstage part so we don't care what is the value of ByteOp
					memstage_Mem_WrEn <= '0'; -- all ALU Fucn Operations don't write at memory
					exstage_reg_we <= '1';
					memstage_reg_we <= '0';
					exstage_ALU_func <= func(3 downto 0);
					
					when "111000" => -- li
					
					
					ifstage_branch <= '0';
					ifstage_branch_condition <= '0';
					decstage_RF_WrEn <= '1'; -- RF[rd] <- SignExtend(Imm)
					decstage_RF_WrData_sel <= '0'; --(ALU)
					decstage_RF_B_sel <= '0'; -- don't care about RF_B (second value register)
					decstage_ImmExt <= "01"; -- sign extention
					decstage_reg_we <= '1';
					exstage_ALU_Bin_sel <= '1'; -- we want to pass the Immed value
					exstage_ALU_func <= "1111"; -- pass the second input as it is to the output
					exstage_reg_we <= '1';
					memstage_ByteOp <= '0'; -- don't care (we don't use the memory at all)
					memstage_Mem_WrEn <= '0'; -- we don't write to the memory
					memstage_reg_we <= '0';
					

			
				
				
		
					
		
					
					when "111001" => -- lui
					ifstage_branch <= '0';
					ifstage_branch_condition <= '0';
					decstage_RF_WrEn <= '1'; -- RF[rd] <- Imm << 16 (zero-fill)
					decstage_RF_WrData_sel <= '0'; --(ALU)
					decstage_RF_B_sel <= '0'; -- don't care about RF_B (second value register)
					decstage_ImmExt <= "11"; -- shift and zero fill
					decstage_reg_we <= '1';
					exstage_ALU_Bin_sel <= '1'; -- we want to pass the Immed value
					exstage_ALU_func <= "1111"; -- pass the second input as it is to the output
					exstage_reg_we <= '1';
					memstage_ByteOp <= '0'; -- don't care (we don't use the memory at all)
					memstage_Mem_WrEn <= '0'; -- we don't write to the memory
					memstage_reg_we <= '0';
					
		
				
				
				
				
				
			
					
					when "110000" => -- addi
					ifstage_branch <= '0';
					ifstage_branch_condition <= '0';
					decstage_RF_WrEn <= '1'; -- RF[rd] <- RF[rs] + SignExtend(Imm)
					decstage_RF_WrData_sel <= '0'; --(ALU)
					decstage_RF_B_sel <= '0'; -- don't care about RF_B (second value register)
					decstage_ImmExt <= "01"; -- sign extention
					decstage_reg_we <= '1';
					exstage_ALU_Bin_sel <= '1'; -- we want to pass the Immed value
					exstage_ALU_func <= "0000"; -- add
					exstage_reg_we <= '1';
					memstage_ByteOp <= '0'; -- don't care (we don't use the memory at all)
					memstage_Mem_WrEn <= '0'; -- we don't write to the memory
					memstage_reg_we <= '0';
					

			
					
				
				
					
				
					
					
					
					when "110010" => -- nandi
					ifstage_branch <= '0';
					ifstage_branch_condition <= '0';
					decstage_RF_WrEn <= '1'; -- RF[rd] <- RF[rs] NAND ZeroFill(Imm)
					decstage_RF_WrData_sel <= '0'; --(ALU)
					decstage_RF_B_sel <= '0'; -- don't care about RF_B (second value register)
					decstage_ImmExt <=  "10"; -- zero fill
					decstage_reg_we <= '1';
					exstage_ALU_Bin_sel <= '1'; -- we want to pass the Immed value
					exstage_ALU_func <= "0101"; -- nand
					exstage_reg_we <= '1';
					memstage_ByteOp <= '0'; -- don't care (we don't use the memory at all)
					memstage_Mem_WrEn <= '0'; -- we don't write to the memory
					memstage_reg_we <= '0';
					
			
					
					
					
					
				
					
					
					
					
					when "110011" => -- ori
					ifstage_branch <= '0';
					ifstage_branch_condition <= '0';
					decstage_RF_WrEn <= '1'; -- RF[rd] <- RF[rs] | ZeroFill(Imm)
					decstage_RF_WrData_sel <= '0'; --(ALU)
					decstage_RF_B_sel <= '0'; -- don't care about RF_B (second value register)
					decstage_ImmExt <= "10"; -- zero fill
					decstage_reg_we <= '1';
					exstage_ALU_Bin_sel <= '1'; -- we want to pass the Immed value
					exstage_ALU_func <= "0011"; -- or
					exstage_reg_we <= '1';
					memstage_ByteOp <= '0'; -- don't care (we don't use the memory at all)
					memstage_Mem_WrEn <= '0'; -- we don't write to the memory
					memstage_reg_we <= '0';
	
					
				
					
					
					
					
			
					
					when "111111" => -- b
					ifstage_branch <= '1';
					ifstage_branch_condition <= '0';
					decstage_RF_WrEn <= '0'; -- PC <- PC + 4 + (SignExtend(Imm) << 2)
					decstage_RF_WrData_sel <= '0'; -- don't care
					decstage_RF_B_sel <= '0'; -- don't care
					decstage_ImmExt <= "00"; -- don't care
					decstage_reg_we <= '0';
					exstage_ALU_Bin_sel <= '0'; -- don't care
					exstage_ALU_func <= "0000"; -- don't care
					exstage_reg_we <= '0';
					memstage_ByteOp <= '0'; -- don't care (we don't use the memory at all)
					memstage_Mem_WrEn <= '0'; -- we don't write to the memory
					memstage_reg_we <= '0';
					

				
				
				
					

					
					when "000000" => -- beq
					ifstage_branch <= '0';
					ifstage_branch_condition <= '1';
					decstage_RF_WrEn <= '0';
					decstage_RF_WrData_sel <= '0'; -- don't care
					decstage_RF_B_sel <= '1'; -- we want as second register the [rd]
					decstage_ImmExt <=  "00"; -- don't care
					decstage_reg_we <= '1';
					exstage_ALU_Bin_sel <= '0'; -- RF_B (not Immed)
					exstage_ALU_func <= "0001"; -- subtraction
					exstage_reg_we <= '1';
					memstage_ByteOp <= '0'; -- don't care (we don't use the memory at all)
					memstage_Mem_WrEn <= '0'; -- we don't write to the memory
					memstage_reg_we <= '0';
					
		

					
					when "000001" => -- bne
					ifstage_branch <= '1';
					ifstage_branch_condition <= '1'; 
					decstage_RF_WrEn <= '0';
					decstage_RF_WrData_sel <= '0'; -- don't care
					decstage_RF_B_sel <=  '1'; -- we want as second register the [rd]
					decstage_ImmExt <= "00"; -- don't care
					decstage_reg_we <= '1';
					exstage_ALU_Bin_sel <=  '0'; -- RF_B (not Immed)
					exstage_ALU_func <= "0001"; -- subtraction
					exstage_reg_we <= '1';
					memstage_ByteOp <= '0'; -- don't care (we don't use the memory at all)
					memstage_Mem_WrEn <= '0'; -- we don't write to the memory
					memstage_reg_we <= '0';
					
					
				
	
					
					when "000011" => -- lb
					ifstage_branch <= '0';
					ifstage_branch_condition <= '0';
					decstage_RF_WrEn <= '1'; -- RF[rd] <- ZeroFill(31 downto 8) & MEM[ RF[rs]+SignExtend(Imm) ](7 downto 0)
					decstage_RF_WrData_sel <= '1'; -- memory
					decstage_RF_B_sel <= '0'; -- don't care for second register we will use the immm16
					decstage_ImmExt <= "01"; -- sign extention
					decstage_reg_we <= '1';
					exstage_ALU_Bin_sel <= '1'; -- we want Immed as value 
					exstage_ALU_func <= "0000"; -- add RF[rs]+SignExtend(Imm)
					exstage_reg_we <= '1';
					memstage_ByteOp <= '1'; -- lb/sb
					memstage_Mem_WrEn <= '0'; -- we don't write at memory
					memstage_reg_we <= '1';
					

					
					when "000111" => -- sb
					ifstage_branch <= '0';
					ifstage_branch_condition <= '0'; 
					decstage_RF_WrEn <= '0'; -- MEM[ RF[rs]+SignExtend(Imm) ] <- ZeroFill(31 downto 8) & RF[rd](7 downto 0)
					decstage_RF_WrData_sel <= '0'; -- don't care
					decstage_RF_B_sel <= '1'; -- we want to store the value of register rd = RF[rd]
					decstage_ImmExt <= "01"; -- sign extention
					decstage_reg_we <= '1';
					exstage_ALU_Bin_sel <= '1'; -- we want Immed as value
					exstage_ALU_func <= "0000"; -- add RF[rs]+SignExtend(Imm)
					exstage_reg_we <= '1';
					memstage_ByteOp <=  '1'; -- lb/sb
					memstage_Mem_WrEn <= '1'; -- we want to write to memory
					memstage_reg_we <= '0';
					
					

					
					when "001111" => -- lw
					ifstage_branch <= '0';
					ifstage_branch_condition <= '0'; 
					decstage_RF_WrEn <= '1'; -- RF[rd] <- MEM[RF[rs] + SignExtend(Imm)]
					decstage_RF_WrData_sel <= '1'; -- memory
					decstage_RF_B_sel <= '0'; -- don't care for second register we will use the immm16
					decstage_ImmExt <= "01"; -- sign extention
					decstage_reg_we <= '1';
					exstage_ALU_Bin_sel <= '1'; -- we want Immed as value 
					exstage_ALU_func <= "0000"; -- add RF[rs]+SignExtend(Imm)
					exstage_reg_we <= '1';
					memstage_ByteOp <=  '0'; -- lw/sw
					memstage_Mem_WrEn <= '0'; -- we don't write at memory
					memstage_reg_we <= '1';
					
					

					
					when "011111" => -- sw
					ifstage_branch <= '0';
					ifstage_branch_condition <= '0'; 
					decstage_RF_WrEn <=  '0'; -- MEM[RF[rs] + SignExtend(Imm)] <- RF[rd] 
					decstage_RF_WrData_sel <= '0'; -- don't care
					decstage_RF_B_sel <= '1'; -- we want to store the value of register rd = RF[rd]
					decstage_ImmExt <= "01"; -- sign extention
					decstage_reg_we <= '1';
					exstage_ALU_Bin_sel <= '1'; -- we want Immed as value
					exstage_ALU_func <= "0000"; -- add RF[rs]+SignExtend(Imm)
					exstage_reg_we <= '1';
					memstage_ByteOp <= '0'; -- lw/sw
					memstage_Mem_WrEn <= '1'; -- we want to write to memory
					memstage_reg_we <= '0';
					

					
					when others => 
					ifstage_branch <= '0';
					ifstage_branch_condition <= '0';
					decstage_RF_WrEn <= '0';
					decstage_RF_WrData_sel <= '0';
					decstage_RF_B_sel <= '0';
					decstage_ImmExt <= "00";
					decstage_reg_we <= '0';
					exstage_ALU_Bin_sel <= '0';
					exstage_ALU_func <= "0000";
					exstage_reg_we <= '0';
					memstage_ByteOp <= '0';
					memstage_Mem_WrEn <= '0';
					memstage_reg_we <= '0';
			end case;
			end if;
		end if;
	end process control_process;
end Behavioral;

