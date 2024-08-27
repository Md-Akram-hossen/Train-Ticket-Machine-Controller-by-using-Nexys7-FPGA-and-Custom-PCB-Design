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
-- Description: It shows the X number that is pressed in the PMOD Keypad 1-F, once the key is not pressed anymore it shows still the X number in a 7-segment display. BTNC botton reset the displayed number.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: own implementation based on available documentation
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hexcalc is
    port (
        clk_50mhz : in std_logic; 
        seg7_anode : out std_logic_vector (7 downto 0); -- anodes of eight 7-seg displays
        seg7_seg : out std_logic_vector (6 downto 0); -- common segments of 7-seg displays
        bt_clr : in std_logic; -- "clear" button
        kb_col : out std_logic_vector (4 downto 1); -- keypad column pins
        kb_row : in std_logic_vector (4 downto 1)); -- keypad row pins
end hexcalc;

architecture behavioral of hexcalc is
    component keypad is
        port (
            samp_ck : in std_logic;
            col : out std_logic_vector (4 downto 1);
            row : in std_logic_vector (4 downto 1);
            value : out std_logic_vector (3 downto 0);
            hit : out std_logic
        );
    end component;
    component leddec16 is
        port (
            dig : in std_logic_vector (2 downto 0);
            data : in std_logic_vector (15 downto 0);
            anode : out std_logic_vector (7 downto 0);
            seg : out std_logic_vector (6 downto 0)
        );
    end component;
    signal cnt : std_logic_vector(20 downto 0); -- counter to generate timing signals
    signal kp_clk, kp_hit, prev_kp_hit : std_logic;
    signal kp_value : std_logic_vector (3 downto 0);
    signal display : std_logic_vector (15 downto 0); -- value to be displayed
    signal led_mpx : std_logic_vector (2 downto 0); -- 7-seg multiplexing clock
begin
    ck_proc : process (clk_50mhz)
    begin
        if rising_edge(clk_50mhz) then 
            cnt <= cnt + 1; 
        end if;
    end process;
    kp_clk <= cnt(15); -- keypad interrogation clock
    led_mpx <= cnt(19 downto 17); -- 7-seg multiplexing clock
    kp1 : keypad
    port map(
        samp_ck => kp_clk, col => kb_col, 
        row => kb_row, value => kp_value, hit => kp_hit
    );
    led1 : leddec16
    port map(
        dig => led_mpx, data => display, 
        anode => seg7_anode, seg => seg7_seg
    );
    -- update the display with the pressed key value
    process (clk_50mhz)
    begin
        if rising_edge(clk_50mhz) then
            prev_kp_hit <= kp_hit;
            if bt_clr = '1' then
                display <= x"0000";
            elsif kp_hit = '1' and prev_kp_hit = '0' then -- new key pressed
                display <= x"000" & kp_value;
            end if;
        end if;
    end process;
end behavioral;
