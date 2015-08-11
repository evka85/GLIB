library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! xilinx packages
library unisim;
use unisim.vcomponents.all;

--! system packages
library work;
use work.system_flash_sram_package.all;
use work.system_pcie_package.all;
use work.system_package.all;
use work.fmc_package.all;
use work.wb_package.all;
use work.ipbus.all;

--! user packages
use work.user_package.all;
use work.user_version_package.all;

entity user_logic is
port(
    --================================--
    -- USER MGT REFCLKs
    --================================--
    -- BANK_112(Q0):
    clk125_1_p                  : in std_logic;
    clk125_1_n                  : in std_logic;
    cdce_out0_p                 : in std_logic;
    cdce_out0_n                 : in std_logic;
    -- BANK_113(Q1):
    fmc2_clk0_m2c_xpoint2_p     : in std_logic;
    fmc2_clk0_m2c_xpoint2_n     : in std_logic;
    cdce_out1_p                 : in std_logic; -- GTX clock speed must be 160 MHz
    cdce_out1_n                 : in std_logic; -- GTX clock speed must be 160 MHz
    -- BANK_114(Q2):
    pcie_clk_p                  : in std_logic;
    pcie_clk_n                  : in std_logic;
    cdce_out2_p                 : in std_logic;
    cdce_out2_n                 : in std_logic;
    -- BANK_115(Q3):
    clk125_2_i                  : in std_logic;
    fmc1_gbtclk1_m2c_p          : in std_logic;
    fmc1_gbtclk1_m2c_n          : in std_logic;
    -- BANK_116(Q4):
    fmc1_gbtclk0_m2c_p          : in std_logic;
    fmc1_gbtclk0_m2c_n          : in std_logic;
    cdce_out3_p                 : in std_logic;
    cdce_out3_n                 : in std_logic;
    --================================--
    -- USER FABRIC CLOCKS
    --================================--
    xpoint1_clk3_p              : in std_logic;
    xpoint1_clk3_n              : in std_logic;
    ------------------------------------
    cdce_out4_p                 : in std_logic;
    cdce_out4_n                 : in std_logic;
    ------------------------------------
    amc_tclkb_o                 : out std_logic;
    ------------------------------------
    fmc1_clk0_m2c_xpoint2_p     : in std_logic;
    fmc1_clk0_m2c_xpoint2_n     : in std_logic;
    fmc1_clk1_m2c_p             : in std_logic;
    fmc1_clk1_m2c_n             : in std_logic;
    fmc1_clk2_bidir_p           : in std_logic;
    fmc1_clk2_bidir_n           : in std_logic;
    fmc1_clk3_bidir_p           : in std_logic;
    fmc1_clk3_bidir_n           : in std_logic;
    ------------------------------------
    fmc2_clk1_m2c_p             : in std_logic;
    fmc2_clk1_m2c_n             : in std_logic;
    --================================--
    -- GBT PHASE MONITORING MGT REFCLK
    --================================--
    cdce_out0_gtxe1_o           : out std_logic;
    cdce_out3_gtxe1_o           : out std_logic;
    --================================--
    -- AMC PORTS
    --================================--
    amc_port_tx_p               : out std_logic_vector(1 to 15);
    amc_port_tx_n               : out std_logic_vector(1 to 15);
    amc_port_rx_p               : in std_logic_vector(1 to 15);
    amc_port_rx_n               : in std_logic_vector(1 to 15);
    ------------------------------------
    amc_port_tx_out             : out std_logic_vector(17 to 20);
    amc_port_tx_in              : in std_logic_vector(17 to 20);
    amc_port_tx_de              : out std_logic_vector(17 to 20);
    amc_port_rx_out             : out std_logic_vector(17 to 20);
    amc_port_rx_in              : in std_logic_vector(17 to 20);
    amc_port_rx_de              : out std_logic_vector(17 to 20);
    --================================--
    -- SFP QUAD
    --================================--
    sfp_tx_p                    : out std_logic_vector(1 to 4);
    sfp_tx_n                    : out std_logic_vector(1 to 4);
    sfp_rx_p                    : in std_logic_vector(1 to 4);
    sfp_rx_n                    : in std_logic_vector(1 to 4);
    sfp_mod_abs                 : in std_logic_vector(1 to 4);
    sfp_rxlos                   : in std_logic_vector(1 to 4);
    sfp_txfault                 : in std_logic_vector(1 to 4);
    --================================--
    -- FMC1
    --================================--
    fmc1_tx_p                   : out std_logic_vector(1 to 4);
    fmc1_tx_n                   : out std_logic_vector(1 to 4);
    fmc1_rx_p                   : in std_logic_vector(1 to 4);
    fmc1_rx_n                   : in std_logic_vector(1 to 4);
    ------------------------------------
    fmc1_io_pin                 : inout fmc_io_pin_type;
    ------------------------------------
    fmc1_clk_c2m_p              : out std_logic_vector(0 to 1);
    fmc1_clk_c2m_n              : out std_logic_vector(0 to 1);
    fmc1_present_l              : in std_logic;
    --================================--
    -- FMC2
    --================================--
    fmc2_io_pin                 : inout fmc_io_pin_type;
    ------------------------------------
    fmc2_clk_c2m_p              : out std_logic_vector(0 to 1);
    fmc2_clk_c2m_n              : out std_logic_vector(0 to 1);
    fmc2_present_l              : in std_logic;
    --================================--
    -- SYSTEM GBE
    --================================--
    sys_eth_amc_p1_tx_p         : in std_logic;
    sys_eth_amc_p1_tx_n         : in std_logic;
    sys_eth_amc_p1_rx_p         : out std_logic;
    sys_eth_amc_p1_rx_n         : out std_logic;
    ------------------------------------
    user_mac_syncacqstatus_i    : in std_logic_vector(0 to 3);
    user_mac_serdes_locked_i    : in std_logic_vector(0 to 3);
    --================================--
    -- SYSTEM PCIe
    --================================--
    sys_pcie_mgt_refclk_o       : out std_logic;
    user_sys_pcie_dma_clk_i     : in std_logic;
    ------------------------------------
    sys_pcie_amc_tx_p           : in std_logic_vector(0 to 3);
    sys_pcie_amc_tx_n           : in std_logic_vector(0 to 3);
    sys_pcie_amc_rx_p           : out std_logic_vector(0 to 3);
    sys_pcie_amc_rx_n           : out std_logic_vector(0 to 3);
    ------------------------------------
    user_sys_pcie_slv_o         : out R_slv_to_ezdma2;
    user_sys_pcie_slv_i         : in R_slv_from_ezdma2;
    user_sys_pcie_dma_o         : out R_userDma_to_ezdma2_array  (1 to 7);
    user_sys_pcie_dma_i         : in R_userDma_from_ezdma2_array(1 to 7);
    user_sys_pcie_int_o         : out R_int_to_ezdma2;
    user_sys_pcie_int_i         : in R_int_from_ezdma2;
    user_sys_pcie_cfg_i         : in R_cfg_from_ezdma2;
    --================================--
    -- SRAMs
    --================================--
    user_sram_control_o         : out userSramControlR_array(1 to 2);
    user_sram_addr_o            : out array_2x21bit;
    user_sram_wdata_o           : out array_2x36bit;
    user_sram_rdata_i           : in array_2x36bit;
    ------------------------------------
    sram1_bwa                   : out std_logic;
    sram1_bwb                   : out std_logic;
    sram1_bwc                   : out std_logic;
    sram1_bwd                   : out std_logic;
    sram2_bwa                   : out std_logic;
    sram2_bwb                   : out std_logic;
    sram2_bwc                   : out std_logic;
    sram2_bwd                   : out std_logic;
    --================================--
    -- CLK CIRCUITRY
    --================================--
    fpga_clkout_o               : out std_logic;
    ------------------------------------
    sec_clk_o                   : out std_logic;
    ------------------------------------
    user_cdce_locked_i          : in std_logic;
    user_cdce_sync_done_i       : in std_logic;
    user_cdce_sel_o             : out std_logic;
    user_cdce_sync_o            : out std_logic;
    --================================--
    -- USER BUS
    --================================--
    wb_miso_o                   : out wb_miso_bus_array(0 to number_of_wb_slaves-1);
    wb_mosi_i                   : in wb_mosi_bus_array(0 to number_of_wb_slaves-1);
    ------------------------------------
    ipb_clk_i                   : in std_logic;
    ipb_miso_o                  : out ipb_rbus_array(0 to number_of_ipb_slaves-1);
    ipb_mosi_i                  : in ipb_wbus_array(0 to number_of_ipb_slaves-1);
    --================================--
    -- VARIOUS
    --================================--
    reset_i                     : in std_logic;
    user_clk125_i               : in std_logic;
    user_clk200_i               : in std_logic;
    ------------------------------------
    sn                          : in std_logic_vector(7 downto 0);
    -------------------------------------
    amc_slot_i                  : in std_logic_vector( 3 downto 0);
    mac_addr_o                  : out std_logic_vector(47 downto 0);
    ip_addr_o                   : out std_logic_vector(31 downto 0);
    ------------------------------------
    user_v6_led_o               : out std_logic_vector(1 to 2)
);
end user_logic;

