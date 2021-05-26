----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:30:39 04/07/2021 
-- Design Name: 
-- Module Name:    CONTROL - Behavioral 
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

entity CONTROL is
	Port (
		exstage_ALU_zero : in STD_LOGIC;
		exstage_ALU_ovf : in STD_LOGIC;
		exstage_ALU_cout : in STD_LOGIC;
		Instruction : in STD_LOGIC_VECTOR (31 downto 0);
		CLK : in STD_LOGIC;
		Reset : in STD_LOGIC; 
		control_signals : out STD_LOGIC_VECTOR (14 downto 0));
end CONTROL;

-- control_signals meaning...
--===========================
-- 0. Reset
-- 1. ifstage_pc_sel  ( 0->(PC+4) 1->((PC+4)+SignExt(Immed)*4) )
-- 2.	ifstage_pc_LdEn  write at register at ifstage
-- 3. decstage_RF_WrEn
-- 4.	decstage_RF_WrData_sel 
-- 5.	decstage_RF_B_sel
-- 6.	decstage_ImmExt = bit 0
-- 7.	decstage_ImmExt = bit 1	
-- 8.	exstage_ALU_Bin_sel 
-- 9.	 exstage_ALU_func bit 0
-- 10. exstage_ALU_func bit 1
-- 11. exstage_ALU_func bit 2
-- 12. exstage_ALU_func bit 3
-- 13. memstage_ByteOp 
-- 14. memstage_Mem_WrEn

