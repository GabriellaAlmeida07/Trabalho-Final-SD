LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MemoriaRAM IS 
	PORT(
			address_input: IN STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Endereço de 8 bits
			readsignal: IN STD_LOGIC; -- Leitura ativa
			writesignal: IN STD_LOGIC;  -- Escrita ativa
			memory_enable: IN STD_LOGIC;  -- Habilita memória 
			clock: IN STD_LOGIC;                 -- Sinal de clock
			dataBuf: BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0)   -- Dados de entrada/saída (8 bits)
	);
END MemoriaRAM;

ARCHITECTURE behavior OF MemoriaRAM IS
	-- Interface do componente a ser instanciado
	-- Definindo o componente RAM256x8
	COMPONENT ram256x8
		PORT(
			address	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Endereço de 8 bits
			clock		: IN STD_LOGIC := '1';              
			data		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);    -- Dados de 8 bits
			wren		: IN STD_LOGIC;                       
			q			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)    -- Dados de saída 8 bits
		);
	END COMPONENT;

	-- Sinal interno para armazenar os dados de saída da RAM
	SIGNAL q_internal: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL dataBuf_sig_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL dataBuf_sig_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL dataIn : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL wren_signal : STD_LOGIC;


BEGIN
	-- Instância do componente RAM256x8
	ram_instance: ram256x8
		PORT MAP(
			address => address_input,       
			clock => clock,            
			data => dataIn,          
			wren => wren_signal,              
			q => q_internal           
		);
		
		
		PROCESS(clock, readsignal, writesignal, memory_enable)
		BEGIN
			IF readsignal = '1' and writesignal = '0' AND memory_enable = '1' then
				wren_signal <= '0';
				databuf <= q_internal;
			ELSIF readsignal = '0' and writesignal = '1' AND memory_enable = '1' then
				wren_signal <= '1'; 
				dataIn <= databuf;
			ELSE
				wren_signal <= '0';
				databuf <= databuf;
			END IF;
		END PROCESS;
		

END behavior;