architecture user_logic_arch of user_logic is

    -- Global signals

    signal gtx_clk              : std_logic := '0';

    -- External signals

    signal ext_sbit             : std_logic := '0';

    -- GTX signals

    signal rx_error             : std_logic_vector(3 downto 0) := (others => '0');
    signal rx_kchar             : std_logic_vector(7 downto 0) := (others => '0');
    signal rx_data              : std_logic_vector(63 downto 0) := (others => '0');
    signal tx_kchar             : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_data              : std_logic_vector(63 downto 0) := (others => '0');

    -- Registers requests

    signal request_write        : array32(127 downto 0) := (others => (others => '0'));
    signal request_tri          : std_logic_vector(127 downto 0) := (others => '0');
    signal request_read         : array32(127 downto 0) := (others => (others => '0'));

    -- Trigger

    signal empty_trigger_fifo   : std_logic := '0';
    signal sbit_configuration   : std_logic_vector(2 downto 0) := (others => '0');
    signal ttc_trigger          : std_logic := '0';
    
    -- TTC
    signal ttc_reset            : std_logic := '0';
    signal ttc_reset_pwrup      : std_logic := '0';
    signal ttc_reset_ipb        : std_logic := '0';
    
    signal ttc_bcntres          : std_logic := '0';
    signal ttc_evcntres         : std_logic := '0';
    signal ttc_sinerrstr        : std_logic := '0';
    signal ttc_dberrstr         : std_logic := '0';
    signal ttc_brcst            : std_logic_vector(5 downto 0) := (others => '0');
    signal ttc_brcststr         : std_logic := '0';
    signal ttc_l1accept	        : std_logic := '0';
    signal ttc_clk              : std_logic := '0';
    signal ttc_ready            : std_logic := '0';

    signal bx_id                : std_logic_vector(11 downto 0) := (others => '0');
    signal orbit_id             : std_logic_vector(31 downto 0) := (others => '0');
    
    signal l1_led               : std_logic := '0';
    signal bc0_led              : std_logic := '0';

    -- Counters
    signal cnt_reset            : std_logic;
    signal cnt_ttc_trigger      : std_logic_vector(31 downto 0) := (others => '0');

    -- DAQ
    signal daq_reset            : std_logic := '0';
    signal daq_reset_pwrup      : std_logic := '0';
    signal daq_event_data       : std_logic_vector(63 downto 0) := (others => '0');
    signal daq_event_write_en   : std_logic := '0';
    signal daq_event_header     : std_logic := '0';
    signal daq_event_trailer    : std_logic := '0';
    signal daq_ready            : std_logic := '0';
    signal daq_almost_full      : std_logic := '0';
    signal daq_tts_state        : std_logic_vector(3 downto 0) := "1000";
    signal daq_gtx_clk          : std_logic;
    
    signal daq_state            : unsigned(3 downto 0) := (others => '0');
    signal daq_auto_reset_cnt   : std_logic_vector(15 downto 0) := (others => '0');
    signal daq_trigger          : std_logic := '0';
    signal daq_clock_locked     : std_logic := '0';
  
    --DAQ conf
    signal daq_auto_reset_enable: std_logic := '0';
    signal daq_ignore_daq_ready : std_logic := '0';
    signal daq_ipb_reset        : std_logic := '0';
    
    signal daq_clk25_bufg           : std_logic;
    signal daq_clk250_bufg      : std_logic;
    
    attribute MARK_DEBUG : string;
    attribute MARK_DEBUG of daq_reset : signal is "TRUE";
    attribute MARK_DEBUG of daq_reset_pwrup : signal is "TRUE";
    attribute MARK_DEBUG of daq_event_data : signal is "TRUE";
    attribute MARK_DEBUG of daq_event_write_en : signal is "TRUE";
    attribute MARK_DEBUG of daq_event_header : signal is "TRUE";
    attribute MARK_DEBUG of daq_event_trailer : signal is "TRUE";
    attribute MARK_DEBUG of daq_ready : signal is "TRUE";
    attribute MARK_DEBUG of daq_almost_full : signal is "TRUE";
    attribute MARK_DEBUG of daq_tts_state : signal is "TRUE";
    attribute MARK_DEBUG of daq_gtx_clk : signal is "TRUE";
    attribute MARK_DEBUG of daq_state : signal is "TRUE";
    attribute MARK_DEBUG of daq_auto_reset_cnt : signal is "TRUE";
    attribute MARK_DEBUG of daq_trigger : signal is "TRUE";
    attribute MARK_DEBUG of daq_clock_locked : signal is "TRUE";
    attribute MARK_DEBUG of daq_auto_reset_enable : signal is "TRUE";
    attribute MARK_DEBUG of daq_ignore_daq_ready : signal is "TRUE";
    attribute MARK_DEBUG of daq_ipb_reset : signal is "TRUE";
    attribute MARK_DEBUG of daq_clk25_bufg : signal is "TRUE";
    attribute MARK_DEBUG of daq_clk250_bufg : signal is "TRUE";
    attribute MARK_DEBUG of ttc_clk : signal is "TRUE";
    attribute MARK_DEBUG of user_clk125_i : signal is "TRUE";
    
