-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version : 1.9
--  \   \         Application : Virtex-6 FPGA GTX Transceiver Wizard
--  /   /         Filename : v6_gtxwizard.vhd
-- /___/   /\
-- \   \  /  \
--  \___\/\___\
--
--
-- Module V6_GTXWIZARD (a GTX Wrapper)
-- Generated by Xilinx Virtex-6 FPGA GTX Transceiver Wizard
-- 
-- 
-- (c) Copyright 2009-2010 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;


--***************************** Entity Declaration ****************************

entity V6_GTXWIZARD_sgmii is
generic
(
    -- Simulation attributes
    WRAPPER_SIM_GTXRESET_SPEEDUP    : integer   := 0 -- Set to 1 to speed up sim reset
);
port
(

    --_________________________________________________________________________
    --_________________________________________________________________________
    --GTX0  (X0Y8)

    GTX0_DOUBLE_RESET_CLK_IN                : in   std_logic;
    ------------------------ Loopback and Powerdown Ports ----------------------
    GTX0_LOOPBACK_IN                        : in   std_logic_vector(2 downto 0);
    GTX0_RXPOWERDOWN_IN                     : in   std_logic_vector(1 downto 0);
    GTX0_TXPOWERDOWN_IN                     : in   std_logic_vector(1 downto 0);
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    GTX0_RXCHARISCOMMA_OUT                  : out  std_logic;
    GTX0_RXCHARISK_OUT                      : out  std_logic;
    GTX0_RXDISPERR_OUT                      : out  std_logic;
    GTX0_RXNOTINTABLE_OUT                   : out  std_logic;
    GTX0_RXRUNDISP_OUT                      : out  std_logic;
    ------------------- Receive Ports - Clock Correction Ports -----------------
    GTX0_RXCLKCORCNT_OUT                    : out  std_logic_vector(2 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    GTX0_RXENMCOMMAALIGN_IN                 : in   std_logic;
    GTX0_RXENPCOMMAALIGN_IN                 : in   std_logic;
    ------------------- Receive Ports - RX Data Path interface -----------------
    GTX0_RXDATA_OUT                         : out  std_logic_vector(7 downto 0);
    GTX0_RXRECCLK_OUT                       : out  std_logic;
    GTX0_RXRESET_IN                         : in   std_logic;
    GTX0_RXUSRCLK2_IN                       : in   std_logic;
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GTX0_RXELECIDLE_OUT                     : out  std_logic;
    GTX0_RXN_IN                             : in   std_logic;
    GTX0_RXP_IN                             : in   std_logic;
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    GTX0_RXBUFRESET_IN                      : in   std_logic;
    GTX0_RXBUFSTATUS_OUT                    : out  std_logic_vector(2 downto 0);
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GTX0_GTXRXRESET_IN                      : in   std_logic;
    GTX0_MGTREFCLKRX_IN                     : in   std_logic;
    GTX0_PLLRXRESET_IN                      : in   std_logic;
    GTX0_RXPLLLKDET_OUT                     : out  std_logic;
    GTX0_RXRESETDONE_OUT                    : out  std_logic;
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    GTX0_TXCHARDISPMODE_IN                  : in   std_logic;
    GTX0_TXCHARDISPVAL_IN                   : in   std_logic;
    GTX0_TXCHARISK_IN                       : in   std_logic;
    ------------------------- Transmit Ports - GTX Ports -----------------------
    GTX0_GTXTEST_IN                         : in   std_logic_vector(12 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GTX0_TXDATA_IN                          : in   std_logic_vector(7 downto 0);
    GTX0_TXOUTCLK_OUT                       : out  std_logic;
    GTX0_TXRESET_IN                         : in   std_logic;
    GTX0_TXUSRCLK2_IN                       : in   std_logic;
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GTX0_TXN_OUT                            : out  std_logic;
    GTX0_TXP_OUT                            : out  std_logic;
    ----------- Transmit Ports - TX Elastic Buffer and Phase Alignment ---------
    GTX0_TXBUFSTATUS_OUT                    : out  std_logic_vector(1 downto 0);
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GTX0_GTXTXRESET_IN                      : in   std_logic;
    GTX0_TXRESETDONE_OUT                    : out  std_logic

 
);


end V6_GTXWIZARD_sgmii;


architecture RTL of V6_GTXWIZARD_sgmii is

    attribute CORE_GENERATION_INFO : string;
    attribute CORE_GENERATION_INFO of RTL : architecture is "V6_GTXWIZARD,v6_gtxwizard_v1_9,{protocol_file=gigabit_ethernet}";

--***************************** Signal Declarations *****************************

    -- ground and tied_to_vcc_i signals
    signal  tied_to_ground_i                :   std_logic;
    signal  tied_to_ground_vec_i            :   std_logic_vector(63 downto 0);
    signal  tied_to_vcc_i                   :   std_logic;

    signal  gtx0_gtxtest_bit1        :   std_logic;
    signal  gtx0_gtxtest_done        :   std_logic;
    signal  gtx0_gtxtest_i           :   std_logic_vector(12 downto 0);
    signal  gtx0_txreset_i           :   std_logic;
    signal  gtx0_rxreset_i           :   std_logic;
    signal  gtx0_rxplllkdet_i        :   std_logic;

    signal  gtx0_share_rxpll_i           :   std_logic_vector(1 downto 0);
    signal  gtx0_mgtrefclkrx_i           :   std_logic_vector(1 downto 0);

--*************************** Component Declarations **************************
component V6_GTXWIZARD_GTX_sgmii
generic
(
    -- Simulation attributes
    GTX_SIM_GTXRESET_SPEEDUP    : integer    := 0;

    -- Share RX PLL parameter
    GTX_TX_CLK_SOURCE           : string     := "TXPLL";
    -- Save power parameter
    GTX_POWER_SAVE              : bit_vector := "0000000000"
);
port
(
    ------------------------ Loopback and Powerdown Ports ----------------------
    LOOPBACK_IN                             : in   std_logic_vector(2 downto 0);
    RXPOWERDOWN_IN                          : in   std_logic_vector(1 downto 0);
    TXPOWERDOWN_IN                          : in   std_logic_vector(1 downto 0);
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    RXCHARISCOMMA_OUT                       : out  std_logic;
    RXCHARISK_OUT                           : out  std_logic;
    RXDISPERR_OUT                           : out  std_logic;
    RXNOTINTABLE_OUT                        : out  std_logic;
    RXRUNDISP_OUT                           : out  std_logic;
    ------------------- Receive Ports - Clock Correction Ports -----------------
    RXCLKCORCNT_OUT                         : out  std_logic_vector(2 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    RXENMCOMMAALIGN_IN                      : in   std_logic;
    RXENPCOMMAALIGN_IN                      : in   std_logic;
    ------------------- Receive Ports - RX Data Path interface -----------------
    RXDATA_OUT                              : out  std_logic_vector(7 downto 0);
    RXRECCLK_OUT                            : out  std_logic;
    RXRESET_IN                              : in   std_logic;
    RXUSRCLK2_IN                            : in   std_logic;
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    RXELECIDLE_OUT                          : out  std_logic;
    RXN_IN                                  : in   std_logic;
    RXP_IN                                  : in   std_logic;
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    RXBUFRESET_IN                           : in   std_logic;
    RXBUFSTATUS_OUT                         : out  std_logic_vector(2 downto 0);
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GTXRXRESET_IN                           : in   std_logic;
    MGTREFCLKRX_IN                          : in   std_logic_vector(1 downto 0);
    PLLRXRESET_IN                           : in   std_logic;
    RXPLLLKDET_OUT                          : out  std_logic;
    RXRESETDONE_OUT                         : out  std_logic;
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    TXCHARDISPMODE_IN                       : in   std_logic;
    TXCHARDISPVAL_IN                        : in   std_logic;
    TXCHARISK_IN                            : in   std_logic;
    ------------------------- Transmit Ports - GTX Ports -----------------------
    GTXTEST_IN                              : in   std_logic_vector(12 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    TXDATA_IN                               : in   std_logic_vector(7 downto 0);
    TXOUTCLK_OUT                            : out  std_logic;
    TXRESET_IN                              : in   std_logic;
    TXUSRCLK2_IN                            : in   std_logic;
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    TXN_OUT                                 : out  std_logic;
    TXP_OUT                                 : out  std_logic;
    ----------- Transmit Ports - TX Elastic Buffer and Phase Alignment ---------
    TXBUFSTATUS_OUT                         : out  std_logic_vector(1 downto 0);
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GTXTXRESET_IN                           : in   std_logic;
    MGTREFCLKTX_IN                          : in   std_logic_vector(1 downto 0);
    PLLTXRESET_IN                           : in   std_logic;
    TXPLLLKDET_OUT                          : out  std_logic;
    TXRESETDONE_OUT                         : out  std_logic


);
end component;

component DOUBLE_RESET_sgmii
port
(
   CLK                :   in    std_logic;
   PLLLKDET           :   in    std_logic;
   GTXTEST_DONE       :   out   std_logic;
   GTXTEST_BIT1       :   out   std_logic

);
end component;

--********************************* Main Body of Code**************************

begin

    tied_to_ground_i                    <= '0';
    tied_to_ground_vec_i(63 downto 0)   <= (others => '0');
    tied_to_vcc_i                       <= '1';

     gtx0_gtxtest_i        <= b"10000000000" & gtx0_gtxtest_bit1 & '0';
     gtx0_txreset_i        <= gtx0_gtxtest_done or GTX0_TXRESET_IN;
     gtx0_rxreset_i        <= gtx0_gtxtest_done or GTX0_RXRESET_IN;
     GTX0_RXPLLLKDET_OUT   <= gtx0_rxplllkdet_i;

    gtx0_mgtrefclkrx_i <= (tied_to_ground_i & GTX0_MGTREFCLKRX_IN);


    --------------------------- GTX Instances  -------------------------------


    --_________________________________________________________________________
    --_________________________________________________________________________
    --GTX0  (X0Y8)

    gtx0_v6_gtxwizard_i : V6_GTXWIZARD_GTX_sgmii
    generic map
    (
        -- Simulation attributes
        GTX_SIM_GTXRESET_SPEEDUP    => WRAPPER_SIM_GTXRESET_SPEEDUP,

        -- Share RX PLL parameter
        GTX_TX_CLK_SOURCE           => "RXPLL",
        -- Save power parameter
        GTX_POWER_SAVE              => "0000110100"
    )
    port map
    (
        ------------------------ Loopback and Powerdown Ports ----------------------
        LOOPBACK_IN                     =>      GTX0_LOOPBACK_IN,
        RXPOWERDOWN_IN                  =>      GTX0_RXPOWERDOWN_IN,
        TXPOWERDOWN_IN                  =>      GTX0_TXPOWERDOWN_IN,
        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        RXCHARISCOMMA_OUT               =>      GTX0_RXCHARISCOMMA_OUT,
        RXCHARISK_OUT                   =>      GTX0_RXCHARISK_OUT,
        RXDISPERR_OUT                   =>      GTX0_RXDISPERR_OUT,
        RXNOTINTABLE_OUT                =>      GTX0_RXNOTINTABLE_OUT,
        RXRUNDISP_OUT                   =>      GTX0_RXRUNDISP_OUT,
        ------------------- Receive Ports - Clock Correction Ports -----------------
        RXCLKCORCNT_OUT                 =>      GTX0_RXCLKCORCNT_OUT,
        --------------- Receive Ports - Comma Detection and Alignment --------------
        RXENMCOMMAALIGN_IN              =>      GTX0_RXENMCOMMAALIGN_IN,
        RXENPCOMMAALIGN_IN              =>      GTX0_RXENPCOMMAALIGN_IN,
        ------------------- Receive Ports - RX Data Path interface -----------------
        RXDATA_OUT                      =>      GTX0_RXDATA_OUT,
        RXRECCLK_OUT                    =>      GTX0_RXRECCLK_OUT,
        RXRESET_IN                      =>      gtx0_rxreset_i,
        RXUSRCLK2_IN                    =>      GTX0_RXUSRCLK2_IN,
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        RXELECIDLE_OUT                  =>      GTX0_RXELECIDLE_OUT,
        RXN_IN                          =>      GTX0_RXN_IN,
        RXP_IN                          =>      GTX0_RXP_IN,
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        RXBUFRESET_IN                   =>      GTX0_RXBUFRESET_IN,
        RXBUFSTATUS_OUT                 =>      GTX0_RXBUFSTATUS_OUT,
        ------------------------ Receive Ports - RX PLL Ports ----------------------
        GTXRXRESET_IN                   =>      GTX0_GTXRXRESET_IN,
        MGTREFCLKRX_IN                  =>      gtx0_mgtrefclkrx_i,
        PLLRXRESET_IN                   =>      GTX0_PLLRXRESET_IN,
        RXPLLLKDET_OUT                  =>      gtx0_rxplllkdet_i,
        RXRESETDONE_OUT                 =>      GTX0_RXRESETDONE_OUT,
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        TXCHARDISPMODE_IN               =>      GTX0_TXCHARDISPMODE_IN,
        TXCHARDISPVAL_IN                =>      GTX0_TXCHARDISPVAL_IN,
        TXCHARISK_IN                    =>      GTX0_TXCHARISK_IN,
        ------------------------- Transmit Ports - GTX Ports -----------------------
        GTXTEST_IN                      =>      gtx0_gtxtest_i,
        ------------------ Transmit Ports - TX Data Path interface -----------------
        TXDATA_IN                       =>      GTX0_TXDATA_IN,
        TXOUTCLK_OUT                    =>      GTX0_TXOUTCLK_OUT,
        TXRESET_IN                      =>      gtx0_txreset_i,
        TXUSRCLK2_IN                    =>      GTX0_TXUSRCLK2_IN,
        ---------------- Transmit Ports - TX Driver and OOB signaling --------------
        TXN_OUT                         =>      GTX0_TXN_OUT,
        TXP_OUT                         =>      GTX0_TXP_OUT,
        ----------- Transmit Ports - TX Elastic Buffer and Phase Alignment ---------
        TXBUFSTATUS_OUT                 =>      GTX0_TXBUFSTATUS_OUT,
        ----------------------- Transmit Ports - TX PLL Ports ----------------------
        GTXTXRESET_IN                   =>      GTX0_GTXTXRESET_IN,
        MGTREFCLKTX_IN                  =>      gtx0_mgtrefclkrx_i,
        PLLTXRESET_IN                   =>      tied_to_ground_i,
        TXPLLLKDET_OUT                  =>      open,
        TXRESETDONE_OUT                 =>      GTX0_TXRESETDONE_OUT

    );


     gtx0_double_reset_i : DOUBLE_RESET_sgmii
     port map
     (
        CLK                             =>      GTX0_DOUBLE_RESET_CLK_IN,
        PLLLKDET                        =>      gtx0_rxplllkdet_i,
        GTXTEST_DONE                    =>      gtx0_gtxtest_done,
        GTXTEST_BIT1                    =>      gtx0_gtxtest_bit1
     );


end RTL;
