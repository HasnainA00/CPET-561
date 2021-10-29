--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*********  Copyright 2017, Rochester Institute of Technology  ***************
--*****************************************************************************
--
--  DESIGNER NAME:  Holly Dickens
--
--       LAB NAME:  ESD Lab 4 Servo Tb
--
--      FILE NAME:  servo_controller_tb.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    This test bench will provide input to test ESD Lab 4 Servo
--
-------------------------------------------------------------------------------
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 10/03/18 | HLD  | 1.0 | original 
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY servo_controller_tb IS
END servo_controller_tb;


ARCHITECTURE test OF servo_controller_tb IS

   -- Component Declaration 
   COMPONENT servo_controller is 
  PORT (
    clk       : IN  STD_LOGIC;
    reset_n   : IN  STD_LOGIC;
    write     : IN  STD_LOGIC;
    writedata : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    address   : IN  STD_LOGIC;
    out_wave_export  : OUT STD_LOGIC;
    irq       : OUT STD_LOGIC
  );
   END COMPONENT;

   -- define signals for component ports
   SIGNAL clk_tb          : std_logic                     := '0';
   SIGNAL reset_n_tb      : std_logic                     := '0';
   SIGNAL write_tb        : std_logic                     := '0';
   SIGNAL write_addr_tb   : std_logic                     := '0';
   SIGNAL write_data_tb   : std_logic_vector(31 DOWNTO 0) := x"00000000";
 
   -- Outputs
   SIGNAL gpio_tb         : std_logic;
	SIGNAL irq_tb          : std_logic;     
   
   -- signals for test bench control
   SIGNAL sim_done : boolean := false;
   SIGNAL PERIOD_c : time    := 20 ns;  -- 50MHz

BEGIN  -- test

   -- component instantiation
   UUT : servo_controller
      PORT MAP (
		  -- inputs
        clk       => clk_tb,
        reset_n   => reset_n_tb,
        write     => write_tb,
        address   => write_addr_tb,
        writedata => write_data_tb,
        -- outputs
        out_wave_export  => gpio_tb,
        irq       => irq_tb
      );

   -- This creates an clock_50 that will shut off at the end of the Simulation
   clk_tb <= NOT clk_tb AFTER PERIOD_C/2 WHEN (NOT sim_done) ELSE '0';

   -- Stim process runs until wait 
   stimulus : PROCESS
    variable wave_start_time : time;
    variable wave_stop_time  : time;

   BEGIN
    -- assert reset 
    reset_n_tb  <= '0';

    -- now lets sync the stimulus to the clk
    -- move stimulus 1ns after clock edge
    WAIT UNTIL clk_tb = '1';
    WAIT FOR 1 ns;
    WAIT FOR PERIOD_c*2;

    -- de-assert reset
    reset_n_tb <= '1';
    WAIT FOR PERIOD_c*2;
 
		-- WRITE MIN
		WAIT FOR PERIOD_c*2;
	  write_data_tb <= x"0000C350"; 
		write_addr_tb <= '0'; 
		write_tb      <= '1';
		WAIT FOR PERIOD_c*2;
		write_tb      <= '0';
    wait until irq_tb = '1'; 
		
		-- WRITE MAX
		WAIT FOR PERIOD_c*2;
	  write_data_tb <= x"000186A0"; 
		write_addr_tb <= '1'; 
		write_tb      <= '1';
		WAIT FOR PERIOD_c*2;
		write_tb      <= '0';
    wait until irq_tb = '1'; 


		-- WRITE MIN
		WAIT FOR PERIOD_c*2;
	  write_data_tb <= x"00015F90"; 
		write_addr_tb <= '0'; 
		write_tb      <= '1';
		WAIT FOR PERIOD_c*2;
		write_tb      <= '0';
    wait until irq_tb = '1'; 
		
	 
	   -- wait for 100 clock periods then stop simulation 
      WAIT FOR PERIOD_c*10000;
      sim_done <= true;
     
      report "Simulation complete. This is not a self-checking testbench. You must verify your results manually.";

      -- wait forever, stop process from rerunning
      WAIT;

   END PROCESS stimulus;

END test;