begin

    --ip_addr_o <= x"c0a8007d";  -- c0a80073 = 192.168.0.115 -- 898A7392 = 137.138.115.146
    --mac_addr_o <= x"080030F100A0";  -- 08:00:30:F1:00:A0
    
    ip_addr_o <= x"c0a800a" & amc_slot_i;  -- 192.168.0.[160:175]
    mac_addr_o <= x"080030F100a" & amc_slot_i;  -- 08:00:30:F1:00:0[A0:AF]     
    
    user_v6_led_o(1) <= l1_led;
    user_v6_led_o(2) <= bc0_led;

    fmc1_io_pin.la_p(10) <= ext_sbit;

    --================================--
    -- GTX
    --================================--

    gtx_wrapper_inst : entity work.gtx_wrapper
    port map(
        gtx_clk_o       => gtx_clk,
        reset_i         => reset_i,
        rx_error_o      => rx_error,
        rx_kchar_o      => rx_kchar,
        rx_data_o       => rx_data,
        rx_n_i          => sfp_rx_n,
        rx_p_i          => sfp_rx_p,
        tx_kchar_i      => tx_kchar,
        tx_data_i       => tx_data,
        tx_n_o          => sfp_tx_n,
        tx_p_o          => sfp_tx_p,
        gtp_refclk_n_i  => cdce_out1_n,
        gtp_refclk_p_i  => cdce_out1_p
    );

    --================================--
    -- Tracking links
    --================================--

    link_tracking_0_inst : entity work.link_tracking
    port map(
        gtx_clk_i       => gtx_clk,
        ipb_clk_i       => ipb_clk_i,
        reset_i         => reset_i,
        rx_error_i      => rx_error(0),
        rx_kchar_i      => rx_kchar(1 downto 0),
        rx_data_i       => rx_data(15 downto 0),
        tx_kchar_o      => tx_kchar(1 downto 0),
        tx_data_o       => tx_data(15 downto 0),
        ipb_vi2c_i      => ipb_mosi_i(ipb_vi2c_0),
        ipb_vi2c_o      => ipb_miso_o(ipb_vi2c_0),
        ipb_track_i     => ipb_mosi_i(ipb_track_0),
        ipb_track_o     => ipb_miso_o(ipb_track_0),
        ipb_regs_i      => ipb_mosi_i(ipb_regs_0),
        ipb_regs_o      => ipb_miso_o(ipb_regs_0),
        ipb_info_i      => ipb_mosi_i(ipb_info_0),
        ipb_info_o      => ipb_miso_o(ipb_info_0),
        request_write_o => open,
        request_tri_o   => open,
        request_read_i  => request_read,
        trigger_i       => '0'
    );

    link_tracking_1_inst : entity work.link_tracking
    port map(
        gtx_clk_i       => gtx_clk,
        ipb_clk_i       => ipb_clk_i,
        reset_i         => reset_i,
        rx_error_i      => rx_error(1),
        rx_kchar_i      => rx_kchar(3 downto 2),
        rx_data_i       => rx_data(31 downto 16),
        tx_kchar_o      => tx_kchar(3 downto 2),
        tx_data_o       => tx_data(31 downto 16),
        ipb_vi2c_i      => ipb_mosi_i(ipb_vi2c_1),
        ipb_vi2c_o      => ipb_miso_o(ipb_vi2c_1),
        ipb_track_i     => ipb_mosi_i(ipb_track_1),
        ipb_track_o     => ipb_miso_o(ipb_track_1),
        ipb_regs_i      => ipb_mosi_i(ipb_regs_1),
        ipb_regs_o      => ipb_miso_o(ipb_regs_1),
        ipb_info_i      => ipb_mosi_i(ipb_info_1),
        ipb_info_o      => ipb_miso_o(ipb_info_1),
        request_write_o => request_write,
        request_tri_o   => request_tri,
        request_read_i  => request_read,
        trigger_i       => ttc_trigger
    );
    
    link_tracking_2_inst : entity work.link_tracking
    port map(
        gtx_clk_i       => gtx_clk,
        ipb_clk_i       => ipb_clk_i,
        reset_i         => reset_i,
        rx_error_i      => rx_error(2),
        rx_kchar_i      => rx_kchar(5 downto 4),
        rx_data_i       => rx_data(47 downto 32),
        tx_kchar_o      => tx_kchar(5 downto 4),
        tx_data_o       => tx_data(47 downto 32),
        ipb_vi2c_i      => ipb_mosi_i(ipb_vi2c_2),
        ipb_vi2c_o      => ipb_miso_o(ipb_vi2c_2),
        ipb_track_i     => ipb_mosi_i(ipb_track_2),
        ipb_track_o     => ipb_miso_o(ipb_track_2),
        ipb_regs_i      => ipb_mosi_i(ipb_regs_2),
        ipb_regs_o      => ipb_miso_o(ipb_regs_2),
        ipb_info_i      => ipb_mosi_i(ipb_info_2),
        ipb_info_o      => ipb_miso_o(ipb_info_2),
        request_write_o => open,
        request_tri_o   => open,
        request_read_i  => request_read,
        trigger_i       => '0'
    );

    --================================--
    -- Trigger links
    --================================--

    link_trigger_inst : entity work.link_trigger
    port map(
        gtx_clk_i       => gtx_clk,
        ipb_clk_i       => ipb_clk_i,
        reset_i         => reset_i,
        rx_error_i      => rx_error(3),
        rx_kchar_i      => rx_kchar(7 downto 6),
        rx_data_i       => rx_data(63 downto 48),
        tx_kchar_o      => tx_kchar(7 downto 6),
        tx_data_o       => tx_data(63 downto 48),
        ipb_trigger_i   => ipb_mosi_i(ipb_trigger),
        ipb_trigger_o   => ipb_miso_o(ipb_trigger),
        fifo_reset_i    => empty_trigger_fifo,
        sbit_config_i   => sbit_configuration,
        ext_sbit_o      => ext_sbit
    );
    
    --================================--
    -- TTC/TTT signal handling 	
    -- from ngFEC_logic.vhd (HCAL)
    --================================--
