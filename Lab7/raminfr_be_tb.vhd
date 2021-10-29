-------------------------------------------------------------------------------
-- Hasnain Akhtar
-- Homework5-problem1: Sequence Detector FSM Test bench
-------------------------------------------------------------------------------
library ieee;
library work;
--use work.raminfr_be_pkg.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity raminfr_be_tb is
end raminfr_be_tb;

architecture arch of raminfr_be_tb is 


component raminfr_be is
    port (
    clk       : in std_logic;
    reset_n   : in std_logic;
    writebyteenable_n : in std_logic_vector(3 downto 0);
    address   : in std_logic_vector(11 downto 0);
    writedata : in std_logic_vector(31 downto 0);

    readdata  : out std_logic_vector(31 downto 0)
   );
   end component;

signal input              : std_logic := '0';
constant period           : time := 20 ns;                                              
signal clk                : std_logic := '0';
signal reset_n            : std_logic := '1';
signal writebyteenable_n  : std_logic_vector(3 downto 0)   := (others => '1');
signal address            : std_logic_vector(11 downto 0)  := (others => '0');
signal writedata          : std_logic_vector(31 downto 0)  := (others => '0');
signal readdata           : std_logic_vector(31 downto 0)  := (others => '0');
signal assert_chk         : std_logic_vector(31 downto 0)  := (others => '0');
signal test_ramp_pattern  : std_logic_vector(31 downto 0)  := x"12345678";


begin
  
   
 
-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/8;
end process; 
 
-- reset process
-- async_reset: process
  -- begin
    -- reset_n <= '0';
    -- wait for 100 ns;
    -- reset_n <= '1';
-- end process; 

comb: process
begin
  for i in 0 to 4023 loop
    writebyteenable_n <= std_logic_vector( unsigned(writebyteenable_n) + 1 );
    writedata <= test_ramp_pattern;
    address <= std_logic_vector( unsigned(address) + 1 );
    wait for 20 ns;
    writedata <= (others => '0');
    wait for 20 ns;
  end loop;
end process comb;

  
uut: raminfr_be  
  port map( 
    clk                => clk,
    reset_n            => reset_n,
    writebyteenable_n  => writebyteenable_n,
    address            => address,
    writedata          => writedata,
    readdata           => readdata
  );
end arch;