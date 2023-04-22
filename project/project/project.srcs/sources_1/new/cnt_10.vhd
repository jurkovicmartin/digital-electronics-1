----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2023 01:50:20 PM
-- Design Name: 
-- Module Name: cnt_10 - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cnt_10 is
generic (
    g_CNT_WIDTH : natural := 4 --! Default number of counter bits
  );
  port (
    clk    : in    std_logic; --! Main clock
    rst    : in    std_logic; --! Synchronous reset
    en     : in    std_logic; --! Enable input
    start  : in	   std_logic_vector(3 downto 0);
    cnt    : out   std_logic_vector(g_CNT_WIDTH - 1 downto 0) --! Counter value
  );
end cnt_10;

architecture Behavioral of cnt_10 is
  signal sig_cnt : unsigned(g_CNT_WIDTH - 1 downto 0) := (others => '0'); --! Local counter

begin

  p_cnt_10 : process (clk) is
  begin

    if rising_edge(clk) then
      if (rst = '1') then           -- Synchronous reset
        sig_cnt <= UNSIGNED(start); -- Set start for counting
      elsif (en = '1') then         -- Test if counter is enabled
      
          sig_cnt <= sig_cnt - 1;
          if(sig_cnt = 0) then
            sig_cnt <= "1001";
          end if;
      end if;
    end if;

  end process p_cnt_10;

  -- Output must be retyped from "unsigned" to "std_logic_vector"
  cnt <= std_logic_vector(sig_cnt);



end Behavioral;