--    amc13_inst : entity work.amc13_top
--    port map(
--        ttc_clk_p  => xpoint1_clk3_p,
--        ttc_clk_n  => xpoint1_clk3_n,
--        ttc_data_p => amc_port_rx_p(3),
--        ttc_data_n => amc_port_rx_n(3),
--        ttc_clk    => ttc_clk,
--        ttcready   => open,
--        l1accept   => ttc_l1accept,
--        bcntres    => ttc_bcntres,
--        evcntres   => ttc_evcntres, 
--        sinerrstr  => ttc_sinerrstr,
--        dberrstr   => ttc_dberrstr,
--        brcststr   => ttc_brcststr,
--        brcst      => ttc_brcst
--    );    

    --================================--
    -- TTC/TTT signal handling 	
    --================================--
    ttc_decoder_i : entity work.TTC_decoder
    port map(
        TTC_CLK_p   => xpoint1_clk3_p,
        TTC_CLK_n   => xpoint1_clk3_n,
        TTC_rst     => ttc_reset,
        TTC_data_p  => amc_port_rx_p(3),
        TTC_data_n  => amc_port_rx_n(3),
        TTC_CLK_out => ttc_clk,
        TTCready    => ttc_ready,
        L1Accept    => ttc_l1accept,
        BCntRes     => ttc_bcntres,
        EvCntRes    => ttc_evcntres,
        SinErrStr   => ttc_sinerrstr,
        DbErrStr    => ttc_dberrstr,
        BrcstStr    => ttc_brcststr,
        Brcst       => ttc_brcst
    );

    -- TTC reset after powerup
    
    ttc_reset <= ttc_reset_pwrup or ttc_reset_ipb;

    process(user_clk125_i)
        variable countdown : integer := 60_000_000; -- hold in reset for 0.5 second after powerup - way too long, but who cares
    begin
        if (rising_edge(user_clk125_i)) then
            if (countdown > 0) then
              ttc_reset_pwrup <= '1';
              countdown := countdown - 1;
            else
              ttc_reset_pwrup <= '0';
            end if;
        end if;
    end process;
    
    -- TTC clock LED
    
    process(ttc_clk)
        variable led_countdown : integer := 0;
    begin
        if (rising_edge(ttc_clk)) then
            if (led_countdown < 2_500_000) then
                bc0_led <= '0';
            else
                bc0_led <= '1';
            end if;
            
            if (led_countdown = 5_000_000) then
                led_countdown := 0;
            else
                led_countdown := led_countdown + 1;
            end if;
        end if;
    end process;
    
    -- L1A
    
    process(ttc_clk)
        variable led_countdown : integer := 0;
    begin
        if (rising_edge(ttc_clk)) then
            if (led_countdown > 0) then
                l1_led <= '1';
            else
                l1_led <= '0';
            end if;
            
            if (ttc_l1accept = '1') then
                cnt_ttc_trigger <= std_logic_vector(unsigned(cnt_ttc_trigger) + 1);
                led_countdown := 400_000;
            elsif (led_countdown > 0) then
                led_countdown := led_countdown - 1;
            else
                led_countdown := 0;
            end if;
        end if;
    end process;
        
    clock_bridge_trigger_inst : entity work.clock_bridge_simple
    port map(
        reset_i     => '0',
        m_clk_i     => ttc_clk,
        m_en_i      => ttc_l1accept,
        s_clk_i     => gtx_clk,
        s_en_o      => ttc_trigger
    );

    -- BC0
    
    process(ttc_clk)
        variable led_countdown : integer := 0;
    begin
        if (rising_edge(ttc_clk)) then
