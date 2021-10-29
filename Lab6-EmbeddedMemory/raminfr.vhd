--------------------------------------------------------------------
--- Hasnain Akhtar
--- CPET - 561
--- raminfr.vhd
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity raminfr is
  port (
    clk       : in std_logic;
    reset_n   : in std_logic;
    write_n   : in std_logic;
    address   : in std_logic_vector(11 downto 0);
    writedata : in std_logic_vector(31 downto 0);

    readdata  : out std_logic_vector(31 downto 0)
   );
end entity raminfr;

architecture rtl of raminfr is

    type ram_type is array (4095 downto 0) OF std_logic_vector (31 downto 0);
    signal ram      : ram_type;
    signal read_addr: std_logic_vector(11 downto 0);
    
  begin
    
      RamBlock : process(clk)
      begin
        if (clk'event AND clk = '1') then
          if (reset_n = '0') then
            read_addr <= (others => '0');  
          elsif (write_n = '0') then
            RAM(conv_integer(address)) <= writedata;
          end if;
          read_addr <= address;
        end if;
      end process RamBlock;
      readdata <= ram(conv_integer(read_addr));

end architecture rtl;