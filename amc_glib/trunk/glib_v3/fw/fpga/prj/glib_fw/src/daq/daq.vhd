----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Evaldas Juska (Evaldas.Juska@cern.ch)
-- 
-- Create Date:    20:18:40 09/17/2015 
-- Design Name: 
-- Module Name:    daq - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.system_package.all;
use work.user_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity daq is
port(

    -- Reset
    reset_i                     : in std_logic;
    soft_reset_i                : in std_logic;
    resync_i                    : in std_logic;

    -- Clocks
    mgt_ref_clk125_i            : in std_logic;
    clk125_i                    : in std_logic;

    -- Pins
    daq_gtx_tx_pin_p            : out std_logic; 
    daq_gtx_tx_pin_n            : out std_logic; 
    daq_gtx_rx_pin_p            : in std_logic; 
    daq_gtx_rx_pin_n            : in std_logic; 

    -- TTC
    ttc_ready_i                 : in std_logic;
    ttc_clk_i                   : in std_logic;
    ttc_l1a_i                   : in std_logic;
    ttc_bc0_i                   : in std_logic;
    ttc_ec0_i                   : in std_logic;
    ttc_bx_id_i                 : in std_logic_vector(11 downto 0);
    ttc_orbit_id_i              : in std_logic_vector(15 downto 0);
    ttc_l1a_id_i                : in std_logic_vector(23 downto 0);

    -- Track data
    track_rx_clk_i              : in std_logic;
    track_rx_en_i               : in std_logic_vector(2 downto 0);
    track_rx_data_i             : in std_logic_vector(223 downto 0);
--    track_rx_data_i             : in track_data;
    
    -- Monitoring and control
    daq_status1_reg_o           : out std_logic_vector(31 downto 0);
    daq_status2_reg_o           : out std_logic_vector(31 downto 0);
    daq_config_reg_i            : in std_logic_vector(31 downto 0);
    gtx_disper_err_cnt_o        : out std_logic_vector(31 downto 0);
    gtx_notintable_err_cnt_o    : out std_logic_vector(31 downto 0);
    cnt_reset_i                 : in std_logic;
    
    -- Other
    board_sn_i                  : in std_logic_vector(7 downto 0) -- board serial ID, needed for the header to AMC13
    
);
end daq;

