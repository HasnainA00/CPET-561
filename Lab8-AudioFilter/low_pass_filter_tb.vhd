-------------------------------------------------------------------------------
-- Hasnain Akhtar
-- Low Pass Filter Test Bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use std.textio.all;

entity low_pass_filter_tb is
end low_pass_filter_tb;

architecture arch of low_pass_filter_tb is 


component low_pass_filter is
    port (
    clk       : in std_logic;
    reset_n   : in std_logic;
    filter_en : in std_logic;
    data_in   : in signed(15 downto 0);
    data_out  : out signed(15 downto 0)
  );
end component;

signal input              : std_logic := '0';
constant period           : time := 20 ns;                                              
signal clk                : std_logic := '0';
signal reset_n            : std_logic := '1';
signal filter_en: std_logic:= '0';
signal data_in: signed(15 downto 0):= (others => '0');
signal data_out: signed(15 downto 0);
type signed_array is array (39 downto 0) of signed(15 downto 0);
signal audioSampleArray: signed_array;

begin
  
   
 
-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/8;
end process; 
 
 stimulus : process is  
  file read_file : text open read_mode is "../verification_src/one_cycle_200_8k.csv"; 
  file results_file : text open write_mode is "../verification_src/output_waveform.csv"; 
  variable lineIn : line; 
  variable lineOut : line; 
  variable readValue : integer; 
  variable writeValue : integer; 
begin 
  wait 
  for 100 ns; 
    reset_n <= '1'; 
    -- 
  --Read data from file into an array 
    for i in 0 to 39 loop 
      readline(read_file, lineIn); 
      read(lineIn, readValue); 
      audioSampleArray(i) <= to_signed(readValue, 16); 
      wait for 50 ns; 
    end loop; 
    file_close(read_file); 
    -- 
  --Apply the test data and put the result into an output file 
    for i in 1 to 10 loop 
      for j in 0 to 39 loop 
        -- your code here
        --Read the data from the array and apply it to Data_In 
        data_in <= (audioSampleArray(j));
        filter_en <= '1';
        wait for 100 ns;
        filter_en <= '0';
        wait for 100 ns;

  --Remember to provide an enable pulse with each new sample 
  --Write filter output to file 
        writeValue := to_integer(data_out); 
        write(lineOut, writeValue); 
        writeline(results_file, lineOut); 
       end loop;
    end loop;
  end process stimulus;
  
uut: low_pass_filter  
  port map( 
    clk       => clk,
    reset_n   => reset_n,
    filter_en => filter_en,
    data_in   => data_in,
    data_out  => data_out
  );
end arch;