library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        A : in std_logic_vector(3 downto 0); -- Input A
        B : in std_logic_vector(3 downto 0); -- Input B
        OP : in std_logic_vector(3 downto 0); -- Opcode
        R : out std_logic_vector(3 downto 0); -- Result
    );
end ALU;

architecture behavior of ALU is
begin
    process(A, B, OP)
    begin
        case OP is :
            when "0000" => -- ADD
                RESULT <= A + B;
            when "0001" => -- OR
                RESULT <= A or B;
            when "0010" => -- SHR
                RESULT <= std_logic_vector(unsigned(A) srl unsigned(B));
            when "0011" => -- SHL
                RESULT <= std_logic_vector(unsigned(A) sll unsigned(B));
            when "0100" => -- XOR
                RESULT <= A xor B;
            when "0101" => -- AND
                RESULT <= A and B;
            when "0110" => -- SUB
                RESULT <= A - B;
            when "0111" => -- CMP
                if (A=B) then
                    RESULT <= x"01";
                else
                    RESULT <= x"00";
                end if;
            when others => 
                RESULT <= x"00";
        end case;
    end process;
    
end architecture behavior;