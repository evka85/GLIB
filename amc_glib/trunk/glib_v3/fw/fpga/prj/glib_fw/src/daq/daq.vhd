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
use work.data_types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity daq is
port(
    -- Track data
    track_rx_clk               : in std_logic;
    track_rx_en_i              : in std_logic_vector(2 downto 0);
    track_rx_data_i            : in track_data
);
end daq;

architecture Behavioral of daq is



begin


end Behavioral;

