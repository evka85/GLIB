------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version : 1.12
--  \   \         Application : Virtex-6 FPGA GTX Transceiver Wizard 
--  /   /         Filename : daq_gtx_wrapper.vhd
-- /___/   /\      
-- \   \  /  \ 
--  \___\/\___\
--
--
-- Module daq_gtx_wrapper
-- Generated by Xilinx Virtex-6 FPGA GTX Transceiver Wizard
-- 
-- 
-- (c) Copyright 2009-2011 Xilinx, Inc. All rights reserved.
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

--***********************************Entity Declaration************************

entity daq_gtx_wrapper is
generic
(
    EXAMPLE_SIM_GTXRESET_SPEEDUP            : integer   := 1;    -- simulation setting for GTX SecureIP model
);
port
(
    Q3_CLK1_MGTREFCLK_PAD_N_IN              : in   std_logic;
    Q3_CLK1_MGTREFCLK_PAD_P_IN              : in   std_logic;
    GTXTXRESET_IN                           : in   std_logic;
    GTXRXRESET_IN                           : in   std_logic;
    TRACK_DATA_OUT                          : out  std_logic;
    RXN_IN                                  : in   std_logic;
    RXP_IN                                  : in   std_logic;
    TXN_OUT                                 : out  std_logic;
    TXP_OUT                                 : out  std_logic
    
);


end daq_gtx_wrapper;
    
architecture RTL of daq_gtx_wrapper is

--**************************Component Declarations*****************************


