LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-------------------------------------------------
ENTITY ball_counter IS
	GENERIC (	N				:		INTEGER	:= 18);
	PORT 	  (	clk			:		IN   STD_LOGIC;
					rst			:		IN   STD_LOGIC;
					ena			:		IN   STD_LOGIC;
					syn_clr 		:		IN   STD_LOGIC;
					load        :     IN   STD_LOGIC;
					d           :     IN   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
					up				:		IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
					MAX			:     IN   STD_LOGIC_VECTOR (N-1 DOWNTO 0);
					counter		:	   OUT  STD_LOGIC_VECTOR (N-1 DOWNTO 0):= MAX );
END ENTITY;
--------------------------------------------------
ARCHITECTURE rt1 OF ball_counter IS
	CONSTANT ONES 			:		UNSIGNED (N-1 DOWNTO 0):=	(OTHERS => '1');
	CONSTANT ZEROS			:		UNSIGNED (N-1 DOWNTO 0):=	(OTHERS => '0');
	-- SIGNAL count_s		:		INTEGER RANGE 0 to (2**N-1);
	
	SIGNAL count_s			:     UNSIGNED (N-1 DOWNTO 0);
	SIGNAL count_next 	:		UNSIGNED (N-1 DOWNTO 0);
	SIGNAL max_tick_s	:		STD_LOGIC;

BEGIN
	-- NEXT STATE LOGIC
	
	
	count_next <=	UNSIGNED(d)       WHEN  load = '1'            ELSE
	               count_s +1			WHEN (ena ='1' AND up="11") ELSE
						count_s -1 			WHEN (ena ='1' AND up="00") ELSE
						count_s;
		PROCESS (clk,rst,MAX)
			VARIABLE temp	:	UNSIGNED (N-1 DOWNTO 0);
		BEGIN
			IF (rst='1') THEN
				temp:= UNSIGNED(MAX);
		ELSIF (rising_edge(clk)) THEN
			IF (syn_clr ='1') THEN
			temp:= (OTHERS => '0');
			ELSIF (ena='1') THEN
				temp	:= count_next;
		END IF;
	END IF;
	counter  <= STD_LOGIC_VECTOR(temp);
	count_s  <= temp;
	END PROCESS;
	
	

END ARCHITECTURE;