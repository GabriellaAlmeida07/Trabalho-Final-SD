library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;  

ENTITY main_dec IS -- controlador principal 
    
	 PORT (instrucao, sw :               				IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			 reg_A,reg_B, reg_R, reg_IR:	BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);
			 reg_PC : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);
			 zero, sign:									BUFFER STD_LOGIC;
			 clk:												IN STD_LOGIC;
			 led: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END;

ARCHITECTURE BEHAVE OF main_dec IS
	
	COMPONENT alu
        PORT (
            a, b :       IN STD_LOGIC_VECTOR(7 DOWNTO 0);      
            alu_ctrl :   IN STD_LOGIC_VECTOR(2 DOWNTO 0);       
            result :     BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);   
            zero :       OUT STD_LOGIC;                         
				sign :		 OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT mem_ram 
		PORT(
				address_input: IN STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Endereço de 8 bits
				readsignal: IN STD_LOGIC; -- Leitura ativa
				writesignal: IN STD_LOGIC;  -- Escrita ativa
				memory_enable: IN STD_LOGIC;  -- Habilita memória 
				clock: IN STD_LOGIC;                 -- Sinal de clock
				dataBuf: BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0));   -- Dados de entrada/saída (8 bits)
	END COMPONENT;
	
	COMPONENT cmp_8bit
		PORT(
				reg1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
				reg2: IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
				zero : BUFFER STD_LOGIC;              
				sign : BUFFER STD_LOGIC);

	END COMPONENT;
	
	SIGNAL reg_A_signal, reg_B_signal, reg_R_signal: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL adress_signal, data_signal: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL read_sig, write_sig, enable_signal:  STD_LOGIC;
	SIGNAL ctrl : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL reg_x, reg_y: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL zero_int, sign_int : STD_LOGIC;
	