--            if (led_countdown > 0) then
--                bc0_led <= '1';
--            else
--                bc0_led <= '0';
--            end if;
            
            if (ttc_bcntres = '1') then
                bx_id <= (others => '0');
                orbit_id <= std_logic_vector(unsigned(orbit_id) + 1);
                led_countdown := 400_000;
            elsif (led_countdown > 0) then
                bx_id <= std_logic_vector(unsigned(bx_id) + 1);
                led_countdown := led_countdown - 1;
            else
                led_countdown := 0;
            end if;
        end if;
    end process;
    
    -- EC0
    
--    process(ttc_clk)
--    begin
--        if (rising_edge(ttc_clk)) then
--            if (ttc_evcntres = '1') then
--                cnt_ttc_trigger <= (others => '0');
--                orbit_id <= (others => '0');
--            end if;
--        end if;
--    end process;
    
    -- TTS
    
    daq_tts_state <= "1000";
    
    clock_bridge_daq_trigger_inst : entity work.clock_bridge_simple
    port map(
        reset_i     => '0',
        m_clk_i     => ttc_clk,
        m_en_i      => ttc_l1accept,
        s_clk_i     => daq_clk25_bufg,
        s_en_o      => daq_trigger
    );
    
    -- fake DAQ data on L1A
    process(daq_clk25_bufg)
    begin
        if (rising_edge(daq_clk25_bufg)) then
            -- start the fake event state machine
            if (daq_trigger = '1' and daq_state = x"0" and (daq_ready = '1' or daq_ignore_daq_ready = '1') and daq_almost_full = '0') then
                daq_state <= x"1";
            end if;
            
            -- state machine for sending one fake event packets
            if (daq_state > x"0") then
                if (daq_state = x"1") then    -- send the first header
                    daq_event_data <= x"00" & cnt_ttc_trigger(23 downto 0) & bx_id & x"00004";
                    daq_event_header <= '1';
                    daq_event_trailer <= '0';
                    daq_event_write_en <= '1';
                    daq_state <= x"2";
                elsif (daq_state = x"2") then -- send the second header
                    daq_event_data <= x"00000000" & orbit_id(15 downto 0) & x"00" & sn;
                    daq_event_header <= '0';
                    daq_event_trailer <= '0';
                    daq_event_write_en <= '1';
                    daq_state <= x"3";
                elsif (daq_state = x"3") then -- send the payload
                    daq_event_data <= x"BAADF00D" & x"BAADCAFE";
                    daq_event_header <= '0';
                    daq_event_trailer <= '0';
                    daq_event_write_en <= '1';
                    daq_state <= x"4";
                elsif (daq_state = x"4") then -- send trailer
                    daq_event_data <= x"00000000" & cnt_ttc_trigger(7 downto 0) & x"0" & x"00004";
                    daq_event_header <= '0';
                    daq_event_trailer <= '1';
                    daq_event_write_en <= '1';
                    daq_state <= x"0";
                else -- hmm
                    daq_state <= x"0";
                end if;
            elsif (daq_state = x"0") then -- zero out everything, especially the write enable :)
                daq_event_data <= (others => '0');
                daq_event_header <= '0';
                daq_event_trailer <= '0';
                daq_event_write_en <= '0';
            end if;
            
        end if;
    end process;

    --================================--
    -- DAQ Link
    --================================--

    -- DAQ reset after powerup
    
    daq_reset <= daq_reset_pwrup or daq_ipb_reset;
    
    process(ttc_clk)
        variable countdown : integer := 40_000_000; -- way too long, but who cares (this is only used after powerup)
    begin
        if (rising_edge(ttc_clk)) then
            if (countdown > 0) then
              daq_reset_pwrup <= '1';
              countdown := countdown - 1;
            else
              daq_reset_pwrup <= '0';
            end if;
        end if;
    end process;

    -- DAQ clocks
    
    clknetwork : entity work.daq_clocks
    port map
    (
        CLK_IN1            => user_clk125_i,
        CLK_OUT1           => daq_clk25_bufg,
        CLK_OUT2           => daq_clk250_bufg,
        RESET              => '0',
        LOCKED             => daq_clock_locked
    );

    
