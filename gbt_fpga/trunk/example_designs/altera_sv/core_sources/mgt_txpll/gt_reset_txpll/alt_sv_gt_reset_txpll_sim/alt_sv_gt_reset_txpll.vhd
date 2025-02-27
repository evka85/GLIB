-- alt_sv_gt_reset_txpll.vhd

-- Generated using ACDS version 13.1 162 at 2014.03.26.15:04:18

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alt_sv_gt_reset_txpll is
	port (
		clock         : in  std_logic                    := '0'; --         clock.clk
		reset         : in  std_logic                    := '0'; --         reset.reset
		pll_powerdown : out std_logic_vector(0 downto 0)         -- pll_powerdown.pll_powerdown
	);
end entity alt_sv_gt_reset_txpll;

architecture rtl of alt_sv_gt_reset_txpll is
	component altera_xcvr_reset_control is
		generic (
			CHANNELS              : integer := 1;
			PLLS                  : integer := 1;
			SYS_CLK_IN_MHZ        : integer := 250;
			SYNCHRONIZE_RESET     : integer := 1;
			REDUCED_SIM_TIME      : integer := 1;
			TX_PLL_ENABLE         : integer := 1;
			T_PLL_POWERDOWN       : integer := 1000;
			SYNCHRONIZE_PLL_RESET : integer := 0;
			TX_ENABLE             : integer := 1;
			TX_PER_CHANNEL        : integer := 0;
			T_TX_DIGITALRESET     : integer := 20;
			T_PLL_LOCK_HYST       : integer := 0;
			RX_ENABLE             : integer := 1;
			RX_PER_CHANNEL        : integer := 0;
			T_RX_ANALOGRESET      : integer := 40;
			T_RX_DIGITALRESET     : integer := 4000
		);
		port (
			clock              : in  std_logic                    := 'X';             -- clk
			reset              : in  std_logic                    := 'X';             -- reset
			pll_powerdown      : out std_logic_vector(0 downto 0);                    -- pll_powerdown
			tx_analogreset     : out std_logic_vector(0 downto 0);                    -- tx_analogreset
			tx_digitalreset    : out std_logic_vector(0 downto 0);                    -- tx_digitalreset
			tx_ready           : out std_logic_vector(0 downto 0);                    -- tx_ready
			pll_locked         : in  std_logic_vector(0 downto 0) := (others => 'X'); -- pll_locked
			pll_select         : in  std_logic_vector(0 downto 0) := (others => 'X'); -- pll_select
			tx_cal_busy        : in  std_logic_vector(0 downto 0) := (others => 'X'); -- tx_cal_busy
			tx_manual          : in  std_logic_vector(0 downto 0) := (others => 'X'); -- tx_reset_mode
			rx_analogreset     : out std_logic_vector(0 downto 0);                    -- rx_analogreset
			rx_digitalreset    : out std_logic_vector(0 downto 0);                    -- rx_digitalreset
			rx_ready           : out std_logic_vector(0 downto 0);                    -- rx_ready
			rx_is_lockedtodata : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_is_lockedtodata
			rx_cal_busy        : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_cal_busy
			rx_manual          : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_reset_mode
			tx_digitalreset_or : in  std_logic_vector(0 downto 0) := (others => 'X'); -- tx_digitalreset_or
			rx_digitalreset_or : in  std_logic_vector(0 downto 0) := (others => 'X')  -- rx_digitalreset_or
		);
	end component altera_xcvr_reset_control;

begin

	alt_sv_gt_reset_txpll_inst : component altera_xcvr_reset_control
		generic map (
			CHANNELS              => 1,
			PLLS                  => 1,
			SYS_CLK_IN_MHZ        => 120,
			SYNCHRONIZE_RESET     => 1,
			REDUCED_SIM_TIME      => 1,
			TX_PLL_ENABLE         => 1,
			T_PLL_POWERDOWN       => 1000,
			SYNCHRONIZE_PLL_RESET => 1,
			TX_ENABLE             => 0,
			TX_PER_CHANNEL        => 0,
			T_TX_DIGITALRESET     => 20,
			T_PLL_LOCK_HYST       => 0,
			RX_ENABLE             => 0,
			RX_PER_CHANNEL        => 0,
			T_RX_ANALOGRESET      => 40,
			T_RX_DIGITALRESET     => 4000
		)
		port map (
			clock              => clock,         --         clock.clk
			reset              => reset,         --         reset.reset
			pll_powerdown      => pll_powerdown, -- pll_powerdown.pll_powerdown
			tx_analogreset     => open,          --   (terminated)
			tx_digitalreset    => open,          --   (terminated)
			tx_ready           => open,          --   (terminated)
			pll_locked         => "0",           --   (terminated)
			pll_select         => "0",           --   (terminated)
			tx_cal_busy        => "0",           --   (terminated)
			tx_manual          => "1",           --   (terminated)
			rx_analogreset     => open,          --   (terminated)
			rx_digitalreset    => open,          --   (terminated)
			rx_ready           => open,          --   (terminated)
			rx_is_lockedtodata => "0",           --   (terminated)
			rx_cal_busy        => "0",           --   (terminated)
			rx_manual          => "0",           --   (terminated)
			tx_digitalreset_or => "0",           --   (terminated)
			rx_digitalreset_or => "0"            --   (terminated)
		);

end architecture rtl; -- of alt_sv_gt_reset_txpll
