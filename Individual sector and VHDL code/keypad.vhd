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
-- Description: this VHDL code is to be used for displaying the X number from the keypad in a 7-segment display
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

entity keypad is
    port (
        samp_ck : in std_logic; -- clock to strobe columns
        col : out std_logic_vector (4 downto 1); -- output column lines
        row : in std_logic_vector (4 downto 1); -- input row lines
        value : out std_logic_vector (3 downto 0); -- hex value of key depressed
        hit : out std_logic -- indicates when a key has been pressed
    );
end keypad;

architecture behavioral of keypad is
    signal cv1, cv2, cv3, cv4 : std_logic_vector (4 downto 1) := "1111"; -- column vector of each row
    signal curr_col : std_logic_vector (4 downto 1) := "1110"; -- current column code
begin

    strobe_proc : process
    begin
        wait until rising_edge(samp_ck);
        case curr_col is
            when "1110" => 
                cv1 <= row;
                curr_col <= "1101";
            when "1101" => 
                cv2 <= row;
                curr_col <= "1011";
            when "1011" => 
                cv3 <= row;
                curr_col <= "0111";
            when "0111" => 
                cv4 <= row;
                curr_col <= "1110";
            when others => 
                curr_col <= "1110";
        end case;
    end process;
    
    out_proc : process (cv1, cv2, cv3, cv4)
    begin
        hit <= '1';
        if cv1(1) = '0' then
            value <= x"1";
        elsif cv1(2) = '0' then
            value <= x"4";
        elsif cv1(3) = '0' then
            value <= x"7";
        elsif cv1(4) = '0' then
            value <= x"0";
        elsif cv2(1) = '0' then
            value <= x"2";
        elsif cv2(2) = '0' then
            value <= x"5";
        elsif cv2(3) = '0' then
            value <= x"8";
        elsif cv2(4) = '0' then
            value <= x"f";
        elsif cv3(1) = '0' then
            value <= x"3";
        elsif cv3(2) = '0' then
            value <= x"6";
        elsif cv3(3) = '0' then
            value <= x"9";
        elsif cv3(4) = '0' then
            value <= x"e";
        elsif cv4(1) = '0' then
            value <= x"a";
        elsif cv4(2) = '0' then
            value <= x"b";
        elsif cv4(3) = '0' then
            value <= x"c";
        elsif cv4(4) = '0' then
            value <= x"d";
        else
            hit <= '0';
            value <= x"0";
        end if;
    end process;
    col <= curr_col;
end behavioral;
