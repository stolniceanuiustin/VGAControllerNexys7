----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2024 07:27:46 PM
-- Design Name: 
-- Module Name: testbrench - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbrench2 is
--  Port ( );
end testbrench2;

architecture Behavioral of testbrench2 is
component VRAM_TWO is --primeste pixel clock
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
end component;
component vram_four is --primeste pixel clock
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
end component;
component ROM_Color is
    Port (
        Adr_Color    : in STD_LOGIC_VECTOR(1 downto 0);
        Enable_Color : in STD_LOGIC;
        R            : out STD_LOGIC_VECTOR(3 downto 0);
        G            : out STD_LOGIC_VECTOR(3 downto 0);
        B            : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;
component VRAM_1 is --primeste pixel clock
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
end component;
component VRAM_three is --primeste pixel clock
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
end component;
component video_signal is
  port (Enable : in  STD_LOGIC;
        Rst    : in  STD_LOGIC;
        CLK    : in  STD_LOGIC;
        Vpos   : out STD_LOGIC_VECTOR(11 downto 0);
        Hpos   : out STD_LOGIC_VECTOR(11 downto 0);
        hsync : out std_logic;
        vsync : out STD_LOGIC;
        ok_video : out std_logic);
end component;
component UnitateControl1 is
    Port ( CLK : in STD_LOGIC;
           Reset: in STD_LOGIC;
           shift_up_nompg : in STD_LOGIC;
           shift_down_nompg : in STD_LOGIC;
           shift_left_nompg : in STD_LOGIC;
           shift_right_nompg : in STD_LOGIC;
           IMGSelect : in STD_LOGIC_VECTOR (1 downto 0);
           CLRSelect : in STD_LOGIC_VECTOR (1 downto 0);
           ALEGE_IMG : out STD_LOGIC;
           ALEGE_CLR : out STD_LOGIC;
           AFISARE : out STD_LOGIC;
           imgok : in STD_LOGIC;
           clrok : in STD_LOGIC;
           incepe : in STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           R : out STD_LOGIC_VECTOR(3 downto 0);
           G : out STD_LOGIC_VECTOR(3 downto 0);
           B : out STD_LOGIC_VECTOR(3 downto 0));
end component;


signal adr_colort : STD_LOGIC_VECTOR(1 downto 0);
signal enablet : STD_LOGIC;
signal hsynct : STD_LOGIC;
signal vsynct : STD_LOGIC;
signal rstt : STD_LOGIC;
signal CLK_tb : STD_LOGIC;
signal shift_upt, shift_downt, shift_leftt, shift_rightt : STD_LOGIC;
signal Rt : STD_LOGIC_VECTOR(3 downto 0);
signal Gt : STD_LOGIC_VECTOR(3 downto 0);
signal Bt : STD_LOGIC_VECTOR(3 downto 0);
signal alege_imgt, alege_clrt : STD_LOGIC;
signal btnc : STD_LOGIC;

signal  imgselectt : STD_LOGIC_VECTOR(1 downto 0);
signal clrselectt : STD_LOGIC_VECTOR(1 downto 0);
signal imgokt, clrokt : STD_LOGIC;
signal incepet : STD_LOGIC;
begin
clkprocess: process
  begin
    clk_tb <= '1';
    wait for 20 ns;
    clk_tb <= '0';
    wait for 20 ns;
  end process;

controlunit: UnitateControl1 
 port map (clk => clk_tb,
           Reset => rstt,
           shift_up_nompg => shift_upt,
           shift_down_nompg => shift_downt,
           shift_left_nompg => shift_leftt,
           shift_right_nompg => shift_rightt,
           IMGSelect => imgselectt,
           CLRSelect => clrselectt,
           ALEGE_IMG => alege_imgt,
           ALEGE_CLR => alege_clrt,
           imgok => imgokt,
           clrok => clrokt,
           incepe => incepet,
           hsync => hsynct,
           vsync => vsynct,
           R => Rt,
           G => Gt,
           B => Bt);
              
main_process: process
begin
        shift_upt <= '0';
        shift_downt <= '0';
        shift_leftt <= '0';
        shift_rightt <= '0';
        imgokt <= '0';
        clrokt <= '0';
        rstt <= '0';
        incepet<='0';
        wait for 100 ns;
        incepet<='1';
        wait for 100 ns;
        incepet<='0';
        
        imgselectt<="00";
        --btnc_tb<='0';
        wait for 20ns;
        imgokt<='1';
        wait for 100ns;
        imgokt<='0';
        clrselectt<="10";
        wait for 20ns;
        clrokt <='1';
        wait for 100ns;
        clrokt <='0';
        wait for 100ms;
        rstt<='1';
        wait for 100ns;
        rstt<='0';
    wait;
end process;
end Behavioral;
