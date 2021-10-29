-------------------------------------------------------------------------------
--      AUTHOR NAME:  Hasnain Akhtar
--      COURSE     :  CPET-561-Embedded Systems Design I
--      LAB NAME   :  Custom Servo Component(Lab 4)
--      FILE NAME  :  servo_controller.vhd
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--      TBD

--*****************************************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

entity servo_controller is
  port (
    clk             : in  std_logic;                       --50 Mhz clock
    reset_n         : in  std_logic;                       --reset signal
    write           : in  std_logic;                       --active high write enable
    writedata       : in  std_logic_vector(31 downto 0);   --data to be read into the registers
    address         : in  std_logic;                       --0 for min angle and 1 for max angle
    out_wave_export : out std_logic;                      --PWM pulse pin to servo
    irq             : out std_logic                       --Interrupt
  );
end servo_controller;

architecture rtl of servo_controller is
signal reg_min_angle  : std_logic_vector(31 downto 0) := X"0000C350";    --Register to hold minimum angle value(45)
signal reg_max_angle  : std_logic_vector(31 downto 0) := X"000186A0";    --Register to hold maximum angle value(135)
signal counter_up     : std_logic_vector(31 downto 0) := X"000124F8";--Used for servo movement up
signal counter_dwn    : std_logic_vector(31 downto 0) := X"000124F8";--Used for servo movement down
signal writedata_sig  : std_logic_vector(31 downto 0) := (others => '0');--signal for adress data coming in servo
signal period_count   : std_logic_vector(31 downto 0) := X"000F4240";     --20ms counter(1000000 count)

type state_type is (sweep_right,int_right,sweep_left,int_left);
signal presentState : state_type;
signal nextState    : state_type;

begin
  
  writedata_sig <= writedata;
  
  internal_reg_reset: process(clk, reset_n)
  begin
    if(reset_n = '0') then
      reg_min_angle <= X"0000C350"; --45 degrees
      reg_max_angle <= X"000186A0"; --135 degrees
    elsif(rising_edge(clk)) then
      if(write = '1') then
        if(address = '0') then
          reg_min_angle <= writedata_sig;
        elsif(address = '1') then
          reg_max_angle <= writedata_sig;
        end if;
      end if;
    end if;
  end process internal_reg_reset;
  
  
  --state machine reset sync
  state_update: process(clk, reset_n)
  begin
    if(reset_n = '0') then
      presentState <= sweep_right;
    elsif(rising_edge(clk)) then
      presentState <= nextState;
    else
    end if;
  end process state_update;
  
  --servo motor turn process
  state_comb: process(clk,presentState)
  begin
    --nextState <= presentState;
    if(rising_edge(clk)) then
      case presentState is
        when sweep_right =>
          if(period_count = X"000F4240") then
            if(counter_up = reg_max_angle) then
              counter_up <= X"000124F8";          --reset counter
              irq <= '1';                         --trigger interrupt
              nextState <= int_right;             --next state
            else
              counter_up <= counter_up + 5000;
              irq <= '0';
            end if;
          end if;
        when int_right =>
          irq <= '0';
          nextState <= sweep_left;
        when sweep_left =>
          if(period_count = X"000F4240") then
            if(counter_dwn = reg_min_angle) then
              counter_dwn <= X"000124F8";
              irq <= '1';
              nextState <= int_left;
            elsif(counter_dwn < reg_min_angle) then
              counter_dwn <= counter_dwn + 5000;
            else
              counter_dwn <= counter_dwn - 5000;
              irq <= '0';
            end if;
          end if;
        when int_left =>
            irq <= '0';
            nextState <= sweep_right;
        when others =>
          nextState <= sweep_right;
      end case;
    end if;
  end process state_comb;
  
  pwm_period_cntr: process(clk, reset_n)
  begin
    if(reset_n = '0') then
      period_count <= (others => '0');
    elsif(rising_edge(clk)) then
      if(period_count = X"000F4240") then
        period_count <= (others => '0');
      else
        period_count <= period_count + 1;
      end if;
    end if;
  end process;
  
  --out_wave_export <= '1' ;
  --out_wave_export <= '1' when((period_count = X"000F4240") or(period_count < 100000)) else '0';
  out_wave_export <= '1' when((counter_up  < reg_max_angle) or (counter_dwn > reg_min_angle)) else '0';

end rtl;