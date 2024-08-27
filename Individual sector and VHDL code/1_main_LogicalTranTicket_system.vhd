LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.Vcomponents.all;
entity trainsys is
	port (
		clk : in STD_LOGIC; 
		sw_operand : in std_logic_vector (15 downto 0);
		KB_row : in std_logic_vector (4 downto 1); 
		bt_sub : in STD_LOGIC;
		bt_clr : in STD_LOGIC; 
		bt_plus : in STD_LOGIC; 
		bt_eq : in STD_LOGIC; 
		bt_ok :  in STD_LOGIC; 
		KB_col : out std_logic_vector (4 downto 1); 
		segment : out std_logic_vector (6 downto 0); 
		AN : out std_logic_vector (7 downto 0);  
		LED : out std_logic_vector(15 downto 0);
		LED16_R : out std_logic;
		LED16_G : out std_logic;
		LED16_B : out std_logic;
		LED17_G : out std_logic;
		LED17_R : out std_logic; 
		LED17_B : out std_logic);
end trainsys;

architecture Behavioral of trainsys is
	component sevensegdecoder is
		port (
			dig : in std_logic_vector (2 downto 0);
			data : in std_logic_vector (15 downto 0);
			anode : out std_logic_vector (7 downto 0);
			seg : out std_logic_vector (6 downto 0)
		);
	end component;
	component keypadecod is
		port (
			samp_ck : in STD_LOGIC;
			col : out std_logic_vector (4 downto 1);
			row : in std_logic_vector (4 downto 1);
			value : out std_logic_vector (3 downto 0);
			hit : out STD_LOGIC
		);
	end component;
	
	
	constant pwm_cycles : integer := 255;
    constant TARGET_INTENSITY : integer := 127;
    
    signal led_blink : std_logic := '0'; 
    signal pwm_counter : integer range 0 to pwm_cycles := 0; 
	signal display : std_logic_vector (15 downto 0); 
	signal counter : std_logic_vector(20 downto 0); 
	signal kp_clk, kp_hit, sm_clk : std_logic;
	signal kp_value : std_logic_vector (3 downto 0);
	signal nx_acc, accumulate : std_logic_vector (15 downto 0);  
	signal nx_operand, operand : std_logic_vector (15 downto 0); 
	signal led_mpx : std_logic_vector (2 downto 0); 
----------------------------------------------------------------------------------
---- FSM: The states are explained in more detailed in the desciption of this main file
----------------------------------------------------------------------------------
	type state is (ORIGIN_INPUT, WAIT_BUTN1, WAIT_BUTN2, WAIT_STATE, 
	DESTINATION_USR, PRICE_CALC, PAYMENT, SHOW_RE_PAYMENT); 
	-- signals that help defining the FSM such as present states, or next states, or for the calculation of the price
	signal pr_state, nx_state : state; 
	signal forw_or_back: STD_LOGIC;
begin
    PWM_PROCESS : process(clk)
        begin   
        if rising_edge(clk) then
            if pwm_counter = pwm_cycles then
                pwm_counter <= 0;
            else
                pwm_counter <= pwm_counter + 1;
            end if;
        end if;
    end process;

    led_fls : process(clk)
    variable count : integer range 0 to 50000000 := 0;
    begin
        if rising_edge(clk) then 
            if count = 50000000 then 
                led_blink <= not led_blink;
                count := 0;
            else
                count := count + 1;
            end if;
        end if;
    end process;
    
	ck_proc : process (clk)
	begin
		if rising_edge(clk) then 
			counter <= counter + 1; 
		end if;
	end process;

	kp_clk <= counter(15); -- keypad interrogation clock
	sm_clk <= counter(20); -- state machine clock
	led_mpx <= counter(19 downto 17); -- 7-seg multiplexing clock
	
	kp1 : keypadecod
	port map(
		samp_ck => kp_clk, col => KB_col, 
		row => KB_row, value => kp_value, hit => kp_hit
		);
		led1 : sevensegdecoder
		port map(
			dig => led_mpx, data => display, 
			anode => AN, seg => segment
		);
