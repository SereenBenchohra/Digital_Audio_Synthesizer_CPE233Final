# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.cache/wt} [current_project]
set_property parent.project_path {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {d:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_mem {
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_6_1a.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_6_3c.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_6_1b.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_6_6a.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_6_1c.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_6_7a.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/prog_rom.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/SW_6.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_7_4a.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_7_5a.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_7_4b.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_7_3b.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_7_6b.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_7_TestAll.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_7_2a.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_7_5aTEST.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/SW_7.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_8_8a.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/HW_8_TEST.mem}
  {D:/Cal Poly/S19/CPE 233/Vivado/HW_8/HW_8.srcs/sources_1/new/SW_8.mem}
}
read_verilog -library xil_defaultlib -sv {
  {D:/Cal Poly/S19/CPE 233/Vivado/HW_4/HW_4.srcs/sources_1/new/ALU.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/HW_1/HW_1.srcs/sources_1/new/Flag.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/HW_1/HW_1.srcs/sources_1/new/Mux2.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/HW_1/HW_1.srcs/sources_1/new/Mux4.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/HW_3/HW_3.srcs/sources_1/new/ProgRom.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/HW_3/HW_3.srcs/sources_1/new/Ram.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/HW_1/HW_1.srcs/sources_1/new/Register.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/ControlUnit.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/RatCPU.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/RatWrapper.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/SevenSeg/SevenSeg.srcs/sources_1/new/UnivSseg.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/sources_1/new/Debounce.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/Keyboard/KeyboardDriver.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/Speaker/SpeakerDriver.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/Speaker/ClkDivider.sv}
  {D:/Cal Poly/S19/CPE 233/Vivado/Speaker/MuxFreq.sv}
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/constrs_1/new/Basys3Master.xdc}}
set_property used_in_implementation false [get_files {{D:/Cal Poly/S19/CPE 233/Vivado/Final_HW/Final_HW.srcs/constrs_1/new/Basys3Master.xdc}}]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top RatWrapper -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef RatWrapper.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file RatWrapper_utilization_synth.rpt -pb RatWrapper_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
