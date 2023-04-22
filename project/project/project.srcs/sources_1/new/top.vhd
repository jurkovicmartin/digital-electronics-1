library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           CA        : out STD_LOGIC;
           CB        : out STD_LOGIC;
           CC        : out STD_LOGIC;
           CD        : out STD_LOGIC;
           CE        : out STD_LOGIC;
           CF        : out STD_LOGIC;
           CG        : out STD_LOGIC;
           DP        : out STD_LOGIC;
           AN        : out STD_LOGIC_VECTOR (7 downto 0);
           BTNC      : in STD_LOGIC;
           SW        : in STD_LOGIC_VECTOR (11 downto 0));
end top;

----------------------------------------------------------
-- Architecture body for top level
----------------------------------------------------------

architecture behavioral of top is

    signal sig_indicator : std_logic_vector(3 downto 0);
    signal sig_first : std_logic_vector(3 downto 0);
    signal sig_second : std_logic_vector(3 downto 0);
    signal sig_third : std_logic_vector(3 downto 0);
    

begin

 timer : entity work.timer
    port map (
      clck      => CLK100MHZ,
      rst => BTNC,
      goDelay => SW (3 downto 0),
      pauseDelay => SW (7 downto 4),
      rounds => SW (11 downto 8),
      indicator => sig_indicator,
      firstDigit => sig_first,
      secondDigit => sig_second,
      thirdDigit => sig_third
    );
      
  driver_7seg_4digits : entity work.driver_7seg_4digits
      port map(
            clk => CLK100MHZ,    
            rst => BTNC,     
            data0 => sig_first,   
            data1 => sig_second,   
            data2 => sig_third,   
            data3 => sig_indicator,   
            dp_vect => "1111", 
            dp => DP,      
            seg(6) => CA,
            seg(5) => CB,
            seg(4) => CC,
            seg(3) => CD,
            seg(2) => CE,
            seg(1) => CF,
            seg(0) => CG,    
            dig(3 downto 0) => AN(3 downto 0)
      );
    --AN(7 downto 4) <= "1111";
    AN(7 downto 4) <= b"1111";
  --------------------------------------------------------
  -- Other settings
  --------------------------------------------------------
  -- Connect one common anode to 3.3V

end architecture behavioral;