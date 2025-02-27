--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Altera Cyclone V - Multi Gigabit Transceivers latency-optimized
--                                                                                                 
-- Language:              VHDL'93                                                                 
--                                                                                                   
-- Target Device:         Altera Cyclone V                                                      
-- Tool version:          Quartus II 13.1                                                              
--                                                                                                   
-- Revision:              3.0                                                                      
--
-- Description:           
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        06/04/2014   3.0       M. Barros Marin   First .vhd module definition           
--
-- Additional Comments:                                                                               
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Bank are set through:                               !!  
-- !!   (Note!! These parameters are vendor specific)                                           !!                    
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Bank module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_bank_package.vhd").                                !! 
-- !!     (e.g. xlx_v6_gbt_bank_package.vhd)                                                    !!
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<vendor>_<device>_gbt_bank_user_setup.vhd".     !!
-- !!     (e.g. xlx_v6_gbt_bank_user_setup.vhd)                                                 !! 
-- !!                                                                                           !! 
-- !! * The "<vendor>_<device>_gbt_bank_user_setup.vhd" is the only file of the GBT Bank that   !!
-- !!   may be modified by the user. The rest of the files MUST be used as is.                  !!
-- !!                                                                                           !!  
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--                                                                                                   
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Altera devices library:
library altera; 
library altera_mf;
library lpm;
use altera.altera_primitives_components.all;   
use altera_mf.altera_mf_components.all;
use lpm.lpm_components.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

