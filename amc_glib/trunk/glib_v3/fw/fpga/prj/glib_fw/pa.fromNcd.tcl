
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name glib_fw -dir "/home/evka/code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/planAhead_run_2" -part xc6vlx130tff1156-1
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "/home/evka/code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/glib_top_cs.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/evka/code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw} {ipcore_dir} {../../src/system/cdce/cdce_phase_mon_v2/dpram} {../../src/system/ethernet/ipcore_dir/basex} {../../src/system/ethernet/ipcore_dir/sgmii} {../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/ezdma2_ctrl_dpram} {../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/ipbus_ctrl_dpram} {../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/slv_rd_fifo} {../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/slv_wr_fifo} {../../src/system/cdce/cdce_phase_mon_v2/pll} {../../src/system/pll} }
add_files [list {ipcore_dir/chipscope_icon.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/trigger_data_fifo.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/tracking_data_fifo.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/chipscope_ila.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../../src/system/cdce/cdce_phase_mon_v2/dpram/ttclk_distributed_dpram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../../src/system/ethernet/ipcore_dir/basex/v6_emac_v2_3_basex.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "/home/evka/code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/src/usr.ucf" [current_fileset -constrset]
add_files [list {/home/evka/code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/src/system.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/evka/code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/src/system_clk.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/evka/code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/src/gtx.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {user_fabric_clk.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/evka/code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/src/user_mgt_amc.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/evka/code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/src/usr.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "/home/evka/code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/glib_top.ncd"
if {[catch {read_twx -name results_1 -file "/home/evka/code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/glib_top.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"/home/evka/code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/glib_top.twx\": $eInfo"
}
