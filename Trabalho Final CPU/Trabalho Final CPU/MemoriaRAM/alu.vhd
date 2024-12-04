library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY alu IS -- ALU
    
	 PORT (
        a        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Operando A (8 bits)
        b        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Operando B (8 bits)
        alu_ctrl : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- Controle da operação (3 bits)
        result   : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);  -- result_parcado da operação (8 bits)
        zero     : OUT STD_LOGIC;								-- Flag Zero (indica se o result_parcado é zero)
		  sign     : OUT STD_LOGIC);
END;

ARCHITECTURE BEHAVE OF alu IS

	SIGNAL zero_flag, sign_flag : STD_LOGIC;
	SIGNAL result_parc : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
    
	 PROCESS (a, b, alu_ctrl)
    
	 BEGIN
        CASE alu_ctrl IS
            
				WHEN "010" => result_parc <= a + b; -- add
								   if a="00000000" and b=a then
										zero_flag <='1';
									else
										zero_flag <='0';
									end if;
            WHEN "110" => result_parc <= a - b; -- sub
								  if a = b then
								    zero_flag <= '1';
								  else
								   zero_flag <= '0';
								  end if;
            WHEN "000" => result_parc <= a AND b; -- AND
									if a="00000000" or b="00000000" then
										zero_flag<='1';
									else
										zero_flag<='0';
									end if;
            WHEN "001" => result_parc <= a OR b; -- OR
								   if a="00000000" and b=a then
										zero_flag <='1';
									else
										zero_flag <='0';
									end if;
            WHEN "111" => result_parc <= NOT a; -- NOT 
									if a="11111111" then
										zero_flag <='1';
									else
										zero_flag <='0';
									end if;
            WHEN OTHERS => result_parc <= (others => 'X');  -- Valor indefinido
        
		  END CASE;
		  
		  IF alu_ctrl = "110" AND b > a THEN
					sign_flag <= '1';
			
		  ELSE
					sign_flag <= '0';
		  END IF;
       
    
	 END PROCESS;
	 zero <= zero_flag;
	 sign <= sign_flag;
	 result <= result_parc;
END;
