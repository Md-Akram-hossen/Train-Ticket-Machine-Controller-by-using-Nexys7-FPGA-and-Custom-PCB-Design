LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNisIM;
--use UNisIM.Vcomponents.all; --unit test sys test test bench white Vidyx
entity sevensegdecoder is
	port (
		dig : in std_logic_vector (2 downto 0); -- which digit to currently display
		data : in std_logic_vector (15 downto 0); -- 16-bit (4-digit) data
		anode : out std_logic_vector (7 downto 0); -- which anode to turn on
		seg : out std_logic_vector (6 downto 0)); -- segment code for current digit
end sevensegdecoder;

architecture Behavioural of sevensegdecoder is
	signal data4 : std_logic_vector (3 downto 0); -- binary value of current digit
begin
	-- up to four digits to be displayed in Hex values
	data4 <= data(3 downto 0) when dig = "000" else 
	         data(7 downto 4) when dig = "001" else 
	         data(11 downto 8) when dig = "010" else
	         data(15 downto 12); 
    -- available Hex values to be decoded
	seg <= "0000001" when data4 = "0000" else -- 0
	       "1001111" when data4 = "0001" else -- 1
	       "0010010" when data4 = "0010" else -- 2
	       "0000110" when data4 = "0011" else -- 3
	       "1001100" when data4 = "0100" else -- 4
	       "0100100" when data4 = "0101" else -- 5
	       "0100000" when data4 = "0110" else -- 6
	       "0001111" when data4 = "0111" else -- 7
	       "0000000" when data4 = "1000" else -- 8
	       "0000100" when data4 = "1001" else -- 9
	       "0001000" when data4 = "1010" else -- A
	       "1100000" when data4 = "1011" else -- B
	       "0110001" when data4 = "1100" else -- C
	       "1000010" when data4 = "1101" else -- D
	       "0110000" when data4 = "1110" else -- E
	       "0111000" when data4 = "1111" else -- F
	       "1111111";
	-- it turns on the anode only when there is a new digit input, up to four digits
	anode <= "11111110" when dig = "000" and data /= X"0000" else 
	         "11111101" when dig = "001" and data(15 downto 4) /= X"000" else 
	         "11111011" when dig = "010" and data(15 downto 8) /= X"00" else 
	         "11110111" when dig = "011" and data(15 downto 12) /= X"0" else 
	         "11111111";
end Behavioural;
