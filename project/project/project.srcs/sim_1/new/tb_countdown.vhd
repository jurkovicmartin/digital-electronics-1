library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------

entity tb_countdown is
  -- Entity of testbench is always empty
end entity tb_countdown;

------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------

architecture testbench of tb_countdown is

  constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

  -- Local signals
  signal sig_clk_100mhz : std_logic;
  signal sig_rst        : std_logic;
  signal sig_en         : std_logic;
  signal sig_first      : std_logic_vector(3 downto 0);
  signal sig_second      : std_logic_vector(3 downto 0);
  signal sig_third      : std_logic_vector(3 downto 0);
  signal sig_10      : std_logic_vector(3 downto 0);
  signal sig_100      : std_logic_vector(3 downto 0);
  
begin

  uut_cnt : entity work.countdown
    port map (
      clk    => sig_clk_100mhz,
      rst    => sig_rst,
      en     => sig_en,
      seconds  => sig_first,
      tens    => sig_second,
      hunderets => sig_third,
      start10 => sig_10,
      start100 => sig_100
    );

  --------------------------------------------------------
  -- Clock generation process
  --------------------------------------------------------
  p_clk_gen : process is
  begin

    while now < 1000 ns loop   

      sig_clk_100mhz <= '0';
      wait for c_CLK_100MHZ_PERIOD / 2;
      sig_clk_100mhz <= '1';
      wait for c_CLK_100MHZ_PERIOD / 2;

    end loop;
    wait;     

  end process p_clk_gen;

  --------------------------------------------------------
  -- Reset generation process
  --------------------------------------------------------
  p_reset_gen : process is
  begin

    sig_rst <= '0';
    wait for 10 ns;

    -- Reset activated
    sig_rst <= '1';
    wait for 70 ns;

    -- Reset deactivated
    sig_rst <= '0';

    wait;

  end process p_reset_gen;

  --------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------
  p_stimulus : process is
  begin

    report "Stimulus process started";
	
    sig_10 <= "0100";
    sig_100 <= "0001";

    sig_en <= '1';

    report "Stimulus process finished";
    wait;

  end process p_stimulus;

end architecture testbench;