LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.Vcomponents.all;
entity keypadecod is
	port (
		samp_ck : in std_logic; 
		col : out std_logic_vector (4 downto 1); 
		row : in std_logic_vector (4 downto 1); 
		value_hit : out std_logic_vector (3 downto 0); -- hex value of key depressed that can be from 1 to FFFF for the origin, destiny user input
		hit : out STD_LOGIC); -- indicates when a key has been pressed
end keypadecod;

architecture Behavioural of keypadecod is
	signal vector1, vector2, vector3, vector4 : std_logic_vector (4 downto 1) := "1111"; 
	signal curr_col : std_logic_vector (4 downto 1) := "1110"; 
begin

	strobe_proc : process
	begin
		wait until rising_edge(samp_ck);
		case curr_col is
			when "1110" => 
				vector1 <= row;
				curr_col <= "1101";
			when "1101" => 
				vector2 <= row;
				curr_col <= "1011";
			when "1011" => 
				vector3 <= row;
				curr_col <= "0111";
			when "0111" => 
				vector4 <= row;
				curr_col <= "1110";
			when others => 
				curr_col <= "1110";
		end case;
	end process;

	out_proc : process (vector1, vector2, vector3, vector4)
	begin
		hit <= '1';
		if vector1(1) = '0' then
			value_hit <= X"1";
		elsif vector1(2) = '0' then
			value_hit <= X"4";
		elsif vector1(3) = '0' then
			value_hit <= X"7";
		elsif vector1(4) = '0' then
			value_hit <= X"0";
		elsif vector2(1) = '0' then
			value_hit <= X"2";
		elsif vector2(2) = '0' then
			value_hit <= X"5";
		elsif vector2(3) = '0' then
			value_hit <= X"8";
		elsif vector2(4) = '0' then
			value_hit <= X"F";
		elsif vector3(1) = '0' then
			value_hit <= X"3";
		elsif vector3(2) = '0' then
			value_hit <= X"6";
		elsif vector3(3) = '0' then
			value_hit <= X"9";
		elsif vector3(4) = '0' then
			value_hit <= X"E";
		elsif vector4(1) = '0' then
			value_hit <= X"A";
		elsif vector4(2) = '0' then
			value_hit <= X"B";
		elsif vector4(3) = '0' then
			value_hit <= X"C";
		elsif vector4(4) = '0' then
			value_hit <= X"D";
		else
			hit <= '0';
			value_hit <= X"0";
		end if;
	end process;
	col <= curr_col;
end Behavioural;
