LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY sevensegdecoder_tb IS
END sevensegdecoder_tb;

ARCHITECTURE hahaha OF sevensegdecoder_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT sevensegdecoder
    PORT(
         dig : IN  std_logic_vector(2 DOWNTO 0);
         data : IN  std_logic_vector(15 DOWNTO 0);
         anode : OUT  std_logic_vector(7 DOWNTO 0);
         seg : OUT  std_logic_vector(6 DOWNTO 0)
        );
    END COMPONENT;
    
    -- Signals for inputs and outputs of the UUT
    SIGNAL dig_tb : std_logic_vector(2 DOWNTO 0) := "000";
    SIGNAL data_tb : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL anode_tb : std_logic_vector(7 DOWNTO 0);
    SIGNAL seg_tb : std_logic_vector(6 DOWNTO 0);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: sevensegdecoder PORT MAP (
          dig => dig_tb,
          data => data_tb,
          anode => anode_tb,
          seg => seg_tb
        );

    -- Stimulus process to apply test inputs to the UUT
    stim_proc: process
    begin
        -- Test 1: Varying data4 from 0 to F with fixed dig = 000
        data_tb <= X"0000"; wait for 10 ns;  -- data4 = 0
        data_tb <= X"0001"; wait for 10 ns;  -- data4 = 1
        data_tb <= X"0002"; wait for 10 ns;  -- data4 = 2
        data_tb <= X"0003"; wait for 10 ns;  -- data4 = 3
        data_tb <= X"0004"; wait for 10 ns;  -- data4 = 4
        data_tb <= X"0005"; wait for 10 ns;  -- data4 = 5
        data_tb <= X"0006"; wait for 10 ns;  -- data4 = 6
        data_tb <= X"0007"; wait for 10 ns;  -- data4 = 7
        data_tb <= X"0008"; wait for 10 ns;  -- data4 = 8
        data_tb <= X"0009"; wait for 10 ns;  -- data4 = 9
        data_tb <= X"000A"; wait for 10 ns;  -- data4 = A
        data_tb <= X"000B"; wait for 10 ns;  -- data4 = B
        data_tb <= X"000C"; wait for 10 ns;  -- data4 = C
        data_tb <= X"000D"; wait for 10 ns;  -- data4 = D
        data_tb <= X"000E"; wait for 10 ns;  -- data4 = E
        data_tb <= X"000F"; wait for 10 ns;  -- data4 = F

        -- Test 2: Checking anode behavior
        -- Case 1: anode = 11111110
        data_tb <= X"0001"; -- Ensure non-zero value in the first digit
        dig_tb <= "000";
        wait for 10 ns;
        assert (anode_tb = "11111110") report "Anode Test Case 1 Failed" severity error;

        -- Case 2: anode = 11111101
        data_tb <= X"0010"; -- Ensure non-zero value in the second digit
        dig_tb <= "001";
        wait for 10 ns;
        assert (anode_tb = "11111101") report "Anode Test Case 2 Failed" severity error;

        -- Case 3: anode = 11111011
        data_tb <= X"0100"; -- Ensure non-zero value in the third digit
        dig_tb <= "010";
        wait for 10 ns;
        assert (anode_tb = "11111011") report "Anode Test Case 3 Failed" severity error;

        -- Case 4: anode = 11110111
        data_tb <= X"1000"; -- Ensure non-zero value in the fourth digit
        dig_tb <= "011";
        wait for 10 ns;
        assert (anode_tb = "11110111") report "Anode Test Case 4 Failed" severity error;

        wait;
    end process;

END;
