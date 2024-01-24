library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        A : in std_logic_vector(15 downto 0); -- Input A
        B : in std_logic_vector(15 downto 0); -- Input B
        OP : in std_logic_vector(3 downto 0); -- Opcode
        Y : out std_logic_vector(15 downto 0); -- Result
        Z : out std_logic -- Zero flag
    );
end ALU;

architecture behavior of ALU is
signal RESULT : std_logic_vector(15 downto 0);
begin
    process(A, B, OP)
    begin
        case OP is
            when "0000" => -- ADD
                RESULT <= A + B;
            when "0001" => -- OR
                RESULT <= A or B;
            when "0010" => -- SHR
                RESULT <= std_logic_vector(unsigned(A) srl 1);
            when "0011" => -- SHL
                RESULT <= std_logic_vector(unsigned(A) sll 1);
            when "0100" => -- XOR
                RESULT <= A xor B;
            when "0101" => -- AND
                RESULT <= A and B;
            when "0110" => -- SUB
                RESULT <= A - B;
            when "0111" => -- CMP
                if (A=B) then
                    RESULT <= x"0001";
                else
                    RESULT <= x"0000";
                end if;
            when "1000" => -- NOT
                RESULT <= not A;
            when others => 
                RESULT <= x"0000";
        end case;
    end process;
	 Y <= RESULT;
    Z <= '1' when (RESULT = x"0000") else '0';
    
end architecture behavior;