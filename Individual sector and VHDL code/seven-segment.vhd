----------------------------------------------------------------------------------
-- Company: HW Group C
-- Engineer/Author: Richard Jimenez G. 
-- 
-- Create Date: 10.06.2024 
-- Design Name: 
-- Module Name: Keypad_peripheral - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description:  this VHDL code is to be used for displaying the X number from the keypad in a 7-segment display
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: own implementation based on available documentation
-- 
----------------------------------------------------------------------------------

library  IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevensegdec is
    port (
        dig : in std_logic_vector (2 downto 0); -- which digit to currently display
        data : in std_logic_vector (15 downto 0); -- 16-bit (4-digit) data
        anode : out std_logic_vector (7 downto 0); -- which anode to turn on
        seg : out std_logic_vector (6 downto 0) -- segment code for current digit
    );
end sevensegdec;

architecture behavioral of sevensegdec is
    signal data4 : std_logic_vector (3 downto 0); -- binary value of current digit
begin
    -- select digit data to be displayed in this mpx period
    data4 <= data(3 downto 0) when dig = "000" else -- digit 0
             data(7 downto 4) when dig = "001" else -- digit 1
             data(11 downto 8) when dig = "010" else -- digit 2
             data(15 downto 12); -- digit 3
    --  4-bit data word
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
           "0001000" when data4 = "1010" else -- a
           "1100000" when data4 = "1011" else -- b
           "0110001" when data4 = "1100" else -- c
           "1000010" when data4 = "1101" else -- d
           "0110000" when data4 = "1110" else -- e
           "0111000" when data4 = "1111" else -- f
           "1111111";
    -- turn on anode of 7-segment display addressed by 3-bit digit selector dig
    anode <= "11111110" when dig = "000" else -- 0
             "11111101" when dig = "001" else -- 1
             "11111011" when dig = "010" else -- 2
             "11110111" when dig = "011" else -- 3
--             "11101111" when dig = "100" else -- 4
--             "11011111" when dig = "101" else -- 5 
--             "10111111" when dig = "110" else -- 6
--             "01111111" when dig = "111" else -- 7
             "11111111";
end behavioral;
