-- Contains the instantiation of the Xilinx MAC IP plus the SGMII PHY interface
--
-- Do not change signal names in here without corresponding alteration to the timing contraints file
--
-- Dave Newbold, April 2011
--
-- $Id$

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.VComponents.all;
use work.emac_hostbus_decl.all;

entity eth_v6_basex is
	port(
		gt_clk: in std_logic;
		--gt_clkp, gt_clkn: in std_logic;
		gt_txp, gt_txn: out std_logic;
		gt_rxp, gt_rxn: in std_logic;
		clk125_o: out std_logic;
		--clk125_fr: out std_logic;
		rst: in std_logic;
		locked: out std_logic;
		tx_data: in std_logic_vector(7 downto 0);
		tx_valid: in std_logic;
		tx_last: in std_logic;
		tx_error: in std_logic;
		tx_ready: out std_logic;
		rx_data: out std_logic_vector(7 downto 0);
		rx_valid: out std_logic;
		rx_last: out std_logic;
		rx_error: out std_logic;
		hostbus_in: in emac_hostbus_in := ('0', "00", "0000000000", X"00000000", '0', '0', '0');
		hostbus_out: out emac_hostbus_out
	);

end eth_v6_basex;

architecture rtl of eth_v6_basex is

	signal clkin, clk125, clk125_out: std_logic;
	signal clkp, clkn, rstn, resetdone, syncacqstatus: std_logic;

begin

	clkin <= gt_clk;

	clkbuf: bufr port map( clr => '0', ce => '1',
		i => clk125_out,
		o => clk125
	);

	clk125_o <= clk125;
	
	locked <= resetdone and syncacqstatus;
	
	rstn <= not rst;

	basex: entity work.v6_emac_v2_3_basex_block port map(
      clk125_out => clk125_out,
      gtx_clk => clk125,
      rx_statistics_vector => open,
      rx_statistics_valid => open,
      rx_reset => open,
      rx_axis_mac_tdata => rx_data,
      rx_axis_mac_tvalid => rx_valid,
      rx_axis_mac_tlast => rx_last,
      rx_axis_mac_tuser => rx_error,
      tx_ifg_delay => X"00",
      tx_statistics_vector => open,
      tx_statistics_valid => open,
      tx_reset => open,
      tx_axis_mac_tdata => tx_data,
      tx_axis_mac_tvalid => tx_valid,
      tx_axis_mac_tlast => tx_last,
      tx_axis_mac_tuser => tx_error,
      tx_axis_mac_tready => tx_ready,
      tx_collision => open,
      tx_retransmit => open,
      pause_req => '0',
      pause_val => X"0000",
      txp => gt_txp,
      txn => gt_txn,
      rxp => gt_rxp,
      rxn => gt_rxn,
      phyad => "00000",
      resetdone => resetdone,
      syncacqstatus => syncacqstatus,
      clk_ds => clkin,
      glbl_rstn => rstn,
      rx_axi_rstn => '1',
      tx_axi_rstn => '1'
   );
   
  hostbus_out.hostrddata <= (others => '0');
	hostbus_out.hostmiimrdy <= '0';

end rtl;

