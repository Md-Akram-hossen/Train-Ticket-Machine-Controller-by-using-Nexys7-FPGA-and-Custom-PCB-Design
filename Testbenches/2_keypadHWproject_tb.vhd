LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
t Declaration for the Unit Under Test (UUT)
    COMPONENT k
ENTITY keypadecod_tb IS
END keypadecod_tb;

ARCHITECTURE corder OF keypadecod_tb IS 

    -- Componeneypadecod
    PORT(
         samp_ck : IN  std_logic;
         col : OUT  std_logic_vector(4 downto 1);
         row : IN  std_logic_vector(4 downto 1);
         value_hit : OUT  std_logic_vector(3 downto 0);
         hit : OUT  std_logic
        );
    END COMPONENT;
    
    --Inputs
    signal samp_ck_tb : std_logic := '0';
    signal row_tb : std_logic_vector(4 downto 1) := (others => '1');

    --Outputs
    signal col_tb : std_logic_vector(4 downto 1);
    signal value_hit_tb : std_logic_vector(3 downto 0);
    signal hit_tb : std_logic;

    -- Clock period definitions
    constant clk_period : time := 2 ns;
    
BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: keypadecod PORT MAP (
          samp_ck => samp_ck_tb,
          col => col_tb,
          row => row_tb,
          value_hit => value_hit_tb,
          hit => hit_tb
        );

    -- Clock process definitions
    clk_process :process
    begin
        samp_ck_tb <= '0';
        wait for clk_period/2;
        samp_ck_tb <= '1';
        wait for clk_period/2;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin
	
	wait for 4 * clk_period;
	

        -- Test Case 1: Press '0'
        row_tb <= "0111"; wait for clk_period;
	if (value_hit_tb = X"0" and hit_tb = '1') then
            report "Test Case 1 Passed" severity note;
        else
            report "Test Case 1 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;
   
        -- Test Case 2: Press '7' 
        row_tb <= "1011"; wait for clk_period;
        if (value_hit_tb = X"7" and hit_tb = '1') then
            report "Test Case 2 Passed" severity note;
        else
            report "Test Case 2 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;

        -- Test Case 3: Press '4'
        row_tb <= "1101"; wait for clk_period;
        if (value_hit_tb = X"4" and hit_tb = '1') then
            report "Test Case 3 Passed" severity note;
        else
            report "Test Case 3 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;

        -- Test Case 4: Press '1' 
        row_tb <= "1110"; wait for clk_period;
        if (value_hit_tb = X"1" and hit_tb = '1') then
            report "Test Case 4 Passed" severity note;
        else
            report "Test Case 4 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 4 * clk_period;

	 -- Test Case 5: Press 'F' 
        row_tb <= "0111"; wait for clk_period;
        if (value_hit_tb = X"F" and hit_tb = '1') then
            report "Test Case 5 Passed" severity note;
        else
            report "Test Case 5 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;

        -- Test Case 6: Press '8' 
        row_tb <= "1011"; wait for clk_period;
        if (value_hit_tb = X"8" and hit_tb = '1') then
            report "Test Case 6 Passed" severity note;
        else
            report "Test Case 6 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;

        -- Test Case 7: Press '5'
        row_tb <= "1101"; wait for clk_period;
        if (value_hit_tb = X"5" and hit_tb = '1') then
            report "Test Case 7 Passed" severity note;
        else
            report "Test Case 7 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;

        -- Test Case 8: Press '2' 
        row_tb <= "1110"; wait for clk_period;
        if (value_hit_tb = X"2" and hit_tb = '1') then
            report "Test Case 8 Passed" severity note;
        else
            report "Test Case 8 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 4 * clk_period;

       	-- Test Case 9: Press 'E' 
        row_tb <= "0111"; wait for clk_period;
        if (value_hit_tb = X"E" and hit_tb = '1') then
            report "Test Case 9 Passed" severity note;
        else
            report "Test Case 9 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;

        -- Test Case 10: Press '9' 
        row_tb <= "1011"; wait for clk_period;
        if (value_hit_tb = X"9" and hit_tb = '1') then
            report "Test Case 10 Passed" severity note;
        else
            report "Test Case 10 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;

        -- Test Case 11: Press '6' 
        row_tb <= "1101"; wait for clk_period;
        if (value_hit_tb = X"6" and hit_tb = '1') then
            report "Test Case 11 Passed" severity note;
        else
            report "Test Case 11 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;

        -- Test Case 12: Press '3' 
        row_tb <= "1110"; wait for clk_period;
        if (value_hit_tb = X"3" and hit_tb = '1') then
            report "Test Case 12 Passed" severity note;
        else
            report "Test Case 12 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 4 * clk_period;

	-- Test Case 13: Press 'D' 
        row_tb <= "0111"; wait for clk_period;
        if (value_hit_tb = X"D" and hit_tb = '1') then
            report "Test Case 13 Passed" severity note;
        else
            report "Test Case 13 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;

        -- Test Case 14: Press 'C'
        row_tb <= "1011"; wait for clk_period;
        if (value_hit_tb = X"C" and hit_tb = '1') then
            report "Test Case 14 Passed" severity note;
        else
            report "Test Case 14 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;

        -- Test Case 15: Press 'B' 
        row_tb <= "1101"; wait for clk_period;
        if (value_hit_tb = X"B" and hit_tb = '1') then
            report "Test Case 15 Passed" severity note;
        else
            report "Test Case 15 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;

        -- Test Case 16: Press 'A' 
        row_tb <= "1110"; wait for clk_period;
        if (value_hit_tb = X"A" and hit_tb = '1') then
            report "Test Case 16 Passed" severity note;
        else
            report "Test Case 16 Failed" severity error;
        end if;
	row_tb <= "1111"; wait for 3 * clk_period;

        wait;
    end process;

END;

