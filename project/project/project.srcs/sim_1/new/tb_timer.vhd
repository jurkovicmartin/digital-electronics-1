-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_timer is
  -- Entity of testbench is always empty
end entity tb_timer;

------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------

architecture testbench of tb_timer is

  constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

  -- Local signals
  signal sig_clk_100mhz : std_logic;
  signal sig_rst : std_logic;
  signal go : std_logic_vector(3 downto 0);
  signal pause : std_logic_vector(3 downto 0);
  signal rounds : std_logic_vector(3 downto 0);
  signal indicator : std_logic_vector(3 downto 0);
  signal first : std_logic_vector(3 downto 0);
  signal second : std_logic_vector(3 downto 0);
  signal third : std_logic_vector(3 downto 0);

begin


  uut_timer : entity work.timer
    port map (
      clck    => sig_clk_100mhz,
      rst => sig_rst,
      goDelay => go,
      pauseDelay => pause,
      rounds => rounds,
      indicator => indicator,
      firstDigit => first,
      secondDigit => second,
      thirdDigit => third
    );

  p_clk_gen : process is      --clock signal generation
  begin

    while now < 2000 ns loop
    
      sig_clk_100mhz <= '0';
      wait for c_CLK_100MHZ_PERIOD / 2;
      sig_clk_100mhz <= '1';
      wait for c_CLK_100MHZ_PERIOD / 2;

    end loop;
    wait;                              

  end process p_clk_gen;
  
  p_reset_gen : process is    --reset signal generation
  begin

    sig_rst <= '0';
    wait for 10 ns;

    sig_rst <= '1';
    wait for 70 ns;

    sig_rst <= '0';

    wait;

  end process p_reset_gen;

  p_stimulus : process is
  begin

    report "Stimulus process started";

    go <= "0010";
    pause <= "0001";
    rounds <= "0001";
    
    report "Stimulus process finished";
    wait;

  end process p_stimulus;

end architecture testbench;