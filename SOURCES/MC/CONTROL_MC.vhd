----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:48:55 05/15/2021 
-- Design Name: 
-- Module Name:    CONTROL_MC - Behavioral 
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

entity CONTROL_MC is
Port (	Reset : in STD_LOGIC;
			CLK : in STD_LOGIC;
			ALU_zero_reg_out : in STD_LOGIC;
			Instruction : in STD_LOGIC_VECTOR (31 downto 0);
			ifstage_pc_sel : out STD_LOGIC;
			ifstage_pc_LdEn : out STD_LOGIC;
			decstage_RF_WrEn : out STD_LOGIC;
			decstage_RF_WrData_sel : out STD_LOGIC;
			decstage_RF_B_sel : out STD_LOGIC;
			decstage_ImmExt: out STD_LOGIC_VECTOR(1 downto 0);
			exstage_ALU_Bin_sel : out STD_LOGIC;
			exstage_ALU_func : out STD_LOGIC_VECTOR (3 downto 0);
			memstage_ByteOp : out STD_LOGIC;
			memstage_Mem_WrEn : out STD_LOGIC;
			ALU_zero_reg_WE : out STD_LOGIC;
			instr_reg_WE : out STD_LOGIC;
			RF_A_reg_WE : out STD_LOGIC;
			RF_B_reg_WE : out STD_LOGIC;
			Immed_32_reg_WE : out STD_LOGIC;
			ALU_out_reg_WE : out STD_LOGIC;
			MEM_DataOut_reg_WE : out STD_LOGIC);
end CONTROL_MC;

architecture Behavioral of CONTROL_MC is
type states is (Ifstage_pc_plus_4, Decstage, Exstage, WriteRegister, Memstage, Ifstage_Beq, Ifstage_Bne, Ifstage_Branch, Reset_State);
signal State, nextState : states;

begin


process (CLK)
	begin
	if rising_edge(CLK) then
		if Reset = '1' then
			State <= Reset_State after 5 ns;
		else 
			State <= nextState after 5 ns;
		end if;
	end if;
end process;

