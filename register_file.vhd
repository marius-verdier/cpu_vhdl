library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity register_file is -- Register File
    port (
        reset : in std_logic;
        clock : in std_logic;
        write_enable : in std_logic;

        address : in std_logic_vector(2 downto 0);
        data_in : in std_logic_vector(15 downto 0);

        addressA : in std_logic_vector(2 downto 0);
        data_outA : out std_logic_vector(15 downto 0);

        addressB : in std_logic_vector(2 downto 0);
        data_outB : out std_logic_vector(15 downto 0)
    )
end register_file;

architecture behavior of register_file is

type register_type is array (0 to 7) of std_logic_vector(15 downto 0);
signal registers : register_type;

begin
    process(clock, reset)
    begin
        if (reset = '1') then
            for i in 0 to 7 loop
                registers(i) <= (others => '0');
            end loop;
        elsif rising_edge(clock) then
            if (write_enable = '1') then
                registers(to_integer(unsigned(address))) <= data_in;
            end if;
        end if;
    end process;
            
    data_outA <= x"0000" if addressA = "000" else registers(to_integer(unsigned(addressA)));
    data_outB <= x"0000" if addressB = "000" else registers(to_integer(unsigned(addressB)));

end architecture behavior;

