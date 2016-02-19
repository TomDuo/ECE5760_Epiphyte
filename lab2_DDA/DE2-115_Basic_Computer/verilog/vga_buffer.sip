set_global_assignment -entity "vga_buffer" -library "lib_vga_buffer" -name IP_TOOL_NAME "altera_up_avalon_sram"
set_global_assignment -entity "vga_buffer" -library "lib_vga_buffer" -name IP_TOOL_VERSION "13.0"
set_global_assignment -entity "vga_buffer" -library "lib_vga_buffer" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_vga_buffer" -name SPD_FILE [file join $::quartus(sip_path) "vga_buffer.spd"]

set_global_assignment -library "lib_vga_buffer" -name MISC_FILE [file join $::quartus(sip_path) "vga_buffer_sim/vga_buffer.v"]
