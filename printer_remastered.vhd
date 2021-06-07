------------------printer-remastered-------------------------
--program receives 3 sets of information. 2 player controlled elements and ball position 
---------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--------------------------------------------------------------
ENTITY printer_remastered IS 
	GENERIC ( N       : INTEGER :=8);
	PORT (   clk 				: IN STD_LOGIC;
	         rst            : IN STD_LOGIC;
				syn_clr        : IN STD_LOGIC;
				player_1       : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0); --user controlled 
				player_2      	: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				ball_x    		: IN STD_LOGIC_VECTOR(3 DOWNTO 0); --ball position in binary 
				ball_y			: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
				row_1 	: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0); --output information 
				column_1: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				row_2 	: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				column_2: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END ENTITY;
---------------------------------------------------------------
ARCHITECTURE fsm OF printer_remastered IS
--timer variables--
SIGNAL max_tick : STD_LOGIC;
SIGNAL min_tick : STD_LOGIC;
SIGNAL counter	 :  STD_LOGIC_VECTOR (17 DOWNTO 0);

TYPE state IS (racket_printing,
					ball_printing);
SIGNAL pr_state, nx_state : state;
--SIGNAL max_tick: STD_LOGIC;

BEGIN
------------------universal_binary_counter------------------------------
	master_counter: ENTITY work.univ_bin_counter
		PORT MAP (clk      =>   clk,
					 rst      =>   rst,
					 ena      =>   '1',
					 syn_clr  =>   syn_clr,
					 up       =>   '1',
					 max_tick =>   max_tick,
					 min_tick =>   min_tick,
					 max      =>   "100100100111110000",
					 counter  => counter); --frame rate 500us--20bits---

----------------------sequential section-------------------------------
	sequential: PROCESS(rst,clk,max_tick)
	BEGIN
	IF (rst = '1') THEN
		 pr_state <= racket_printing;
	ELSIF (rising_edge(max_tick)) THEN
		 pr_state <= nx_state;
	END IF;
	END PROCESS sequential;

--------------------combinational section------------------------------
combinational: PROCESS(pr_state,max_tick,ball_x,ball_y,player_1,player_2)
BEGIN
	CASE pr_state IS 
----------------------------------------------------------------------
		WHEN racket_printing => 
			row_1 	<= player_1;
			column_1 		<= "01111111";
			
			row_2 	<= player_2;
			column_2 		<= "11111110";
		IF(max_tick ='1') THEN 
			nx_state <=	ball_printing;
		ELSE 
			nx_state <= racket_printing;
		END IF;
------------------------------------------------------------------------
		WHEN ball_printing => 
		IF(ball_x="0001") THEN
		column_1 		<= "10111111";
		column_2 		<= "11111111";
		
		ELSIF(ball_x="0010") THEN 
		
		column_1 		<= "11011111";
		column_2 		<= "11111111";
		
		ELSIF(ball_x="0011") THEN
		
		column_1 		<= "11101111";
		column_2 		<= "11111111";
		
		ELSIF(ball_x="0100") THEN

		column_1 		<= "11110111";
		column_2 		<= "11111111";
		
		ELSIF(ball_x="0101") THEN
		
		column_1 		<= "11111011";
		column_2 		<= "11111111";	
		
		
		ELSIF(ball_x="0110") THEN
		
		column_1 		<= "11111101";
		column_2 		<= "11111111";	
		
		ELSIF(ball_x="0111") THEN
		
		column_1 		<= "11111110";
		column_2 		<= "11111111";	
		
		
		ELSIF(ball_x="1000") THEN
		
		column_1 		<= "11111111";
		column_2 		<= "01111111";	
		
		ELSIF(ball_x="1001") THEN
		
		column_1 		<= "11111111";
		column_2 		<= "10111111";	
		
		ELSIF(ball_x="1010") THEN
		
		column_1 		<= "11111111";
		column_2 		<= "11011111";	
		
		
		ELSIF(ball_x="1011") THEN
		
		column_1 		<= "11111111";
		column_2 		<= "11101111";	
		
		ELSIF(ball_x="1100") THEN
		
		column_1 		<= "11111111";
		column_2 		<= "11110111";	
		
		ELSIF(ball_x="1101") THEN
		
		column_1 		<= "11111111";
		column_2 		<= "11111011";	
		
		ELSIF(ball_x="1110") THEN
		
		column_1 		<= "11111111";
		column_2 		<= "11111101";	
		ELSE
		
		column_1 		<= "11111111";
		column_2 		<= "11111110";	
		
		END IF;
		
		IF(ball_y="000") THEN
		
		row_1<="10000000";
		row_2<="10000000";
		
		ELSIF(ball_y="001") THEN
		
		row_1<="01000000";
		row_2<="01000000";
		
		ELSIF(ball_y="010") THEN 
		
	   row_1<="00100000";
		row_2<="00100000";
		
		ELSIF(ball_y="011") THEN
		
		row_1<="00010000";
		row_2<="00010000";
		
		ELSIF(ball_y="100") THEN

		row_1<="00001000";
		row_2<="00001000";
		
		ELSIF(ball_y="101") THEN
		
		row_1<="00000100";
		row_2<="00000100";	
		
		
		ELSIF(ball_y="110") THEN
		
		row_1<="00000010";
		row_2<="00000010";	
		ELSE
		
		row_1<="00000001";
		row_2<="00000001";
		
		END IF;
		
		IF(max_tick ='1') THEN 
			nx_state <=	racket_printing;
		ELSE 
			nx_state <= ball_printing;
		END IF;
	END CASE;
END PROCESS combinational;

END ARCHITECTURE fsm;