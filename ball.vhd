LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-------------------------------------------------
ENTITY ball IS
	PORT 	  (	clk			:		IN   STD_LOGIC;
					rst			:		IN   STD_LOGIC;
					ena			:		IN   STD_LOGIC;
					player_1    :     IN   STD_LOGIC_VECTOR(7 DOWNTO 0);
					player_2    :     IN   STD_LOGIC_VECTOR(7 DOWNTO 0);
					ball_x      :     OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
					ball_y      :     OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
					count_1     :     OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
					count_2     :     OUT  STD_LOGIC_VECTOR(3 DOWNTO 0));
END ENTITY;
-----------------------------------------------------------------
ARCHITECTURE fsm OF ball IS
TYPE state IS (INITIAL_STATE,
               UP_LEFT,
					DOWN_LEFT,
					UP_RIGHT,
					DOWN_RIGHT,
					POINT_WINNER_1,
					POINT_WINNER_2);
					
SIGNAL pr_state, nx_state : state;
SIGNAL rst_game,ena_x,ena_y,load  : STD_LOGIC;
SIGNAL up_x,up_y             :STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL dx                    : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL dy                    : STD_LOGIC_VECTOR(2 DOWNTO 0); 
SIGNAL counter_x             : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL counter_Y             : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL counter               : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL temp_y                : INTEGER;
SIGNAL point_1               : STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
SIGNAL point_2               : STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";


BEGIN 	
-------------------------------------------------------------------------
temp_y <= to_integer(unsigned(counter_y));	 
count_1 <= point_1;
count_2 <= point_2;

------------------------Counter for players------------------------------
BALl_counter_X: ENTITY work.ball_counter
GENERIC MAP(N => 4)
	PORT MAP (clk	   => clk,		
				 rst	   => rst_game,		
				 ena     => '1',		
				 syn_clr => '0',
			    load    => load,	
				 d       => "1000", 
				 up      => up_x, 				
				 MAX	   => "1111",		
				 counter	=> counter_x);
--
BALl_counter_Y: ENTITY work.ball_counter
	GENERIC MAP(N => 3)
	PORT MAP (clk	   => clk,		
				 rst	   => rst_game,		
				 ena     => '1',		
				 syn_clr => '0',
				 load    => load,
				 d       => "100",
				 up      => up_y, 				
				 MAX	   => "111",		
				 counter	=> counter_y);
-------------------------------FRAME_SPEED------------------------------------	

------------------------------------------------------------------------------		  




   random: ENTITY work.univ_bin_counter	
           GENERIC MAP(N        => 2)
				 PORT MAP (clk      =>   clk,
                       rst      =>   rst,
                       ena      =>   '1',
                       syn_clr  =>   '0',
				           up       =>   '1',
				           max      =>   "11",
							  counter  =>   counter);
----------------------FSM------------------------------------------------	
PROCESS (rst, clk)
	BEGIN 
	IF(rst = '1')THEN
		pr_state	<= INITIAL_STATE;
		ELSIF (rising_edge (clk)) THEN 
		pr_state <=	nx_state;
	END IF;
END PROCESS;
------------------------------COMBINATIONAL------------------------------
			 
PROCESS (counter_Y,counter_x,counter,temp_y,pr_state,point_1,point_2)
	
BEGIN 
				
		CASE pr_state IS 
-- Decision making states		
--INITIAL_STATE, X=7 Y=4 AND RANDOM DIRECTION
			WHEN INITIAL_STATE => 
			   ball_x  <= "1000";--8
            ball_y  <= "100";--4
				load    <= '1';
			
				IF (counter = "11") THEN
					nx_state <= UP_LEFT;
				ELSIF (counter = "10") THEN
					nx_state <= DOWN_RIGHT;
				ELSIF (counter = "01") THEN
					nx_state <= DOWN_LEFT;
				ELSE 
					nx_state <= UP_RIGHT;
				END IF;

--Ball movement towards left---------------------------------
			WHEN UP_LEFT =>
			   up_x     <="00"; 
				up_y     <="11";
				ball_x  <= counter_x;
            ball_y  <= counter_y;
				load    <= '0';
				rst_game <='0';
				IF (counter_y="110") THEN
			      IF(counter_x = "0001")THEN
				       IF(player_1(temp_y)='1') THEN
					       nx_state <= UP_RIGHT;
					    ELSE
					       nx_state <= POINT_WINNER_2;
			 	       END IF;
					 
				    ELSE
				    nx_state <= DOWN_LEFT;
				    END IF;
		
             ELSE
               IF(counter_x = "0001") THEN
			          IF(player_1(temp_y)='1')THEN
				          nx_state <= UP_RIGHT;
			           ELSE
				          nx_state <= POINT_WINNER_2;
			           END IF;
			      ELSE
			             nx_state <= UP_LEFT;
			      END IF;
			
          END IF;	
			 
