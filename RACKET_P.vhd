--------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
--------------------------------------------------------------------------
ENTITY  RACKET_P IS	
	PORT 	(	rst		 	 		:  IN 	STD_LOGIC;
				clk 					:	IN 	STD_LOGIC;
				up			         :	IN		STD_LOGIC;
				down				   :	IN		STD_LOGIC;
				COLUMN				:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
END ENTITY;
----------------------------------------
ARCHITECTURE fsm OF RACKET_P IS

TYPE STATE IS (STATE_0, DOWN_0, DOWN_1, DOWN_2, UP_0, UP_1 );
SIGNAL pr_state, nx_state	:	STATE ;

BEGIN



------------------------SEQUENTIAL SECTION-----------------------------
PROCESS (rst, clk)
	BEGIN 
	IF(rst = '1')THEN
		pr_state	<= STATE_0;
		ELSIF (rising_edge (clk)) THEN 
		pr_state <=	nx_state;
	END IF;
END PROCESS;

-----------------------COMBINATIONAL SECTION --------------------------
PROCESS(pr_state,up,down)
BEGIN	
CASE pr_state	IS
			
----------------------------------STATE_0------------------------------
WHEN STATE_0 =>

				COLUMN 	<= "00111000";

				IF(up ='1') THEN 
					nx_state <= UP_0;
				ELSIF (down ='1' ) THEN
					nx_state <= DOWN_0;
				ELSE
					nx_state<=STATE_0;
				END IF;
		
----------------------------------DOWN_0------------------------------
WHEN DOWN_0 =>

				COLUMN 	<= "00011100";

				IF(up ='1') THEN 
					nx_state <= STATE_0;
				ELSIF (down ='1' ) THEN
					nx_state <= DOWN_1;
				ELSE
					nx_state<=DOWN_0;
				END IF;
		
----------------------------------DOWN_1------------------------------
WHEN DOWN_1 =>

				COLUMN 	<= "00001110";

				IF(up ='1') THEN 
					nx_state <= DOWN_0;
				ELSIF (down ='1' ) THEN
					nx_state <= DOWN_2;
				ELSE
					nx_state<=DOWN_1;
				END IF;
		
----------------------------------DOWN_2------------------------------
WHEN DOWN_2 =>

				COLUMN 	<= "00000111";

				IF(up ='1') THEN 
					nx_state <= DOWN_1;
				ELSIF (down ='1' ) THEN
					nx_state <= DOWN_2;
				ELSE
					nx_state<=DOWN_2;
				END IF;
		
----------------------------------UP_0------------------------------
WHEN UP_0 =>

				COLUMN 	<= "01110000";

				IF(up ='1') THEN 
					nx_state <= UP_1;
				ELSIF (down ='1' ) THEN
					nx_state <= STATE_0;
				ELSE
					nx_state<=UP_0;
				END IF;
		
----------------------------------UP_1-------------------------------
WHEN UP_1 =>

				COLUMN 	<= "11100000";

				IF(up ='1') THEN 
					nx_state <= UP_1;
				ELSIF (down ='1' ) THEN
					nx_state <= UP_0;
				ELSE
					nx_state<=UP_1;
            END IF;
		

	END CASE;
END PROCESS;
END ARCHITECTURE fsm;