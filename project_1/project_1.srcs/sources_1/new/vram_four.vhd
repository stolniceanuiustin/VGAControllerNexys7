library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.numeric_std.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;

entity VRAM_four is --primeste pixel clock
  port (hpos         : in  STD_LOGIC_VECTOR(11 downto 0);
        vpos         : in  STD_LOGIC_VECTOR(11 downto 0);
        shift_up     : in  STD_LOGIC;
        shift_down   : in  STD_LOGIC;
        shift_right  : in  STD_LOGIC;
        shift_left   : in  STD_LOGIC;
        pixel        : out STD_LOGIC;
        clk          : in  std_logic;
        enable       : in  std_logic;
        enable_video : in  std_logic;
        rst          : in  STD_LOGIC
       );
end vram_four;

architecture Behavioral of vram_four is
  --impartim pixel_clock-ul la 8 apoi cu un divizor la 16
  type RAM_ARRAY is array (0 to 45) of STD_LOGIC_VECTOR(80 downto 0); --memory(240)(320) e temporar -- imagine de 45x80, factor de scalare de 16
  signal memory  : RAM_ARRAY;
  signal aux_bit : STD_LOGIC;
  signal divizor : STD_LOGIC;
  constant H_SIze : integer := 79;
  constant V_Size : integer := 44;
  signal i_aux     : STD_LOGIC_VECTOR(11 downto 0);
  signal j_aux     : STD_LOGIC_VECTOR(11 downto 0);
begin
  i_aux   <= (others => '0');
  j_aux   <= (others => '0');
  divizor <= '1';

  draw_initial_image: process (enable, rst, clk)
    variable i             : integer := 0;
    variable j             : integer := 0;
    variable t             : integer := 0;
    variable k             : integer := 0;
    variable lower_bound_i : integer := 10;
    variable upper_bound_i : integer := 30;
    variable lower_bound_j : integer := 20;
    variable upper_bound_j : integer := 60;
  begin
    if rst = '1' or enable ='0'  then
      memory <= (others => (others => '0'));
      lower_bound_i := 10;
      upper_bound_i := 30;
      lower_bound_j := 20;
      upper_bound_j := 60;
      i := 0;
      j := 0;
    elsif rising_edge(clk) then
      if rst = '0' and enable = '1' and enable_video = '1' then
        if j < H_SIze then
            j := j + 2;
        end if;
        if j >= H_SIze then
            j := 0;
            if i < V_size then
              i := i + 2;
            else
              i := 0;
            end if;
        end if;
        if i > lower_bound_i and i < upper_bound_i and j > lower_bound_j and j < upper_bound_j then
          memory(i)(j) <= '1';
        else
          memory(i)(j) <= '0';
        end if;
        if shift_down = '1' then
          if lower_bound_j > 0 then
            lower_bound_j := lower_bound_j - 1;
            upper_bound_j := upper_bound_j - 1;
          end if;
        end if;

        if shift_up = '1' then
          if upper_bound_j < H_Size then
            lower_bound_j := lower_bound_j + 1;
            upper_bound_j := upper_bound_j + 1;
          end if;
        end if;

        if shift_left = '1' then
          if lower_bound_i > 0 then
            lower_bound_i := lower_bound_i - 1;
            upper_bound_i := upper_bound_i - 1;
          end if;
        end if;

        if shift_right = '1' then
          if upper_bound_i < V_Size then
            lower_bound_i := lower_bound_i + 1;
            upper_bound_i := upper_bound_i + 1;
          end if;
        end if;

      end if;
    end if;
  end process;

  get_pixel: process (hpos, vpos, clk, enable, rst, enable_video)
  begin
    if enable_video = '1' and enable = '1' and rst = '0' and rising_edge(clk) then
      pixel <= memory(to_integer(unsigned(vpos)) / 16)(to_integer(unsigned(hpos)) / 16);
    end if;

  end process;
end architecture;