-----------------------------------------------------------------------------
			WHEN DOWN_LEFT => 
			   up_x     <="00";
				up_y     <="00";
				ball_x  <= counter_x;
            ball_y  <= counter_y;
				load    <= '0';
				rst_game <='0';
				IF (counter_y="001") THEN
			      IF(counter_x = "0001")THEN
				       IF(player_1(temp_y)='1') THEN
					       nx_state <= DOWN_RIGHT;
					    ELSE
					       nx_state <= POINT_WINNER_2;
			 	       END IF;
					 
				    ELSE
				    nx_state <= UP_LEFT;
				    END IF;
		
             ELSE
               IF(counter_x = "0001") THEN
			          IF(player_1(temp_y)='1')THEN
				          nx_state <= DOWN_RIGHT;
			           ELSE
				          nx_state <= POINT_WINNER_2;
			           END IF;
			      ELSE
			             nx_state <= DOWN_LEFT;
			      END IF;
			
          END IF;	
-----------------------------------------------------------------------------
			WHEN UP_RIGHT => 
			   up_x     <="11";
				up_y     <="11";
				ball_x  <= counter_x;
            ball_y  <= counter_y;
				load    <= '0';
				rst_game <='0';
				IF (counter_y="110") THEN
			      IF(counter_x = "1110")THEN
				       IF(player_1(temp_y)='1') THEN
					       nx_state <= UP_LEFT;
					    ELSE
					       nx_state <= POINT_WINNER_1;
			 	       END IF;
					 
				    ELSE
				    nx_state <= DOWN_RIGHT;
				    END IF;
		
             ELSE
               IF(counter_x = "1110") THEN
			          IF(player_1(temp_y)='1')THEN
				          nx_state <= UP_LEFT;
			           ELSE
				          nx_state <= POINT_WINNER_1;
			           END IF;
			      ELSE
			             nx_state <= UP_RIGHT;
			      END IF;
			
          END IF;	
-----------------------------------------------------------------------------
			WHEN DOWN_RIGHT => 
            up_x     <="11";
				up_y     <="00";
				ball_x  <= counter_x;
            ball_y  <= counter_y;
				load    <= '0';
				rst_game <='0';
				IF (counter_y="001") THEN
			      IF(counter_x = "1110")THEN
				       IF(player_1(temp_y)='1') THEN
					       nx_state <= DOWN_LEFT;
					    ELSE
					       nx_state <= POINT_WINNER_1;
			 	       END IF;
					 
				    ELSE
				    nx_state <= UP_RIGHT;
				    END IF;
		
             ELSE
               IF(counter_x = "1110") THEN
			          IF(player_1(temp_y)='1')THEN
				          nx_state <= DOWN_LEFT;
			           ELSE
				          nx_state <= POINT_WINNER_1;
			           END IF;
			      ELSE
			             nx_state <= DOWN_RIGHT;
			      END IF;
			
          END IF;	
-----------------------------------------------------------------------------
----------------------------POINT_STATES-------------------------------------
          WHEN POINT_WINNER_1 =>
			   up_x     <="10";
				up_y     <="10";
				ball_x  <= "1000";--8
            ball_y  <= "100";--4
				load    <= '0';
				rst_game <='1';
				IF ((point_1 OR point_2) < "1010")THEN
				     point_1 <= point_1 + 1;
					  nx_state <= INITIAL_STATE;
			   ELSE
				    point_1 <= "0000";
					 point_2 <= "0000";
				    nx_state <= INITIAL_STATE;
				END IF;
-----------------------------------------------------------------------------
          WHEN POINT_WINNER_2 =>
			   up_x     <="10";
				up_y     <="10";
				ball_x  <= "1000";--8
            ball_y  <= "100";--4
				load    <= '0';
				rst_game <='1';
				IF ((point_1 OR point_2) < "1010")THEN
				     point_2 <= point_2 + 1;
					  nx_state <= INITIAL_STATE;
			   ELSE
				    point_1 <= "0000";
					 point_2 <= "0000";
				    nx_state <= INITIAL_STATE;
				END IF;			     
------------------------------------------------------------------------------


				
	 END CASE;
END PROCESS;
END ARCHITECTURE fsm;