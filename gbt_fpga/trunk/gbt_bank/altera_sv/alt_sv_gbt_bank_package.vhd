--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                        (Original design by P. Vichoudis (CERN) & M. Barros Marin)                                                                                                    
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          Altera Stratix V - GBT Bank package                                        
--                                                                                                 
-- Language:              VHDL'93                                                            
--                                                                                                   
-- Target Device:         Altera Stratix V                                                          
-- Tool version:          Quartus II 13.1                                                                
--                                                                                                   
-- Revision:              3.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        09/03/2014   3.0       M. Barros Marin   - First .vhd package definition           
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

--=================================================================================================--
--##################################   Package Declaration   ######################################--
--=================================================================================================--

package vendor_specific_gbt_bank_package is
   
   --=================================== GBT Bank setup ==================================--
   
   constant MAX_NUM_GBT_LINK                    : integer :=  3;
   constant WORD_WIDTH                          : integer := 40; 
   constant WORD_ADDR_MSB                       : integer :=  4;
   constant WORD_ADDR_PS_CHECK_MSB              : integer :=  1;
   constant GBTRX_BITSLIP_NBR_MSB               : integer :=  5;
   constant GBTRX_BITSLIP_NBR_MAX               : integer := 39;
   constant GBTRX_BITSLIP_MIN_DLY               : integer := 40;
   constant RXFRAMECLK_STEPS_MSB                : integer :=  1;
   
   --=====================================================================================--
   
   --================================ Record Declarations ================================--   
   
   --====================--
   -- User setup package --
   --====================--
      
   type gbt_bank_user_setup_R is 
   record
   
      -- Number of links:
      -------------------
      
      -- Comment:   The number of links per GBT Bank is device dependant (up to THREE links on Stratix V).  
      
      NUM_LINKS                                 : integer;
      
      -- GBT Bank optimization:
      -------------------------

      -- Comment:   (0 -> STANDARD | 1 -> LATENCY_OPTIMIZED)  
      
      TX_OPTIMIZATION                           : integer range 0 to 1; 
      RX_OPTIMIZATION                           : integer range 0 to 1; 
      
      -- GBT encodings:
      -----------------
      
      -- Comment:   (0 -> GBT_FRAME | 1 -> WIDE_BUS | 2 -> GBT_8B10B)
      
      TX_ENCODING                               : integer range 0 to 2;
      RX_ENCODING                               : integer range 0 to 2;
      
   end record;  
   
   --===============--
   -- GT bank (MGT) --
   --===============--
   
   -- Clocks scheme:
   -----------------
   
   type gbtBankMgtClks_i_R is
   record         
      mgtTxRefClk                               : std_logic;
      extGtTxPll_clk                            : std_logic;
      mgtRxRefClk                               : std_logic;
      ------------------------------------------
      txWrdClkMon_sampledClk                    : std_logic;
      ------------------------------------------
      tx_wordClk                                : std_logic_vector(1 to MAX_NUM_GBT_LINK);
      rx_wordClk                                : std_logic_vector(1 to MAX_NUM_GBT_LINK);
   end record;   
   
   type gbtBankMgtClks_o_R is
   record
      tx_wordClk                                : std_logic_vector(1 to MAX_NUM_GBT_LINK);
      rx_wordClk                                : std_logic_vector(1 to MAX_NUM_GBT_LINK);         
   end record;   
   
   -- Common I/O:
   --------------
   
   type mgtCommon_i_R is
   record
      extGtTxPll_powerDown                      : std_logic;
      extGtTxPll_locked                         : std_logic;
      ------------------------------------------
      txWrdClkMon_thresholdUp                   : std_logic_vector(7 downto 0);
      txWrdClkMon_thresholdLow                  : std_logic_vector(7 downto 0);
      txWrdClkMon_mgtTxRstEn                    : std_logic;
      ------------------------------------------
      reconfigXcvr                              : std_logic_vector((MAX_NUM_GBT_LINK*70)-1 downto 0); 
   end record;   
   
   type mgtCommon_o_R is
   record
      txWrdClkMon_stats                         : std_logic_vector(7 downto 0);
      txWrdClkMon_phaseOk                       : std_logic;
      txWrdClkMon_reset                         : std_logic;
      ------------------------------------------
      reconfigXcvr                              : std_logic_vector((MAX_NUM_GBT_LINK*46)-1 downto 0); 
   end record;   
   
   -- Links I/O:
   -------------
   
   type mgtLink_i_R is
   record
      tx_reset                                  : std_logic; 
      rx_reset                                  : std_logic;      
      ------------------------------------------         
      rxSerialData                              : std_logic; 
      ------------------------------------------
      loopBack                                  : std_logic;
      ------------------------------------------
      tx_polarity                               : std_logic; 
      rx_polarity                               : std_logic; 
      ------------------------------------------         
      rxSlide_enable                            : std_logic; 
      rxSlide_ctrl                              : std_logic; 
      rxSlide_nbr                               : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
      rxSlide_run                               : std_logic; 
   end record;
   
   type mgtLink_o_R is
   record
      tx_ready                                  : std_logic;
      rx_ready                                  : std_logic;      
      ready                                     : std_logic;
      ------------------------------------------         
      rxWordClkReady                            : std_logic;
      ------------------------------------------         
      txSerialData                              : std_logic;
      ------------------------------------------         
      rxIsLocked_toRef                          : std_logic;                      
      rxIsLocked_toData                         : std_logic;     
      ------------------------------------------         
      txCal_busy                                : std_logic;                      
      rxCal_busy                                : std_logic;
   end record;
   
   --=====================================================================================-- 
   
   --================================= Array Declarations ================================--
   
   --====================--
   -- User setup package --
   --====================--   
   
   type gbt_bank_user_setup_R_A                 is array (natural range <>) of gbt_bank_user_setup_R;   
   
   --===============--
   -- GT bank (MGT) --
   --===============--
   
   type mgtLink_i_R_A                           is array (natural range <>) of mgtLink_i_R;                          
   type mgtLink_o_R_A                           is array (natural range <>) of mgtLink_o_R;    
   
   type reconfig_to_xcvr_nx70bit_A              is array (natural range <>) of std_logic_vector(69 downto 0);
   type reconfig_from_xcvr_nx46bit_A            is array (natural range <>) of std_logic_vector(45 downto 0); 
   
   type frmClkPhAlSteps_nx6bit                  is array (natural range <>) of std_logic_vector( 5 downto 0);
   type gbtRxSlideNbr_mxnbit_A                  is array (natural range <>) of std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);

   --=====================================================================================--   

   --========================== Finite State Machine (FSM) states ========================--
   
  --===============--
   -- GT bank (MGT) --
   --===============--
   
   -- TX_WORDCLK monitoring:
   -------------------------
   
   type txWordClkMonitoringFsmLatOpt_T          is (s0_idle, s1_stats, s2_thresholds, s3_resetMgtTx, s4_phaseOk);

   --=====================================================================================--
   
   --=============================== Constant Declarations ===============================--
  
   --====================--
   -- User setup package --
   --====================--
   
   -- Optimization:
   ----------------
   
   constant STANDARD                            : integer := 0;
   constant LATENCY_OPTIMIZED                   : integer := 1;
   
   -- Encoding:
   ------------
   
   constant GBT_FRAME                           : integer := 0;
   constant WIDE_BUS                            : integer := 1;
   constant GBT_8B10B                           : integer := 2;
   
   --===============--
   -- GT bank (MGT) --
   --===============--

   -- TX_WORDCLK monitoring:
   -------------------------
   
   constant TXWORDCLK_MON_TIMEOUT               : integer := 2**16;
   constant TXWORDCLK_MON_RESETDLY              : integer := 10;        
   
   --=====================================================================================--   
end vendor_specific_gbt_bank_package;   
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--