BEGIN
	
	alu1: alu PORT MAP  (reg_A_signal, reg_B_signal, ctrl, reg_R_signal, zero, sign);
		
	mem_ram1 : mem_ram PORT MAP (adress_signal, read_sig, write_sig, enable_signal, clk, data_signal);
	
	cmp_8bit1 : cmp_8bit PORT MAP (reg_A_signal, reg_B_signal, zero_int, sign_int); 
	
	reg_R <= reg_R_signal;
	
	
   PROCESS (instrucao) BEGIN
       
		 CASE instrucao (7 DOWNTO 4) IS
	
	-- Reg_signal manda para a ULA 
	
			WHEN "0000" =>  -- Add
			
			   ctrl <= "010"; 
			
				case instrucao (3 DOWNTO 0) IS 	
					when "0000" => reg_A_signal <= reg_A;
								      reg_B_signal <= reg_A;
					
					when "0001" => reg_A_signal <= reg_A;
								      reg_B_signal <= reg_B;
					
					when "0010" =>	reg_A_signal <= reg_A;
								      reg_B_signal <= reg_R;
					
					when "0011" =>	reg_A_signal <= reg_A;
								      reg_B_signal <= reg_IR;
					
					when "0100" => reg_A_signal <= reg_B;
								      reg_B_signal <= reg_A;
					
					when "0101" => reg_A_signal <= reg_B;
								      reg_B_signal <= reg_B;
					
					when "0110" =>	reg_A_signal <= reg_B;
								      reg_B_signal <= reg_R;
					
					when "0111" =>	reg_A_signal <= reg_B;
								      reg_B_signal <= reg_IR;
					
					when "1000" => reg_A_signal <= reg_R;
								      reg_B_signal <= reg_A;
					
					when "1001" => reg_A_signal <= reg_R;
								      reg_B_signal <= reg_B;
					
					when "1010" =>	reg_A_signal <= reg_R;
								      reg_B_signal <= reg_R;
					
					when "1011" => reg_A_signal <= reg_R;
								      reg_B_signal <= reg_IR;
					
					when others => reg_A_signal <= "00000000";
										reg_B_signal <= "00000000";
					
				END CASE;
				
			WHEN "0001" =>  -- SUB
			
			ctrl <= "110"; 
					
						case instrucao (3 DOWNTO 0) IS 	
							when "0000" => reg_A_signal <= reg_A;
												reg_B_signal <= reg_A;
							
							when "0001" => reg_A_signal <= reg_A;
												reg_B_signal <= reg_B;
							
							when "0010" =>	reg_A_signal <= reg_A;
												reg_B_signal <= reg_R;
							
							when "0011" =>	reg_A_signal <= reg_A;
												reg_B_signal <= reg_IR;
							
							when "0100" => reg_A_signal <= reg_B;
												reg_B_signal <= reg_A;
							
							when "0101" => reg_A_signal <= reg_B;
												reg_B_signal <= reg_B;
							
							when "0110" =>	reg_A_signal <= reg_B;
												reg_B_signal <= reg_R;
							
							when "0111" =>	reg_A_signal <= reg_B;
												reg_B_signal <= reg_IR;
							
							when "1000" => reg_A_signal <= reg_R;
												reg_B_signal <= reg_A;
							
							when "1001" => reg_A_signal <= reg_R;
												reg_B_signal <= reg_B;
							
							when "1010" =>	reg_A_signal <= reg_R;
												reg_B_signal <= reg_R;
							
							when "1011" => reg_A_signal <= reg_R;
												reg_B_signal <= reg_IR;
												
							when others => reg_A_signal <= "00000000";
												reg_B_signal <= "00000000";
						END CASE;
						
			
			WHEN "0010" =>  -- AND
			
			ctrl <= "000"; 
			
				case instrucao (3 DOWNTO 0) IS 	
					when "0000" => reg_A_signal <= reg_A;
								      reg_B_signal <= reg_A;
					
					when "0001" => reg_A_signal <= reg_A;
								      reg_B_signal <= reg_B;
					
					when "0010" =>	reg_A_signal <= reg_A;
								      reg_B_signal <= reg_R;
					
					when "0011" =>	reg_A_signal <= reg_A;
								      reg_B_signal <= reg_IR;
					
					when "0100" => reg_A_signal <= reg_B;
								      reg_B_signal <= reg_A;
					
					when "0101" => reg_A_signal <= reg_B;
								      reg_B_signal <= reg_B;
					
					when "0110" =>	reg_A_signal <= reg_B;
								      reg_B_signal <= reg_R;
					
					when "0111" =>	reg_A_signal <= reg_B;
								      reg_B_signal <= reg_IR;
					
					when "1000" => reg_A_signal <= reg_R;
								      reg_B_signal <= reg_A;
					
					when "1001" => reg_A_signal <= reg_R;
								      reg_B_signal <= reg_B;
					
					when "1010" =>	reg_A_signal <= reg_R;
								      reg_B_signal <= reg_R;
					
					when "1011" => reg_A_signal <= reg_R;
								      reg_B_signal <= reg_IR;
										
					when others => reg_A_signal <= "00000000";
										reg_B_signal <= "00000000";
										
				END CASE;
				
			
			WHEN "0011" => --CMP
			
			--crtl <= "000";
			
				CASE instrucao(3 DOWNTO 0) IS
					  
					  WHEN "0000" =>  -- Comparar reg_A com reg_A
							reg_A_signal <= reg_A;
							reg_B_signal <= reg_A;

					  WHEN "0100" =>  -- Comparar reg_A com reg_B
							reg_A_signal <= reg_A;
							reg_B_signal <= reg_B;

					  WHEN "1000" =>  -- Comparar reg_A com reg_R
							reg_A_signal <= reg_A;
							reg_B_signal <= reg_R;

					  WHEN "1100" =>  -- Comparar reg_A com reg_IR
							reg_A_signal <= reg_A;
							reg_B_signal <= reg_IR;

					  WHEN "0001" =>  -- Comparar reg_B com reg_A
							reg_A_signal <= reg_B;
							reg_B_signal <= reg_A;

					  WHEN "0101" =>  -- Comparar reg_B com reg_B
							reg_A_signal <= reg_B;
							reg_B_signal <= reg_B;

					  WHEN "1001" =>  -- Comparar reg_B com reg_R
							reg_A_signal <= reg_B;
							reg_B_signal <= reg_R;

					  WHEN "1101" =>  -- Comparar reg_B com reg_IR
							reg_A_signal <= reg_B;
							reg_B_signal <= reg_IR;

					  WHEN "0010" =>  -- Comparar reg_R com reg_A
							reg_A_signal <= reg_R;
							reg_B_signal <= reg_A;

					  WHEN "0110" =>  -- Comparar reg_R com reg_B
							reg_A_signal <= reg_R;
							reg_B_signal <= reg_B;

					  WHEN "1010" =>  -- Comparar reg_R com reg_R
							reg_A_signal <= reg_R;
							reg_B_signal <= reg_R;

					  WHEN "1110" =>  -- Comparar reg_R com reg_IR
							reg_A_signal <= reg_R;
							reg_B_signal <= reg_IR;

						WHEN OTHERS =>
							reg_A_signal <= (OTHERS => '0');
							reg_B_signal <= (OTHERS => '0');
				END CASE;
				
			WHEN "0100" =>  -- OR
		
			ctrl <= "001"; 
		
			case instrucao (3 DOWNTO 0) IS 	
				when "0000" => reg_A_signal <= reg_A;
									reg_B_signal <= reg_A;
				
				when "0001" => reg_A_signal <= reg_A;
									reg_B_signal <= reg_B;
				
				when "0010" =>	reg_A_signal <= reg_A;
									reg_B_signal <= reg_R;
				
				when "0011" =>	reg_A_signal <= reg_A;
									reg_B_signal <= reg_IR;
				
				when "0100" => reg_A_signal <= reg_B;
									reg_B_signal <= reg_A;
				
				when "0101" => reg_A_signal <= reg_B;
									reg_B_signal <= reg_B;
				
				when "0110" =>	reg_A_signal <= reg_B;
									reg_B_signal <= reg_R;
				
				when "0111" =>	reg_A_signal <= reg_B;
									reg_B_signal <= reg_IR;
				
				when "1000" => reg_A_signal <= reg_R;
									reg_B_signal <= reg_A;
				
				when "1001" => reg_A_signal <= reg_R;
									reg_B_signal <= reg_B;
				
				when "1010" =>	reg_A_signal <= reg_R;
									reg_B_signal <= reg_R;
				
				when "1011" => reg_A_signal <= reg_R;
									reg_B_signal <= reg_IR;
									
				when others => reg_A_signal <= "00000000";
									reg_B_signal <= "00000000";
									
			END CASE;
				
				
			
			WHEN "0101" =>  --NOT
		
			ctrl <= "111"; 
		
			case instrucao (3 DOWNTO 0) IS 	
				when "0000" => reg_A_signal <= reg_A;
				
				when "0001" => reg_A_signal <= reg_B;
				
				when "0010" =>	reg_A_signal <= reg_R;
				
				when "0011" =>	reg_A_signal <= reg_IR;
									
				when others => reg_A_signal <= "00000000";
									
			END CASE;
			
			WHEN "0110" =>  -- ADDI (check)
			
				ctrl <= "010"; 
			
				case instrucao (3 DOWNTO 0) IS 	
					when "0000" => reg_A_signal <= reg_A;
					
					when "0001" => reg_A_signal <= reg_B;
					
					when "0010" =>	reg_A_signal <= reg_R;
					
					when "0011" =>	reg_A_signal <= reg_IR;
					
					when others => reg_A_signal <= "00000000";
										reg_B_signal <= "00000000";										
										
				END CASE;
				
			when "0111" => -- LOAD
				enable_signal <= '1'; 
				write_sig <= '0';    
				read_sig <= '1';    
   
			case instrucao(3 DOWNTO 0) IS
				when "0000" => -- Carrega para reg_A a partir de um endereço imediato no PC
					adress_signal <= std_logic_vector(unsigned(reg_PC) + 1); -- Endereço imediato
					reg_A <= data_signal;

				when "0001" => -- Carrega para reg_A a partir do endereço armazenado em reg_B
					adress_signal <= reg_B;
					reg_A <= data_signal;

				when "0010" => -- Carrega para reg_A a partir do endereço armazenado em reg_R
					adress_signal <= reg_R;
					reg_A <= data_signal;

				when "0100" => -- Carrega para reg_B a partir do endereço armazenado em reg_A
					adress_signal <= reg_A;
					reg_B <= data_signal;

				when "0101" => -- Carrega para reg_B a partir de um endereço imediato no PC
					adress_signal <= std_logic_vector(unsigned(reg_PC) + 1); -- Endereço imediato
					reg_B <= data_signal;

				when "1000" => -- Carrega para reg_R a partir do endereço armazenado em reg_A
					adress_signal <= reg_A;
					reg_R <= data_signal;

				when others => -- Caso padrão
					reg_A <= (others => '0');
					reg_B <= (others => '0');
					reg_R <= (others => '0');
			end case;

			-- Desabilita leitura e habilitação de memória no final do ciclo
			enable_signal <= '0';
			read_sig <= '0';
			
			
			when "1000" => -- STORE
				
				enable_signal <= '1';
				write_sig <= '1';   
				read_sig <= '0';      
   
				case instrucao(3 DOWNTO 0) IS
					when "0000" => -- Armazena reg_A no endereço imediato (PC + 1)
						adress_signal <= std_logic_vector(unsigned(reg_PC) + 1);
						data_signal <= reg_A;

					when "0001" => -- Armazena reg_A no endereço armazenado em reg_B
						adress_signal <= reg_B;
						data_signal <= reg_A;

					when "0010" => -- Armazena reg_A no endereço armazenado em reg_R
						adress_signal <= reg_R;
						data_signal <= reg_A;

					when "0100" => -- Armazena reg_B no endereço armazenado em reg_A
						adress_signal <= reg_A;
						data_signal <= reg_B;

					when "0101" => -- Armazena reg_B no endereço imediato (PC + 1)
						adress_signal <= std_logic_vector(unsigned(reg_PC) + 1);
						data_signal <= reg_B;

					when "1000" => -- Armazena reg_R no endereço armazenado em reg_A
						adress_signal <= reg_A;
						data_signal <= reg_R;

					when others => -- Caso padrão
						adress_signal <= (others => '0');
						data_signal <= (others => '0');
				end case;

				enable_signal <= '0';
				write_sig <= '0';
				
				
				
			when "1001" => -- MOV
				case instrucao(3 DOWNTO 0) IS
					
					when "0100" => -- Move reg_A para reg_B
						reg_B <= reg_A;

					when "1000" => -- Move reg_A para reg_R
						reg_R <= reg_A;

					when "1100" => -- Move reg_A para reg_IR
						reg_IR <= reg_A;

					when "0001" => -- Move reg_B para reg_A
						reg_A <= reg_B;
						
					when "1001" => -- Move reg_B para reg_R
						reg_R <= reg_B;

					when "1101" => -- Move reg_B para reg_IR
						reg_IR <= reg_B;

					when "0010" => -- Move reg_R para reg_A
						reg_A <= reg_R;

					when "0110" => -- Move reg_R para reg_B
						reg_B <= reg_R;

					when "1110" => -- Move reg_R para reg_IR
						reg_IR <= reg_R;

					when "0011" => -- Move reg_IR para reg_A
						reg_A <= reg_IR;

					when "0111" => -- Move reg_IR para reg_B
						reg_B <= reg_IR;

					when "1011" => -- Move reg_IR para reg_R
						reg_R <= reg_IR;

					when others => -- Caso padrão: Zera todos os registradores de destino
						reg_A <= (others => '0');
						reg_B <= (others => '0');
						reg_R <= (others => '0');
						reg_IR <= (others => '0');
			end case;

			-- JMP
			WHEN "1010" =>
						
			--crtl <= "000";

				 case instrucao (3 downto 0) is 
					when "0000" => reg_PC <= reg_A;
					when "0001" => reg_PC <= reg_B;
					when "0010" => reg_PC <= reg_R;
					--when "0011" => reg_PC; --imediato
					when others => reg_A_signal <= "00000000";
									reg_B_signal <= "00000000";
				end case;

			-- JEQ
			WHEN "1011" =>
			
			--crtl <= "000";
			
				 IF zero_int = '0' AND sign_int = '0' THEN
					  reg_PC <= "0000" & instrucao(3 DOWNTO 0); -- O endereço é concatenado com 0000 para dar 8 bits
				 END IF;

			-- JGR
			WHEN "1100" =>
			
			--crtl <= "000";
			
				 IF zero_int = '1' AND sign_int = '0' THEN
					  reg_PC <= "0000" & instrucao(3 DOWNTO 0); -- O endereço é concatenado com 0000 para dar 8 bits
				 END IF;
				 
			-- IN
		
				WHEN "1101" =>  -- IN
					 CASE instrucao(3 DOWNTO 0) IS
						  WHEN "0000" => reg_A <= sw;
						  WHEN "0100" => reg_B <= sw;
						  WHEN "1000" => reg_R <= sw;
						  WHEN OTHERS => reg_A <= "00000000";
					 END CASE;
				WHEN "1110" =>  -- OUT
					 CASE instrucao(3 DOWNTO 0) IS
						  WHEN "0000" => led <= reg_A;
						  WHEN "0100" => led <= reg_B;
						  WHEN "1000" => led <= reg_R;
						  WHEN OTHERS => led <= "00000000";
					 END CASE;
			
		  when others => ctrl <= "011";

		 END CASE;
   
	END PROCESS;
	
END;
