--------------------------------------------------------------------
--- Hasnain Akhtar
--- CPET - 561
--- raminfr_be.vhd
-----------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity raminfr_be is
  port (
    clk       : in std_logic;
    reset_n   : in std_logic;
    writebyteenable_n : in std_logic_vector(3 downto 0);
    address   : in std_logic_vector(11 downto 0);
    writedata : in std_logic_vector(31 downto 0);

    readdata  : out std_logic_vector(31 downto 0)
   );
end entity raminfr_be;

architecture rtl of raminfr_be is

  type ram_type is array (4095 downto 0) OF std_logic_vector (31 downto 0);
  signal RAM : ram_type;
  signal ram1 : std_logic_vector(7 downto 0) := "00000000"; 
  signal ram2 : std_logic_vector(7 downto 0) := "00000000"; 
  signal ram3 : std_logic_vector(7 downto 0) := "00000000"; 
  signal ram4 : std_logic_vector(7 downto 0) := "00000000"; 
  signal read_addr : std_logic_vector(11 downto 0);
  
begin

  RamBlock : process(clk) 
  begin
    if (clk'event AND clk = '1') then
      if (reset_n = '0') then
        read_addr <= (others => '0');
      end if;
      if (writebyteenable_n(0) = '0') then
        ram1 <= writedata(7 downto 0);
      end if;
      if (writebyteenable_n(1) = '0') then
        ram2 <= writedata(15 downto 8);
      end if;
      if (writebyteenable_n(2) = '0') then
        ram3 <= writedata(23 downto 16);
      end if;
      if (writebyteenable_n(3) = '0') then
        ram4 <= writedata(31 downto 24);
      end if;
        read_addr <= address;
        RAM(conv_integer(address)) <= ram4 & ram3 & ram2 & ram1;
    end if;
  end process RamBlock;
  readdata <= RAM(conv_integer(read_addr));
end ARCHITECTURE rtl;