process (State, Instruction, ALU_zero_reg_out)
variable opcode : std_logic_vector (5 downto 0);
variable func : std_logic_vector (5 downto 0);
begin
	opcode := Instruction(31 downto 26);
	func := Instruction(5 downto 0);
	case State is
		when Reset_State => 
			ifstage_pc_sel <= '0';
			ifstage_pc_LdEn <= '0';
			decstage_RF_WrEn <= '0';
			decstage_RF_WrData_sel <= '0';
			decstage_RF_B_sel <= '0';
			decstage_ImmExt <= "00";
			exstage_ALU_Bin_sel <= '0'; 
			exstage_ALU_func <= "0000";
			memstage_ByteOp <= '0';
			memstage_Mem_WrEn <= '0';
			ALU_zero_reg_WE <= '0';
			instr_reg_WE <= '0';
			RF_A_reg_WE <= '0';
			RF_B_reg_WE <= '0';
			Immed_32_reg_WE <= '0';
			ALU_out_reg_WE <= '0';
			MEM_DataOut_reg_WE <= '0';
			nextState <= Ifstage_pc_plus_4;
			
		when Ifstage_pc_plus_4 =>
			ifstage_pc_sel <= '0'; -- PC + 4
			ifstage_pc_LdEn <= '1';
			decstage_RF_WrEn <= '0';
			decstage_RF_WrData_sel <= '0';
			decstage_RF_B_sel <= '0';
			decstage_ImmExt <= "00";
			exstage_ALU_Bin_sel <= '0'; 
			exstage_ALU_func <= "0000";
			memstage_ByteOp <= '0';
			memstage_Mem_WrEn <= '0';
			ALU_zero_reg_WE <= '0';
			instr_reg_WE <= '1';
			RF_A_reg_WE <= '0';
			RF_B_reg_WE <= '0';
			Immed_32_reg_WE <= '0';
			ALU_out_reg_WE <= '0';
			MEM_DataOut_reg_WE <= '0';
			nextState <= Decstage;
			
			
		when Decstage =>
			ifstage_pc_sel <= '0';
			ifstage_pc_LdEn <= '0';
			decstage_RF_WrEn <= '0';
			decstage_RF_WrData_sel <= '0';
			exstage_ALU_Bin_sel <= '0'; 
			exstage_ALU_func <= "0000";
			memstage_ByteOp <= '0';
			memstage_Mem_WrEn <= '0';
			ALU_zero_reg_WE <= '0';
			instr_reg_WE <= '0';
			RF_A_reg_WE <= '1';
			RF_B_reg_WE <= '1';
			Immed_32_reg_WE <= '1';
			ALU_out_reg_WE <= '0';
			MEM_DataOut_reg_WE <= '0';
			if opcode = "100000" then -- func type instructions
				decstage_RF_B_sel <= '0'; -- rt as second register
				decstage_ImmExt <= "00"; -- don't care
				nextState <= Exstage;
			elsif opcode = "111000" then -- li
				decstage_RF_B_sel <= '0'; -- don't care
				decstage_ImmExt <= "01"; -- sign extention
				nextState <= Exstage;
			elsif opcode = "111001" then -- lui
				decstage_RF_B_sel <= '0'; -- don't care
				decstage_ImmExt <= "11"; -- shift and zero fill
				nextState <= Exstage;
			elsif opcode = "110000" then -- addi
				decstage_RF_B_sel <= '0'; -- don't care about RF_B (second value register)
				decstage_ImmExt <= "01"; -- sign extention
				nextState <= Exstage;
			elsif opcode = "110010" then -- nandi
				decstage_RF_B_sel <= '0'; -- don't care about RF_B (second value register)
				decstage_ImmExt <= "10"; -- zero fill
				nextState <= Exstage;
			elsif opcode = "110011" then -- ori
				decstage_RF_B_sel <= '0'; -- don't care about RF_B (second value register)
				decstage_ImmExt <= "10"; -- zero fill
				nextState <= Exstage;
			elsif opcode = "111111" then -- b
				decstage_RF_B_sel <= '0'; -- don't care
				decstage_ImmExt <= "00"; -- don't care
				nextState <= Ifstage_Branch;
			elsif opcode = "000000" then -- beq
				decstage_RF_B_sel <= '1'; -- we want as second register the [rd]
				decstage_ImmExt <= "00"; -- don't care
				nextState <= Exstage;
			elsif opcode = "000001" then -- bne
				decstage_RF_B_sel <= '1'; -- we want as second register the [rd]
				decstage_ImmExt <= "00"; -- don't care
				nextState <= Exstage;
			elsif opcode = "000011" then -- lb
				decstage_RF_B_sel <= '0'; -- don't care for second register we will use the immm16
				decstage_ImmExt <= "01"; -- sign extention
				nextState <= Exstage;
			elsif opcode = "000111" then -- sb
				decstage_RF_B_sel <= '1'; -- we want to store the value of register rd = RF[rd]
				decstage_ImmExt <= "01"; -- sign extention
				nextState <= Exstage;
			elsif opcode = "001111" then -- lw
				decstage_RF_B_sel <= '0'; -- don't care for second register we will use the immm16
				decstage_ImmExt <= "01"; -- sign extention
				nextState <= Exstage;
			elsif opcode = "011111" then -- sw
				decstage_RF_B_sel <= '1'; -- we want to store the value of register rd = RF[rd]
				decstage_ImmExt <= "01"; -- sign extention
				nextState <= Exstage;
			end if;
			--decstage_RF_B_sel <= '0';
			--decstage_ImmExt <= "00";
			
			
		when Exstage =>
			ifstage_pc_sel <= '0';
			ifstage_pc_LdEn <= '0';
			decstage_RF_WrEn <= '0';
			decstage_RF_WrData_sel <= '0';
			decstage_RF_B_sel <= '0';
			decstage_ImmExt <= "00";
			memstage_ByteOp <= '0';
			memstage_Mem_WrEn <= '0';
			ALU_zero_reg_WE <= '1';
			instr_reg_WE <= '0';
			RF_A_reg_WE <= '0';
			RF_B_reg_WE <= '0';
			Immed_32_reg_WE <= '0';
			ALU_out_reg_WE <= '1';
			MEM_DataOut_reg_WE <= '0';
			if opcode = "100000" then -- func type instructions
				exstage_ALU_Bin_sel <= '0'; -- all ALU Func Operations need RF_B([rt]) as input or don't want second input at all (never gonna need the Immed value)
				exstage_ALU_func <= func(3 downto 0);
				nextState <= WriteRegister;
			elsif opcode = "111000" then -- li
				exstage_ALU_Bin_sel <= '1'; -- we want to pass the Immed value
				exstage_ALU_func <= "1111"; -- pass the second input as it is to the output			
				nextState <= WriteRegister;
			elsif opcode = "111001" then -- lui
				exstage_ALU_Bin_sel <= '1'; -- we want to pass the Immed value
				exstage_ALU_func <= "1111"; -- pass the second input as it is to the output				
				nextState <= WriteRegister;
			elsif opcode = "110000" then -- addi
				exstage_ALU_Bin_sel <= '1'; -- we want to pass the Immed value
				exstage_ALU_func <= "0000"; -- add			
				nextState <= WriteRegister;
			elsif opcode = "110010" then -- nandi
				exstage_ALU_Bin_sel <= '1'; -- we want to pass the Immed value
				exstage_ALU_func <= "0101"; -- nand				
				nextState <= WriteRegister;
			elsif opcode = "110011" then -- ori
				exstage_ALU_Bin_sel <= '1'; -- we want to pass the Immed value
				exstage_ALU_func <= "0011"; -- or				
				nextState <= WriteRegister;
			elsif opcode = "000000" then -- beq
				exstage_ALU_Bin_sel <= '0'; -- RF_B (not Immed)
				exstage_ALU_func <= "0001"; -- subtraction				
				nextState <= Ifstage_Beq;
			elsif opcode = "000001" then -- bne
				exstage_ALU_Bin_sel <= '0'; -- RF_B (not Immed)
				exstage_ALU_func <= "0001"; -- subtraction				
				nextState <= Ifstage_Bne;
			elsif opcode = "000011" then -- lb
				exstage_ALU_Bin_sel <= '1'; -- we want Immed as value
				exstage_ALU_func <= "0000"; -- add RF[rs]+SignExtend(Imm)				
				nextState <= Memstage;
			elsif opcode = "000111" then -- sb
				exstage_ALU_Bin_sel <= '1'; -- we want Immed as value
				exstage_ALU_func <= "0000"; -- add RF[rs]+SignExtend(Imm)				
				nextState <= Memstage;
			elsif opcode = "001111" then -- lw
				exstage_ALU_Bin_sel <= '1'; -- we want Immed as value
				exstage_ALU_func <= "0000"; -- add RF[rs]+SignExtend(Imm)				
				nextState <= Memstage;
			elsif opcode = "011111" then -- sw
				exstage_ALU_Bin_sel <= '1'; -- we want Immed as value
				exstage_ALU_func <= "0000"; -- add RF[rs]+SignExtend(Imm)				
				nextState <= Memstage;
			end if;
			
		when WriteRegister =>
			ifstage_pc_sel <= '0';
			ifstage_pc_LdEn <= '0';
			decstage_RF_WrEn <= '1';
			decstage_RF_B_sel <= '0';
			decstage_ImmExt <= "00";
			exstage_ALU_Bin_sel <= '0'; 
			exstage_ALU_func <= "0000";
			memstage_ByteOp <= '0';
			memstage_Mem_WrEn <= '0';
			ALU_zero_reg_WE <= '0';
			instr_reg_WE <= '0';
			RF_A_reg_WE <= '0';
			RF_B_reg_WE <= '0';
			Immed_32_reg_WE <= '0';
			ALU_out_reg_WE <= '0';
			MEM_DataOut_reg_WE <= '0';
			if opcode = "100000" then -- func type instructions
				decstage_RF_WrData_sel <= '0'; -- all ALU Fucn Operations write at [rd] from ALU and not from memory
				nextState <= Ifstage_pc_plus_4;
			elsif opcode = "111000" then -- li
				decstage_RF_WrData_sel <= '0'; --(ALU)
				nextState <= Ifstage_pc_plus_4;
			elsif opcode = "111001" then -- lui			
				decstage_RF_WrData_sel <= '0'; --(ALU)
				nextState <= Ifstage_pc_plus_4;
			elsif opcode = "110000" then -- addi		
				decstage_RF_WrData_sel <= '0'; --(ALU)
				nextState <= Ifstage_pc_plus_4;
			elsif opcode = "110010" then -- nandi		
				decstage_RF_WrData_sel <= '0'; --(ALU)
				nextState <= Ifstage_pc_plus_4;
			elsif opcode = "110011" then -- ori				
				decstage_RF_WrData_sel <= '0'; --(ALU)
				nextState <= Ifstage_pc_plus_4;
			elsif opcode = "000011" then -- lb			
				decstage_RF_WrData_sel <= '1'; -- memory
				nextState <= Ifstage_pc_plus_4;
			elsif opcode = "001111" then -- lw				
				decstage_RF_WrData_sel <= '1'; -- memory
				nextState <= Ifstage_pc_plus_4;
			end if;
			
			
		when Memstage =>
			ifstage_pc_sel <= '0';
			ifstage_pc_LdEn <= '0';
			decstage_RF_WrEn <= '0';
			decstage_RF_WrData_sel <= '0';
			decstage_RF_B_sel <= '0';
			decstage_ImmExt <= "00";
			exstage_ALU_Bin_sel <= '0'; 
			exstage_ALU_func <= "0000";
			ALU_zero_reg_WE <= '0';
			instr_reg_WE <= '0';
			RF_A_reg_WE <= '0';
			RF_B_reg_WE <= '0';
			Immed_32_reg_WE <= '0';
			ALU_out_reg_WE <= '0';
			MEM_DataOut_reg_WE <= '1';
			if opcode = "000011" then -- lb
				memstage_ByteOp <= '1';
				memstage_Mem_WrEn <= '0';
				nextState <= WriteRegister;
			elsif opcode = "000111" then -- sb			
				memstage_ByteOp <= '1';
				memstage_Mem_WrEn <= '1'; 
				nextState <= Ifstage_pc_plus_4;
			elsif opcode = "001111" then -- lw			
				memstage_ByteOp <= '0';
				memstage_Mem_WrEn <= '0'; 
				nextState <= WriteRegister;
			elsif opcode = "011111" then -- sw			
				memstage_ByteOp <= '0';
				memstage_Mem_WrEn <= '1';
				nextState <= Ifstage_pc_plus_4;
			end if;

			
		when Ifstage_Beq =>
			ifstage_pc_LdEn <= '1';
			decstage_RF_WrEn <= '0';
			decstage_RF_WrData_sel <= '0';
			decstage_RF_B_sel <= '0';
			decstage_ImmExt <= "00";
			exstage_ALU_Bin_sel <= '0'; 
			exstage_ALU_func <= "0000";
			memstage_ByteOp <= '0';
			memstage_Mem_WrEn <= '0';
			ALU_zero_reg_WE <= '0';
			instr_reg_WE <= '1';
			RF_A_reg_WE <= '0';
			RF_B_reg_WE <= '0';
			Immed_32_reg_WE <= '0';
			ALU_out_reg_WE <= '0';
			MEM_DataOut_reg_WE <= '0';
			nextState <= Decstage;
			if ALU_zero_reg_out = '1' then
				ifstage_pc_sel <= '1';
			else
				ifstage_pc_sel <= '0';
			end if;
			
		when Ifstage_Bne =>
			ifstage_pc_LdEn <= '1';
			decstage_RF_WrEn <= '0';
			decstage_RF_WrData_sel <= '0';
			decstage_RF_B_sel <= '0';
			decstage_ImmExt <= "00";
			exstage_ALU_Bin_sel <= '0'; 
			exstage_ALU_func <= "0000";
			memstage_ByteOp <= '0';
			memstage_Mem_WrEn <= '0';
			ALU_zero_reg_WE <= '0';
			instr_reg_WE <= '1';
			RF_A_reg_WE <= '0';
			RF_B_reg_WE <= '0';
			Immed_32_reg_WE <= '0';
			ALU_out_reg_WE <= '0';
			MEM_DataOut_reg_WE <= '0';
			nextState <= Decstage;
			if ALU_zero_reg_out = '1' then
				ifstage_pc_sel <= '0';
			else
				ifstage_pc_sel <= '1';
			end if;

			
		when Ifstage_Branch =>
			ifstage_pc_sel <= '1'; -- branch
			ifstage_pc_LdEn <= '1';
			decstage_RF_WrEn <= '0';
			decstage_RF_WrData_sel <= '0';
			decstage_RF_B_sel <= '0';
			decstage_ImmExt <= "00";
			exstage_ALU_Bin_sel <= '0'; 
			exstage_ALU_func <= "0000";
			memstage_ByteOp <= '0';
			memstage_Mem_WrEn <= '0';
			ALU_zero_reg_WE <= '0';
			instr_reg_WE <= '1';
			RF_A_reg_WE <= '0';
			RF_B_reg_WE <= '0';
			Immed_32_reg_WE <= '0';
			ALU_out_reg_WE <= '0';
			MEM_DataOut_reg_WE <= '0';
			nextState <= Decstage;
		
		when others =>
				assert false report "Illegal state in FSM control unit" severity error;
	end case;	
end process;


end Behavioral;

