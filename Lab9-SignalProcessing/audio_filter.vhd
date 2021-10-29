-------------------------------------------------------------------------
-- Authors: Hasnain Akhtar, Calvin Chen, Akshay Desai
-- CPET-561-Lab6-Embedded Memory
-- Filename: audio_filter.vhd
-------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity audio_filter is
	port(
		clk: in std_logic;
		reset_n: in std_logic;
		write: in std_logic;
		address: in std_logic;
		writedata: in std_logic_vector(15 downto 0);
		readdata: out std_logic_vector(15 downto 0);
		ext_addr_export: in std_logic_vector(9 downto 0); -- switch addresses
		ext_data_export: out std_logic_vector(9 downto 0); --switch reg stat
		invalid_export: in std_logic; 
		irq: out std_logic
		);
end entity audio_filter; 

architecture fir_arch of audio_filter is

		--multsigs
	signal multiply_result1:     std_logic_vector (31 downto 0); -- output for each multiplier
	signal multiply_result2:     std_logic_vector (31 downto 0);
	signal multiply_result3:     std_logic_vector (31 downto 0);
	signal multiply_result4:     std_logic_vector (31 downto 0);
	signal multiply_result5:     std_logic_vector (31 downto 0);
	signal multiply_result6:     std_logic_vector (31 downto 0);
	signal multiply_result7:     std_logic_vector (31 downto 0);
	signal multiply_result8:     std_logic_vector (31 downto 0);
	signal multiply_result9:     std_logic_vector (31 downto 0);
	signal multiply_result10:    std_logic_vector (31 downto 0);
	signal multiply_result11:    std_logic_vector (31 downto 0);
	signal multiply_result12:    std_logic_vector (31 downto 0);
	signal multiply_result13:    std_logic_vector (31 downto 0);
	signal multiply_result14:    std_logic_vector (31 downto 0);
	signal multiply_result15:    std_logic_vector (31 downto 0);
	signal multiply_result16:    std_logic_vector (31 downto 0);
	signal multiply_result17:    std_logic_vector (31 downto 0);
	signal multiply_result18:    std_logic_vector (31 downto 0);
	
	signal multiply_16_result1: std_logic_vector  (15 downto 0); -- output for each multiplier
	signal multiply_16_result2: std_logic_vector  (15 downto 0);
	signal multiply_16_result3: std_logic_vector  (15 downto 0);
	signal multiply_16_result4: std_logic_vector  (15 downto 0);
	signal multiply_16_result5: std_logic_vector  (15 downto 0);
	signal multiply_16_result6: std_logic_vector  (15 downto 0);
	signal multiply_16_result7: std_logic_vector  (15 downto 0);
	signal multiply_16_result8: std_logic_vector  (15 downto 0);
	signal multiply_16_result9: std_logic_vector  (15 downto 0);
	signal multiply_16_result10: std_logic_vector (15 downto 0);
	signal multiply_16_result11: std_logic_vector (15 downto 0);
	signal multiply_16_result12: std_logic_vector (15 downto 0);
	signal multiply_16_result13: std_logic_vector (15 downto 0);
	signal multiply_16_result14: std_logic_vector (15 downto 0);
	signal multiply_16_result15: std_logic_vector (15 downto 0);
	signal multiply_16_result16: std_logic_vector (15 downto 0);
	signal multiply_16_result17: std_logic_vector (15 downto 0);
	signal multiply_16_result18: std_logic_vector (15 downto 0);
	
	signal signed_add_result1  :std_logic_vector(15 downto 0) := x"0000"; 
	signal signed_add_result2  :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result3  :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result4  :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result5  :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result6  :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result7  :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result8  :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result9  :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result10 :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result11 :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result12 :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result13 :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result14 :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result15 :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result16 :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result17 :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result18 :std_logic_vector(15 downto 0) := x"0000";
	signal signed_add_result19 :std_logic_vector(15 downto 0) := x"0000";
	
		--ensigs
	signal en1_output: std_logic_vector  (15 downto 0)  := x"0000"; 
	signal en2_output: std_logic_vector  (15 downto 0)  := x"0000";
	signal en3_output: std_logic_vector  (15 downto 0)  := x"0000";
	signal en4_output: std_logic_vector  (15 downto 0)  := x"0000";
	signal en5_output: std_logic_vector  (15 downto 0)  := x"0000";
	signal en6_output: std_logic_vector  (15 downto 0)  := x"0000";
	signal en7_output: std_logic_vector  (15 downto 0)  := x"0000";
	signal en8_output: std_logic_vector  (15 downto 0)  := x"0000";
	signal en9_output: std_logic_vector  (15 downto 0)  := x"0000";
	signal en10_output: std_logic_vector (15 downto 0)  := x"0000";
	signal en11_output: std_logic_vector (15 downto 0)  := x"0000";
	signal en12_output: std_logic_vector (15 downto 0)  := x"0000";
	signal en13_output: std_logic_vector (15 downto 0)  := x"0000";
	signal en14_output: std_logic_vector (15 downto 0)  := x"0000";
	signal en15_output: std_logic_vector (15 downto 0)  := x"0000";
	signal en16_output: std_logic_vector (15 downto 0)  := x"0000";
	signal en17_output: std_logic_vector (15 downto 0)  := x"0000";
	signal en18_output: std_logic_vector (15 downto 0)  := x"0000";
	signal en19_output: std_logic_vector (15 downto 0)  := x"0000";
	
	--HPF
	constant HPm0:  std_logic_vector(15 downto 0) := x"003E"; 
	constant HPm1:  std_logic_vector(15 downto 0) := x"FF9A"; 
	constant HPm2:  std_logic_vector(15 downto 0) := x"FE9E"; 	
	constant HPm3:  std_logic_vector(15 downto 0) := x"0000"; 
	constant HPm4:  std_logic_vector(15 downto 0) := x"0536"; 
	constant HPm5:  std_logic_vector(15 downto 0) := x"05B2"; 
	constant HPm6:  std_logic_vector(15 downto 0) := x"F5AC";
	constant HPm7:  std_logic_vector(15 downto 0) := x"DAB7"; 
	constant HPm8:  std_logic_vector(15 downto 0) := x"4C92";
	constant HPm9:  std_logic_vector(15 downto 0) := x"DAB7"; 
	constant HPm10: std_logic_vector(15 downto 0) := x"F5AC"; 	
	constant HPm11: std_logic_vector(15 downto 0) := x"05B2"; 
	constant HPm12: std_logic_vector(15 downto 0) := x"0536"; 
	constant HPm13: std_logic_vector(15 downto 0) := x"0000"; 
	constant HPm14: std_logic_vector(15 downto 0) := x"FE9E"; 	
	constant HPm15: std_logic_vector(15 downto 0) := x"FF9A"; 
	constant HPm16: std_logic_vector(15 downto 0) := x"003E"; 
	--LPF
	constant LPm0:  std_logic_vector(15 downto 0) := x"0052"; 
	constant LPm1:  std_logic_vector(15 downto 0) := x"00BB"; 
	constant LPm2:  std_logic_vector(15 downto 0) := x"01E2"; 
	constant LPm3:  std_logic_vector(15 downto 0) := x"0408"; 
	constant LPm4:  std_logic_vector(15 downto 0) := x"071B"; 
	constant LPm5:  std_logic_vector(15 downto 0) := x"0AAD"; 
	constant LPm6:  std_logic_vector(15 downto 0) := x"0E11";
	constant LPm7:  std_logic_vector(15 downto 0) := x"1080"; 
	constant LPm8:  std_logic_vector(15 downto 0) := x"1162";
	constant LPm9:  std_logic_vector(15 downto 0) := x"1080"; 
	constant LPm10: std_logic_vector(15 downto 0) := x"0E11"; 	
	constant LPm11: std_logic_vector(15 downto 0) := x"0AAD"; 
	constant LPm12: std_logic_vector(15 downto 0) := x"071B"; 
	constant LPm13: std_logic_vector(15 downto 0) := x"0408"; 
	constant LPm14: std_logic_vector(15 downto 0) := x"01E2"; 	
	constant LPm15: std_logic_vector(15 downto 0) := x"00BB"; 
	constant LPm16: std_logic_vector(15 downto 0) := x"0052"; 
	
	component multiplier is
		port(
			dataa		: IN std_logic_vector (15 DOWNTO 0);
			datab		: IN std_logic_vector (15 DOWNTO 0);
			result	: OUT std_logic_vector (31 DOWNTO 0)
		);
	end component multiplier;
	
	component lpm_adder_16 is 
		port(
			dataa	: in std_logic_vector(15 downto 0);
			datab	: in std_logic_vector(15 downto 0);
			result : out std_logic_vector(15 downto 0)
		);
	end component lpm_adder_16;
	
	component filter_enable is
		port(
			clk: in std_logic;
			reset_n: in std_logic;
			data_in_en:in std_logic_vector(15 downto 0);
			filter_en:in std_logic;
			data_output_en: out std_logic_vector(15 downto 0)
		);
	end component filter_enable;
	
	component filter_enable_1bit is
		port(
			clk: in std_logic;
			reset_n: in std_logic;
			data_in_en:in std_logic;
			filter_en:in std_logic;
			data_output_en: out std_logic
		);
	end component filter_enable_1bit;

	--new sigs 
	type const_array is array (0 to 16) of std_logic_vector(15 downto 0);
	signal LPm_array: const_array; 
	signal HPm_array: const_array; 
	signal const_dataset: const_array;
	
	--mux1
	signal mux2data: std_logic;
	signal mux2sel: std_logic; 
	--mux2
	
	--register data
	signal data_prev:    std_logic_vector(15 downto 0);
	signal data_current: std_logic_vector(15 downto 0);
	
	--register sel
	signal sel_prev: 	 std_logic_vector(15 downto 0);
	signal sel_current: std_logic_vector(15 downto 0); --still a vector, output is 1 bit to select const array 	
	
	--register out sigs
	signal data_reg_output:std_logic_vector(15 downto 0); 
	signal sel_16: std_logic_vector(15 downto 0); 
	signal sel_reg_output:std_logic; 
	
	--export & interface signals
	signal internal_addr: std_logic_vector(3 downto 0); --addr for switches 
	signal ext_addr     : std_logic_vector(15 downto 0);
	signal ext_data     : std_logic_vector(15 downto 0); 
	
	begin
	
	addr_latch:process(clk, reset_n)
	begin
		if(reset_n = '0') then	
			internal_addr <= (others => '0');
		elsif (clk'event and clk = '1') then
			internal_addr <= ext_addr;
		end if;
	end process; 

	readdata <= signed_add_result16;
	
	demux0:process(address, write)
	begin
		case address is 
			when '0' =>
				mux2data <= write; --if issues directly pass a 1 to reg to do pulse to select reg
				mux2sel  <= '0';	
			when '1' =>
				mux2data <= '0';
				mux2sel  <= write; --if issues directly pass a 1 to reg to do pulse to select reg
		end case;
	end process; 
	
	data_reg: filter_enable
	port map(clk => clk,reset_n => reset_n,data_in_en => writedata,data_output_en => data_reg_output,filter_en => mux2data);
	
	sel_reg: filter_enable
	port map(clk => clk,reset_n => reset_n,data_in_en => writedata,data_output_en => sel_16,filter_en => mux2sel	);
	
	sel_reg_output <= sel_16(0); 
	
	const_array_sel: process(sel_reg_output)
	begin
		if(reset_n = '0') then
			const_dataset <= (others =>(others => '0'));
		elsif(sel_reg_output <= '0') then	
			const_dataset <= LPm_array;
		elsif (sel_reg_output <= '1') then 
			const_dataset <= HPm_array;
		end if;
	end process;
		

	mult_1: lpm_multiplier 
	port map (dataa => (data_reg_output),datab => (const_dataset(0)),result => multiply_result1);
	
	mult_2: lpm_multiplier 
	port map (dataa => (en1_output),datab => (const_dataset(1)),result => multiply_result2);
		
	mult_3: lpm_multiplier 
	port map (dataa => ( en2_output),datab => (const_dataset(2)),result => multiply_result3	);

	mult_4: lpm_multiplier 
	port map (dataa => ( en3_output),datab => (const_dataset(3)),result => multiply_result4);

	mult_5: lpm_multiplier 
	port map (dataa => ( en4_output),datab => (const_dataset(4)),result => multiply_result5
		);	
		
	mult_6: lpm_multiplier 
	port map (dataa => ( en5_output),datab => (const_dataset(5)),result => multiply_result6);
		
	mult_7: lpm_multiplier 
	port map (dataa => ( en6_output),datab => ( const_dataset(6)),result => multiply_result7);
		
	mult_8: lpm_multiplier 
	port map (dataa => ( en7_output),datab => (const_dataset(7)),result => multiply_result8);

	mult_9: lpm_multiplier 
	port map (dataa => ( en8_output),datab => (const_dataset(8)),result => multiply_result9	);

	mult_10: lpm_multiplier 
	port map (dataa => ( en9_output),datab => (const_dataset(9)),result => multiply_result10);
		
	mult_11: lpm_multiplier 
	port map (dataa => ( en10_output),datab => (const_dataset(10)),result => multiply_result11
		);	
		
	mult_12: lpm_multiplier
	port map (dataa => ( en11_output),datab => (const_dataset(11)),result => multiply_result12
		);		

	mult_13: lpm_multiplier 
	port map (dataa => ( en12_output),datab => (const_dataset(12)),result => multiply_result13);
		
	mult_14: lpm_multiplier 
	port map (dataa => ( en13_output),datab => (const_dataset(13)),result => multiply_result14);
	mult_15: lpm_multiplier 
	port map (dataa => ( en14_output),datab => (const_dataset(14)),result => multiply_result15);
	mult_16: lpm_multiplier 
	port map (dataa => ( en15_output),datab => (const_dataset(15)),result => multiply_result16);
	mult_17: lpm_multiplier 
	port map (dataa => ( en16_output),datab => (const_dataset(16)),result => multiply_result17);

	multiply_16_result1 <= multiply_result1 (30 downto 15);       
  multiply_16_result2 <= multiply_result2 (30 downto 15);
  multiply_16_result3 <= multiply_result3 (30 downto 15);	
	multiply_16_result4 <= multiply_result4 (30 downto 15);	
	multiply_16_result5 <= multiply_result5 (30 downto 15);	
	multiply_16_result6 <= multiply_result6 (30 downto 15);	
	multiply_16_result7 <= multiply_result7 (30 downto 15);	
	multiply_16_result8 <= multiply_result8 (30 downto 15);	
	multiply_16_result9 <= multiply_result9 (30 downto 15);	
	multiply_16_result10<= multiply_result10(30 downto 15);	
	multiply_16_result11<= multiply_result11(30 downto 15);	
	multiply_16_result12<= multiply_result12(30 downto 15);	
	multiply_16_result13<= multiply_result13(30 downto 15);	
	multiply_16_result14<= multiply_result14(30 downto 15);	
	multiply_16_result15<= multiply_result15(30 downto 15);	
	multiply_16_result16<= multiply_result16(30 downto 15);	
	multiply_16_result17<= multiply_result17(30 downto 15);	
	multiply_16_result18<= multiply_result18(30 downto 15);	
											  

	--Enables
	enable_1: filter_enable
	port map (clk => clk,reset_n => reset_n,data_in_en => data_reg_output,filter_en => write,data_output_en => en1_output);

	enable_2: filter_enable
	port map (clk => clk,reset_n => reset_n,data_in_en => en1_output,filter_en => write,data_output_en => en2_output);
			
	enable_3: filter_enable
	port map (clk => clk,reset_n => reset_n,data_in_en => en2_output,filter_en => write,data_output_en => en3_output);		
	
	enable_4: filter_enable
	port map (clk => clk,reset_n => reset_n,data_in_en => en3_output,filter_en => write,data_output_en => en4_output);	
	
	enable_5: filter_enable
	port map (clk => clk,reset_n => reset_n,data_in_en => en4_output,filter_en => write,data_output_en => en5_output);
	
	enable_6: filter_enable
	port map (clk => clk,reset_n => reset_n,data_in_en => en5_output,filter_en => write,data_output_en => en6_output);
			
	enable_7: filter_enable
	port map (clk => clk,reset_n => reset_n,data_in_en => en6_output,filter_en => write,data_output_en => en7_output);		
	
	enable_8: filter_enable
	port map (clk => clk,reset_n => reset_n,data_in_en => en7_output,filter_en => write,data_output_en => en8_output);	

	enable_9: filter_enable
	port map (clk => clk,reset_n => reset_n,data_in_en => en8_output,filter_en => write,data_output_en => en9_output);

	enable_10: filter_enable
	port map (clk => clk,reset_n => reset_n,data_in_en => en9_output,filter_en => write,data_output_en => en10_output);
			
	enable_11: filter_enable
	port map (clk => clk,reset_n => reset_n,data_in_en => en10_output,filter_en => write,data_output_en => en11_output);		
	
	enable_12: filter_enable
	port map (clk => clk,reset_n => reset_n,filter_en => write,data_in_en => en11_output,data_output_en => en12_output);	

	enable_13: filter_enable
	port map (clk => clk,reset_n => reset_n,filter_en => write,data_in_en => en12_output,data_output_en => en13_output);

	enable_14: filter_enable
	port map (clk => clk,reset_n => reset_n,filter_en => write,data_in_en => en13_output,data_output_en => en14_output);
			
	enable_15: filter_enable
	port map (clk => clk,reset_n => reset_n,filter_en => write,data_in_en => en14_output,data_output_en => en15_output);		
	
	enable_16: filter_enable
	port map (clk => clk,reset_n => reset_n,filter_en => write,data_in_en => en15_output,data_output_en => en16_output);	
		
	
	
	add1: lpm_adder_16 
	port map(dataa => multiply_16_result1,datab => multiply_16_result2,result => signed_add_result1);

	add2: lpm_adder_16 
	port map(dataa => signed_add_result1,datab => multiply_16_result3,result => signed_add_result2);
	
	add3: lpm_adder_16	
	port map(dataa => signed_add_result2,datab => multiply_16_result4,result => signed_add_result3);

	add4: lpm_adder_16	
	port map(dataa => signed_add_result3,datab => multiply_16_result5,result => signed_add_result4);
	
	add5: lpm_adder_16	
	port map(dataa => signed_add_result4,datab => multiply_16_result6,result => signed_add_result5);
	
	add6: lpm_adder_16	
	port map(dataa => signed_add_result5,datab => multiply_16_result7,result => signed_add_result6);
	
	add7: lpm_adder_16	
	port map(dataa => signed_add_result6,datab => multiply_16_result8,result => signed_add_result7);
	
	add8: lpm_adder_16	
	port map(dataa => signed_add_result7,datab => multiply_16_result9,result => signed_add_result8);
	
	add9: lpm_adder_16	
	port map(dataa => signed_add_result8,datab => multiply_16_result10,result => signed_add_result9);
	
	add10: lpm_adder_16	
	port map(dataa => signed_add_result9,datab => multiply_16_result11,result => signed_add_result10);
	
	
	add11: lpm_adder_16	
	port map(dataa => signed_add_result10,datab => multiply_16_result12,result => signed_add_result11);
	
	add12: lpm_adder_16	
	port map(dataa => signed_add_result11,datab => multiply_16_result13,result => signed_add_result12);
	
	add13: lpm_adder_16	
	port map(dataa => signed_add_result12,datab => multiply_16_result14,result => signed_add_result13);
	
	add14: lpm_adder_16	
	port map(dataa => signed_add_result13,datab => multiply_16_result15,result => signed_add_result14);
	
	add15: lpm_adder_16	
	port map(dataa => signed_add_result14,datab => multiply_16_result16,result => signed_add_result15);
	
	add16: lpm_adder_16	
	port map(dataa => signed_add_result15,datab => multiply_16_result17,result => signed_add_result16);
end fir_arch;