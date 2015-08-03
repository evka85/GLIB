----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:26:57 08/01/2015 
-- Design Name: 
-- Module Name:    daqlink_wrapper - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity daqlink_wrapper is
port
(
  RESET_IN                        : in std_logic; -- reset
  MGT_REF_CLK_IN                  : in std_logic; -- 125MHz GTX reference clock (must be put through ibufds_gtxe already)
  GTX_TXN_OUT                     : out std_logic;
  GTX_TXP_OUT                     : out std_logic;
  GTX_RXN_IN                      : in std_logic;
  GTX_RXP_IN                      : in std_logic;
  DATA_CLK_IN                     : in std_logic; -- whatever you're clocking your data on
  EVENT_DATA_IN                   : in std_logic_vector (63 downto 0); -- data
  EVENT_DATA_HEADER_IN            : in std_logic; -- assert for first word of the packet
  EVENT_DATA_TRAILER_IN           : in std_logic; -- assert for last word of the packet
  DATA_WRITE_EN_IN                : in std_logic; -- data write enable
  READY_OUT                       : out std_logic; -- DAQ ready
  ALMOST_FULL_OUT                 : out std_logic; -- DAQ almost full
  TTS_CLK_IN                      : in std_logic; -- LHC clock ~40.08MHz used for both the TTS and TTC
  TTS_STATE_IN                    : in std_logic_vector(3 downto 0)
);
end daqlink_wrapper;

architecture Behavioral of daqlink_wrapper is

component DAQLINK_gtx
  generic
  (
    F_REFCLK  : integer  := 125
  );
  port
  (
      ------------------------ Loopback and Powerdown Ports ----------------------
      LOOPBACK_IN                             : in   std_logic_vector(2 downto 0);
      ----------------------- Receive Ports - 8b10b Decoder ----------------------
      RXCHARISCOMMA_OUT                       : out  std_logic_vector(1 downto 0);
      RXCHARISK_OUT                           : out  std_logic_vector(1 downto 0);
      RXDISPERR_OUT                           : out  std_logic_vector(1 downto 0);
      RXNOTINTABLE_OUT                        : out  std_logic_vector(1 downto 0);
      ------------------- Receive Ports - Clock Correction Ports -----------------
      RXCLKCORCNT_OUT                         : out  std_logic_vector(2 downto 0);
      --------------- Receive Ports - Comma Detection and Alignment --------------
      RXENMCOMMAALIGN_IN                      : in   std_logic;
      RXENPCOMMAALIGN_IN                      : in   std_logic;
      ------------------- Receive Ports - RX Data Path interface -----------------
      RXDATA_OUT                              : out  std_logic_vector(15 downto 0);
      RXUSRCLK2_IN                            : in   std_logic;
      ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
      RXCDRRESET_IN                           : in   std_logic;
      RXEQMIX_IN                              : in   std_logic_vector(2 downto 0);
      RXN_IN                                  : in   std_logic;
      RXP_IN                                  : in   std_logic;
      --------------- Receive Ports - RX Loss-of-sync State Machine --------------
      RXLOSSOFSYNC_OUT                        : out  std_logic_vector(1 downto 0);
      ------------------------ Receive Ports - RX PLL Ports ----------------------
      GTXRXRESET_IN                           : in   std_logic;
      MGTREFCLKRX_IN                          : in   std_logic_vector(1 downto 0);
      PLLRXRESET_IN                           : in   std_logic;
      RXPLLLKDET_OUT                          : out  std_logic;
      RXRESETDONE_OUT                         : out  std_logic;
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      RXPOLARITY_IN                           : in   std_logic;
      ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
      TXCHARISK_IN                            : in   std_logic_vector(1 downto 0);
      ------------------ Transmit Ports - TX Data Path interface -----------------
      TXDATA_IN                               : in   std_logic_vector(15 downto 0);
      TXOUTCLK_OUT                            : out  std_logic;
      TXUSRCLK2_IN                            : in   std_logic;
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      TXDIFFCTRL_IN                           : in   std_logic_vector(3 downto 0);
      TXN_OUT                                 : out  std_logic;
      TXP_OUT                                 : out  std_logic;
      TXPOSTEMPHASIS_IN                       : in   std_logic_vector(4 downto 0);
      --------------- Transmit Ports - TX Driver and OOB signalling --------------
      TXPREEMPHASIS_IN                        : in   std_logic_vector(3 downto 0);
      ----------------------- Transmit Ports - TX PLL Ports ----------------------
      GTXTXRESET_IN                           : in   std_logic;
      MGTREFCLKTX_IN                          : in   std_logic_vector(1 downto 0);
      PLLTXRESET_IN                           : in   std_logic;
      TXPLLLKDET_OUT                          : out  std_logic;
      TXRESETDONE_OUT                         : out  std_logic;
      -------------------- Transmit Ports - TX Polarity Control ------------------
      TXPOLARITY_IN                           : in   std_logic
  );
