#!/bin/sh

# Clean up the results directory
rm -rf results
mkdir -p results

echo 'Synthesizing example design with XST';
xst -ifn xst.scr
cp v6_emac_v2_3_sgmii_example_design.ngc results/

# Copy the EDIF's generated by Coregen
echo 'Copying files from the netlist directory to the results directory'
cp ../../v6_emac_v2_3_sgmii.ngc results/

echo 'Copying files from constraints directory to results directory'
cp ../example_design/v6_emac_v2_3_sgmii_example_design.ucf results/

cd results

echo 'Running ngdbuild'
ngdbuild -uc v6_emac_v2_3_sgmii_example_design.ucf v6_emac_v2_3_sgmii_example_design.ngc v6_emac_v2_3_sgmii_example_design.ngd

echo 'Running map'
map -detail -ol high v6_emac_v2_3_sgmii_example_design -o mapped.ncd

echo 'Running par'
par -ol high mapped.ncd routed.ncd mapped.pcf

echo 'Running trce'
trce -e 10 routed -o routed mapped.pcf

echo 'Running design through bitgen'
bitgen -w routed routed mapped.pcf

echo 'Running netgen to create gate level VHDL model'
netgen -ofmt vhdl -sim -dir . -pcf mapped.pcf -tm v6_emac_v2_3_sgmii_example_design -w routed.ncd routed.vhd