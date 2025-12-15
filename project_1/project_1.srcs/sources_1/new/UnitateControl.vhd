library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UnitateControl1 is
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
end UnitateControl1;

architecture Behavioral of UnitateControl1 is


signal Img_UE : STD_LOGIC_VECTOR (1 downto 0);
signal CLR_UE : STD_LOGIC_VECTOR (1 downto 0);
signal enable_vram : STD_LOGIC;
signal BTNC : STD_LOGIC;
signal pixel_clk : STD_LOGIC;
signal enable_signal : STD_LOGIC;
signal vpos : STD_LOGIC_VECTOR(11 downto 0);
signal hpos : STD_LOGIC_VECTOR(11 downto 0);

signal START, IMG_ok, CLR_ok : STD_LOGIC ;
signal locked_debug : STD_LOGIC;
signal Shift_UP, shift_down ,shift_left, shift_right : STD_LOGIC;
signal pixel_final, pixel_1, pixel_2, pixel_3, pixel_4 : STD_LOGIC;
signal R_inside, B_inside, G_inside : STD_LOGIC_VECTOR(3 downto 0);

component MPG is
  port (
    btn : in std_logic := '0';
    clk : in std_logic;
    debounced : out std_logic := '0'
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
component clk_wiz_0
    port (
      clk_in1  : in  std_logic;
      clk_out1 : out std_logic;
      reset    : in  std_logic;
      locked   : out std_logic
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

component VRAM_four is --primeste pixel clock
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

type stare_t is (Astept, AsteptIMG, AsteptCLR, AfisareImagine);
signal Stare, Nx_Stare : stare_t;

begin

    debouncer1: MPG port map(btn => shift_up_nompg, clk => clk, debounced => shift_up);
    debouncer2: MPG port map(btn => shift_left_nompg, clk => clk, debounced => shift_left);
    debouncer3: MPG port map(btn => shift_right_nompg, clk => clk, debounced => shift_right);
    debouncer4: MPG port map(btn => shift_down_nompg, clk => clk, debounced => shift_down);
    clock_divider: clk_wiz_0 
    port map(clk_in1 => clk,
             clk_out1 => pixel_clk,
             reset => reset,
             locked => locked_debug);
    
    act_stare : process(CLK, Reset)
    begin
        if Reset = '1' then
            Stare <= Astept;
        elsif CLK'event and CLK = '1' then
            Stare <= Nx_Stare;
        end if;
    end process;
    
    video_signal_portmap: 
    video_signal
    port map(Enable => enable_signal,
        Rst => reset,
        CLK => pixel_clk,
        Vpos => vpos,
        Hpos => hpos,
        hsync => hsync,
        vsync => vsync,
        ok_video => enable_vram);
      
    vram111: VRAM_1
port map(hpos => hpos,
         vpos => vpos,
         shift_up => shift_up,
         shift_down => shift_down,
         shift_left => shift_left,
         shift_right => shift_right,
         pixel => pixel_1,
         clk => pixel_clk,
         enable => enable_signal,
         enable_video => enable_vram,
         rst => reset);
vram2: vram_two
port map(hpos => hpos,
         vpos => vpos,
         shift_up => shift_up,
         shift_down => shift_down,
         shift_left => shift_left,
         shift_right => shift_right,
         pixel => pixel_2,
         clk => pixel_clk,
         enable => enable_signal,
         enable_video => enable_vram,
         rst => reset);
    
vram3: vram_three
port map(hpos => hpos,
         vpos => vpos,
         shift_up => shift_up,
         shift_down => shift_down,
         shift_left => shift_left,
         shift_right => shift_right,
         pixel => pixel_3,
         clk => pixel_clk,
         enable => enable_signal,
         enable_video => enable_vram,
         rst => reset);

vram4: vram_four
port map(hpos => hpos,
         vpos => vpos,
         shift_up => shift_up,
         shift_down => shift_down,
         shift_left => shift_left,
         shift_right => shift_right,
         pixel => pixel_4,
         clk => pixel_clk,
         enable => enable_signal,
         enable_video => enable_vram,
         rst => reset);

color: ROM_Color
    port map (adr_color    => clr_ue,
              Enable_color => pixel_final,
              R            => R_inside,
              G            => G_inside,
              B            => B_inside);
              

tranzitii : process(Stare, incepe, IMGok, CLRok) 
begin

    --START <='0';
    --IMG_ok<='0';
    --CLR_ok<='0';
    --ALEGE_IMG <='0';
    --ALEGE_CLR <='0';
    --Img_UE<="00";
    --clr_UE<="00";
    case Stare is
        when Astept => 
            enable_signal <= '0';
            --Start <= BTNC;
            AFISARE <= '0';
            ALEGE_IMG <='0';
            ALEGE_CLR <='0';
            if incepe = '1' then
                Nx_Stare <= AsteptIMG;
            else 
                Nx_Stare <= Astept;
            end if;
        when AsteptIMG =>
            enable_signal <= '0';
            --Start<='1';
            --IMG_ok <= BTNC;
            AFISARE <= '0';
            ALEGE_IMG <='1';
            ALEGE_CLR <='0';
            if imgok = '1' then
                img_ue<=imgselect;
                Nx_Stare <= AsteptCLR;
            else
                Nx_Stare <= AsteptIMG;
            end if;
        when AsteptCLR =>
            enable_signal <= '0';
            Img_ok<='1';
            AFISARE <= '0';
            ALEGE_IMG <='0';
            ALEGE_CLR <='1';
            if clrok = '1' then
                clr_ue<=clrselect;
                Nx_Stare <= AfisareImagine;
            else
                Nx_Stare <= AsteptCLR;
            end if;
        when AfisareImagine =>
            enable_signal <= '1';
            Nx_Stare <= AfisareImagine; 
            AFISARE <= '1';
            ALEGE_IMG <='-';
            ALEGE_CLR <='-';
            
        when Others =>
            AFISARE <= '0';
            ALEGE_IMG <='-';
            ALEGE_CLR <='-';
            Start <= BTNC;
            Nx_Stare <= Astept;
end case;
end process;

updatepixel: process(pixel_1, pixel_2, pixel_3, pixel_4, pixel_clk)
begin
    if rising_edge(pixel_clk) then
            if IMG_UE = "00" then
                pixel_final <= pixel_1;
            elsif IMG_UE = "01" then
                pixel_final <= pixel_2;
            elsif IMG_UE = "10" then
                pixel_final <= pixel_3;
            else pixel_final <= pixel_4;
            end if;
            
            if pixel_final = '1' then
                R <= R_inside;
                G <= G_inside;
                B <= B_inside;
            else 
                R <= "0000";
                G <= "0000";
                B <= "0000";
            end if;
    
    end if;
end process;

end Behavioral;
