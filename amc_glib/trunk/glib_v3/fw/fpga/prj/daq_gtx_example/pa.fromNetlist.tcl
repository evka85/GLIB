
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name daq_gtx_example -dir "/opt/evka/code/GEM/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/daq_gtx_example/planAhead_run_3" -part xc6vlx130tff1156-1
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/opt/evka/code/GEM/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/daq_gtx_example/daq_gtx_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/opt/evka/code/GEM/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/daq_gtx_example} }
set_property target_constrs_file "/opt/evka/code/GEM/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/daq_gtx_example/daq_gtx_top.ucf" [current_fileset -constrset]
add_files [list {daq_gtx_top.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {gtx_attributes.ucf}] -fileset [get_property constrset [current_run]]
link_design
