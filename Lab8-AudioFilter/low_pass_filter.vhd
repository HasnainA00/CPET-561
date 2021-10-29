-------------------------------------------------------------------------
-- Author: Hasnain Akhtar
-- CPET-561-Lab6-Embedded Memory
-- Filename: low_pass_filter.vhd
-------------------------------------------------------------------------
LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
USE ieee.std_logic_signed.all; 

entity low_pass_filter is
  port (
    clk       : in std_logic;
    reset_n   : in std_logic;
    filter_en : in std_logic;
    data_in   : in signed(15 downto 0);
    data_out  : out signed(15 downto 0)
  );
  
end entity low_pass_filter;

architecture arch of low_pass_filter is
type coeficient_type is array(16 downto 0) of std_logic_vector(15 downto 0);
signal low_pass_coefficients : coeficient_type := 
                                  ( x"0052",
                                    x"00BB",
                                    x"01E2",
                                    x"0408",
                                    x"071B",
                                    x"0AAD",
                                    x"0E11",
                                    x"1080",
                                    x"1162",
                                    x"1080",
                                    x"0E11",
                                    x"0AAD",
                                    x"071B",
                                    x"0408",
                                    x"01E2",
                                    x"00BB",
                                    x"0052"
                                   ); 
type data_out_indiv is array(16 downto 0) of std_logic_vector(31 downto 0);
type data_in_indiv is array(16 downto 0) of std_logic_vector(15 downto 0);
signal data_out_sig : data_out_indiv;
signal data_main : data_in_indiv;
signal data_out_main : std_logic_vector(31 downto 0);
signal mult_result0 : std_logic_vector(31 downto 0);
signal mult_result1 : std_logic_vector(31 downto 0);
signal mult_result2 : std_logic_vector(31 downto 0);
signal mult_result3 : std_logic_vector(31 downto 0);
signal mult_result4 : std_logic_vector(31 downto 0);
signal mult_result5 : std_logic_vector(31 downto 0);
signal mult_result6 : std_logic_vector(31 downto 0);
signal mult_result7 : std_logic_vector(31 downto 0);
signal mult_result8 : std_logic_vector(31 downto 0);
signal mult_result9 : std_logic_vector(31 downto 0);
signal mult_result10 : std_logic_vector(31 downto 0);
signal mult_result11 : std_logic_vector(31 downto 0);
signal mult_result12 : std_logic_vector(31 downto 0);
signal mult_result13 : std_logic_vector(31 downto 0);
signal mult_result14 : std_logic_vector(31 downto 0);
signal mult_result15 : std_logic_vector(31 downto 0);
signal mult_result16 : std_logic_vector(31 downto 0);

  component multiplier is
    port(
      dataa   : IN std_logic_vector (15 DOWNTO 0);
      datab   : IN std_logic_vector (15 DOWNTO 0);
      result  : OUT std_logic_vector (31 DOWNTO 0)
    );
  end component multiplier;
  
  component enable_register is
    port (
    clk         : in std_logic;
    reset_n     : in std_logic;
    enable_in   : in std_logic;
    data_input  : in std_logic_vector(15 downto 0);
    data_output : out std_logic_vector(15 downto 0)
  );
  end component enable_register;

begin
  
  process(filter_en)
  begin
    data_main(0) <= std_logic_vector(data_in);
  end process;
  filter1 : enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(0),        data_output => data_main(1));
  filter2 : enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(1),        data_output => data_main(2));
  filter3 : enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(2),        data_output => data_main(3));
  filter4 : enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(3),        data_output => data_main(4));
  filter5 : enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(4),        data_output => data_main(5));
  filter6 : enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(5),        data_output => data_main(6));
  filter7 : enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(6),        data_output => data_main(7));
  filter8 : enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(7),        data_output => data_main(8));
  filter9 : enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(8),        data_output => data_main(9));
  filter10: enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(9),        data_output => data_main(10));
  filter11: enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(10),       data_output => data_main(11));
  filter12: enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(11),       data_output => data_main(12));
  filter13: enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(12),       data_output => data_main(13));
  filter14: enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(13),       data_output => data_main(14));
  filter15: enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(14),       data_output => data_main(15));
  filter16: enable_register port map ( clk  => clk, reset_n => reset_n, enable_in   => filter_en,    data_input  => data_main(15),       data_output => data_main(16));
  mult1   : multiplier     port map (dataa => data_main(0), datab       => low_pass_coefficients(0), result => mult_result0);
  mult2   : multiplier     port map (dataa => data_main(1), datab       => low_pass_coefficients(1), result => mult_result1);
  mult3   : multiplier     port map (dataa => data_main(2), datab       => low_pass_coefficients(2), result => mult_result2);
  mult4   : multiplier     port map (dataa => data_main(3), datab       => low_pass_coefficients(3), result => mult_result3);
  mult5   : multiplier     port map (dataa => data_main(4), datab       => low_pass_coefficients(4), result => mult_result4);
  mult6   : multiplier     port map (dataa => data_main(5), datab       => low_pass_coefficients(5), result => mult_result5);
  mult7   : multiplier     port map (dataa => data_main(6), datab       => low_pass_coefficients(6), result => mult_result6);
  mult8   : multiplier     port map (dataa => data_main(7), datab       => low_pass_coefficients(7), result => mult_result7);
  mult9   : multiplier     port map (dataa => data_main(8), datab       => low_pass_coefficients(8), result => mult_result8);
  mult10  : multiplier     port map (dataa => data_main(9), datab       => low_pass_coefficients(9), result => mult_result9);
  mult11  : multiplier     port map (dataa => data_main(10),datab       => low_pass_coefficients(10), result => mult_result10);
  mult12  : multiplier     port map (dataa => data_main(11),datab       => low_pass_coefficients(11), result => mult_result11);
  mult13  : multiplier     port map (dataa => data_main(12),datab       => low_pass_coefficients(12), result => mult_result12);
  mult14  : multiplier     port map (dataa => data_main(13),datab       => low_pass_coefficients(13), result => mult_result13);
  mult15  : multiplier     port map (dataa => data_main(14),datab       => low_pass_coefficients(14), result => mult_result14);
  mult16  : multiplier     port map (dataa => data_main(15),datab       => low_pass_coefficients(15), result => mult_result15);
  mult17  : multiplier     port map (dataa => data_main(16),datab       => low_pass_coefficients(16), result => mult_result16);
  
  data_out <= signed(data_out_main(31 downto 16));
  data_out_main <= mult_result0 + mult_result1 + mult_result2 + mult_result3 + mult_result4 + mult_result5 + mult_result6 + mult_result7 + mult_result8 + mult_result9 + mult_result10 + mult_result11 + mult_result12 + mult_result13 + mult_result14 + mult_result15 + mult_result16;
  
  
end arch;