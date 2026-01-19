library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity mac is
    generic (input_data_width : natural :=24;
             SIGNED_UNSIGNED : string := "unsigned");
    Port ( clk_i : in std_logic;
           u_i : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           b_i : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           prev_block_i : in STD_LOGIC_VECTOR (2*input_data_width-1 downto 0);
           block_o : out STD_LOGIC_VECTOR (2*input_data_width-1 downto 0));
end mac;

architecture Behavioral of mac is
    --signal reg_b : STD_LOGIC_VECTOR (input_data_width - 1 downto 0);
    signal reg_u : STD_LOGIC_VECTOR (input_data_width - 1 downto 0):=(others=>'0');
    signal reg_s : STD_LOGIC_VECTOR (2*input_data_width-1 downto 0):=(others=>'0');
    signal reg_m : STD_LOGIC_VECTOR (2*input_data_width-1 downto 0):=(others=>'0');
    signal reg_p : STD_LOGIC_VECTOR (2*input_data_width-1 downto 0):=(others=>'0');
    
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";
begin
    process(clk_i)
    begin
        if (clk_i'event and clk_i = '1')then
            reg_s <= prev_block_i;
            reg_u <= u_i;
            
            if (SIGNED_UNSIGNED = "signed") then
                reg_m <= std_logic_vector(signed(reg_u) * signed(b_i));
            else
                reg_m <= std_logic_vector(unsigned(reg_u) * unsigned(b_i));
            end if;
            
            if (SIGNED_UNSIGNED = "signed") then
                reg_p <= std_logic_vector(signed(reg_m) + signed(reg_s));
            else
                reg_p <= std_logic_vector(unsigned(reg_m) + unsigned(reg_s));
            end if;
            
        end if;
    end process;
    
    block_o <= reg_p;
    
end Behavioral;