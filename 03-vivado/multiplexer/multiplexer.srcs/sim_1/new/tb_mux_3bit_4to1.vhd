library ieee;
  use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------

entity tb_mux_3bit_4to1 is
  -- Entity of testbench is always empty
end entity tb_mux_3bit_4to1;

------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------

architecture testbench of tb_mux_3bit_4to1 is

  -- Testbench local signals
  signal sig_a           : std_logic_vector(2 downto 0);
  signal sig_b           : std_logic_vector(2 downto 0);
  signal sig_c           : std_logic_vector(2 downto 0);
  signal sig_d           : std_logic_vector(2 downto 0);
  signal sig_sel           : std_logic_vector(1 downto 0);
  signal sig_f           : std_logic_vector(2 downto 0);

begin

  -- Connecting testbench signals with comparator_4bit
  -- entity (Unit Under Test)
  uut_mux_3bit_4to1 : entity work.mux_3bit_4to1
    port map (
      a_i           => sig_a,
      b_i           => sig_b,
      c_i           => sig_c,
      d_i           => sig_d,
      sel_i         => sig_sel,
      f_o           => sig_f

    );

  --------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------
  p_stimulus : process is
  begin

    -- Report a note at the beginning of stimulus process
    report "Stimulus process started";
    
    sig_a <= "001";
    sig_b <= "010";
    sig_c <= "011";
    sig_d <= "100";
    -- First test case ...
    sig_sel <= "00";
    wait for 100 ns;
    -- ... and its expected outputs
    assert (
            (sig_f = sig_a)
        )
      -- If false, then report an error
      -- If true, then do not report anything
      report "Error"
      severity error;
      
      sig_sel <= "01";
    wait for 100 ns;
    -- ... and its expected outputs
    assert (
            (sig_f = sig_b)
        )
      -- If false, then report an error
      -- If true, then do not report anything
      report "Error"
      severity error;
      
      sig_sel <= "10";
    wait for 100 ns;
    -- ... and its expected outputs
    assert (
            (sig_f = sig_c)
        )
      -- If false, then report an error
      -- If true, then do not report anything
      report "Error"
      severity error;
      
      sig_sel <= "11";
    wait for 100 ns;
    -- ... and its expected outputs
    assert (
            (sig_f = sig_d)
        )
      -- If false, then report an error
      -- If true, then do not report anything
      report "Error"
      severity error;

    -- Report a note at the end of stimulus process
    report "Stimulus process finished";

    wait; -- Data generation process is suspended forever

  end process p_stimulus;

end architecture testbench;