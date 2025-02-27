--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Altera Cyclone V - Multi Gigabit Transceivers TX PLL
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
--                        07/04/2014   3.0       M. Barros Marin   First .vhd module definition           
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
library alt_cv_gt_reset_txpll;
library alt_cv_gt_txpll;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity alt_cv_mgt_txpll is
   port (      
      
      --=======--  
      -- Reset --  
      --=======--  
      
      RESET_I                                   : in  std_logic;
      
      --===============--  
      -- Clocks scheme --  
      --===============--  
      
      MGT_REFCLK_I                              : in  std_logic;
      FEEDBACK_CLK_I                            : in  std_logic;
      
      EXTGTTXPLL_CLK_O                          : out std_logic;
      
      --===============--  
      -- Clocks scheme --  
      --===============--  
      
      --=========--
      -- Control --
      --=========--
      
      POWER_DOWN_O                              : out std_logic;
      LOCKED_O                                  : out std_logic;
      
      --=================--  
      -- Reconfiguration --  
      --=================-- 
      
      RECONFIG_I                                : in  std_logic_vector(69 downto 0);
      RECONFIG_O                                : out std_logic_vector(45 downto 0)

   );
end alt_cv_mgt_txpll;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of alt_cv_mgt_txpll is 

   --================================ Signal Declarations ================================--
   
   signal pllPowerDown_from_rstGtTxPll          : std_logic;
   
   --=====================================================================================--   
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================-- 
   
   --======================--
   -- PLL reset controller --
   --======================-- 
   
   rstGtTxPll: entity alt_cv_gt_reset_txpll.alt_cv_gt_reset_txpll
      port map (     
         CLOCK                                  => MGT_REFCLK_I,
         RESET                                  => RESET_I,
         ---------------------------------------    
         PLL_POWERDOWN(0)                       => pllPowerDown_from_rstGtTxPll
      );  
      
   --===========--
   -- GT TX PLL --
   --===========--
   
   gtTxPll: entity alt_cv_gt_txpll.alt_cv_gt_txpll
      port map (
         PLL_POWERDOWN                          => pllPowerDown_from_rstGtTxPll,             
         PLL_REFCLK(0)                          => MGT_REFCLK_I,
         PLL_FBCLK                              => FEEDBACK_CLK_I,          
         PLL_CLKOUT                             => EXTGTTXPLL_CLK_O,                                
         PLL_LOCKED                             => LOCKED_O,                                             
         FBOUTCLK                               => open,
         HCLK                                   => open,
         RECONFIG_TO_XCVR                       => RECONFIG_I,
         RECONFIG_FROM_XCVR                     => RECONFIG_O              
      );
      
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--