LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY IntermediateBuffer IS
	GENERIC(N : integer := 32);
		PORT( 
		D: IN std_logic_vector(N - 1 DOWNTO 0); 
		EN: IN std_logic;
		INT: IN std_logic;
		BRANCH: IN std_logic;
		RET: IN std_logic;
		RTI: IN std_logic;
		HAZARDDETECT: IN std_logic;
		CLK: IN std_logic;
		RST: IN std_logic;
		Q: OUT std_logic_vector(N - 1 DOWNTO 0)
		);
END IntermediateBuffer;


ARCHITECTURE REG_ARCH OF IntermediateBuffer IS
BEGIN
	PROCESS(CLK, RST, EN)
	BEGIN
	  
		IF(RST = '1') THEN
			Q <= (others =>'0');
		ELSIF(EN = '0' OR INT ='1' OR RET ='1' OR RTI ='1' OR BRANCH ='1' OR HAZARDDETECT ='1') THEN
			Q <= (others =>'Z');		
		ELSIF rising_edge(CLK) and EN = '1' THEN     
		 	Q <= D;
		END IF;
	END PROCESS;
END REG_ARCH;
