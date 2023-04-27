library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    Port ( clck : in STD_LOGIC;
           rst : in STD_LOGIC;
           goDelay : in STD_LOGIC_VECTOR (3 downto 0);     -- time of round
           pauseDelay : in STD_LOGIC_VECTOR (3 downto 0);  -- time of pause
           rounds : in STD_LOGIC_VECTOR (3 downto 0);      -- number of rounds
           indicator : out STD_LOGIC_VECTOR (3 downto 0);  -- 4th digit
           firstDigit : out STD_LOGIC_VECTOR (3 downto 0);
           secondDigit : out STD_LOGIC_VECTOR (3 downto 0);
           thirdDigit : out STD_LOGIC_VECTOR (3 downto 0)
           );
end timer;

architecture Behavioral of timer is

 type t_state is(
 PAUSE,
 GO,
 OVER
 );

  signal sig_state : t_state;
  
  -- Internal clock enable
  signal sig_en : std_logic;  -- main
  signal sig_en1 : std_logic; -- for display countdown
  
  -- delay counter
  signal sig_cnt : unsigned(4 downto 0);
  -- rounds counter
  signal sig_round_cnt : unsigned(4 downto 0);
  
  -- set up signals
  signal sig_g_start2 : std_logic_vector(3 downto 0); -- GO 2nd digit
  signal sig_g_start3 : std_logic_vector(3 downto 0); -- Go 3rd digit
  signal sig_p_start2 : std_logic_vector(3 downto 0); -- PAUSE 2nd digit
  signal sig_p_start3 : std_logic_vector(3 downto 0); -- PAUSE 3rd digit
  
  -- siganls to display
  signal sig_g_first : std_logic_vector(3 downto 0);  --GO 1st digit
  signal sig_g_second : std_logic_vector(3 downto 0); --Go 2nd digit
  signal sig_g_third : std_logic_vector(3 downto 0);  --GO 3rd digit
  signal sig_p_first : std_logic_vector(3 downto 0);  --PAUSE 1st digit
  signal sig_p_second : std_logic_vector(3 downto 0); --PAUSE 2nd digit
  signal sig_p_third : std_logic_vector(3 downto 0);  --PAUSE 3rd digit
  
  -- signals to reset display counters
  signal sig_g_reset : std_logic; --go
  signal sig_p_reset : std_logic; --pause
  
begin

clk_en0 : entity work.clock_enable
    generic map (
      g_MAX => 1000000000 -- 10 seconds
    )
    port map (
      clk => clck,
      rst => rst,
      ce  => sig_en
    );
    
clk_en1 : entity work.clock_enable
    generic map (
      g_MAX => 100000000 -- 1 seconds
    )
    port map (
      clk => clck,
      rst => rst,
      ce  => sig_en1
    );

countdownGo : entity work.countdown --for displaying GO countdown
    port map (
      clk => clck,
      rst => sig_g_reset,
      en => sig_en1,
      start10 => sig_g_start2,
      start100 => sig_g_start3,
      seconds => sig_g_first,
      tens => sig_g_second,
      hunderets => sig_g_third
    );
    
countdownPause : entity work.countdown --for displaying PAUSE countdown
    port map (
      clk => clck,
      rst => sig_p_reset,
      en => sig_en1,
      start10 => sig_p_start2,
      start100 => sig_p_start3,
      seconds => sig_p_first,
      tens => sig_p_second,
      hunderets => sig_p_third
    );

