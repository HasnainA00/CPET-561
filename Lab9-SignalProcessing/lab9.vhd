-------------------------------------------------------------------------
-- Authors: Hasnain Akhtar, Calvin Chen, Akshay Desai
-- CPET-561-Lab6-Embedded Memory
-- Filename: lab9.vhd(Main Top file)
-------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY lab9 IS
    PORT (	
    ----- Audio -----
    AUD_ADCDAT  : in std_logic; 
    AUD_ADCLRCK : inout std_logic;
    AUD_BCLK    : inout std_logic;
    AUD_DACDAT  : out std_logic;
    AUD_DACLRCK : inout std_logic;
    AUD_XCK     : out std_logic;

    ----- CLOCK -----
    CLOCK_50  : in std_logic;
    CLOCK2_50 : in std_logic;
    CLOCK3_50 : in std_logic;
    CLOCK4_50 : in std_logic;

    ----- SDRAM -----
    DRAM_ADDR  : out std_logic_vector(12 downto 0);
    DRAM_BA    : out std_logic_vector(1 downto 0);
    DRAM_CAS_N : out std_logic;
    DRAM_CKE   : out std_logic;
    DRAM_CLK   : out std_logic;
    DRAM_CS_N  : out std_logic;
    DRAM_DQ    : inout std_logic_vector(15 downto 0);
    DRAM_LDQM  : out std_logic;
    DRAM_RAS_N : out std_logic;
    DRAM_UDQM  : out std_logic;
    DRAM_WE_N  : out std_logic;

    ----- I2C for Audio and Video-In -----
    FPGA_I2C_SCLK : out std_logic;
    FPGA_I2C_SDAT : inout std_logic;

    ----- SEG7 -----
    HEX0 : out std_logic_vector(6 downto 0);
    HEX1 : out std_logic_vector(6 downto 0);
    HEX2 : out std_logic_vector(6 downto 0);
    HEX3 : out std_logic_vector(6 downto 0);
    HEX4 : out std_logic_vector(6 downto 0);
    HEX5 : out std_logic_vector(6 downto 0);

    ----- KEY -----
    KEY : in std_logic_vector(3 downto 0);

    ----- LED -----
    LEDR : out  std_logic_vector(9 downto 0);

    ----- SW -----
    SW : in  std_logic_vector(9 downto 0);

    ----- GPIO_0, GPIO_0 connect to GPIO Default -----
    GPIO_0 : inout  std_logic_vector(35 downto 0);

    ----- GPIO_1, GPIO_1 connect to GPIO Default -----
    GPIO_1 : inout  std_logic_vector(35 downto 0)     
        );
END lab9;

architecture structure of lab9 is
	signal reset_n : std_logic;
	signal key0_d1 : std_logic;
	signal key0_d2 : std_logic;
	signal key0_d3 : std_logic;
	signal sw_d1   : std_logic_vector(9 downto 0);
	signal sw_d2   : std_logic_vector(9 downto 0);
--sig for write?

		component nios_system is
		port (
			AUD_ADCDAT_to_the_audio_0   : in    std_logic                     := 'X';             -- ADCDAT
			AUD_ADCLRCK_to_the_audio_0  : in    std_logic                     := 'X';             -- ADCLRCK
			AUD_BCLK_to_the_audio_0     : in    std_logic                     := 'X';             -- BCLK
			AUD_DACDAT_from_the_audio_0 : out   std_logic;                                        -- DACDAT
			AUD_DACLRCK_to_the_audio_0  : in    std_logic                     := 'X';             -- DACLRCK
			clk_clk                     : in    std_logic                     := 'X';             -- clk
			i2c_SDAT                    : inout std_logic                     := 'X';             -- SDAT
			i2c_SCLK                    : out   std_logic;                                        -- SCLK
			pin_export                  : out   std_logic;                                        -- export
			reset_reset                 : in    std_logic                     := 'X';             -- reset
			sdram_addr                  : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ba                    : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n                 : out   std_logic;                                        -- cas_n
			sdram_cke                   : out   std_logic;                                        -- cke
			sdram_cs_n                  : out   std_logic;                                        -- cs_n
			sdram_dq                    : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_dqm                   : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_ras_n                 : out   std_logic;                                        -- ras_n
			sdram_we_n                  : out   std_logic;                                        -- we_n
			sdram_clk_clk               : out   std_logic;                                        -- clk
			sw_export                   : in    std_logic_vector(7 downto 0)  := (others => 'X')  -- export
		);
	end component nios_system;

	
	signal DRAM_DQM : std_logic_vector(1 DOWNTO 0);
	signal int_AUD_BCLK  : std_logic;
	signal int_AUD_DACDAT  : std_logic;
	signal int_AUD_DACLRCK : std_logic;
	signal count           : std_logic_vector(3 downto 0);
	signal test_sig        : std_logic;

begin
	LEDR <= "1010101010";
	AUD_XCK <= count(1);
	
	reset_n <= not KEY(0);
   DRAM_UDQM <= DRAM_DQM(1);
	DRAM_LDQM <= DRAM_DQM(0);
   --int_AUD_BCLK <= AUD_BCLK;
 	GPIO_0(0) <= AUD_BCLK; 
	AUD_DACDAT <= int_AUD_DACDAT;
	GPIO_0(1) <= int_AUD_DACDAT;
   --int_AUD_DACLRCK <= AUD_DACLRCK;
 	GPIO_0(2) <= AUD_DACLRCK;   
	GPIO_0(3) <= test_sig; 	

	nios2: nios_system
		port map(
			AUD_ADCDAT_to_the_audio_0   => AUD_ADCDAT,   --     audio.ADCDAT
			AUD_ADCLRCK_to_the_audio_0  => AUD_ADCLRCK,  --          .ADCLRCK
			AUD_BCLK_to_the_audio_0     => AUD_BCLK,     --          .BCLK
			AUD_DACDAT_from_the_audio_0 => int_AUD_DACDAT, --          .DACDAT
			AUD_DACLRCK_to_the_audio_0  => AUD_DACLRCK,  --          .DACLRCK
			clk_clk                     => CLOCK2_50,                     --       clk.clk
			i2c_SDAT                    => FPGA_I2C_SDAT,                    --       i2c.SDAT
			i2c_SCLK                    => FPGA_I2C_SCLK,                    --          .SCLK
			pin_export                  => test_sig,                  --       pin.export
			reset_reset                 => reset_n,                 --     reset.reset
			sdram_addr                  => DRAM_ADDR,                  --     sdram.addr
			sdram_ba                    => DRAM_BA,                    --          .ba
			sdram_cas_n                 => DRAM_CAS_N,                 --          .cas_n
			sdram_cke                   => DRAM_CKE,                   --          .cke
			sdram_cs_n                  => DRAM_CS_N,                  --          .cs_n
			sdram_dq                    => DRAM_DQ,                    --          .dq
			sdram_dqm                   => DRAM_DQM,                   --          .dqm
			sdram_ras_n                 => DRAM_RAS_N,                 --          .ras_n
			sdram_we_n                  => DRAM_WE_N,                  --          .we_n
			sdram_clk_clk               => DRAM_CLK,               -- sdram_clk.clk
			sw_export                   => SW(7 downto 0)

	);

	clkgen: process(CLOCK2_50, reset_n) 
		begin
			if (reset_n = '1') then
				count <= "0000";
         elsif (rising_edge(CLOCK2_50)) then
            count <= count + 1;
			end if;
		end process;
		
end structure; 