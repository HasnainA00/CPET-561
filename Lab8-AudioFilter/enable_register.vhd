-------------------------------------------------------------------------
-- Author: Hasnain Akhtar
-- CPET-561-Lab6-Embedded Memory
-- Filename: enable_register.vhd
-------------------------------------------------------------------------
LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all; 
USE ieee.std_logic_signed.all; 

entity enable_register is
  port (
    clk         : in std_logic;
    reset_n     : in std_logic;
    enable_in   : in std_logic;
    data_input  : in std_logic_vector(15 downto 0);
    data_output : out std_logic_vector(15 downto 0)
  );
end entity enable_register;

architecture en of enable_register is

begin
  
  process(clk)
  begin
    if(rising_edge(clk)) then
      if(reset_n = '0') then
        data_output <= (others => '0');
      elsif(enable_in = '1') then
        data_output <= data_input;
      end if;
    end if;
  end process;
  
end en;