architecture Behavioral of CONTROL is
begin
	control_process: process(CLK,Instruction)
	variable opcode : std_logic_vector (5 downto 0);
	variable func : std_logic_vector (5 downto 0);
	variable immediate : std_logic_vector (15 downto 0);
	variable pc_sel,pc_LdEn,RF_WrEn,RF_WrData_sel,RF_B_sel,ALU_Bin_sel,ByteOp,Mem_WrEn : STD_LOGIC;
	variable ImmExt : std_logic_vector(1 downto 0);
	variable ALU_func : std_logic_vector(3 downto 0);
	begin
		-- Variable Initialization
		opcode := Instruction(31 downto 26);
		func := Instruction(5 downto 0);
		immediate := Instruction(15 downto 0);
		control_signals <= "000000000000000";
		Mem_WrEn := '0';
		ByteOp := '0';
		ALU_func := "0000";
		ALU_Bin_sel := '0';
		ImmExt := "00";
		RF_B_sel := '0';
		RF_WrData_sel := '0';
		RF_WrEn := '0';
		pc_LdEn := '0';
		pc_sel := '0';
		if(CLK='1') then
			if(Reset='1') then control_signals <= "000000000000000";
			else
			case opcode is 
					when "100000" => -- ALU Func Operations
					
					pc_LdEn := '1';
					
					pc_sel := '0'; -- all ALU Fucn Operations just run the next instruction after execution (PC + 4)
					RF_WrEn := '1'; -- all ALU Fucn Operations write at register [rd] the result of the operation
					RF_WrData_sel := '0'; -- all ALU Fucn Operations write at [rd] from ALU and not from memory
					RF_B_sel := '0'; -- all ALU Func Operations have as RF_B the register [rt] or don't have RF_B at all (never gonna need the [rd] register)
					ImmExt := "00"; -- all ALU Func Operations don't have at all Immediate so we don't care what is the value of ImmExt
					ALU_Bin_sel := '0'; -- all ALU Func Operations need RF_B([rt]) as input or don't want second input at all (never gonna need the Immed value)
					ByteOp := '0'; -- all ALU Func Operations don't use at all the memstage part so we don't care what is the value of ByteOp
					Mem_WrEn := '0'; -- all ALU Fucn Operations don't write at memory
					case func is 
						when "110000" => -- add
						-- exstage_ALU_func = 0000 (add)
						ALU_func := "0000";
						when "110001" => -- sub
						-- exstage_ALU_func = 0001 (sub)
						ALU_func := "0001";
						when "110010" => -- and
						-- exstage_ALU_func = 0010 (and)
						ALU_func := "0010";
						when "110011" => -- or
						-- exstage_ALU_func = 0011 (or)
						ALU_func := "0011";
						when "110100" => -- not
						-- exstage_ALU_func = 0100 (not)
						ALU_func := "0100";
						when "110101" => -- nand
						-- exstage_ALU_func = 0101 (nand)
						ALU_func := "0101";
						when "110110" => -- nor
						-- exstage_ALU_func = 0110 (nor)
						ALU_func := "0110";
						when "111000" => -- sra
						-- exstage_ALU_func = 1000 (sra)
						ALU_func := "1000";
						when "111001" => -- srl
						-- exstage_ALU_func = 1001 (srl)
						ALU_func := "1001";
						when "111010" => -- sll
						-- exstage_ALU_func = 1010 (sll)
						ALU_func := "1010";
						when "111100" => -- rol
						-- exstage_ALU_func = 1100 (rol)
						ALU_func := "1100";
						when "111101" => -- ror
						-- exstage_ALU_func = 1101 (ror)
						ALU_func := "1101";
						when others => control_signals <= "000000000000000";
					end case;
					
					when "111000" => -- li
					pc_sel := '0'; --(PC+4) 
					pc_LdEn := '1';
					RF_WrEn := '1'; -- RF[rd] <- SignExtend(Imm)					RF_WrData_sel := '0'; --(ALU)
					RF_B_sel := '0'; -- don't care about RF_B (second value register)
					ImmExt := "01"; -- sign extention
					ALU_Bin_sel := '1'; -- we want to pass the Immed value
					ALU_func := "1111"; -- pass the second input as it is to the output
					ByteOp := '0'; -- don't care (we don't use the memory at all)
					Mem_WrEn := '0'; -- we don't write to the memory 
					
					when "111001" => -- lui
					pc_sel := '0'; --(PC+4)
					pc_LdEn := '1';
					RF_WrEn := '1'; -- RF[rd] <- Imm << 16 (zero-fill)
					RF_WrData_sel := '0'; --(ALU)
					RF_B_sel := '0'; -- don't care about RF_B (second value register)
					ImmExt := "11"; -- shift and zero fill
					ALU_Bin_sel := '1'; -- we want to pass the Immed value
					ALU_func := "1111"; -- pass the second input as it is to the output
					ByteOp := '0'; -- don't care (we don't use the memory at all)
					Mem_WrEn := '0'; -- we don't write to the memory
					
					when "110000" => -- addi
					pc_sel := '0'; --(PC+4)
					pc_LdEn := '1';
					RF_WrEn := '1'; -- RF[rd] <- RF[rs] + SignExtend(Imm)
					RF_WrData_sel := '0'; --(ALU)
					RF_B_sel := '0'; -- don't care about RF_B (second value register)
					ImmExt := "01"; -- sign extention
					ALU_Bin_sel := '1'; -- we want to pass the Immed value
					ALU_func := "0000"; -- add
					ByteOp := '0'; -- don't care (we don't use the memory at all)
					Mem_WrEn := '0'; -- we don't write to the memory
					
					when "110010" => -- nandi
					pc_sel := '0'; --(PC+4)
					pc_LdEn := '1';
					RF_WrEn := '1'; -- RF[rd] <- RF[rs] NAND ZeroFill(Imm)
					RF_WrData_sel := '0'; --(ALU)
					RF_B_sel := '0'; -- don't care about RF_B (second value register)
					ImmExt := "10"; -- zero fill
					ALU_Bin_sel := '1'; -- we want to pass the Immed value
					ALU_func := "0101"; -- nand
					ByteOp := '0'; -- don't care (we don't use the memory at all)
					Mem_WrEn := '0'; -- we don't write to the memory
					
					when "110011" => -- ori
					pc_sel := '0'; --(PC+4)
					pc_LdEn := '1';
					RF_WrEn := '1'; -- RF[rd] <- RF[rs] | ZeroFill(Imm)
					RF_WrData_sel := '0'; --(ALU)
					RF_B_sel := '0'; -- don't care about RF_B (second value register)
					ImmExt := "10"; -- zero fill
					ALU_Bin_sel := '1'; -- we want to pass the Immed value
					ALU_func := "0011"; -- or
					ByteOp := '0'; -- don't care (we don't use the memory at all)
					Mem_WrEn := '0'; -- we don't write to the memory
					
					when "111111" => -- b
					pc_sel := '1'; -- branch
					pc_LdEn := '1';
					RF_WrEn := '0'; -- PC <- PC + 4 + (SignExtend(Imm) << 2)
					RF_WrData_sel := '0'; -- don't care
					RF_B_sel := '0'; -- don't care
					ImmExt := "00"; -- don't care
					ALU_Bin_sel := '0'; -- don't care
					ALU_func := "0000"; -- don't care
					ByteOp := '0'; -- don't care (we don't use the memory at all)
					Mem_WrEn := '0'; -- we don't write to the memory
					
					when "000000" => -- beq
					pc_sel := exstage_ALU_zero; -- branch if zero is 1
					pc_LdEn := '1';
					RF_WrEn := '0';
					RF_WrData_sel := '0'; -- don't care
					RF_B_sel := '1'; -- we want as second register the [rd]
					ImmExt := "00"; -- don't care
					ALU_Bin_sel := '0'; -- RF_B (not Immed)
					ALU_func := "0001"; -- subtraction
					ByteOp := '0'; -- don't care (we don't use the memory at all)
					Mem_WrEn := '0'; -- we don't write to the memory
					
					when "000001" => -- bne
					pc_sel := not exstage_ALU_zero; -- branch if zero is 0
					pc_LdEn := '1';
					RF_WrEn := '0';
					RF_WrData_sel := '0'; -- don't care
					RF_B_sel := '1'; -- we want as second register the [rd]
					ImmExt := "00"; -- don't care
					ALU_Bin_sel := '0'; -- RF_B (not Immed)
					ALU_func := "0001"; -- subtraction
					ByteOp := '0'; -- don't care (we don't use the memory at all)
					Mem_WrEn := '0'; -- we don't write to the memory
					
					when "000011" => -- lb
					pc_sel := '0'; --(PC+4)
					pc_LdEn := '1';
					RF_WrEn := '1'; -- RF[rd] <- ZeroFill(31 downto 8) & MEM[ RF[rs]+SignExtend(Imm) ](7 downto 0)					RF_WrData_sel := '1'; -- memory
					RF_B_sel := '0'; -- don't care for second register we will use the immm16
					ImmExt := "01"; -- sign extention
					ALU_Bin_sel := '1'; -- we want Immed as value 
					ALU_func := "0000"; -- add RF[rs]+SignExtend(Imm)
					ByteOp := '1'; -- lb/sb
					Mem_WrEn := '0'; -- we don't write at memory
					
					when "000111" => -- sb
					pc_sel := '0'; -- (PC+4)
					pc_LdEn := '1';
					RF_WrEn := '0'; -- MEM[ RF[rs]+SignExtend(Imm) ] <- ZeroFill(31 downto 8) & RF[rd](7 downto 0)
					RF_WrData_sel := '0'; -- don't care
					RF_B_sel := '1'; -- we want to store the value of register rd = RF[rd]
					ImmExt := "01"; -- sign extention
					ALU_Bin_sel := '1'; -- we want Immed as value
					ALU_func := "0000"; -- add RF[rs]+SignExtend(Imm)
					ByteOp := '1'; -- lb/sb
					Mem_WrEn := '1'; -- we want to write to memory
					
					when "001111" => -- lw
					pc_sel := '0'; --(PC+4)
					pc_LdEn := '1';
					RF_WrEn := '1'; -- RF[rd] <- MEM[RF[rs] + SignExtend(Imm)]					RF_WrData_sel := '1'; -- memory
					RF_B_sel := '0'; -- don't care for second register we will use the immm16
					ImmExt := "01"; -- sign extention
					ALU_Bin_sel := '1'; -- we want Immed as value 
					ALU_func := "0000"; -- add RF[rs]+SignExtend(Imm)
					ByteOp := '0'; -- lw/sw
					Mem_WrEn := '0'; -- we don't write at memory
					
					when "011111" => -- sw
					pc_sel := '0'; -- (PC+4)
					pc_LdEn := '1';
					RF_WrEn := '0'; -- MEM[RF[rs] + SignExtend(Imm)] <- RF[rd] 
					RF_WrData_sel := '0'; -- don't care
					RF_B_sel := '1'; -- we want to store the value of register rd = RF[rd]
					ImmExt := "01"; -- sign extention
					ALU_Bin_sel := '1'; -- we want Immed as value
					ALU_func := "0000"; -- add RF[rs]+SignExtend(Imm)
					ByteOp := '0'; -- lw/sw
					Mem_WrEn := '1'; -- we want to write to memory
					
					when others => control_signals <= "000000000000000";
			end case;
			control_signals <= Mem_WrEn & ByteOp & ALU_func & ALU_Bin_sel & ImmExt & RF_B_sel & RF_WrData_sel & RF_WrEn & pc_LdEn & pc_sel & Reset;
			end if;
		end if;
	end process control_process;
end Behavioral;

