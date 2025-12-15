
library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;

entity video_signal is
  port (Enable : in  STD_LOGIC;
        Rst    : in  STD_LOGIC;
        CLK    : in  STD_LOGIC;
        Vpos   : out STD_LOGIC_VECTOR(11 downto 0);
        Hpos   : out STD_LOGIC_VECTOR(11 downto 0);
        hsync : out std_logic;
        vsync : out STD_LOGIC;
        ok_video : out std_logic);
end entity;

architecture Behavioral of video_signal is
  signal hpos_aux : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
  signal vpos_aux : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
  constant HD  : integer := 1279; --Zona display
  constant HFP : integer := 110;  --Front porch(partea moarta din dreapta)
  constant HS  : integer := 40;   -- Semnal H_Sync = 0
  constant HBP : integer := 220;  --Back Porch

  constant VBP   : integer := 20;  --Back Porch
  constant VFP   : integer := 5;   --Front Porch
  constant VD    : integer := 719; --Partea de display
  constant VS    : integer := 5;   --sync

begin

  process (Enable, Rst, CLK)
  begin

    if Rst = '1' then
      hpos_aux <= (others => '0');
      vpos_aux <= (others => '0');
    end if;

    if rising_edge(CLK) then
      if Enable = '1' and Rst = '0' then
        if hpos_aux = (HD + HFP + HS + HBP) then
            hpos_aux <= (others => '0');
            vpos_aux <= vpos_aux + 1;
          else
            hpos_aux <= hpos_aux + 1;
        end if;
        
        if vpos_aux = (VD + VBP + VFP + VS) then
            vpos_aux <= (others => '0');
        end if;
        
        if hpos_aux >= HD + HFP and hpos_aux <= HD + HFP + HS then
          Hsync <= '0';
        else
          Hsync <= '1';
        end if;
        if vpos_aux >= VD + VFP and vpos_aux <= VD + VFP + VS then
          Vsync <= '0';
        else
          Vsync <= '1';
        end if;
        
        if Hpos_aux <= HD and vpos_aux <= VD then
          ok_video <= '1';
        else
          ok_video <= '0';
        end if;
      end if;
      hpos <= hpos_aux;
      vpos <= vpos_aux;
    end if;

  end process;

end architecture;