end component;

component DAQ_Link_V6
		Generic
    (
           -- If you do not use the trigger port, set it to false
					 --USE_TRIGGER_PORT : boolean := false;
					 simulation       : boolean := false
    );
    Port ( 
           reset                      : in  STD_LOGIC; -- asynchronous reset, assert reset until GTX REFCLK stable
           USE_TRIGGER_PORT           : boolean;
        -- MGT signals
           UsrClk                     : in  STD_LOGIC; -- it must have a frequency of 250MHz
           RXPLLLKDET                 : in  STD_LOGIC;
           RxResetDone                : in  STD_LOGIC;
           TxResetDone                : in  STD_LOGIC;
           RXCDRRESET                 : out  STD_LOGIC;
           RXENPCOMMAALIGN            : out  STD_LOGIC;
           RXENMCOMMAALIGN            : out  STD_LOGIC;
           RXLOSSOFSYNC               : in  STD_LOGIC_VECTOR (1 downto 0);
           RXCHARISCOMMA              : in  STD_LOGIC_VECTOR (1 downto 0);
           RXCHARISK                  : in  STD_LOGIC_VECTOR (1 downto 0);
           RXDATA                     : in  STD_LOGIC_VECTOR (15 downto 0);
           TXCHARISK                  : out  STD_LOGIC_VECTOR (1 downto 0);
           TXDATA                     : out  STD_LOGIC_VECTOR (15 downto 0);
         -- TRIGGER port
           TTCclk                     : in  STD_LOGIC;
           BcntRes                    : in  STD_LOGIC;
           trig                       : in  STD_LOGIC_VECTOR (7 downto 0);
         -- TTS port
           TTSclk                     : in  STD_LOGIC; -- clock source which clocks TTS signals
           TTS                        : in  STD_LOGIC_VECTOR (3 downto 0);
         -- Data port
					 EventDataClk               : in  STD_LOGIC;
           EventData_valid            : in  STD_LOGIC; -- used as data write enable
           EventData_header           : in  STD_LOGIC; -- first data word
           EventData_trailer          : in  STD_LOGIC; -- last data word
           EventData                  : in  STD_LOGIC_VECTOR (63 downto 0);
           AlmostFull                 : out  STD_LOGIC; -- buffer almost full
           Ready                      : out  STD_LOGIC;
           sysclk                     : in  STD_LOGIC;
           L1A_DATA_we                : out  STD_LOGIC; -- last data word
           L1A_DATA                   : out  STD_LOGIC_VECTOR (15 downto 0)
    );
