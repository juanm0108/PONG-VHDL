---------------------------MASTER CODE --------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-----------------------------------------------------------------------
ENTITY MASTER_CODE IS 
      PORT(clk   : IN STD_LOGIC;
		     rst   : IN STD_LOGIC;
			  ena   : IN STD_LOGIC;
			  up1   : IN STD_LOGIC;
			  down1 : IN STD_LOGIC;
			  up2   : IN STD_LOGIC;
			  down2 : IN STD_LOGIC;
			  row_1    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			  row_2    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			  column_1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			  column_2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			  sseg1    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			  sseg2    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END ENTITY;
-----------------------------------------------------------------------
ARCHITECTURE names OF MASTER_CODE IS

SIGNAL syn_clr    : STD_LOGIC :='0';
SIGNAL MAX_racket : STD_LOGIC;
SIGNAL MAX_tick_supreme : STD_LOGIC;
SIGNAL player_1   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL player_2   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL ball_x     : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL ball_y     : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL pstb_x     : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL pstb_y     : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL cp1        : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL cp2        : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL row_3,row_4,row_5,row_6,row_7,row_8 : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
-----------------timer_racket------------------------------------------
clock_speed: ENTITY work.univ_bin_counter	
           GENERIC MAP(N        => 25)
				 PORT MAP (clk      =>   clk,
                       rst      =>   rst,
                       ena      =>   '1',
                       syn_clr  =>   '0',
				           up       =>   '1',
				           max_tick =>   max_racket,
				           max      =>   "0010111010111100000000000");

-----------------printer_remastered------------------------------------

print_matrix:ENTITY WORK.printer_remastered
             PORT MAP(clk      => clk,
				          rst      => rst,
		                syn_clr  => syn_clr,
						    player_1 => player_1,
							 player_2 => player_2,
							 ball_x   => ball_x,
							 ball_y   => ball_y,
							 row_1    => row_1,
				          column_1 => column_1,
				          row_2 	  => row_2,
				          column_2 => column_2);


----------------PLAYERS------------------------------------------------

    Fplayer_1:ENTITY WORK.RACKET_P
	           PORT MAP(clk      => MAX_racket,
				           rst      => rst,
						     up       => up1,
							  down     => down1,
							  COLUMN   => player_1);

    Fplayer_2:ENTITY WORK.RACKET_P
	           PORT MAP(clk      => MAX_racket,
				           rst      => rst,							 
						     up       => up2,
							  down     => down2,
							  COLUMN   => player_2);
							 
---------------BALL---------------------------------------------------

    BALL_PHYSICS:ENTITY WORK.BALL
	              PORT MAP(clk => max_racket,
					           rst => rst,
								  ena => '1',
								  player_1 => player_1,
								  player_2 => player_2,
								  ball_x   => ball_x,
								  ball_y   => ball_y,
								  count_1  => cp1,
								  count_2  => cp2);
								  
---------------BIN_TO_SSEG---------------------------------------------

          FSSEG1:ENTITY WORK.bin_to_sseg
	              PORT MAP(bin       => cp1,
				             sseg      => sseg1);
								  
	       FSSEG2:ENTITY WORK.bin_to_sseg
	              PORT MAP(bin       => cp2,
				             sseg      => sseg2);		
-------------------------------END =)----------------------------------
	
END ARCHITECTURE;