--    clk_125Mhz_bufg : BUFG
--    port map
--    (
--        I                               =>      clk125_2_i,
--        O                               =>      clk125_2_i_bufg
--    );

    -- check frequency of all clocks
    process(daq_gtx_clk)
        variable last_daq_clk   : std_logic := '0';
        variable daq_clk_length : unsigned(7 downto 0) := (others => '0');
        variable last_ttc_clk   : std_logic := '0';
        variable ttc_clk_length : unsigned(7 downto 0) := (others => '0');
    begin
        if (rising_edge(daq_gtx_clk)) then
            if (daq_clk25_bufg = last_daq_clk) then
                daq_clk_length := daq_clk_length + 1;
            else
                request_read(6) <= x"000000" & std_logic_vector(daq_clk_length);
                daq_clk_length := (others => '0');
                last_daq_clk := daq_clk25_bufg;
            end if;
            if (ttc_clk = last_ttc_clk) then
                ttc_clk_length := ttc_clk_length + 1;
            else
                request_read(7) <= x"000000" & std_logic_vector(ttc_clk_length);
                ttc_clk_length := (others => '0');
                last_ttc_clk := ttc_clk;
            end if;            
        end if;
    end process;

    -- DAQ Link instantiation
    daq_link : entity work.daqlink_wrapper
    port map(
        RESET_IN              => daq_reset,
        MGT_REF_CLK_IN        => clk125_2_i,
        GTX_TXN_OUT           => amc_port_tx_n(1),
        GTX_TXP_OUT           => amc_port_tx_p(1),
        GTX_RXN_IN            => amc_port_rx_n(1),
        GTX_RXP_IN            => amc_port_rx_p(1),
        DATA_CLK_IN           => daq_clk25_bufg,
        EVENT_DATA_IN         => daq_event_data,
        EVENT_DATA_HEADER_IN  => daq_event_header,
        EVENT_DATA_TRAILER_IN => daq_event_trailer,
        DATA_WRITE_EN_IN      => daq_event_write_en,
        READY_OUT             => daq_ready,
        ALMOST_FULL_OUT       => daq_almost_full,
        TTS_CLK_IN            => ttc_clk,
        TTS_STATE_IN          => daq_tts_state,
        AUTO_RESET_ENABLE     => daq_auto_reset_enable,
        AUTO_RESET_COUNT_OUT  => daq_auto_reset_cnt,
        GTX_CLK_OUT           => daq_gtx_clk
    );

    --================================--
    -- Register mapping
    --================================--

    -- Empty trigger fifo

    empty_trigger_fifo <= request_tri(0);

    -- S Bits configuration : 0 -- read / write _ Controls the Sbits to send to the TDC

    sbit_configuration_reg : entity work.reg port map(fabric_clk_i => ipb_clk_i, reset_i => reset_i, wbus_i => request_write(1), wbus_t => request_tri(1), rbus_o => request_read(1));
    sbit_configuration <= request_read(1)(2 downto 0);

    -- Counters reset
    cnt_reset <= request_tri(2);
    
	-- TTC trigger counter
    --?ttc_trigger_counter : entity work.counter port map(fabric_clk_i => gtx_clk, reset_i => cnt_reset, en_i => ttc_trigger, data_o => cnt_ttc_trigger);
    request_read(3) <= cnt_ttc_trigger;
	 
	request_read(4) <= daq_auto_reset_cnt & x"00" & "00" & ttc_ready & daq_clock_locked & daq_auto_reset_enable & daq_ignore_daq_ready & daq_almost_full & daq_ready;
    
    daq_config_reg : entity work.reg port map(fabric_clk_i => ipb_clk_i, reset_i => reset_i, wbus_i => request_write(5), wbus_t => request_tri(5), rbus_o => request_read(5));
    ttc_reset_ipb <= request_read(5)(3);
    daq_ipb_reset <= request_read(5)(2);
    daq_auto_reset_enable <= request_read(5)(1);
    daq_ignore_daq_ready <= request_read(5)(0);

end user_logic_arch;