architecture Behavioral of daq is
    -- Constants (should be moved to package)
    constant vfat_block_marker    : std_logic_vector(47 downto 0) := x"a000c000e000";

    -- Reset
    signal daq_reset            : std_logic := '1';
    signal fifo_reset           : std_logic := '1';
    signal reset_pwrup          : std_logic := '1';

    -- DAQlink
    signal daq_event_data       : std_logic_vector(63 downto 0) := (others => '0');
    signal daq_event_write_en   : std_logic := '0';
    signal daq_event_header     : std_logic := '0';
    signal daq_event_trailer    : std_logic := '0';
    signal daq_ready            : std_logic := '0';
    signal daq_almost_full      : std_logic := '0';
    signal daq_tts_state        : std_logic_vector(3 downto 0) := "1000";
    signal daq_gtx_clk          : std_logic;
    
    signal daq_trigger          : std_logic := '0';
    signal daq_clock_locked     : std_logic := '0';
  
    signal daq_disper_err_cnt   : std_logic_vector(15 downto 0) := (others => '0');
    signal daq_notintable_err_cnt: std_logic_vector(15 downto 0) := (others => '0');
    
    -- DAQ conf
    signal daq_enable           : std_logic := '1'; -- enable sending data to DAQ on L1A
    
    -- DAQ counters
    signal sent_event_cnt       : std_logic_vector(23 downto 0) := (others => '0');
    signal corrupted_vfat_cnt   : std_logic_vector(31 downto 0) := (others => '0');

    -- DAQ event sending state machine
    signal daq_state            : unsigned(3 downto 0) := (others => '0');
    signal daq_curr_vfat_block  : unsigned(11 downto 0) := (others => '0');
    signal daq_curr_block_word  : integer range 0 to 2 := 0;

    
    -- DAQ global state
    signal oos_glib_vfat        : std_logic := '0'; -- GLIB is out of sync with vfat(s)
    signal oos_glib_oh          : std_logic := '0'; -- GLIB is out of sync with OH
    signal oos_oh_vfat          : std_logic := '0'; -- OH is out of sync with vfat(s)
    signal input_fifo_full      : std_logic := '0';
    signal input_fifo_near_full : std_logic := '0';
    signal input_fifo_underflow : std_logic := '0'; -- Tried to read too many blocks from the input fifo when sending events to the DAQlink (indicates a problem in the vfat block counter)
    signal event_fifo_full      : std_logic := '0';
    signal event_fifo_near_full : std_logic := '0';
    signal corrupted_vfat_data  : std_logic := '0'; -- detected at least one invalid VFAT block
    signal event_too_big        : std_logic := '0'; -- detected an event with too many VFAT blocks (more than 4095 blocks!)
    signal event_bigger_than_24 : std_logic := '0'; -- there was an event which had more than 24 VFAT blocks
    
    signal daq_critical_error   : std_logic := '0'; -- critical error detected - NEED RESET
    
    -- Input FIFO
    signal infifo_din           : std_logic_vector(191 downto 0) := (others => '0');
    signal infifo_dout          : std_logic_vector(191 downto 0) := (others => '0');
    signal infifo_rd_en         : std_logic := '0';
    signal infifo_wr_en         : std_logic := '0';
    signal infifo_full          : std_logic := '0';
    signal infifo_almost_full   : std_logic := '0';
    signal infifo_empty         : std_logic := '0';
    signal infifo_almost_empty  : std_logic := '0';
    signal infifo_valid         : std_logic := '0';
    signal infifo_underflow     : std_logic := '0';

    -- Event FIFO
    signal evtfifo_din          : std_logic_vector(59 downto 0) := (others => '0');
    signal evtfifo_dout         : std_logic_vector(59 downto 0) := (others => '0');
    signal evtfifo_rd_en        : std_logic := '0';
    signal evtfifo_wr_en        : std_logic := '0';
    signal evtfifo_almost_full  : std_logic := '0';
    signal evtfifo_full         : std_logic := '0';
    signal evtfifo_empty        : std_logic := '0';
    signal evtfifo_valid        : std_logic := '0';
    signal evtfifo_underflow    : std_logic := '0';

    -- Event builder
    signal eb_last_ec            : std_logic_vector(7 downto 0) := (others => '0');
    signal eb_last_bc            : std_logic_vector(11 downto 0) := (others => '0');
    signal eb_last_oh_bc         : std_logic_vector(31 downto 0) := (others => '0');
    signal eb_first_block        : std_logic := '1'; -- it's the first ever event
    signal eb_event_num          : unsigned(23 downto 0) := x"000001";
    signal eb_event_num_short    : unsigned(7 downto 0) := x"00"; -- used to double check with VFAT EC
    
    -- Clocks
    signal daq_clk_bufg          : std_logic;
    
    -- Test
    signal last_rx_data          : std_logic_vector(255 downto 0) := (others => '0');
    
    
    -- Debug flags for ChipScope
    attribute MARK_DEBUG : string;
    attribute MARK_DEBUG of daq_reset : signal is "TRUE";
    attribute MARK_DEBUG of daq_gtx_clk : signal is "TRUE";
    attribute MARK_DEBUG of daq_clk_bufg : signal is "TRUE";

    attribute MARK_DEBUG of track_rx_clk_i : signal is "TRUE";
    attribute MARK_DEBUG of track_rx_en_i : signal is "TRUE";
    attribute MARK_DEBUG of track_rx_data_i : signal is "TRUE";

    attribute MARK_DEBUG of infifo_din : signal is "TRUE";
    attribute MARK_DEBUG of infifo_dout : signal is "TRUE";
    attribute MARK_DEBUG of infifo_rd_en : signal is "TRUE";
    attribute MARK_DEBUG of infifo_wr_en : signal is "TRUE";
    attribute MARK_DEBUG of infifo_full : signal is "TRUE";
    attribute MARK_DEBUG of infifo_empty : signal is "TRUE";
    attribute MARK_DEBUG of infifo_valid : signal is "TRUE";
    attribute MARK_DEBUG of infifo_underflow : signal is "TRUE";
    
    attribute MARK_DEBUG of evtfifo_din : signal is "TRUE";
    attribute MARK_DEBUG of evtfifo_dout : signal is "TRUE";
    attribute MARK_DEBUG of evtfifo_rd_en : signal is "TRUE";
    attribute MARK_DEBUG of evtfifo_wr_en : signal is "TRUE";
    attribute MARK_DEBUG of evtfifo_full : signal is "TRUE";
    attribute MARK_DEBUG of evtfifo_empty : signal is "TRUE";
    attribute MARK_DEBUG of evtfifo_valid : signal is "TRUE";
    attribute MARK_DEBUG of evtfifo_underflow : signal is "TRUE";
    
    attribute MARK_DEBUG of eb_last_ec : signal is "TRUE";
    attribute MARK_DEBUG of eb_last_bc : signal is "TRUE";
    attribute MARK_DEBUG of eb_last_oh_bc : signal is "TRUE";
    attribute MARK_DEBUG of eb_first_block : signal is "TRUE";
    attribute MARK_DEBUG of eb_event_num_short : signal is "TRUE";
    attribute MARK_DEBUG of corrupted_vfat_data : signal is "TRUE";
    attribute MARK_DEBUG of daq_state : signal is "TRUE";
    attribute MARK_DEBUG of daq_curr_vfat_block : signal is "TRUE";
    attribute MARK_DEBUG of daq_curr_block_word : signal is "TRUE";

