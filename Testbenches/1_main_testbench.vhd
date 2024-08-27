----------------------------------------------------------------------------------
-- Company: HW Group C
-- Engineer/Author: Richard Jimenez G. 
-- 
-- Create Date: 26.07.2024
-- Design Name: 
-- Module Name: V1_TB
-- Project Name: Logical train ticket system
-- Target Devices: 
-- Tool Versions: 
-- Description: Test bench for the FSM of the train ticket system
-- 
-- Dependencies: trainsys
-- 
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: This test bench covers a scenario where the user inputs an origin and destination, calculates the price, and makes the payment.
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY trainsys_tb IS
END trainsys_tb;

ARCHITECTURE natal OF trainsys_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT trainsys
    PORT(
         clk : IN  std_logic;
         sw_operand : IN  std_logic_vector(15 downto 0);
         KB_row : IN  std_logic_vector(4 downto 1);
         bt_sub : IN  std_logic;
         bt_clr : IN  std_logic;
         bt_plus : IN  std_logic;
         bt_eq : IN  std_logic;
         bt_ok : IN  std_logic;
         KB_col : OUT  std_logic_vector(4 downto 1);
         segment : OUT  std_logic_vector(6 downto 0);
         AN : OUT  std_logic_vector(7 downto 0);
         LED : OUT  std_logic_vector(15 downto 0);
         LED16_R : OUT  std_logic;
         LED16_G : OUT  std_logic;
         LED16_B : OUT  std_logic;
         LED17_G : OUT  std_logic;
         LED17_R : OUT  std_logic;
         LED17_B : OUT  std_logic
        );
    END COMPONENT;
    
   -- Inputs
   signal clk_tb : std_logic := '0';
   signal sw_operand_tb : std_logic_vector(15 downto 0) := (others => '0');
   signal KB_row_tb : std_logic_vector(4 downto 1) := (others => '0');
   signal bt_sub_tb : std_logic := '0';
   signal bt_clr_tb : std_logic := '0';
   signal bt_plus_tb : std_logic := '0';
   signal bt_eq_tb : std_logic := '0';
   signal bt_ok_tb : std_logic := '0';

    -- Outputs
   signal KB_col_tb : std_logic_vector(4 downto 1);
   signal segment_tb : std_logic_vector(6 downto 0);
   signal AN_tb : std_logic_vector(7 downto 0);
   signal LED_tb : std_logic_vector(15 downto 0);
   signal LED16_R_tb : std_logic;
   signal LED16_G_tb : std_logic;
   signal LED16_B_tb : std_logic;
   signal LED17_G_tb : std_logic;
   signal LED17_R_tb : std_logic;
   signal LED17_B_tb : std_logic;

    -- Clock period definitions
    constant clk_period : time := 2 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: trainsys PORT MAP (
          clk => clk_tb,
          sw_operand => sw_operand_tb,
          KB_row => KB_row_tb,
          bt_sub => bt_sub_tb,
          bt_clr => bt_clr_tb,
          bt_plus => bt_plus_tb,
          bt_eq => bt_eq_tb,
          bt_ok => bt_ok_tb,
          KB_col => KB_col_tb,
          segment => segment_tb,
          AN => AN_tb,
          LED => LED_tb,
          LED16_R => LED16_R_tb,
          LED16_G => LED16_G_tb,
          LED16_B => LED16_B_tb,
          LED17_G => LED17_G_tb,
          LED17_R => LED17_R_tb,
          LED17_B => LED17_B_tb
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk_tb <= '0';
        wait for clk_period/2;
        clk_tb <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- Reset inputs
        bt_clr_tb <= '1'; wait for 10 ns;

        -- Input Origin (e.g., 1234)
        KB_row_tb <= "0001"; wait for 8 ns;       
        KB_row_tb <= "0010"; wait for 8 ns;
        KB_row_tb <= "0100"; wait for 8 ns;
        KB_row_tb <= "1000"; wait for 8 ns;
        
        -- Wait for user to confirm with '+' button
        bt_plus_tb <= '1';
        wait for 10 ns;
        
        -- Input Destination (e.g., 5678)
        KB_row_tb <= "0100"; wait for 8 ns; -- 5
        KB_row_tb <= "1000"; wait for 8 ns; -- 6  
        KB_row_tb <= "0001"; wait for 8 ns; -- 7      
        KB_row_tb <= "0010"; wait for 8 ns; -- 8

        -- Wait for user to confirm with '-' button
        bt_sub_tb <= '1'; wait for 10 ns;

        -- Pay the exact amount (1234+5678=68AC)
        sw_operand_tb <= X"68AC";
        bt_eq_tb <= '1'; wait for 10 ns;
        
        -- Confirm successful purchase
        bt_ok_tb <= '1'; wait for 10 ns;

        wait;
    end process;

END;

