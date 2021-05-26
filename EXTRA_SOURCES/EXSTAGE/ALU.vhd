----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:11:21 04/02/2021 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           Output : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : inout  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
begin

process(A,B,Op)
variable temp: STD_LOGIC_VECTOR (32 downto 0);
variable outputv: STD_LOGIC_VECTOR (31 downto 0);
variable coutv,temp_2: STD_LOGIC;
begin
	Cout <= '0'; 
	Ovf <= '0';
	temp := (others => '0');
	case Op is
		when "0000" => --add
			temp:= ('0' & A) + ('0' & B);
			outputv := temp(31 downto 0);
			coutv := temp(32);
			Ovf <= outputv(31) xor A(31) xor B(31) xor coutv;
			Cout <= coutv;
		when "0001" =>
			temp:= ('0' & A) - ('0' & B);
			outputv := temp(31 downto 0);
			coutv := temp(32);
			Ovf <= outputv(31) xor A(31) xor B(31) xor coutv;
			Cout <= coutv;
		when "0010" =>
			outputv := A and B;
		when "0011" =>
			outputv := A or B;
		when "0100" =>
			outputv :=  not A;
		when "1000" => 
			outputv := STD_LOGIC_VECTOR(shift_right(signed(A),1));
		when "1001" => 
			outputv := STD_LOGIC_VECTOR(shift_right(unsigned(A),1));
		when "1010" =>
			outputv := STD_LOGIC_VECTOR(shift_left(unsigned(A),1));
		when "1100" => 
			temp_2 := A(31);
			outputv := STD_LOGIC_VECTOR(shift_left(signed(A),1));
			outputv(0) := temp_2; 
		when "1101" => 
			temp_2 := A(0);
			outputv := STD_LOGIC_VECTOR(shift_right(signed(A),1));
			outputv(31) := temp_2;
		when "1111" => -- pass second variable to the output
			outputv := B;
		when others => 
			outputv := (31 downto 0 => '0');
	end case;
	
	if (outputv = (31 downto 0 => '0') and Cout = '0') then
		Zero <= '1';
	else
		Zero <= '0';
	end if;
	
	Output <= outputv after 5ns;--10ns;
	
end process;


end Behavioral;