begin

    --================================--
    -- TTS
    --================================--
    
    daq_critical_error <= event_too_big or event_fifo_full or input_fifo_underflow or input_fifo_full;
    daq_tts_state <= x"8" when (daq_critical_error = '0') else x"c"; -- for now READY all the time but ERROR when daq_critical_error = '1'
    
    --================================--
    -- DAQ clocks
    --================================--
    
    daq_clocks : entity work.daq_clocks
    port map
    (
        CLK_IN1            => clk125_i,
        CLK_OUT1           => daq_clk_bufg, -- 25MHz
        CLK_OUT2           => open, -- 250MHz, not used
        RESET              => '0',
        LOCKED             => daq_clock_locked
    );    
    
    --================================--
    -- Signal transfer between clock domains (note that the L1A is only needed in the DAQ clock domain if we use fake data)
    --================================--
    clock_bridge_daq_trigger_inst : entity work.clock_bridge_simple
    port map(
        reset_i     => '0',
        m_clk_i     => ttc_clk_i,
        m_en_i      => ttc_l1a_i,
        s_clk_i     => daq_clk_bufg,
        s_en_o      => daq_trigger
    );
    
    --================================--
    -- DAQ Link
    --================================--

    -- DAQ Link instantiation
    daq_link : entity work.daqlink_wrapper
    port map(
        RESET_IN              => daq_reset,
        MGT_REF_CLK_IN        => mgt_ref_clk125_i,
        GTX_TXN_OUT           => daq_gtx_tx_pin_n,
        GTX_TXP_OUT           => daq_gtx_tx_pin_p,
        GTX_RXN_IN            => daq_gtx_rx_pin_n,
        GTX_RXP_IN            => daq_gtx_rx_pin_p,
        DATA_CLK_IN           => daq_clk_bufg,
        EVENT_DATA_IN         => daq_event_data,
        EVENT_DATA_HEADER_IN  => daq_event_header,
        EVENT_DATA_TRAILER_IN => daq_event_trailer,
        DATA_WRITE_EN_IN      => daq_event_write_en,
        READY_OUT             => daq_ready,
        ALMOST_FULL_OUT       => daq_almost_full,
        TTS_CLK_IN            => ttc_clk_i,
        TTS_STATE_IN          => daq_tts_state,
        GTX_CLK_OUT           => daq_gtx_clk,
        ERR_DISPER_COUNT      => daq_disper_err_cnt,
        ERR_NOT_IN_TABLE_COUNT=> daq_notintable_err_cnt,
        BC0_IN                => ttc_bc0_i,
        CLK125_IN             => clk125_i
    );    
 
    --================================--
    -- Resets
    --================================--
    
    daq_reset <= reset_pwrup or reset_i; -- or daq_ipb_reset;
    fifo_reset <= reset_pwrup or reset_i;
    
    -- Reset after powerup
    
    process(ttc_clk_i)
        variable countdown : integer := 40_000_000; -- probably way too long, but ok for now (this is only used after powerup)
    begin
        if (rising_edge(ttc_clk_i)) then
            if (countdown > 0) then
              reset_pwrup <= '1';
              countdown := countdown - 1;
            else
              reset_pwrup <= '0';
            end if;
        end if;
    end process;

    --================================--
    -- FIFOs
    --================================--
  
    -- Input FIFO
    daq_input_fifo_inst : entity work.daq_input_fifo
    PORT MAP (
        rst => fifo_reset,
        wr_clk => track_rx_clk_i,
        rd_clk => daq_clk_bufg,
        din => infifo_din,
        wr_en => infifo_wr_en,
        rd_en => infifo_rd_en,
        dout => infifo_dout,
        full => infifo_full,
        almost_full => infifo_almost_full,
        empty => infifo_empty,
        almost_empty => infifo_almost_empty,
        valid => infifo_valid,
        underflow => infifo_underflow,
        prog_full => input_fifo_near_full
    );

    -- Event FIFO
    daq_event_fifo_inst : entity work.daq_event_fifo
    PORT MAP (
        rst => fifo_reset,
        wr_clk => track_rx_clk_i,
        rd_clk => daq_clk_bufg,
        din => evtfifo_din,
        wr_en => evtfifo_wr_en,
        rd_en => evtfifo_rd_en,
        dout => evtfifo_dout,
        full => evtfifo_full,
        almost_full => evtfifo_almost_full,
        empty => evtfifo_empty,
        valid => evtfifo_valid,
        underflow => evtfifo_underflow,
        prog_full => event_fifo_near_full
    );

    --================================--
    -- Event building
    --================================--
    
    process(track_rx_clk_i)
        variable vfat_words_64          : unsigned(11 downto 0) := (others => '0');
        variable end_of_event           : std_logic := '0';
        
        -- Flags
        variable f_invalid_vfat_block   : std_logic := '0';
        variable f_vfat_bx_mismatch     : std_logic := '0'; -- BX mismatch between VFATs in the same event
        variable f_vfat_oh_bx_mismatch  : std_logic := '0'; -- BX mismatch between OH and VFAT
        variable f_oos_glib_vfat        : std_logic := '0'; -- GLIB is out of sync with vfat(s)
        variable f_oos_glib_oh          : std_logic := '0'; -- GLIB is out of sync with OH
        variable f_oos_oh               : std_logic := '0'; -- OH is out of sync (OH BC has changed between different blocks inside the same event)
        variable f_fifo_full            : std_logic := '0';   
        variable f_event_too_big        : std_logic := '0'; -- this event is too big - vfat_words_64 counter has maxed out (will discard the data)
        variable f_event_bigger_than_24 : std_logic := '0'; -- this event has more than 24 VFAT blocks
    begin
        if (rising_edge(track_rx_clk_i)) then
            if (track_rx_en_i(0) = '1') then
                last_rx_data(223 downto 0) <= track_rx_data_i;
                
                -- push to input FIFO
                if (infifo_full = '0') then
                    if (f_event_too_big = '0') then
                        infifo_din <= track_rx_data_i(191 downto 0);
                        infifo_wr_en <= '1';
                    end if;
                else
                    input_fifo_full <= '1';
                end if;
                
                -- Fill flags
                -- invalid vfat block?
                if ((track_rx_data_i(191 downto 144) and x"f000f000f000") /= vfat_block_marker) then
                    f_invalid_vfat_block := '1';
                    corrupted_vfat_data <= '1';
                    corrupted_vfat_cnt <= std_logic_vector(unsigned(corrupted_vfat_cnt) + 1);
                else -- valid block
                    if (eb_first_block = '1') then
                        eb_first_block <= '0';
                    end if;
                    
                    if ((eb_first_block = '0') and (eb_last_ec /= track_rx_data_i(171 downto 164))) then
                        end_of_event := '1';
                    end if;
                    
                    eb_last_ec <= track_rx_data_i(171 downto 164);
                    eb_last_bc <= track_rx_data_i(187 downto 176);
                    eb_last_oh_bc <= track_rx_data_i(223 downto 192);
                    
                end if;
                
                -- Fill the event flags
                if (end_of_event = '0') then
                    evtfifo_wr_en <= '0';
                    if (f_event_too_big = '0') then
                        vfat_words_64 := vfat_words_64 + 3;
                    end if;
                    if (vfat_words_64 = x"fff") then
                        event_too_big <= '1';
                        f_event_too_big := '1';
                    end if;
                    if (vfat_words_64 > x"18") then
                        f_event_bigger_than_24 := '1';
                        event_bigger_than_24 <= '1';
                    end if;
                    if (infifo_full = '1') then
                        f_fifo_full := '1';
                    end if;
                    if (eb_first_block = '0') then -- only do the checks if you already have populated the eb_last_* signals
                        if (eb_last_bc /= track_rx_data_i(187 downto 176)) then
                            f_vfat_bx_mismatch := '1';
                        end if;
                        if (eb_last_oh_bc /= track_rx_data_i(223 downto 192)) then
                            f_oos_oh := '1';
                        end if;
                        if (eb_last_oh_bc(11 downto 0) /= track_rx_data_i(187 downto 176)) then
                            f_vfat_oh_bx_mismatch := '1';
                            oos_oh_vfat <= '1';
                        end if;
                        if (eb_last_ec /= std_logic_vector(eb_event_num_short)) then
                            f_oos_glib_vfat := '1';
                            oos_glib_vfat <= '1';
                        end if;
                        -- TODO: f_oos_glib_oh (need to record bx, ec, orbit exactly when you get an l1a -- push that info to the l1a fifo)
                        -- push to L1A fifo as soon as you get L1A and pop from it only when sending an event to DAQ (not here)
                    end if;
                else -- Push to event FIFO
                    eb_event_num <= eb_event_num + 1;
                    eb_event_num_short <= eb_event_num_short + 1;
                    -- ....... PUSH HERE .......
                    if (evtfifo_full = '0') then
                        evtfifo_wr_en <= '1';
                        evtfifo_din <= std_logic_vector(eb_event_num) & eb_last_bc & std_logic_vector(vfat_words_64) & evtfifo_almost_full & f_fifo_full & f_invalid_vfat_block & f_oos_glib_vfat & f_oos_glib_oh & f_oos_oh & f_vfat_bx_mismatch & f_vfat_oh_bx_mismatch & f_event_too_big & "000";
                    else
                        event_fifo_full <= '1';
                    end if;
                    
                    -- reset event flags
                    end_of_event := '0';
                    f_invalid_vfat_block := '0';
                    f_vfat_bx_mismatch := '0';
                    f_vfat_oh_bx_mismatch := '0';
                    f_oos_glib_vfat := '0';
                    f_oos_glib_oh := '0';
                    f_oos_oh := '0';
                    f_fifo_full := '0';
                    f_event_too_big := '0';
                    f_event_bigger_than_24 := '0';
                    vfat_words_64 := (others => '0');
                end if;
                
            else
                infifo_wr_en <= '0';
                evtfifo_wr_en <= '0';
            end if;
        end if;
    end process;    
    
    --================================--
    -- Event shipping to DAQLink
    --================================--
    
    process(daq_clk_bufg)
    
        -- event info
        variable e_id                  : std_logic_vector(23 downto 0) := (others => '0');
        variable e_bx                  : std_logic_vector(11 downto 0) := (others => '0');
        variable e_payload_size        : unsigned(19 downto 0) := (others => '0');
        variable e_evtfifo_almost_full : std_logic := '0';
        variable e_infifo_full         : std_logic := '0';
        variable e_invalid_vfat_block  : std_logic := '0';
        variable e_oos_glib_vfat       : std_logic := '0';
        variable e_oos_glib_oh         : std_logic := '0';
        variable e_oos_oh              : std_logic := '0';
        variable e_vfat_bx_mismatch    : std_logic := '0';
        variable e_vfat_oh_bx_mismatch : std_logic := '0';
        variable e_event_too_big       : std_logic := '0';
        
        -- counters
        variable word_count            : unsigned(19 downto 0) := (others => '0');
        
    begin
    
        if (rising_edge(daq_clk_bufg)) then
        
            -- state machine for sending data
            -- state 0: idle
            -- state 1: sending the first AMC13 header
            -- state 2: sending the second AMC13 header
            -- state 3: sending the payload
            -- state 4: sending the AMC13 trailer
            if (daq_state = x"0") then
            
                -- zero out everything, especially the write enable :)
                daq_event_data <= (others => '0');
                daq_event_header <= '0';
                daq_event_trailer <= '0';
                daq_event_write_en <= '0';
                
                -- if the DAQlink state is ok and the event fifo is not empty - start the DAQ state machine
                if (evtfifo_empty = '0' and daq_ready = '1' and daq_almost_full = '0' and daq_reset = '0' and daq_enable = '1') then
                    daq_state <= x"1";
                    evtfifo_rd_en <= '1'; -- read in the event info
                else
                    evtfifo_rd_en <= '0'; -- don't read unless it's a new event (DAQ is in state 0 and events are available)
                end if;
                
            else
            
                evtfifo_rd_en <= '0'; -- make sure you're not reading the event fifo
                -- lets send some data!
                -- send the first header
                
                if (daq_state = x"1") then
                
                    e_id := evtfifo_dout(59 downto 36);
                    e_bx := evtfifo_dout(35 downto 24);
                    e_payload_size(11 downto 0) := unsigned(evtfifo_dout(23 downto 12));
                    e_evtfifo_almost_full := evtfifo_dout(11);
                    e_infifo_full         := evtfifo_dout(10);
                    e_invalid_vfat_block  := evtfifo_dout(9);
                    e_oos_glib_vfat       := evtfifo_dout(8);
                    e_oos_glib_oh         := evtfifo_dout(7);
                    e_oos_oh              := evtfifo_dout(6);
                    e_vfat_bx_mismatch    := evtfifo_dout(5);
                    e_vfat_oh_bx_mismatch := evtfifo_dout(4);
                    e_event_too_big       := evtfifo_dout(3);

                    daq_curr_vfat_block <= unsigned(evtfifo_dout(23 downto 12)) - 3;
                
                    daq_event_data <= x"00" & e_id & e_bx & std_logic_vector(e_payload_size + 3);
                    daq_event_header <= '1';
                    daq_event_trailer <= '0';
                    daq_event_write_en <= '1';
                    daq_state <= x"2";
                    
                -- send the second header
                elsif (daq_state = x"2") then
                
                    daq_event_data <= x"FAFAB" & "000" & e_evtfifo_almost_full & e_infifo_full & e_invalid_vfat_block & e_oos_glib_vfat & e_oos_glib_oh & e_oos_oh & e_vfat_bx_mismatch & e_vfat_oh_bx_mismatch & e_event_too_big & ttc_orbit_id_i(15 downto 0) & x"00" & board_sn_i;
                    daq_event_header <= '0';
                    daq_event_trailer <= '0';
                    daq_event_write_en <= '1';
                    daq_state <= x"3";
                    -- read a block from the input fifo
                    infifo_rd_en <= '1';
                    daq_curr_block_word <= 2;
                    word_count := x"00002";
                
                -- send the payload
                elsif (daq_state = x"3") then
                
                    -- read the next vfat block from the infifo if we're already working with the last word, but it's not yet the last block
                    if ((daq_curr_block_word = 0) and (daq_curr_vfat_block > x"0")) then
                        infifo_rd_en <= '1';
                        daq_curr_block_word <= 2;
                        daq_curr_vfat_block <= daq_curr_vfat_block - 3; -- this looks strange, but it's because this is not actually vfat_block but number of 64bit words of vfat data
                    -- we are done sending everything -- move on to the next state
                    elsif ((daq_curr_block_word = 0) and (daq_curr_vfat_block = x"0")) then
                        infifo_rd_en <= '0';
                        daq_state <= x"4";
                    -- lets move to the next vfat word
                    else
                        infifo_rd_en <= '0';
                        daq_curr_block_word <= daq_curr_block_word - 1;
                    end if;
                    
                    -- send the data!
                    daq_event_data <= infifo_dout((((daq_curr_block_word + 1) * 64) - 1) downto (daq_curr_block_word * 64));
                    daq_event_header <= '0';
                    daq_event_trailer <= '0';
                    daq_event_write_en <= '1';
                    word_count := word_count + 1;
                    
                -- send the trailer
                elsif (daq_state = x"4") then
                
                    daq_event_data <= x"00000000" & e_id(7 downto 0) & x"0" & std_logic_vector(word_count + 1); --& std_logic_vector(e_payload_size + 3);
                    daq_event_header <= '0';
                    daq_event_trailer <= '1';
                    daq_event_write_en <= '1';
                    daq_state <= x"0";
                    sent_event_cnt <= std_logic_vector(unsigned(sent_event_cnt) + 1);
                    
                -- hmm
                else
                
                    daq_state <= x"0";
                    
                end if;
                
            end if;

            -- check for underflows and set the permanent flag if it happens
            if (evtfifo_underflow = '1') then
                input_fifo_underflow <= '1';
            end if;
            
        end if;
        
    end process;
    
