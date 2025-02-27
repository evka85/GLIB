
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

# ACDS 13.1 162 win32 2014.04.07.21:46:00

# ----------------------------------------
# Auto-generated simulation script

# ----------------------------------------
# Initialize variables
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
}

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "alt_cv_gt_reconfctrl_x2"
}

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
}

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "C:/altera/13.1/quartus/"
}

# ----------------------------------------
# Initialize simulation properties - DO NOT MODIFY!
set ELAB_OPTIONS ""
set SIM_OPTIONS ""
if ![ string match "*-64 vsim*" [ vsim -version ] ] {
} else {
}

set Aldec "Riviera"
if { [ string match "*Active-HDL*" [ vsim -version ] ] } {
  set Aldec "Active"
}

if { [ string match "Active" $Aldec ] } {
  scripterconf -tcl
  createdesign "$TOP_LEVEL_NAME"  "."
  opendesign "$TOP_LEVEL_NAME"
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib      ./libraries     
ensure_lib      ./libraries/work
vmap       work ./libraries/work
ensure_lib                       ./libraries/altera_ver           
vmap       altera_ver            ./libraries/altera_ver           
ensure_lib                       ./libraries/lpm_ver              
vmap       lpm_ver               ./libraries/lpm_ver              
ensure_lib                       ./libraries/sgate_ver            
vmap       sgate_ver             ./libraries/sgate_ver            
ensure_lib                       ./libraries/altera_mf_ver        
vmap       altera_mf_ver         ./libraries/altera_mf_ver        
ensure_lib                       ./libraries/altera_lnsim_ver     
vmap       altera_lnsim_ver      ./libraries/altera_lnsim_ver     
ensure_lib                       ./libraries/cyclonev_ver         
vmap       cyclonev_ver          ./libraries/cyclonev_ver         
ensure_lib                       ./libraries/cyclonev_hssi_ver    
vmap       cyclonev_hssi_ver     ./libraries/cyclonev_hssi_ver    
ensure_lib                       ./libraries/cyclonev_pcie_hip_ver
vmap       cyclonev_pcie_hip_ver ./libraries/cyclonev_pcie_hip_ver
ensure_lib                       ./libraries/altera               
vmap       altera                ./libraries/altera               
ensure_lib                       ./libraries/lpm                  
vmap       lpm                   ./libraries/lpm                  
ensure_lib                       ./libraries/sgate                
vmap       sgate                 ./libraries/sgate                
ensure_lib                       ./libraries/altera_mf            
vmap       altera_mf             ./libraries/altera_mf            
ensure_lib                       ./libraries/altera_lnsim         
vmap       altera_lnsim          ./libraries/altera_lnsim         
ensure_lib                       ./libraries/cyclonev             
vmap       cyclonev              ./libraries/cyclonev             
ensure_lib                         ./libraries/alt_cv_gt_reconfctrl_x2
vmap       alt_cv_gt_reconfctrl_x2 ./libraries/alt_cv_gt_reconfctrl_x2

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  vlog +define+SKIP_KEYWORDS_PRAGMA "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"                    -work altera_ver           
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                             -work lpm_ver              
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                                -work sgate_ver            
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                            -work altera_mf_ver        
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                        -work altera_lnsim_ver     
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/aldec/cyclonev_atoms_ncrypt.v"          -work cyclonev_ver         
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/aldec/cyclonev_hmi_atoms_ncrypt.v"      -work cyclonev_ver         
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_atoms.v"                       -work cyclonev_ver         
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/aldec/cyclonev_hssi_atoms_ncrypt.v"     -work cyclonev_hssi_ver    
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_hssi_atoms.v"                  -work cyclonev_hssi_ver    
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/aldec/cyclonev_pcie_hip_atoms_ncrypt.v" -work cyclonev_pcie_hip_ver
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_pcie_hip_atoms.v"              -work cyclonev_pcie_hip_ver
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_syn_attributes.vhd"              -work altera               
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_standard_functions.vhd"          -work altera               
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/alt_dspbuilder_package.vhd"             -work altera               
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_europa_support_lib.vhd"          -work altera               
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives_components.vhd"       -work altera               
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.vhd"                  -work altera               
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/220pack.vhd"                            -work lpm                  
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.vhd"                           -work lpm                  
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate_pack.vhd"                         -work sgate                
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.vhd"                              -work sgate                
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf_components.vhd"               -work altera_mf            
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.vhd"                          -work altera_mf            
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim_components.vhd"            -work altera_lnsim         
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_atoms.vhd"                     -work cyclonev             
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_components.vhd"                -work cyclonev             
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/altera_xcvr_functions.sv"                    -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_xcvr_h.sv"                                -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_resync.sv"                          -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_h.sv"                      -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig.sv"                        -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_cal_seq.sv"                -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xreconf_cif.sv"                          -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xreconf_uif.sv"                          -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xreconf_basic_acq.sv"                    -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_analog.sv"                 -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_analog_av.sv"              -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xreconf_analog_datactrl_av.sv"           -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xreconf_analog_rmw_av.sv"                -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xreconf_analog_ctrlsm.sv"                -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_offset_cancellation.sv"    -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_offset_cancellation_av.sv" -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_eyemon.sv"                 -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe.sv"                    -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_adce.sv"                   -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd.sv"                    -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd_av.sv"                 -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd_cal_av.sv"             -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd_control_av.sv"         -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_mif.sv"                    -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_xcvr_reconfig_mif.sv"                     -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_xcvr_reconfig_mif_ctrl.sv"                -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_xcvr_reconfig_mif_avmm.sv"                -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_pll.sv"                    -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_xcvr_reconfig_pll.sv"                     -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_xcvr_reconfig_pll_ctrl.sv"                -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_soc.sv"                    -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_cpu_ram.sv"                -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_direct.sv"                 -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_arbiter_acq.sv"                          -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_basic.sv"                  -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_xrbasic_l2p_addr.sv"                      -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_xrbasic_l2p_ch.sv"                        -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_xrbasic_l2p_rom.sv"                       -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_xrbasic_lif_csr.sv"                       -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_xrbasic_lif.sv"                           -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_xcvr_reconfig_basic.sv"                   -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_arbiter.sv"                         -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_m2s.sv"                             -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/altera_wait_generate.v"                      -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_csr_selector.sv"                    -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_reconfig_bundle_to_basic.sv"              -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_reconfig_bundle_to_basic.sv"              -work alt_cv_gt_reconfctrl_x2
  vlog  "$QSYS_SIMDIR/alt_xcvr_reconfig/av_reconfig_bundle_to_xcvr.sv"               -work alt_cv_gt_reconfctrl_x2
  vcom  "$QSYS_SIMDIR/alt_cv_gt_reconfctrl_x2.vhd"                                                                
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim +access +r -t ps $ELAB_OPTIONS -L work -L alt_cv_gt_reconfctrl_x2 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with -dbg -O2 option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -dbg -O2 +access +r -t ps $ELAB_OPTIONS -L work -L alt_cv_gt_reconfctrl_x2 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -dbg -O2
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                     -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with -dbg -O2 option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -dbg -O2"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR           -- Quartus installation directory."
}
file_copy
h