----------------------------------------------------------------------------------
----Additional FSM related to the clock process
----------------------------------------------------------------------------------
	sm_ck_pr : process (bt_clr, sm_clk) 
		begin
			if bt_clr = '1' then 
				accumulate <= X"0000";
				operand <= X"0000";
				pr_state <= ORIGIN_INPUT;
			elsif rising_edge (sm_clk) then 
				pr_state <= nx_state; 
				accumulate <= nx_acc; 
				operand <= nx_operand; 
			end if;
		end process;
		
		
	sm_comb_pr : process (kp_hit, kp_value, bt_plus, bt_eq, bt_ok, accumulate, operand, pr_state, sw_operand)
		begin
		-- default values of different signals including LEDs
			LED <= (others => '0');	
			nx_acc <= accumulate; 
			nx_operand <= operand;
			display <= accumulate;
			LED16_R <= '0';
            LED16_G <= '0';
            LED16_B <= '0';
            LED17_R <= '0';
            LED17_G <= '0';
            LED17_B <= '0';
			
			CASE pr_state IS 
				when ORIGIN_INPUT => 
				    LED(15 downto 0) <= x"0003"; 

				    if (pwm_counter < TARGET_INTENSITY and led_blink = '1') then
						LED16_R <= '1';
						LED16_G <= '1';
						LED16_B <= '1';
						LED17_R <= '1';
						LED17_G <= '1';
						LED17_B <= '1';
					else
						LED16_R <= '0';
						LED16_G <= '0';
						LED16_B <= '0';
						LED17_R <= '0';
						LED17_G <= '0';
						LED17_B <= '0';
					end if;
				    
					if kp_hit = '1' then
						nx_acc <= accumulate(11 downto 0) & kp_value;
						nx_state <= WAIT_BUTN1;
					elsif bt_plus = '1' then
						nx_state <= WAIT_BUTN2;
						forw_or_back <= '1';
					elsif bt_sub ='1'then
					   nx_state <= WAIT_BUTN2;
					   forw_or_back <='0';
					else
						nx_state <= ORIGIN_INPUT;
					end if;

				when WAIT_BUTN1 => -- here it waits for the keypad button
				    LED(15 downto 0) <= x"000F"; 
					if kp_hit = '0' then
						nx_state <= ORIGIN_INPUT;
					else nx_state <= WAIT_BUTN1;
					end if;

				when WAIT_BUTN2 => -- second digit for user input
				    LED(15 downto 0) <= x"000F";  
					if kp_hit = '1' then
						nx_operand <= X"000" & kp_value;
						nx_state <= WAIT_STATE;
						display <= operand;
					else nx_state <= WAIT_BUTN2;
					end if;

				when WAIT_STATE =>
					display <= operand;
					if kp_hit = '0' then
						nx_state <= DESTINATION_USR;
					else nx_state <= WAIT_STATE;
					end if;

				-- in this state it is only possible to have an accumulate for the distance calc between 0001 and FFFF 
				when DESTINATION_USR => 
				    LED(15 downto 0) <= x"003F";
					display <= operand;
					  if (bt_eq = '1' and forw_or_back='1') then
                        if (bt_eq = '1' and (accumulate + operand < accumulate)) then
                            -- Overflow detected as it can't be over FFFF
                            LED(15 downto 0) <= x"007F";
                            LED16_R <= '1';
                                LED16_G <= '0';
                                LED16_B <= '0';
                                LED17_R <= '1';
                                LED17_G <= '0';
                                LED17_B <= '0';
                            nx_state <= ORIGIN_INPUT;
                        else
                            nx_acc <= accumulate + operand;
                            nx_state <= PRICE_CALC;
                                                       
                        end if;
					elsif (bt_eq = '1'and forw_or_back= '0' and operand < accumulate)then
					   nx_acc <= accumulate - operand;
					   nx_state <= PRICE_CALC;
					   
					elsif (bt_eq = '1' and forw_or_back= '0' and not(operand < accumulate))then
					   LED(15 downto 0) <= x"007F";
					   
					   LED16_R <= '1';
                        LED16_G <= '0';
                        LED16_B <= '0';
                        LED17_R <= '1';
                        LED17_G <= '0';
                        LED17_B <= '0';
					   nx_state <= ORIGIN_INPUT; --here it comes backs to handle a suitabe value
					elsif kp_hit = '1' then
						nx_operand <= operand(11 downto 0) & kp_value;
						nx_state <= WAIT_STATE;
					else nx_state <= DESTINATION_USR;
					end if;

				when PRICE_CALC => -- final price calculation showing
				    LED(15 downto 0) <= x"00FF"; 
				    if bt_sub = '1' then
                        nx_state <= PAYMENT;
                        forw_or_back <= '0';
                    else
                        nx_state <= PRICE_CALC;
                    end if;

                when PAYMENT =>
                    LED(15 downto 0) <= x"03FF";
                    display <= sw_operand; 
                    if (bt_eq = '1' and sw_operand = accumulate) then
                        nx_state <= SHOW_RE_PAYMENT;
                        
                    elsif (bt_eq = '1' and not (sw_operand = accumulate)) then
                         LED(15 downto 0) <= x"07FF";
                         LED16_R <= '1';
                        LED16_G <= '0';
                        LED16_B <= '0';
                        LED17_R <= '1';
                        LED17_G <= '0';
                        LED17_B <= '0';
						 display <= accumulate; -- it shows the accumulate price value while OK button is pressed 
                         nx_state <= PAYMENT;   
                    else
                        LED(15 downto 0) <= x"03FF";
                        nx_state <= PAYMENT;                        
                    end if;
					
			    when SHOW_RE_PAYMENT => -- display result of pay
			        display <= accumulate - sw_operand;
			        LED(15 downto 0) <= x"0FFF"; -- as a sign of complete ticket purchase
			        LED16_G <= '1'; -- as a sign of succesful pro
                    LED17_G <= '1';
					if bt_ok = '1' then -- confirmation from user 
					  
                       nx_acc <= X"000" & kp_value;
                       nx_state <= ORIGIN_INPUT;                   
                    else
                        nx_state <= SHOW_RE_PAYMENT;
                    end if;
			
			end CASE;
		end process;
end Behavioral;