end component;


    -------------------------- MGT Wrapper Wires ------------------------------
    --________________________________________________________________________
    --________________________________________________________________________
    --GTX0   (X0Y8)

    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    signal  gtx0_rxchariscomma_i            : std_logic_vector(1 downto 0);
    signal  gtx0_rxcharisk_i                : std_logic_vector(1 downto 0);
    --? signal  gtx0_rxdisperr_i                : std_logic_vector(1 downto 0);
    --? signal  gtx0_rxnotintable_i             : std_logic_vector(1 downto 0);
    ------------------- Receive Ports - Clock Correction Ports -----------------
    --? signal  gtx0_rxclkcorcnt_i              : std_logic_vector(2 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    signal  gtx0_rxenmcommaalign_i          : std_logic;
    signal  gtx0_rxenpcommaalign_i          : std_logic;
    ------------------- Receive Ports - RX Data Path interface -----------------
    signal  gtx0_rxdata_i                   : std_logic_vector(15 downto 0);
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    signal  gtx0_rxcdrreset_i               : std_logic;
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    signal  gtx0_pllrxreset_i               : std_logic;
    signal  gtx0_rxplllkdet_i               : std_logic;
    signal  gtx0_rxresetdone_i              : std_logic;
    ----------------- Receive Ports - RX Polarity Control Ports ----------------
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    signal  gtx0_txcharisk_i                : std_logic_vector(1 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    signal  gtx0_txdata_i                   : std_logic_vector(15 downto 0);
    signal  gtx0_txoutclk_i                 : std_logic;
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    signal  gtx0_txdiffctrl_i               : std_logic_vector(3 downto 0);
    signal  gtx0_txpostemphasis_i           : std_logic_vector(4 downto 0);
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    signal  gtx0_txpreemphasis_i            : std_logic_vector(3 downto 0);
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    signal  gtx0_txresetdone_i              : std_logic;
    -------------------- Transmit Ports - TX Polarity Control ------------------
    signal  gtx0_txpolarity_i               : std_logic;
   --------------- Receive Ports - RX Loss-of-sync State Machine --------------
    signal  gtx0_rxlossofsync               : std_logic_vector(1 downto 0);

    ----------------
    signal  gtx0_mgt_ref_clk_2b        : std_logic_vector(1 downto 0);
    signal  gtx0_tx_clk_out                 : std_logic;
    signal  gtx0_usr_clk                    : std_logic;
    signal  reset_daq                       : std_logic;
  
begin

    -- ref clock wiring

    gtx0_mgt_ref_clk_2b <= '0' & MGT_REF_CLK_IN; -- GTX takes 2 bits, we ignore the second bit

    -- user clock
    txoutclk_bufg0_i : BUFG
    port map
    (
        I                               =>      gtx0_tx_clk_out,
        O                               =>      gtx0_usr_clk
    );
    
    -- reset
    
    reset_daq <= RESET_IN;
    
    -- GTX
    
    daqlink_gtx_i : DAQLINK_gtx
    generic map
    (
        F_REFCLK                =>  125
    )
    port map
    (

        --_____________________________________________________________________
        --_____________________________________________________________________
        --GTX0  (X0Y8)
        ------------------------ Loopback and Powerdown Ports ----------------------
        LOOPBACK_IN                    =>      "000",
        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        RXCHARISCOMMA_OUT          =>      gtx0_rxchariscomma_i,
        RXCHARISK_OUT              =>      gtx0_rxcharisk_i,
        RXDISPERR_OUT              =>      open, --? gtx0_rxdisperr_i,
        RXNOTINTABLE_OUT           =>      open, --? gtx0_rxnotintable_i,
        ------------------- Receive Ports - Clock Correction Ports -----------------
        RXCLKCORCNT_OUT            =>      open, --? gtx0_rxclkcorcnt_i,
        --------------- Receive Ports - Comma Detection and Alignment --------------
        RXENMCOMMAALIGN_IN         =>      gtx0_rxenmcommaalign_i,
        RXENPCOMMAALIGN_IN         =>      gtx0_rxenpcommaalign_i,
        ------------------- Receive Ports - RX Data Path interface -----------------
        RXDATA_OUT                 =>      gtx0_rxdata_i,
        RXUSRCLK2_IN               =>      gtx0_usr_clk,
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        RXCDRRESET_IN              =>      gtx0_rxcdrreset_i,
        RXEQMIX_IN                 =>      "000",
        RXN_IN                     =>      GTX_RXN_IN,
        RXP_IN                     =>      GTX_RXP_IN,
       --------------- Receive Ports - RX Loss-of-sync State Machine --------------
        RXLOSSOFSYNC_OUT           =>    gtx0_rxlossofsync,
        ------------------------ Receive Ports - RX PLL Ports ----------------------
        GTXRXRESET_IN              =>      reset_daq,
        MGTREFCLKRX_IN             =>      gtx0_mgt_ref_clk_2b,
        PLLRXRESET_IN              =>      '0',
        RXPLLLKDET_OUT             =>      gtx0_rxplllkdet_i,
        RXRESETDONE_OUT            =>      gtx0_rxresetdone_i,
        ----------------- Receive Ports - RX Polarity Control Ports ----------------
        RXPOLARITY_IN              =>      '1', -- the generated core is using "0" but HCAL uses "1"
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        TXCHARISK_IN               =>      gtx0_txcharisk_i,
        ------------------ Transmit Ports - TX Data Path interface -----------------
        TXDATA_IN                  =>      gtx0_txdata_i,
        TXOUTCLK_OUT               =>      gtx0_tx_clk_out,
        TXUSRCLK2_IN               =>      gtx0_usr_clk,
        ---------------- Transmit Ports - TX Driver and OOB signaling --------------
        TXDIFFCTRL_IN              =>      "1001", -- the generated core is using "1010" but HCAL uses "1001"
        TXN_OUT                    =>      GTX_TXN_OUT,
        TXP_OUT                    =>      GTX_TXP_OUT,
        TXPOSTEMPHASIS_IN          =>      "00000",
        --------------- Transmit Ports - TX Driver and OOB signalling --------------
        TXPREEMPHASIS_IN           =>      "0000",
        ----------------------- Transmit Ports - TX PLL Ports ----------------------
        GTXTXRESET_IN              =>      reset_daq,
        TXRESETDONE_OUT            =>      gtx0_txresetdone_i,
        MGTREFCLKTX_IN             =>      gtx0_mgt_ref_clk_2b,
        PLLTXRESET_IN              =>      '0',
        TXPLLLKDET_OUT             =>      open,
        -------------------- Transmit Ports - TX Polarity Control ------------------
        TXPOLARITY_IN              =>      '1' -- the generated core is using "0" but HCAL uses "1"
    );

    -- DAQ link

    DAQ_Link_V6_i : DAQ_Link_V6
		generic map
    (
           -- If you do not use the trigger port, set it to false
					 --USE_TRIGGER_PORT => false,
					 simulation       => false
    )
    port map
    ( 
           reset                      => reset_daq, -- asynchronous reset, assert reset until GTX REFCLK stable
           USE_TRIGGER_PORT           => false,
        -- MGT signals
           UsrClk                     => gtx0_usr_clk, -- it must have a frequency of 250MHz
           RXPLLLKDET                 => gtx0_rxplllkdet_i,
           RxResetDone                => gtx0_rxresetdone_i,
           TxResetDone                => gtx0_txresetdone_i,
           RXCDRRESET                 => gtx0_rxcdrreset_i,
           RXENPCOMMAALIGN            => gtx0_rxenpcommaalign_i,
           RXENMCOMMAALIGN            => gtx0_rxenmcommaalign_i,
           RXLOSSOFSYNC               => gtx0_rxlossofsync,
           RXCHARISCOMMA              => gtx0_rxchariscomma_i,
           RXCHARISK                  => gtx0_rxcharisk_i,
           RXDATA                     => gtx0_rxdata_i,
           TXCHARISK                  => gtx0_txcharisk_i,
           TXDATA                     => gtx0_txdata_i,
         -- TRIGGER port
           TTCclk                     => TTS_CLK_IN,
           BcntRes                    => '0',
           trig                       => x"00",
         -- TTS port
           TTSclk                     => TTS_CLK_IN,
           TTS                        => TTS_STATE_IN,
         -- Data port
					 EventDataClk               => DATA_CLK_IN,
           EventData_valid            => DATA_WRITE_EN_IN,
           EventData_header           => EVENT_DATA_HEADER_IN,
           EventData_trailer          => EVENT_DATA_TRAILER_IN,
           EventData                  => EVENT_DATA_IN,
           AlmostFull                 => ALMOST_FULL_OUT,
           Ready                      => READY_OUT,
           sysclk                     => '0', -- hmm, HCAL did it like that, so lets see
           L1A_DATA_we                => open,
           L1A_DATA                   => open
    );

end Behavioral;