component daq_gtx 
generic
(
    -- Simulation attributes
    WRAPPER_SIM_GTXRESET_SPEEDUP    : integer   := 0 -- Set to 1 to speed up sim reset
);
port
(

    --_________________________________________________________________________
    --_________________________________________________________________________
    --GTX0  (X0_Y8)

    ------------------------ Loopback and Powerdown Ports ----------------------
    GTX0_LOOPBACK_IN                        : in   std_logic_vector(2 downto 0);
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    GTX0_RXCHARISCOMMA_OUT                  : out  std_logic_vector(1 downto 0);
    GTX0_RXCHARISK_OUT                      : out  std_logic_vector(1 downto 0);
    GTX0_RXDISPERR_OUT                      : out  std_logic_vector(1 downto 0);
    GTX0_RXNOTINTABLE_OUT                   : out  std_logic_vector(1 downto 0);
    ------------------- Receive Ports - Clock Correction Ports -----------------
    GTX0_RXCLKCORCNT_OUT                    : out  std_logic_vector(2 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    GTX0_RXBYTEISALIGNED_OUT                : out  std_logic;
    GTX0_RXBYTEREALIGN_OUT                  : out  std_logic;
    GTX0_RXCOMMADET_OUT                     : out  std_logic;
    GTX0_RXENMCOMMAALIGN_IN                 : in   std_logic;
    GTX0_RXENPCOMMAALIGN_IN                 : in   std_logic;
    ------------------- Receive Ports - RX Data Path interface -----------------
    GTX0_RXDATA_OUT                         : out  std_logic_vector(15 downto 0);
    GTX0_RXUSRCLK2_IN                       : in   std_logic;
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GTX0_RXCDRRESET_IN                      : in   std_logic;
    GTX0_RXEQMIX_IN                         : in   std_logic_vector(2 downto 0);
    GTX0_RXN_IN                             : in   std_logic;
    GTX0_RXP_IN                             : in   std_logic;
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GTX0_GTXRXRESET_IN                      : in   std_logic;
    GTX0_MGTREFCLKRX_IN                     : in   std_logic;
    GTX0_PLLRXRESET_IN                      : in   std_logic;
    GTX0_RXPLLLKDET_OUT                     : out  std_logic;
    GTX0_RXRESETDONE_OUT                    : out  std_logic;
    ----------------- Receive Ports - RX Polarity Control Ports ----------------
    GTX0_RXPOLARITY_IN                      : in   std_logic;
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    GTX0_TXCHARISK_IN                       : in   std_logic_vector(1 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GTX0_TXDATA_IN                          : in   std_logic_vector(15 downto 0);
    GTX0_TXOUTCLK_OUT                       : out  std_logic;
    GTX0_TXUSRCLK2_IN                       : in   std_logic;
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GTX0_TXDIFFCTRL_IN                      : in   std_logic_vector(3 downto 0);
    GTX0_TXN_OUT                            : out  std_logic;
    GTX0_TXP_OUT                            : out  std_logic;
    GTX0_TXPOSTEMPHASIS_IN                  : in   std_logic_vector(4 downto 0);
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    GTX0_TXPREEMPHASIS_IN                   : in   std_logic_vector(3 downto 0);
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GTX0_GTXTXRESET_IN                      : in   std_logic;
    GTX0_TXRESETDONE_OUT                    : out  std_logic;
    -------------------- Transmit Ports - TX Polarity Control ------------------
    GTX0_TXPOLARITY_IN                      : in   std_logic


);
end component;

component MGT_USRCLK_SOURCE 
generic
(
    FREQUENCY_MODE   : string   := "LOW";    
    PERFORMANCE_MODE : string   := "MAX_SPEED"    
);
port
(
    DIV1_OUT                : out std_logic;
    DIV2_OUT                : out std_logic;
    DCM_LOCKED_OUT          : out std_logic;
    CLK_IN                  : in  std_logic;
    DCM_RESET_IN            : in  std_logic

);
end component;

--***********************************Parameter Declarations********************

    constant DLY : time := 1 ns;
 
    attribute max_fanout : string; 

--************************** Register Declarations ****************************

    signal   gtx0_txresetdone_r              : std_logic;
    signal   gtx0_txresetdone_r2             : std_logic;
    signal   gtx0_rxresetdone_i_r            : std_logic;
    signal   gtx0_rxresetdone_r              : std_logic;
    signal   gtx0_rxresetdone_r2             : std_logic;
    signal   gtx0_rxresetdone_r3             : std_logic;
    attribute max_fanout of gtx0_rxresetdone_i_r : signal is "1";


--**************************** Wire Declarations ******************************
    -------------------------- MGT Wrapper Wires ------------------------------
    --________________________________________________________________________
    --________________________________________________________________________
    --GTX0   (X0Y8)

    ------------------------ Loopback and Powerdown Ports ----------------------
    signal  gtx0_loopback_i                 : std_logic_vector(2 downto 0);
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    signal  gtx0_rxchariscomma_i            : std_logic_vector(1 downto 0);
    signal  gtx0_rxcharisk_i                : std_logic_vector(1 downto 0);
    signal  gtx0_rxdisperr_i                : std_logic_vector(1 downto 0);
    signal  gtx0_rxnotintable_i             : std_logic_vector(1 downto 0);
    ------------------- Receive Ports - Clock Correction Ports -----------------
    signal  gtx0_rxclkcorcnt_i              : std_logic_vector(2 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    signal  gtx0_rxbyteisaligned_i          : std_logic;
    signal  gtx0_rxbyterealign_i            : std_logic;
    signal  gtx0_rxcommadet_i               : std_logic;
    signal  gtx0_rxenmcommaalign_i          : std_logic;
    signal  gtx0_rxenpcommaalign_i          : std_logic;
    ------------------- Receive Ports - RX Data Path interface -----------------
    signal  gtx0_rxdata_i                   : std_logic_vector(15 downto 0);
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    signal  gtx0_rxcdrreset_i               : std_logic;
    signal  gtx0_rxeqmix_i                  : std_logic_vector(2 downto 0);
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    signal  gtx0_gtxrxreset_i               : std_logic;
    signal  gtx0_pllrxreset_i               : std_logic;
    signal  gtx0_rxplllkdet_i               : std_logic;
    signal  gtx0_rxresetdone_i              : std_logic;
    ----------------- Receive Ports - RX Polarity Control Ports ----------------
    signal  gtx0_rxpolarity_i               : std_logic;
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
    signal  gtx0_gtxtxreset_i               : std_logic;
    signal  gtx0_txresetdone_i              : std_logic;
    -------------------- Transmit Ports - TX Polarity Control ------------------
    signal  gtx0_txpolarity_i               : std_logic;



    signal  gtx0_tx_system_reset_c          : std_logic;
    signal  gtx0_rx_system_reset_c          : std_logic;
    signal  tied_to_ground_i                : std_logic;
    signal  tied_to_ground_vec_i            : std_logic_vector(63 downto 0);
    signal  tied_to_vcc_i                   : std_logic;
    signal  tied_to_vcc_vec_i               : std_logic_vector(7 downto 0);
    signal  drp_clk_in_i                    : std_logic;
 

    ----------------------------- User Clocks ---------------------------------

    signal  gtx0_txusrclk2_i                : std_logic;


    ----------------------------- Reference Clocks ----------------------------
    
    signal    q3_clk1_refclk_i                : std_logic;
    signal    q3_clk1_refclk_i_bufg           : std_logic;
    
--**************************** Main Body of Code *******************************
begin

    --  Static signal Assigments
    tied_to_ground_i                             <= '0';
    tied_to_ground_vec_i                         <= x"0000000000000000";
    tied_to_vcc_i                                <= '1';
    tied_to_vcc_vec_i                            <= x"ff";



    
  

    -----------------------Dedicated GTX Reference Clock Inputs ---------------
    -- The dedicated reference clock inputs you selected in the GUI are implemented using
    -- IBUFDS_GTXE1 instances.
    --
    -- In the UCF file for this example design, you will see that each of
    -- these IBUFDS_GTXE1 instances has been LOCed to a particular set of pins. By LOCing to these
    -- locations, we tell the tools to use the dedicated input buffers to the GTX reference
    -- clock network, rather than general purpose IOs. To select other pins, consult the 
    -- Implementation chapter of UG___, or rerun the wizard.
    --
    -- This network is the highest performace (lowest jitter) option for providing clocks
    -- to the GTX transceivers.
    
    q3_clk1_refclk_ibufds_i : IBUFDS_GTXE1
    port map
    (
        O                               =>      q3_clk1_refclk_i,
        ODIV2                           =>      open,
        CEB                             =>      tied_to_ground_i,
        I                               =>      Q3_CLK1_MGTREFCLK_PAD_P_IN,
        IB                              =>      Q3_CLK1_MGTREFCLK_PAD_N_IN
    );

 

   q3_clk1_refclk_bufg_i : BUFG
    port map
    (
        I                               =>      q3_clk1_refclk_i,
        O                               =>      q3_clk1_refclk_i_bufg
    );



    ----------------------------------- User Clocks ---------------------------
    
    -- The clock resources in this section were added based on userclk source selections on
    -- the Latency, Buffering, and Clocking page of the GUI. A few notes about user clocks:
    -- * The userclk and userclk2 for each GTX datapath (TX and RX) must be phase aligned to 
    --   avoid data errors in the fabric interface whenever the datapath is wider than 10 bits
    -- * To minimize clock resources, you can share clocks between GTXs. GTXs using the same frequency
    --   or multiples of the same frequency can be accomadated using MMCMs. Use caution when
    --   using RXRECCLK as a clock source, however - these clocks can typically only be shared if all
    --   the channels using the clock are receiving data from TX channels that share a reference clock 
    --   source with each other.

    txoutclk_bufg0_i : BUFG
    port map
    (
        I                               =>      gtx0_txoutclk_i,
        O                               =>      gtx0_txusrclk2_i
    );




    ----------------------------- The GTX Wrapper -----------------------------
    
    -- Use the instantiation template in the example directory to add the GTX wrapper to your design.
    -- In this example, the wrapper is wired up for basic operation with a frame generator and frame 
    -- checker. The GTXs will reset, then attempt to align and transmit data. If channel bonding is 
    -- enabled, bonding should occur after alignment.


    daq_gtx_i : daq_gtx
    generic map
    (
        WRAPPER_SIM_GTXRESET_SPEEDUP    =>      EXAMPLE_SIM_GTXRESET_SPEEDUP
    )
    port map
    (

        --_____________________________________________________________________
        --_____________________________________________________________________
        --GTX0  (X0Y8)
        ------------------------ Loopback and Powerdown Ports ----------------------
        GTX0_LOOPBACK_IN                =>      gtx0_loopback_i,
        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        GTX0_RXCHARISCOMMA_OUT          =>      gtx0_rxchariscomma_i,
        GTX0_RXCHARISK_OUT              =>      gtx0_rxcharisk_i,
        GTX0_RXDISPERR_OUT              =>      gtx0_rxdisperr_i,
        GTX0_RXNOTINTABLE_OUT           =>      gtx0_rxnotintable_i,
        ------------------- Receive Ports - Clock Correction Ports -----------------
        GTX0_RXCLKCORCNT_OUT            =>      gtx0_rxclkcorcnt_i,
        --------------- Receive Ports - Comma Detection and Alignment --------------
        GTX0_RXBYTEISALIGNED_OUT        =>      gtx0_rxbyteisaligned_i,
        GTX0_RXBYTEREALIGN_OUT          =>      gtx0_rxbyterealign_i,
        GTX0_RXCOMMADET_OUT             =>      gtx0_rxcommadet_i,
        GTX0_RXENMCOMMAALIGN_IN         =>      gtx0_rxenmcommaalign_i,
        GTX0_RXENPCOMMAALIGN_IN         =>      gtx0_rxenpcommaalign_i,
        ------------------- Receive Ports - RX Data Path interface -----------------
        GTX0_RXDATA_OUT                 =>      gtx0_rxdata_i,
        GTX0_RXUSRCLK2_IN               =>      gtx0_txusrclk2_i,
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        GTX0_RXCDRRESET_IN              =>      gtx0_rxcdrreset_i,
        GTX0_RXEQMIX_IN                 =>      gtx0_rxeqmix_i,
        GTX0_RXN_IN                     =>      RXN_IN,
        GTX0_RXP_IN                     =>      RXP_IN,
        ------------------------ Receive Ports - RX PLL Ports ----------------------
        GTX0_GTXRXRESET_IN              =>      gtx0_gtxrxreset_i,
        GTX0_MGTREFCLKRX_IN             =>      q3_clk1_refclk_i,
        GTX0_PLLRXRESET_IN              =>      gtx0_pllrxreset_i,
        GTX0_RXPLLLKDET_OUT             =>      gtx0_rxplllkdet_i,
        GTX0_RXRESETDONE_OUT            =>      gtx0_rxresetdone_i,
        ----------------- Receive Ports - RX Polarity Control Ports ----------------
        GTX0_RXPOLARITY_IN              =>      gtx0_rxpolarity_i,
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        GTX0_TXCHARISK_IN               =>      gtx0_txcharisk_i,
        ------------------ Transmit Ports - TX Data Path interface -----------------
        GTX0_TXDATA_IN                  =>      gtx0_txdata_i,
        GTX0_TXOUTCLK_OUT               =>      gtx0_txoutclk_i,
        GTX0_TXUSRCLK2_IN               =>      gtx0_txusrclk2_i,
        ---------------- Transmit Ports - TX Driver and OOB signaling --------------
        GTX0_TXDIFFCTRL_IN              =>      gtx0_txdiffctrl_i,
        GTX0_TXN_OUT                    =>      TXN_OUT,
        GTX0_TXP_OUT                    =>      TXP_OUT,
        GTX0_TXPOSTEMPHASIS_IN          =>      gtx0_txpostemphasis_i,
        --------------- Transmit Ports - TX Driver and OOB signalling --------------
        GTX0_TXPREEMPHASIS_IN           =>      gtx0_txpreemphasis_i,
        ----------------------- Transmit Ports - TX PLL Ports ----------------------
        GTX0_GTXTXRESET_IN              =>      gtx0_gtxtxreset_i,
        GTX0_TXRESETDONE_OUT            =>      gtx0_txresetdone_i,
        -------------------- Transmit Ports - TX Polarity Control ------------------
        GTX0_TXPOLARITY_IN              =>      gtx0_txpolarity_i


    );


    -------------------------- User Module Resets -----------------------------
    -- All the User Modules i.e. FRAME_GEN, FRAME_CHECK and the sync modules
    -- are held in reset till the RESETDONE goes high. 
    -- The RESETDONE is registered a couple of times on USRCLK2 and connected 
    -- to the reset of the modules
    
    process( gtx0_txusrclk2_i)
    begin
         if(gtx0_txusrclk2_i'event and gtx0_txusrclk2_i = '1') then
            gtx0_rxresetdone_i_r  <= gtx0_rxresetdone_i   after DLY;
         end if; 
    end process; 

    process( gtx0_txusrclk2_i,gtx0_rxresetdone_i_r)
    begin
        if(gtx0_rxresetdone_i_r = '0') then
            gtx0_rxresetdone_r    <= '0'   after DLY;
            gtx0_rxresetdone_r2   <= '0'   after DLY;
        elsif(gtx0_txusrclk2_i'event and gtx0_txusrclk2_i = '1') then
            gtx0_rxresetdone_r    <= gtx0_rxresetdone_i_r after DLY;
            gtx0_rxresetdone_r2   <= gtx0_rxresetdone_r   after DLY;
        end if;
    end process;

    process( gtx0_txusrclk2_i)
    begin
         if(gtx0_txusrclk2_i'event and gtx0_txusrclk2_i = '1') then
            gtx0_rxresetdone_r3  <= gtx0_rxresetdone_r2   after DLY;
         end if; 
    end process; 

    process( gtx0_txusrclk2_i,gtx0_txresetdone_i)
    begin
        if(gtx0_txresetdone_i = '0') then
            gtx0_txresetdone_r  <= '0'   after DLY;
            gtx0_txresetdone_r2 <= '0'   after DLY;
        elsif(gtx0_txusrclk2_i'event and gtx0_txusrclk2_i = '1') then
            gtx0_txresetdone_r  <= gtx0_txresetdone_i   after DLY;
            gtx0_txresetdone_r2 <= gtx0_txresetdone_r   after DLY;
        end if;
    end process;

    -- If Chipscope is not being used, drive GTX reset signal
    -- from the top level ports
    gtx0_gtxtxreset_i                            <= GTXTXRESET_IN;
    gtx0_gtxrxreset_i                            <= GTXRXRESET_IN;

    -- assign resets for frame_gen modules
    gtx0_tx_system_reset_c                       <= not gtx0_txresetdone_r2;
    -- assign resets for frame_check modules
    gtx0_rx_system_reset_c                       <= not gtx0_rxresetdone_r3;

    gtxtxreset_i                                 <= tied_to_ground_i;
    gtxrxreset_i                                 <= tied_to_ground_i;
    user_tx_reset_i                              <= tied_to_ground_i;
    user_rx_reset_i                              <= tied_to_ground_i;
    gtx0_loopback_i                              <= tied_to_ground_vec_i(2 downto 0);
    gtx0_txdiffctrl_i                            <= "1010";
    gtx0_txpreemphasis_i                         <= tied_to_ground_vec_i(3 downto 0);
    gtx0_txpostemphasis_i                        <= tied_to_ground_vec_i(4 downto 0);
    gtx0_txpolarity_i                            <= tied_to_ground_i;
    gtx0_pllrxreset_i                            <= tied_to_ground_i;
    gtx0_rxcdrreset_i                            <= tied_to_ground_i;
    gtx0_rxeqmix_i                               <= tied_to_ground_vec_i(2 downto 0);
    gtx0_rxpolarity_i                            <= tied_to_ground_i;

end RTL;

