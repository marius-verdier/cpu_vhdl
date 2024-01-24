library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_decoder is
    port (
        instruction : in std_logic_vector(15 downto 0);
        alu_opcode : out std_logic_vector(3 downto 0);
        alu_a_address : out std_logic_vector(3 downto 0);
        alu_b_address : out std_logic_vector(3 downto 0);
        register_write_enable : out std_logic;
    );
end instruction_decoder;

architecture behavior of instruction_decoder is

begin
    process (instruction)
    begin
        alu_opcode <= instruction(15 downto 12);
        alu_a_address <= instruction(11 downto 8);
        alu_b_address <= instruction(7 downto 4);
    end process;

end behavior;