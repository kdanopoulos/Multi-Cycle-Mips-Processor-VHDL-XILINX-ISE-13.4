----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:37:30 04/06/2021 
-- Design Name: 
-- Module Name:    MEMSTAGE - Behavioral 
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

entity MEMSTAGE is
    Port ( clk : in  STD_LOGIC;
           ByteOp : in  STD_LOGIC;--done
           Mem_WrEn : in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0); --done
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0); --done
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0); --done
           MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0); --done
           MM_WrEn : out  STD_LOGIC;
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0); --done
           MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0)); --done
end MEMSTAGE;

architecture Structural of MEMSTAGE is
	component Mux_2to1 is
	Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
           In1 : in  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component Mux_4to1 is
	Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
           In1 : in  STD_LOGIC_VECTOR (31 downto 0);
			  In2 : in  STD_LOGIC_VECTOR (31 downto 0);
			  In3 : in  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC_VECTOR(1 downto 0);
           Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	Component adder is
		Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
			   In1 : in  STD_LOGIC_VECTOR (31 downto 0);
               Output : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	--signal tmpAdderOut, tmpMEM_DataIn, tmpMEM_DataOut : STD_LOGIC_VECTOR (31 downto 0);
	--signal tempSel : STD_LOGIC_VECTOR(1 downto 0);
	--signal temp1,temp2 : STD_LOGIC_VECTOR (31 downto 0);
begin
	MM_WrEn <= Mem_WrEn;
	
	offset_adder : adder PORT MAP (
		In0 => ALU_MEM_Addr,
		In1 => "00000000000000000000010000000000", -- 0x400 = 1024
		Output => MM_Addr);
		
	data_out_mux: Mux_4to1 PORT MAP (
		In0 => MM_RdData, -- 00 = lw
		In1 => "000000000000000000000000" & MM_RdData(7 downto 0), -- 01 = lb
		In2 => "00000000000000000000000000000000", -- 10 = sw -- x dont't care at store
		In3 => "00000000000000000000000000000000", -- 11 = sb -- x dont't care at store
		Sel => Mem_WrEn & ByteOp,
		Output =>MEM_DataOut);
		
	data_in_mux: Mux_4to1 PORT MAP (
		In0 => "00000000000000000000000000000000", -- 00 = lw -- x dont't care at load
		In1 => "00000000000000000000000000000000", -- 01 = lb -- x dont't care at load
		In2 => MEM_DataIn, -- 10 = sw 
		In3 => "000000000000000000000000" & MEM_DataIn(7 downto 0), -- 11 = sb 
		Sel => Mem_WrEn & ByteOp,
		Output =>MM_WrData);


end Structural;

