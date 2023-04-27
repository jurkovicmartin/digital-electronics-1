library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--enable signal shoud be 1s to work properly
entity countdown is
  port (
    clk    : in    std_logic; -- main clock
    rst    : in    std_logic; -- reset
    en     : in    std_logic; -- enable input
    start10  : in std_logic_vector(3 downto 0); --start value for x0x s
    start100 : in std_logic_vector(3 downto 0); --start value for 0xx s
    seconds : out std_logic_vector(3 downto 0);      --value xx0
    tens : out std_logic_vector(3 downto 0);	     --value x0x
    hunderets : out std_logic_vector(3 downto 0)     --value 0xx
    );
end countdown;

architecture Behavioral of countdown is
  
signal cnt1 : unsigned(3 downto 0);   --to count seconds
signal cnt10 : unsigned(3 downto 0);  --to count 10s of seconds
signal cnt100 : unsigned(3 downto 0); --to count 100s of seconds

begin

  p_countdown : process (clk) is
  begin

    if rising_edge(clk) then
      if (rst = '1') then              --reset
        cnt1 <= "0000";		       --set starting value xx0
        cnt10 <= unsigned(start10);    --set starting value x0x
        cnt100 <= unsigned(start100);  --set starting value 0xx
      elsif (en = '1') then 
      
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