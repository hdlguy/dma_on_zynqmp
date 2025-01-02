# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj 
set_property part xczu2cg-sfvc784-1-e [current_project]
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]

read_ip ../dgen_ila/dgen_ila.xci
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]

read_verilog -sv ../dgen_mem.sv  
read_verilog -sv ../datagen.sv  
read_verilog -sv ../datagen_tb.sv

add_files -fileset sim_1 -norecurse ./datagen_tb_behav.wcfg

close_project




