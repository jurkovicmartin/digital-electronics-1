library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity countdown is
  port (
    clk    : in    std_logic; --! Main clock
    rst    : in    std_logic;
    en     : in    std_logic; --! Enable input
    start10  : in	   std_logic_vector(3 downto 0);
    start100 : in	   std_logic_vector(3 downto 0);
    seconds : out std_logic_vector(3 downto 0);
    tens : out std_logic_vector(3 downto 0);
    hunderets : out std_logic_vector(3 downto 0)
    );
end countdown;

architecture Behavioral of countdown is
  
signal cnt1 : unsigned(3 downto 0);
signal cnt10 : unsigned(3 downto 0);
signal cnt100 : unsigned(3 downto 0);

begin

  p_countdown : process (clk) is
  begin

    if rising_edge(clk) then
      if (rst = '1') then           -- Synchronous reset
        cnt1 <= "0000";
        cnt10 <= unsigned(start10);
        cnt100 <= unsigned(start100);
      elsif (en = '1') then         -- Test if counter is enabled
      
      
        if(cnt10 = "0000" and cnt1 = "0000") then
            cnt1 <= "1001";
        	cnt10 <= "1001";
            cnt100 <= cnt100 - 1;
        elsif (cnt1 = "0000") then
        	cnt1 <= "1001";
            cnt10 <= cnt10 - 1;
        else
            cnt1 <= cnt1 - 1;
        end if;
 
        
      end if;
    end if;

  end process p_countdown;

  -- Output must be retyped from "unsigned" to "std_logic_vector"
  seconds <= std_logic_vector(cnt1);
  tens <= std_logic_vector(cnt10);
  hunderets <= std_logic_vector(cnt100);

end Behavioral;
