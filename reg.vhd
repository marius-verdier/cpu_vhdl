library ieee;

use IEEE.std_logic_1164.all;

entity reg is
    port (
       signal data_in: in std_logic_vector(15 downto 0); 
       signal clk: in std_logic;
       signal write: in std_logic;
       signal rst: in std_logic;
       signal data_out: out std_logic_vector(15 downto 0)
    );
end entity reg;

architecture behavioral of reg is
    
begin
    access_reg: process(rst, clk)
    begin
        if rst='1' then
            
        else
            
        end if;
    end process
    
    
end architecture behavioral;