p_setup_fsm : process (rst) is --process to set up starting values for countdown
  begin
  
  case goDelay is
  	
    when "0000" => -- 10 seconds
    	sig_g_start2 <= "0001";
        sig_g_start3 <= "0000";
   
    when "0001" => -- 20 seconds
    	sig_g_start2 <= "0010";
        sig_g_start3 <= "0000";
        
    when "0010" => -- 30 seconds
    	sig_g_start2 <= "0011";
        sig_g_start3 <= "0000";
        
    when "0011" =>
    	sig_g_start2 <= "0100";
        sig_g_start3 <= "0000";
  	
    when "0100" =>
    	sig_g_start2 <= "0101";
        sig_g_start3 <= "0000";
        
    when "0101" =>
    	sig_g_start2 <= "0110";
        sig_g_start3 <= "0000";
        
    when "0110" =>
    	sig_g_start2 <= "0111";
        sig_g_start3 <= "0000";
        
    when "0111" =>
    	sig_g_start2 <= "1000";
        sig_g_start3 <= "0000";
        
    when "1000" =>
    	sig_g_start2 <= "1001";
        sig_g_start3 <= "0000";
        
    when "1001" =>
    	sig_g_start2 <= "0000";
        sig_g_start3 <= "0001";
        
    when "1010" =>
    	sig_g_start2 <= "0001";
        sig_g_start3 <= "0001";
        
    when "1011" =>
    	sig_g_start2 <= "0010";
        sig_g_start3 <= "0001";
        
    when "1100" =>
    	sig_g_start2 <= "0011";
        sig_g_start3 <= "0001";
        
    when "1101" =>
    	sig_g_start2 <= "0100";
        sig_g_start3 <= "0001";
        
    when "1110" =>
    	sig_g_start2 <= "0101";
        sig_g_start3 <= "0001";
        
    when "1111" =>
    	sig_g_start2 <= "0110";
        sig_g_start3 <= "0001";
        
    when others =>
    	sig_g_start2 <= "0000";
        sig_g_start3 <= "0000";
        
  end case;
  
  case pauseDelay is
  
  when "0000" => -- 10 seconds
    	sig_p_start2 <= "0001";
        sig_p_start3 <= "0000";
   
    when "0001" => -- 20 seconds
    	sig_p_start2 <= "0010";
        sig_p_start3 <= "0000";
        
    when "0010" => -- 30 seconds
    	sig_p_start2 <= "0011";
        sig_p_start3 <= "0000";
        
    when "0011" =>
    	sig_p_start2 <= "0100";
        sig_p_start3 <= "0000";
  	
    when "0100" =>
    	sig_p_start2 <= "0101";
        sig_p_start3 <= "0000";
        
    when "0101" =>
    	sig_p_start2 <= "0110";
        sig_p_start3 <= "0000";
        
    when "0110" =>
    	sig_p_start2 <= "0111";
        sig_p_start3 <= "0000";
        
    when "0111" =>
    	sig_p_start2 <= "1000";
        sig_p_start3 <= "0000";
        
    when "1000" =>
    	sig_p_start2 <= "1001";
        sig_p_start3 <= "0000";
        
    when "1001" =>
    	sig_p_start2 <= "0000";
        sig_p_start3 <= "0001";
        
    when "1010" =>
    	sig_p_start2 <= "0001";
        sig_p_start3 <= "0001";
        
    when "1011" =>
    	sig_p_start2 <= "0010";
        sig_p_start3 <= "0001";
        
    when "1100" =>
    	sig_p_start2 <= "0011";
        sig_p_start3 <= "0001";
        
    when "1101" =>
    	sig_p_start2 <= "0100";
        sig_p_start3 <= "0001";
        
    when "1110" =>
    	sig_p_start2 <= "0101";
        sig_p_start3 <= "0001";
        
    when "1111" =>
    	sig_p_start2 <= "0110";
        sig_p_start3 <= "0001";
        
    when others =>
    	sig_p_start2 <= "0000";
        sig_p_start3 <= "0000";
  
  end case;
  
end process p_setup_fsm;

    
p_timer_fsm : process (clck) is
begin
if (rising_edge(clck)) then
      if (rst = '1') then               -- Synchronous reset
        sig_state <= GO;                -- Init state
        sig_cnt   <= (others => '0');       --Clear dealy counter
        sig_round_cnt <= (others => '0');   -- Clear rounds counter
      elsif (sig_en = '1') then
        case sig_state is
        
         when GO =>
        
          if (sig_cnt < UNSIGNED(goDelay)) then
              sig_cnt <= sig_cnt + 1;
          else
            
             if(sig_round_cnt = UNSIGNED(rounds)) then --check for last round
             	sig_state <= OVER;
             else
             	sig_state <= PAUSE;
             	sig_cnt   <= (others => '0');
             end if;
              
          end if;         
            
          when PAUSE =>
          
            if (sig_cnt < UNSIGNED(pauseDelay)) then
              sig_cnt <= sig_cnt + 1;
            else
              sig_state <= GO;
              sig_cnt   <= (others => '0');
              sig_round_cnt <= sig_round_cnt + 1;
            end if;
            
            when OVER =>

                if(rst = '1') then
                    sig_state <= GO;
                    sig_cnt   <= (others => '0');
                end if;
            
            when others =>
                sig_state <= OVER;
                sig_cnt   <= (others => '0');
          end case;
        end if;
      end if;
      
end process p_timer_fsm;


p_reset_fsm : process (clck) is --seting reseting signals for display counters
begin

if(rising_edge(clck)) then

	if(sig_state = GO) then
    	sig_g_reset <= '0';
        sig_p_reset <= '1';
           
    elsif(sig_state = PAUSE) then
    	sig_g_reset <= '1';
        sig_p_reset <= '0';
    else
    	sig_g_reset <= '1';
        sig_p_reset <= '1';
        
    end if;
end if;

end process p_reset_fsm;

 
p_output_fsm : process (clck) is --set outputs
  begin

    case sig_state is
    
      when GO =>
           indicator <= "1100"; --g
           firstDigit <= sig_g_first;
           secondDigit <= sig_g_second;
           thirdDigit <= sig_g_third;
        
      when PAUSE =>
           indicator <= "1111"; --P
           firstDigit <= sig_p_first;
           secondDigit <= sig_p_second;
           thirdDigit <= sig_p_third;
           
      when OVER =>
           indicator <= "1110"; -- E
           firstDigit <= "0000";
           secondDigit <= "0000";
           thirdDigit <= "0000";
           
      when others =>
           indicator <= "1110"; -- E
           firstDigit <= "0000";
           secondDigit <= "0000";
           thirdDigit <= "0000";
           
     end case;
   end process p_output_fsm;
end Behavioral;