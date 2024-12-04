library IEEE;
use IEEE.STD_LOGIC_1164.ALL;    -- Para operações com STD_LOGIC_VECTOR
use IEEE.NUMERIC_STD.ALL;       -- Para operações com unsigned e signed


ENTITY cpu is 
	PORT(clk, reset: IN STD_LOGIC;
			sw: 		  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			LED:       OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
			
END;

ARCHITECTURE BEHAVE OF cpu is

	--type ram_type is array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
	
	--signal mem : ram_type;
	
	COMPONENT MemoriaRAM
		PORT(
			address_input: IN STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Endereço de 8 bits
			readsignal: IN STD_LOGIC; -- Leitura ativa
			writesignal: IN STD_LOGIC;  -- Escrita ativa
			memory_enable: IN STD_LOGIC;  -- Habilita memória 
			clock: IN STD_LOGIC;                 -- Sinal de clock
			dataBuf: BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0)   -- Dados de entrada/saída (8 bits)
		);
	END COMPONENT;
	
	COMPONENT main_dec
        PORT (
           instrucao, sw :               				IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			  reg_A, reg_B, reg_R, reg_IR:	BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);
			  reg_PC : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);
			  zero, sign:									BUFFER STD_LOGIC;
			  clk:												IN STD_LOGIC;
			  led: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
				);	
	
	END COMPONENT;
	
	SIGNAL instrucao, reg_A, reg_B, reg_R, reg_PC, reg_IR : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL zero, sign : STD_LOGIC;
	
	BEGIN
	
	
	dec: main_dec PORT MAP (instrucao, sw, reg_A, reg_B, reg_R, reg_IR, reg_PC, zero, sign, clk, LED);


	PROCESS(clk, reset)
	BEGIN
		 IF reset = '1' THEN
			  reg_A <= "00000000";
			  reg_B <= "00000000";
			  reg_R <= "00000000";
			  reg_PC <= "00000000";
		 ELSIF rising_edge(clk) THEN
			  -- Incrementa o contador de programa
			  reg_PC <= std_logic_vector(unsigned(reg_PC) + 1);
		 END IF;
	END PROCESS;
	

	
END BEHAVE;