--    -- fake DAQ data on L1A
--    process(daq_clk_bufg)
--        variable payload_size : unsigned(19 downto 0) := (others => '0');
--        variable payload_block : integer range 0 to 4096 := 0;
--    begin
--        if (rising_edge(daq_clk_bufg)) then
--            -- start the fake event state machine
--            if (daq_trigger = '1' and daq_state = x"0" and daq_ready = '1' and daq_almost_full = '0' and daq_reset = '0' and daq_enable = '1') then
--                daq_state <= x"1";
--                payload_block := 5;
--                payload_size := x"00005";
--            end if;
--            
--            -- state machine for sending one fake event packets
--            if (daq_state > x"0") then
--                if (daq_state = x"1") then    -- send the first header
--                    daq_event_data <= x"00" & ttc_l1a_id_i(23 downto 0) & ttc_bx_id_i & std_logic_vector(payload_size + 3); --x"00004";
--                    daq_event_header <= '1';
--                    daq_event_trailer <= '0';
--                    daq_event_write_en <= '1';
--                    daq_state <= x"2";
--                elsif (daq_state = x"2") then -- send the second header
--                    daq_event_data <= x"FAFABABA" & ttc_orbit_id_i(15 downto 0) & x"00" & board_sn_i;
--                    daq_event_header <= '0';
--                    daq_event_trailer <= '0';
--                    daq_event_write_en <= '1';
--                    daq_state <= x"3";
--                elsif (daq_state = x"3") then -- send the payload
--                    if (payload_block > 0) then
--                        if (payload_block = 5) then
--                            daq_event_data <= x"BAADF00D" & x"BAADCAFE";
--                            daq_event_header <= '0';
--                            daq_event_trailer <= '0';
--                            daq_event_write_en <= '1';                        
--                            payload_block := payload_block - 1;
--                        else
--                            daq_event_data <= last_rx_data((payload_block * 64) - 1 downto (payload_block - 1) * 64);
--                            payload_block := payload_block - 1;
--                            daq_event_header <= '0';
--                            daq_event_trailer <= '0';
--                            daq_event_write_en <= '1';
--                            if (payload_block = 0) then
--                                daq_state <= x"4";
--                            end if;
--                        end if;
--                    else
--                        daq_state <= x"4";
--                    end if;
----                    daq_event_data <= x"BAADF00D" & x"BAADCAFE";
----                    daq_event_header <= '0';
----                    daq_event_trailer <= '0';
----                    daq_event_write_en <= '1';
----                    daq_state <= x"4";
--                elsif (daq_state = x"4") then -- send trailer
--                    daq_event_data <= x"00000000" & ttc_l1a_id_i(7 downto 0) & x"0" & std_logic_vector(payload_size + 3); --x"00004";
--                    daq_event_header <= '0';
--                    daq_event_trailer <= '1';
--                    daq_event_write_en <= '1';
--                    daq_state <= x"0";
--                    sent_event_cnt <= std_logic_vector(unsigned(sent_event_cnt) + 1);
--                else -- hmm
--                    daq_state <= x"0";
--                end if;
--            elsif (daq_state = x"0") then -- zero out everything, especially the write enable :)
--                daq_event_data <= (others => '0');
--                daq_event_header <= '0';
--                daq_event_trailer <= '0';
--                daq_event_write_en <= '0';
--            end if;
--            
--        end if;
--    end process;

    --================================--
    -- Monitoring
    --================================--
    
    daq_status1_reg_o <= std_logic_vector(sent_event_cnt(11 downto 0)) & std_logic_vector(eb_event_num(11 downto 0)) & x"0" & ttc_ready_i & daq_clock_locked & daq_almost_full & daq_ready;
    daq_status2_reg_o <= daq_critical_error & "000" & daq_tts_state & x"000" & infifo_empty & evtfifo_empty & oos_glib_vfat & oos_glib_oh & oos_oh_vfat & input_fifo_full & input_fifo_near_full & input_fifo_underflow & event_fifo_full & event_fifo_near_full & corrupted_vfat_data & event_too_big;
    daq_enable <= daq_config_reg_i(0);

    -- quick and dirty check of frequency of some clocks
--    process(daq_gtx_clk)
--        variable last_daq_clk   : std_logic := '0';
--        variable daq_clk_length : unsigned(7 downto 0) := (others => '0');
--        variable last_ttc_clk   : std_logic := '0';
--        variable ttc_clk_length : unsigned(7 downto 0) := (others => '0');
--    begin
--        if (rising_edge(daq_gtx_clk)) then
--            if (daq_clk_bufg = last_daq_clk) then
--                daq_clk_length := daq_clk_length + 1;
--            else
--                request_read(6) <= x"000000" & std_logic_vector(daq_clk_length);
--                daq_clk_length := (others => '0');
--                last_daq_clk := daq_clk_bufg;
--            end if;
--            if (ttc_clk = last_ttc_clk) then
--                ttc_clk_length := ttc_clk_length + 1;
--            else
--                request_read(7) <= x"000000" & std_logic_vector(ttc_clk_length);
--                ttc_clk_length := (others => '0');
--                last_ttc_clk := ttc_clk;
--            end if;            
--        end if;
--    end process;


end Behavioral;

