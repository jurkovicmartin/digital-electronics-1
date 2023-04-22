----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2023 01:44:12 PM
-- Design Name: 
-- Module Name: timer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timer is
    Port ( clck : in STD_LOGIC;
           rst : in STD_LOGIC;
           goDelay : in STD_LOGIC_VECTOR (3 downto 0);
           pauseDelay : in STD_LOGIC_VECTOR (3 downto 0);
           rounds : in STD_LOGIC_VECTOR (3 downto 0);
           indicator : out STD_LOGIC_VECTOR (3 downto 0);
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

  -- Define the signal that uses different states
  signal sig_state : t_state;
  
  -- Internal clock enable
  signal sig_en : std_logic;
  
  -- Local delay counter
  signal sig_cnt : unsigned(4 downto 0);
  -- Local rounds counter
  signal sig_round_cnt : unsigned(4 downto 0);
  
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
         if (sig_round_cnt = UNSIGNED(rounds)) then
            sig_state <= OVER;
          else
            if (sig_cnt < UNSIGNED(goDelay)) then
              sig_cnt <= sig_cnt + 1;
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
                if (sig_cnt < b"0000") then
              sig_cnt <= sig_cnt + 1;
            else
              sig_state <= GO;
              sig_cnt   <= (others => '0');
              sig_round_cnt <= (others => '0');
            end if;
            
            when others =>
                sig_state <= OVER;
                sig_cnt   <= (others => '0');
          end case;
        end if;
      end if;
      
end process p_timer_fsm;
 
p_output_fsm : process (sig_state) is
  begin

    case sig_state is
    
      when GO =>
           indicator <= "1100"; --g
           firstDigit <= "0001";
           secondDigit <= "0001";
           thirdDigit <= "0001";
        
      when PAUSE =>
           indicator <= "1111"; --P
           firstDigit <= "0000";
           secondDigit <= "0000";
           thirdDigit <= "0000";
           
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
