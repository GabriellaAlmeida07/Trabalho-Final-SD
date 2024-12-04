library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Declaração da entidade do comparador
ENTITY cmp_8bit IS
    PORT (
        reg1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Primeiro número de entrada
        reg2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Segundo número de entrada
        zero : BUFFER STD_LOGIC;                -- Sinal: num1 é maior que num2
        sign : BUFFER STD_LOGIC                    -- Sinal: num1 é menor que num2
    );
END ENTITY cmp_8bit;

-- Implementação do comparador
ARCHITECTURE Behavioral OF cmp_8bit IS
BEGIN
    PROCESS (reg1, reg2)
    BEGIN
        
		  IF reg1 = reg2 THEN
            zero <= '0';
            sign <= '0';        
		  
			ELSIF reg1 < reg2 THEN
            zero <= '0';
            sign <= '1';
        ELSE
            zero <= '1';
            sign <= '0';
        END IF;
    END PROCESS;
END ARCHITECTURE Behavioral;