-- Libraries for direct instantiation:
library alt_cv_gt_latopt_x1;
library alt_cv_gt_latopt_x2;
library alt_cv_gt_latopt_x3;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity mgt_latopt is
   generic (
      GBT_BANK_ID                                  : integer := 1
   ); 
   port (      

      --===============--  
      -- Clocks scheme --  
      --===============--  

      MGT_CLKS_I                                   : in  gbtBankMgtClks_i_R;
      MGT_CLKS_O                                   : out gbtBankMgtClks_o_R;        

      --=========--  
      -- MGT I/O --  
      --=========--  

      MGT_I                                        : in  mgt_i_R;
      MGT_O                                        : out mgt_o_R;

      --=============-- 
      -- GBT Control -- 
      --=============-- 

      GBT_RX_HEADER_LOCKED_I                       : in  std_logic_vector       (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
      GBT_RX_BITSLIP_NBR_I                         : in  gbtRxSlideNbr_mxnbit_A (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);      
      
      GBT_RX_MGT_RDY_O                             : out std_logic_vector       (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
      GBT_RX_RXWORDCLK_READY_O                     : out std_logic_vector       (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
      
      --=======-- 
      -- Words -- 
      --=======-- 
 
      GBT_TX_WORD_I                                : in  word_mxnbit_A          (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);     
      GBT_RX_WORD_O                                : out word_mxnbit_A          (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS) 
   
   );
end mgt_latopt;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of mgt_latopt is 

   --================================ Signal Declarations ================================--
   
   --======================--
   -- GT reset controllers --
   --======================--  
   
   signal txAnalogReset_from_gtRstCtrl             : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
   signal txDigitalReset_from_gtRstCtrl            : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
   signal txReady_from_gtRstCtrl                   : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
   ------------------------------------------------   
   signal rxAnalogreset_from_gtRstCtrl             : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
   signal rxDigitalreset_from_gtRstCtrl            : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
   signal rxReady_from_gtRstCtrl                   : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);

   --=======================--
   -- TX_WORDCLK monitoring --
   --=======================--
   
   signal done_from_txWordClkMon                   : std_logic;

   --====================--
   -- RX phase alignment --
   --====================--
   
   signal bitSlipNbr_to_bitSlipControl             : gbtRxSlideNbr_mxnbit_A     (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
   signal bitSlipRun_to_bitSlipControl             : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
   signal bitSlip_from_bitSlipControl              : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
   signal bitSlip_to_gtLatOpt                      : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);   
   signal done_from_bitSlipControl                 : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);  
   
   --================================================--
   -- Multi-Gigabit Transceivers (latency-optimized) --
   --================================================--      

   signal rxIsLockedToData_from_gtLatOpt           : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);   
   signal txCalBusy_from_gtLatOpt                  : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
   signal rxCalBusy_from_gtLatOpt                  : std_logic_vector           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS); 
   
   --=====================================================================================--   
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================-- 
   
   --=============--
   -- Assignments --
   --=============--
   
   commonAssign_gen: for i in 1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS generate
   
      MGT_O.mgtLink(i).txCal_busy                  <= txCalBusy_from_gtLatOpt(i);
      MGT_O.mgtLink(i).rxCal_busy                  <= rxCalBusy_from_gtLatOpt(i);
      MGT_O.mgtLink(i).ready                       <= txReady_from_gtRstCtrl(i) and rxReady_from_gtRstCtrl(i);
      MGT_O.mgtLink(i).tx_ready                    <= txReady_from_gtRstCtrl(i);
      MGT_O.mgtLink(i).rx_ready                    <= rxReady_from_gtRstCtrl(i);
      GBT_RX_MGT_RDY_O(i)                          <= rxReady_from_gtRstCtrl(i);         
      MGT_O.mgtLink(i).rxIsLocked_toData           <= rxIsLockedToData_from_gtLatOpt(i);
   
   end generate;
   
   --======================--
   -- GT reset controllers --
   --======================--
   
   gtRstCtrl_gen: for i in 1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS generate
   
      gtRstCtrl: entity work.alt_cv_mgt_resetctrl       
         port map (
            CLK_I                                  => MGT_CLKS_I.mgtTxRefClk,                            
            ---------------------------------------            
            TX_RESET_I                             => MGT_I.mgtLink(i).tx_reset,    
            RX_RESET_I                             => MGT_I.mgtLink(i).rx_reset,    
            ---------------------------------------             
            TX_ANALOGRESET_O                       => txAnalogReset_from_gtRstCtrl(i),
            TX_DIGITALRESET_O                      => txDigitalReset_from_gtRstCtrl(i),                  
            TX_READY_O                             => txReady_from_gtRstCtrl(i),                         
            PLL_LOCKED_I                           => MGT_I.mgtCommon.extGtTxPll_locked,                       
            TX_CAL_BUSY_I                          => txCalBusy_from_gtLatOpt(i),                          
            ---------------------------------------             
            RX_ANALOGRESET_O                       => rxAnalogreset_from_gtRstCtrl(i),
            RX_DIGITALRESET_O                      => rxDigitalreset_from_gtRstCtrl(i),                          
            RX_READY_O                             => rxReady_from_gtRstCtrl(i),                         
            RX_IS_LOCKEDTODATA_I                   => rxIsLockedToData_from_gtLatOpt(i),                     
            RX_CAL_BUSY_I                          => rxCalBusy_from_gtLatOpt(i)                                 
         );
   
   end generate;

   --=======================--
   -- TX_WORDCLK monitoring --
   --=======================--
 
   txWordClkMon_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).TX_OPTIMIZATION = LATENCY_OPTIMIZED generate
      
      -- Comment: * The phase of TX_WORDCLK may be 0deg or 180deg with respect to the phase of the MGT_REFCLK.
      --
      --          * The module "txWordClkMon" monitors the phase of TX_WORDCLK and if it is not the one chosen by 
      --            the user, resets the GT TX until having the correct phase.
            
      txWordClkMon: entity work.alt_cv_mgt_latopt_txwordclkmon
         port map (
            TX_RESET_I                             => MGT_I.mgtLink(1).tx_reset,
            ---------------------------------------                     
            SAMPLED_CLK_I                          => MGT_CLKS_I.txWrdClkMon_sampledClk,
            MGT_TX_PLL_LOCKED_I                    => MGT_I.mgtCommon.extGtTxPll_locked,
            MGT_REFCLK_I                           => MGT_CLKS_I.mgtTxRefClk,           
            TX_READY_I                             => txReady_from_gtRstCtrl(1),
            TX_WORDCLK_I                           => MGT_CLKS_I.tx_wordClk(1),
            ---------------------------------------         
            THRESHOLD_UP_I                         => MGT_I.mgtCommon.txWrdClkMon_thresholdUp,
            STATS_O                                => MGT_O.mgtCommon.txWrdClkMon_stats,
            THRESHOLD_LOW_I                        => MGT_I.mgtCommon.txWrdClkMon_thresholdLow,           
            PHASE_OK_O                             => MGT_O.mgtCommon.txWrdClkMon_phaseOk,
            DONE_O                                 => done_from_txWordClkMon,
            ---------------------------------------         
            MGT_TX_RESET_EN_I                      => MGT_I.mgtCommon.txWrdClkMon_mgtTxRstEn,
            MGT_TX_RESET_O                         => MGT_O.mgtCommon.txWrdClkMon_reset
         );
      
   end generate;

   txWordClkMon_no_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).TX_OPTIMIZATION = STANDARD generate

      MGT_O.mgtCommon.txWrdClkMon_stats            <= (others => '0');
      MGT_O.mgtCommon.txWrdClkMon_phaseOk          <= '0';
      
      done_from_txWordClkMon                       <= '1';
      ---------------------------------------------
      MGT_O.mgtCommon.txWrdClkMon_reset            <= '0';
      
   end generate;
      
   --====================--
   -- RX phase alignment --
   --====================--
   
   -- Comment: Note!! The standard version of the GT does not align the phase of the  
   --                 RX_RECCLK (RX_WORDCLK) with respect to the TX_OUTCLK (TX_WORDCLK).
   
   rxPhaseAlign_numLinks_gen: for i in 1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS generate

      rxPhaseAlign_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).RX_OPTIMIZATION = LATENCY_OPTIMIZED generate
      
         -- Bitslip control module:
         --------------------------
         
         bitSlipControl: entity work.mgt_latopt_bitslipctrl 
            port map (
               RX_RESET_I                          => rxDigitalreset_from_gtRstCtrl(i),
               RX_WORDCLK_I                        => MGT_CLKS_I.rx_wordClk(i),
               NUMBITSLIPS_I                       => bitSlipNbr_to_bitSlipControl(i),
               ENABLE_I                            => bitSlipRun_to_bitSlipControl(i),
               BITSLIP_O                           => bitSlip_from_bitSlipControl(i),
               DONE_O                              => done_from_bitSlipControl(i)
            );   
         
         MGT_O.mgtLink(i).rxWordClkReady           <= done_from_bitSlipControl(i);
         GBT_RX_RXWORDCLK_READY_O(i)               <= done_from_bitSlipControl(i);
            
         -- Manual or auto bitslip control selection logic:
         --------------------------------------------------
         
         -- Comment: * MGT_I(i).rxSlide_enable must be '1' to enable the GT RX phase alignment.
         --
         --          * Manual control: MGT_I(i).rxSlide_ctrl = '1'
         --            Auto control  : MGT_I(i).rxSlide_ctrl = '0'
         --
         --          * In manual control, the user provides the number of bitslips (MGT_I(i).rxSlide_nbr)
         --            as well as triggers the GT RX phase alignment (MGT_I(i).rxSlide_run).
         
         bitSlip_to_gtLatOpt(i)                    <= bitSlip_from_bitSlipControl(i) when     MGT_I.mgtLink(i).rxSlide_enable = '1'
                                                      -----------------------------------------------------------------------------
                                                      else '0'; 
                                                
         bitSlipRun_to_bitSlipControl(i)           <= MGT_I.mgtLink(i).rxSlide_run   when     MGT_I.mgtLink(i).rxSlide_enable = '1' 
                                                                                          and MGT_I.mgtLink(i).rxSlide_ctrl   = '1'
                                                      -----------------------------------------------------------------------------
                                                      else GBT_RX_HEADER_LOCKED_I(i) when     MGT_I.mgtLink(i).rxSlide_enable = '1'
                                                                                          and MGT_I.mgtLink(i).rxSlide_ctrl   = '0'
                                                   -----------------------------------------------------------------------------
                                                   else '0';
                           
         bitSlipNbr_to_bitSlipControl(i)           <= MGT_I.mgtLink(i).rxSlide_nbr   when     MGT_I.mgtLink(i).rxSlide_enable = '1'
                                                                                          and MGT_I.mgtLink(i).rxSlide_ctrl   = '1'
                                                      -----------------------------------------------------------------------------                                
                                                      else GBT_RX_BITSLIP_NBR_I(i)   when     MGT_I.mgtLink(i).rxSlide_enable = '1'
                                                                                          and MGT_I.mgtLink(i).rxSlide_ctrl   = '0'
                                                      -----------------------------------------------------------------------------                                
                                                      else (others => '0');   
      
      end generate;
      
      rxPhaseAlign_no_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).RX_OPTIMIZATION = STANDARD generate
      
         -- Bitslip control module:
         --------------------------
        
         MGT_O.mgtLink(i).rxWordClkReady           <= rxReady_from_gtRstCtrl(i);
         GBT_RX_RXWORDCLK_READY_O(i)               <= rxReady_from_gtRstCtrl(i);
         
         -- Manual or auto bitslip control selection logic:
         --------------------------------------------------
      
         bitSlip_to_gtLatOpt(i)                    <= '0';
      
      end generate;
      
   end generate;
   
   --================================================--
   -- Multi-Gigabit Transceivers (latency-optimized) --
   --================================================-- 
   
   -- MGT latency-optimized x1:
   ----------------------------
   
   gtLatOpt_x1_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS = 1 generate
      
      gtLatOpt_x1: entity alt_cv_gt_latopt_x1.alt_cv_gt_latopt_x1
         port map (
            PLL_POWERDOWN(0)                       => MGT_I.mgtCommon.extGtTxPll_powerDown,   
            TX_ANALOGRESET(0)                      => txAnalogReset_from_gtRstCtrl(1), 
            TX_DIGITALRESET(0)                     => txDigitalReset_from_gtRstCtrl(1), 
            TX_SERIAL_DATA(0)                      => MGT_O.mgtLink(1).txSerialData,                      
            EXT_PLL_CLK(0)                         => MGT_CLKS_I.extGtTxPll_clk,                
            RX_ANALOGRESET(0)                      => rxAnalogReset_from_gtRstCtrl(1),
            RX_DIGITALRESET(0)                     => rxDigitalReset_from_gtRstCtrl(1),
            RX_CDR_REFCLK(0)                       => MGT_CLKS_I.mgtRxRefClk,      
            RX_SERIAL_DATA(0)                      => MGT_I.mgtLink(1).rxSerialData,       
            RX_CLKSLIP(0)                          => bitSlip_to_gtLatOpt(1),
            RX_IS_LOCKEDTOREF(0)                   => MGT_O.mgtLink(1).rxIsLocked_toRef,    
            RX_IS_LOCKEDTODATA (0)                 => rxIsLockedToData_from_gtLatOpt(1),
            RX_SERIALLPBKEN(0)                     => MGT_I.mgtLink(1).loopBack, 
            TX_STD_CORECLKIN(0)                    => MGT_CLKS_I.tx_wordClk(1),      
            RX_STD_CORECLKIN(0)                    => MGT_CLKS_I.rx_wordClk(1),      
            TX_STD_CLKOUT(0)                       => MGT_CLKS_O.tx_wordClk(1),         
            RX_STD_CLKOUT(0)                       => MGT_CLKS_O.rx_wordClk(1),         
            TX_STD_POLINV(0)                       => MGT_I.mgtLink(1).tx_polarity,      
            RX_STD_POLINV(0)                       => MGT_I.mgtLink(1).rx_polarity,      
            TX_CAL_BUSY(0)                         => txCalBusy_from_gtLatOpt(1),         
            RX_CAL_BUSY(0)                         => rxCalBusy_from_gtLatOpt(1),         
            RECONFIG_TO_XCVR                       => MGT_I.mgtCommon.reconfigXcvr((1*70)-1 downto 0),  
            RECONFIG_FROM_XCVR                     => MGT_O.mgtCommon.reconfigXcvr((1*46)-1 downto 0),
            TX_PARALLEL_DATA                       => GBT_TX_WORD_I(1),
            RX_PARALLEL_DATA                       => GBT_RX_WORD_O(1)    
         );
      
   end generate;
   
   -- MGT latency-optimized x2:
   ----------------------------
   
   gtLatOpt_x2_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS = 2 generate
      
      gtLatOpt_x2: entity alt_cv_gt_latopt_x2.alt_cv_gt_latopt_x2
         port map (
            PLL_POWERDOWN(0)                       => MGT_I.mgtCommon.extGtTxPll_powerDown,    
            TX_ANALOGRESET(0)                      => txAnalogReset_from_gtRstCtrl(1), 
            TX_ANALOGRESET(1)                      => txAnalogReset_from_gtRstCtrl(2), 
            TX_DIGITALRESET(0)                     => txDigitalReset_from_gtRstCtrl(1), 
            TX_DIGITALRESET(1)                     => txDigitalReset_from_gtRstCtrl(2), 
            TX_SERIAL_DATA(0)                      => MGT_O.mgtLink(1).txSerialData,                      
            TX_SERIAL_DATA(1)                      => MGT_O.mgtLink(2).txSerialData,                      
            EXT_PLL_CLK(0)                         => MGT_CLKS_I.extGtTxPll_clk,               
            RX_ANALOGRESET(0)                      => rxAnalogReset_from_gtRstCtrl(1),
            RX_ANALOGRESET(1)                      => rxAnalogReset_from_gtRstCtrl(2),
            RX_DIGITALRESET(0)                     => rxDigitalReset_from_gtRstCtrl(1),
            RX_DIGITALRESET(1)                     => rxDigitalReset_from_gtRstCtrl(2),
            RX_CDR_REFCLK(0)                       => MGT_CLKS_I.mgtRxRefClk,      
            RX_SERIAL_DATA(0)                      => MGT_I.mgtLink(1).rxSerialData,       
            RX_SERIAL_DATA(1)                      => MGT_I.mgtLink(2).rxSerialData,       
            RX_CLKSLIP(0)                          => bitSlip_to_gtLatOpt(1),
            RX_CLKSLIP(1)                          => bitSlip_to_gtLatOpt(2),
            RX_IS_LOCKEDTOREF(0)                   => MGT_O.mgtLink(1).rxIsLocked_toRef,    
            RX_IS_LOCKEDTOREF(1)                   => MGT_O.mgtLink(2).rxIsLocked_toRef,    
            RX_IS_LOCKEDTODATA(0)                  => rxIsLockedToData_from_gtLatOpt(1),
            RX_IS_LOCKEDTODATA(1)                  => rxIsLockedToData_from_gtLatOpt(2),
            RX_SERIALLPBKEN(0)                     => MGT_I.mgtLink(1).loopBack, 
            RX_SERIALLPBKEN(1)                     => MGT_I.mgtLink(2).loopBack, 
            TX_STD_CORECLKIN(0)                    => MGT_CLKS_I.tx_wordClk(1),      
            TX_STD_CORECLKIN(1)                    => MGT_CLKS_I.tx_wordClk(2),      
            RX_STD_CORECLKIN(0)                    => MGT_CLKS_I.rx_wordClk(1),      
            RX_STD_CORECLKIN(1)                    => MGT_CLKS_I.rx_wordClk(2),      
            TX_STD_CLKOUT(0)                       => MGT_CLKS_O.tx_wordClk(1),         
            TX_STD_CLKOUT(1)                       => MGT_CLKS_O.tx_wordClk(2),         
            RX_STD_CLKOUT(0)                       => MGT_CLKS_O.rx_wordClk(1),         
            RX_STD_CLKOUT(1)                       => MGT_CLKS_O.rx_wordClk(2),         
            TX_STD_POLINV(0)                       => MGT_I.mgtLink(1).tx_polarity,      
            TX_STD_POLINV(1)                       => MGT_I.mgtLink(2).tx_polarity,      
            RX_STD_POLINV(0)                       => MGT_I.mgtLink(1).rx_polarity,      
            RX_STD_POLINV(1)                       => MGT_I.mgtLink(2).rx_polarity,      
            TX_CAL_BUSY(0)                         => txCalBusy_from_gtLatOpt(1),         
            TX_CAL_BUSY(1)                         => txCalBusy_from_gtLatOpt(2),         
            RX_CAL_BUSY(0)                         => rxCalBusy_from_gtLatOpt(1),         
            RX_CAL_BUSY(1)                         => rxCalBusy_from_gtLatOpt(2),         
            RECONFIG_TO_XCVR                       => MGT_I.mgtCommon.reconfigXcvr((2*70)-1 downto 0),  
            RECONFIG_FROM_XCVR                     => MGT_O.mgtCommon.reconfigXcvr((2*46)-1 downto 0),
            TX_PARALLEL_DATA(39 downto  0)         => GBT_TX_WORD_I(1),
            TX_PARALLEL_DATA(79 downto 40)         => GBT_TX_WORD_I(2),
            RX_PARALLEL_DATA(39 downto  0)         => GBT_RX_WORD_O(1),
            RX_PARALLEL_DATA(79 downto 40)         => GBT_RX_WORD_O(2)
         );
         
      end generate;   
   
   -- MGT latency-optimized x3:
   ----------------------------
   
   gtLatOpt_x3_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS = 3 generate
      
      gtLatOpt_x3: entity alt_cv_gt_latopt_x3.alt_cv_gt_latopt_x3
         port map (
            PLL_POWERDOWN(0)                       => MGT_I.mgtCommon.extGtTxPll_powerDown,    
            TX_ANALOGRESET(0)                      => txAnalogReset_from_gtRstCtrl(1), 
            TX_ANALOGRESET(1)                      => txAnalogReset_from_gtRstCtrl(2), 
            TX_ANALOGRESET(2)                      => txAnalogReset_from_gtRstCtrl(3), 
            TX_DIGITALRESET(0)                     => txDigitalReset_from_gtRstCtrl(1), 
            TX_DIGITALRESET(1)                     => txDigitalReset_from_gtRstCtrl(2), 
            TX_DIGITALRESET(2)                     => txDigitalReset_from_gtRstCtrl(3), 
            TX_SERIAL_DATA(0)                      => MGT_O.mgtLink(1).txSerialData,                      
            TX_SERIAL_DATA(1)                      => MGT_O.mgtLink(2).txSerialData,                      
            TX_SERIAL_DATA(2)                      => MGT_O.mgtLink(3).txSerialData,                      
            EXT_PLL_CLK(0)                         => MGT_CLKS_I.extGtTxPll_clk,               
            RX_ANALOGRESET(0)                      => rxAnalogReset_from_gtRstCtrl(1),
            RX_ANALOGRESET(1)                      => rxAnalogReset_from_gtRstCtrl(2),
            RX_ANALOGRESET(2)                      => rxAnalogReset_from_gtRstCtrl(3),
            RX_DIGITALRESET(0)                     => rxDigitalReset_from_gtRstCtrl(1),
            RX_DIGITALRESET(1)                     => rxDigitalReset_from_gtRstCtrl(2),
            RX_DIGITALRESET(2)                     => rxDigitalReset_from_gtRstCtrl(3),
            RX_CDR_REFCLK(0)                       => MGT_CLKS_I.mgtRxRefClk,      
            RX_SERIAL_DATA(0)                      => MGT_I.mgtLink(1).rxSerialData,       
            RX_SERIAL_DATA(1)                      => MGT_I.mgtLink(2).rxSerialData,       
            RX_SERIAL_DATA(2)                      => MGT_I.mgtLink(3).rxSerialData,       
            RX_CLKSLIP(0)                          => bitSlip_to_gtLatOpt(1),
            RX_CLKSLIP(1)                          => bitSlip_to_gtLatOpt(2),
            RX_CLKSLIP(2)                          => bitSlip_to_gtLatOpt(3),
            RX_IS_LOCKEDTOREF(0)                   => MGT_O.mgtLink(1).rxIsLocked_toRef,    
            RX_IS_LOCKEDTOREF(1)                   => MGT_O.mgtLink(2).rxIsLocked_toRef,    
            RX_IS_LOCKEDTOREF(2)                   => MGT_O.mgtLink(3).rxIsLocked_toRef,    
            RX_IS_LOCKEDTODATA(0)                  => rxIsLockedToData_from_gtLatOpt(1),
            RX_IS_LOCKEDTODATA(1)                  => rxIsLockedToData_from_gtLatOpt(2),
            RX_IS_LOCKEDTODATA(2)                  => rxIsLockedToData_from_gtLatOpt(3),
            RX_SERIALLPBKEN(0)                     => MGT_I.mgtLink(1).loopBack, 
            RX_SERIALLPBKEN(1)                     => MGT_I.mgtLink(2).loopBack, 
            RX_SERIALLPBKEN(2)                     => MGT_I.mgtLink(3).loopBack, 
            TX_STD_CORECLKIN(0)                    => MGT_CLKS_I.tx_wordClk(1),      
            TX_STD_CORECLKIN(1)                    => MGT_CLKS_I.tx_wordClk(2),      
            TX_STD_CORECLKIN(2)                    => MGT_CLKS_I.tx_wordClk(3),      
            RX_STD_CORECLKIN(0)                    => MGT_CLKS_I.rx_wordClk(1),      
            RX_STD_CORECLKIN(1)                    => MGT_CLKS_I.rx_wordClk(2),      
            RX_STD_CORECLKIN(2)                    => MGT_CLKS_I.rx_wordClk(3),      
            TX_STD_CLKOUT(0)                       => MGT_CLKS_O.tx_wordClk(1),         
            TX_STD_CLKOUT(1)                       => MGT_CLKS_O.tx_wordClk(2),         
            TX_STD_CLKOUT(2)                       => MGT_CLKS_O.tx_wordClk(3),         
            RX_STD_CLKOUT(0)                       => MGT_CLKS_O.rx_wordClk(1),         
            RX_STD_CLKOUT(1)                       => MGT_CLKS_O.rx_wordClk(2),         
            RX_STD_CLKOUT(2)                       => MGT_CLKS_O.rx_wordClk(3),         
            TX_STD_POLINV(0)                       => MGT_I.mgtLink(1).tx_polarity,      
            TX_STD_POLINV(1)                       => MGT_I.mgtLink(2).tx_polarity,      
            TX_STD_POLINV(2)                       => MGT_I.mgtLink(3).tx_polarity,      
            RX_STD_POLINV(0)                       => MGT_I.mgtLink(1).rx_polarity,      
            RX_STD_POLINV(1)                       => MGT_I.mgtLink(2).rx_polarity,      
            RX_STD_POLINV(2)                       => MGT_I.mgtLink(3).rx_polarity,      
            TX_CAL_BUSY(0)                         => txCalBusy_from_gtLatOpt(1),         
            TX_CAL_BUSY(1)                         => txCalBusy_from_gtLatOpt(2),         
            TX_CAL_BUSY(2)                         => txCalBusy_from_gtLatOpt(3),         
            RX_CAL_BUSY(0)                         => rxCalBusy_from_gtLatOpt(1),         
            RX_CAL_BUSY(1)                         => rxCalBusy_from_gtLatOpt(2),         
            RX_CAL_BUSY(2)                         => rxCalBusy_from_gtLatOpt(3),         
            RECONFIG_TO_XCVR                       => MGT_I.mgtCommon.reconfigXcvr((3*70)-1 downto 0),  
            RECONFIG_FROM_XCVR                     => MGT_O.mgtCommon.reconfigXcvr((3*46)-1 downto 0), 
            TX_PARALLEL_DATA( 39 downto  0)        => GBT_TX_WORD_I(1),
            TX_PARALLEL_DATA( 79 downto 40)        => GBT_TX_WORD_I(2),
            TX_PARALLEL_DATA(119 downto 80)        => GBT_TX_WORD_I(3),
            RX_PARALLEL_DATA( 39 downto  0)        => GBT_RX_WORD_O(1),
            RX_PARALLEL_DATA( 79 downto 40)        => GBT_RX_WORD_O(2),
            RX_PARALLEL_DATA(119 downto 80)        => GBT_RX_WORD_O(3)
         );
      
   end generate;
      
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--