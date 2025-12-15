library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity MPG is
  port (
    btn : in std_logic := '0';
    clk : in std_logic;
    debounced : out std_logic := '0'
  );
end MPG;

architecture Behavioral of MPG is

  signal cnt : integer := 0;
  signal Q1 : std_logic := '0';
  signal Q2 : std_logic := '0';
  signal Q3 : std_logic := '0';
begin
  process (clk)
  begin
    if rising_edge(clk) then

      cnt <= cnt + 1;
      if cnt = 5 then --65536
        cnt <= 1;
      end if;
    end if;
  end process;

  process (btn, clk)
  begin
    if rising_edge(clk) then
 if cnt = 4 then --65535
        Q1 <= btn;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      Q2 <= Q1;
      Q3 <= Q2;
    end if;

    debounced <= not Q3 and Q2;

  end process;

end Behavioral;