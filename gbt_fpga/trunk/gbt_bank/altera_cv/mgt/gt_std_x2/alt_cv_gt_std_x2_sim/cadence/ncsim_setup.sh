
# (C) 2001-2014 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 13.1 162 win32 2014.04.06.20:53:41

# ----------------------------------------
# ncsim - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="alt_cv_gt_std_x2"
QSYS_SIMDIR="./../"
QUARTUS_INSTALL_DIR="C:/altera/13.1/quartus/"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="-input \"@run 100; exit\""

# ----------------------------------------
# overwrite variables - DO NOT MODIFY!
# This block evaluates each command line argument, typically used for 
# overwriting variables. An example usage:
#   sh <simulator>_setup.sh SKIP_ELAB=1 SKIP_SIM=1
for expression in "$@"; do
  eval $expression
  if [ $? -ne 0 ]; then
    echo "Error: This command line argument, \"$expression\", is/has an invalid expression." >&2
    exit $?
  fi
done

# ----------------------------------------
# initialize simulation properties - DO NOT MODIFY!
ELAB_OPTIONS=""
SIM_OPTIONS=""
if [[ `ncsim -version` != *"ncsim(64)"* ]]; then
  :
else
  :
fi

# ----------------------------------------
# create compilation libraries
mkdir -p ./libraries/work/
mkdir -p ./libraries/alt_cv_gt_std_x2/
mkdir -p ./libraries/altera_ver/
mkdir -p ./libraries/lpm_ver/
mkdir -p ./libraries/sgate_ver/
mkdir -p ./libraries/altera_mf_ver/
mkdir -p ./libraries/altera_lnsim_ver/
mkdir -p ./libraries/cyclonev_ver/
mkdir -p ./libraries/cyclonev_hssi_ver/
mkdir -p ./libraries/cyclonev_pcie_hip_ver/
mkdir -p ./libraries/altera/
mkdir -p ./libraries/lpm/
mkdir -p ./libraries/sgate/
mkdir -p ./libraries/altera_mf/
mkdir -p ./libraries/altera_lnsim/
mkdir -p ./libraries/cyclonev/

# ----------------------------------------
# copy RAM/ROM files to simulation directory

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"                      -work altera_ver           
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                               -work lpm_ver              
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                                  -work sgate_ver            
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                              -work altera_mf_ver        
  ncvlog -sv  "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                          -work altera_lnsim_ver     
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/cadence/cyclonev_atoms_ncrypt.v"          -work cyclonev_ver         
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/cadence/cyclonev_hmi_atoms_ncrypt.v"      -work cyclonev_ver         
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_atoms.v"                         -work cyclonev_ver         
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/cadence/cyclonev_hssi_atoms_ncrypt.v"     -work cyclonev_hssi_ver    
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_hssi_atoms.v"                    -work cyclonev_hssi_ver    
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/cadence/cyclonev_pcie_hip_atoms_ncrypt.v" -work cyclonev_pcie_hip_ver
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_pcie_hip_atoms.v"                -work cyclonev_pcie_hip_ver
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_syn_attributes.vhd"                -work altera               
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_standard_functions.vhd"            -work altera               
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/alt_dspbuilder_package.vhd"               -work altera               
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_europa_support_lib.vhd"            -work altera               
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives_components.vhd"         -work altera               
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.vhd"                    -work altera               
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/220pack.vhd"                              -work lpm                  
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.vhd"                             -work lpm                  
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate_pack.vhd"                           -work sgate                
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.vhd"                                -work sgate                
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf_components.vhd"                 -work altera_mf            
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.vhd"                            -work altera_mf            
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim_components.vhd"              -work altera_lnsim         
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_atoms.vhd"                       -work cyclonev             
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_components.vhd"                  -work cyclonev             
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/altera_xcvr_functions.sv"                -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/sv_reconfig_bundle_to_xcvr.sv"           -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/sv_reconfig_bundle_to_ip.sv"             -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/sv_reconfig_bundle_merger.sv"            -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_xcvr_h.sv"                            -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_xcvr_avmm_csr.sv"                     -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_tx_pma_ch.sv"                         -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_tx_pma.sv"                            -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_rx_pma.sv"                            -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_pma.sv"                               -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_pcs_ch.sv"                            -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_pcs.sv"                               -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_xcvr_avmm.sv"                         -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_xcvr_native.sv"                       -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_xcvr_plls.sv"                         -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_xcvr_data_adapter.sv"                 -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_reconfig_bundle_to_basic.sv"          -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_reconfig_bundle_to_xcvr.sv"           -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_8g_rx_pcs_rbc.sv"                -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_8g_tx_pcs_rbc.sv"                -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_common_pcs_pma_interface_rbc.sv" -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_common_pld_pcs_interface_rbc.sv" -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_pipe_gen1_2_rbc.sv"              -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_rx_pcs_pma_interface_rbc.sv"     -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_rx_pld_pcs_interface_rbc.sv"     -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_tx_pcs_pma_interface_rbc.sv"     -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_tx_pld_pcs_interface_rbc.sv"     -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_reset_ctrl_lego.sv"                  -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_reset_ctrl_tgx_cdrauto.sv"           -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_resync.sv"                      -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_csr_common_h.sv"                -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_csr_common.sv"                  -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_csr_pcs8g_h.sv"                 -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_csr_pcs8g.sv"                   -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_csr_selector.sv"                -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_mgmt2dec.sv"                    -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog      "$QSYS_SIMDIR/altera_xcvr_native_cv/altera_wait_generate.v"                  -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/altera_xcvr_native_av_functions_h.sv"    -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/altera_xcvr_native_av.sv"                -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvlog -sv  "$QSYS_SIMDIR/altera_xcvr_native_cv/altera_xcvr_data_adapter_av.sv"          -work alt_cv_gt_std_x2 -cdslib ./cds_libs/alt_cv_gt_std_x2.cds.lib
  ncvhdl -v93 "$QSYS_SIMDIR/alt_cv_gt_std_x2.vhd"                                                                                                            
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  ncelab -access +w+r+c -namemap_mixgen -relax $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  eval ncsim -licqueue $SIM_OPTIONS $USER_DEFINED_SIM_OPTIONS $TOP_LEVEL_NAME
fi
