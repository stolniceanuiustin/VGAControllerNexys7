library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ROM_Color is
    Port (
        Adr_Color    : in STD_LOGIC_VECTOR(1 downto 0);
        Enable_Color : in STD_LOGIC;
        R            : out STD_LOGIC_VECTOR(3 downto 0);
        G            : out STD_LOGIC_VECTOR(3 downto 0);
        B            : out STD_LOGIC_VECTOR(3 downto 0)
    );
end ROM_Color;

architecture Behavioral of ROM_Color is
    signal R0 : STD_LOGIC_VECTOR(3 downto 0) := "1111";
    signal R1 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal R2 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal R3 : STD_LOGIC_VECTOR(3 downto 0) := "1111";
    signal G0 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal G1 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal G2 : STD_LOGIC_VECTOR(3 downto 0) := "1111";
    signal G3 : STD_LOGIC_VECTOR(3 downto 0) := "1111";
    signal B0 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal B1 : STD_LOGIC_VECTOR(3 downto 0) := "1111";
    signal B2 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal B3 : STD_LOGIC_VECTOR(3 downto 0) := "1111";
begin
    process(Enable_Color, Adr_Color)
    begin
        if Enable_Color = '1' then
            case Adr_Color is
                when "00" => 
                    R <= R0;
                    G <= G0;
                    B <= B0;
                when "01" => 
                    R <= R1;
                    G <= G1;
                    B <= B1;
                when "10" => 
                    R <= R2;
                    G <= G2;
                    B <= B2;
                when "11" => 
                    R <= R3;
                    G <= G3;
                    B <= B3;
                when others =>
                    R <= (others => '0'); -- Default values if address is invalid
                    G <= (others => '0');
                    B <= (others => '0');
            end case;
        else
            R <= (others => '0'); -- Outputs all zeros when Enable_Color is '0'
            G <= (others => '0');
            B <= (others => '0');
        end if;
    end process;
end Behavioral;