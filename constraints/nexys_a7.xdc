# Nexys A7 onboard 100 MHz clock
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {clk}]
create_clock -name sys_clk -period 10.000 [get_ports {clk}]

# Active-low CPU reset button (not used, BTNC is the reset)
#set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports {ext_reset_in_0}]

# UART receive: computer sends data to FPGA
#set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports {UART_0_rxd}]

# UART transmit: FPGA sends data to computer
#set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports {UART_0_txd}]

# Buttons
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports {btn_reset}]         ;# BTNC
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports {btn_reprogram}]     ;# BTNU
#set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports {BTNL}]
#set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {BTNR}]
#set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports {BTND}]

# Switches
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {sw_ignition}]       ;# SW0
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {sw_driver_door}]    ;# SW1
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {sw_pass_door}]      ;# SW2
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {sw_hidden}]         ;# SW3
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {sw_brake}]          ;# SW4
#set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {SW[5]}]
#set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {SW[6]}]
#set_property -dict {PACKAGE_PIN R13 IOSTANDARD LVCMOS33} [get_ports {SW[7]}]
#set_property -dict {PACKAGE_PIN T8  IOSTANDARD LVCMOS18} [get_ports {SW[8]}]
#set_property -dict {PACKAGE_PIN U8  IOSTANDARD LVCMOS18} [get_ports {SW[9]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports {sw_time_value[0]}]  ;# SW10
set_property -dict {PACKAGE_PIN T13 IOSTANDARD LVCMOS33} [get_ports {sw_time_value[1]}]  ;# SW11
set_property -dict {PACKAGE_PIN H6  IOSTANDARD LVCMOS33} [get_ports {sw_time_value[2]}]  ;# SW12
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33} [get_ports {sw_time_value[3]}]  ;# SW13
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS33} [get_ports {sw_param_sel[0]}]   ;# SW14
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33} [get_ports {sw_param_sel[1]}]   ;# SW15

# LEDs
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {led_status}]        ;# LD0
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports {led_siren}]         ;# LD1
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports {led_fuel_pump}]     ;# LD2
#set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {LED[3]}]
#set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {LED[4]}]
#set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {LED[5]}]
#set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {LED[6]}]
#set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {LED[7]}]
#set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {LED[8]}]
#set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports {LED[9]}]
#set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {LED[10]}]
#set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports {LED[11]}]
#set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports {LED[12]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {led_state[0]}]      ;# LD13
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {led_state[1]}]      ;# LD14
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33} [get_ports {led_state[2]}]      ;# LD15

# Pmod JA, pin 1 drives a buzzer for the siren tone
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports {speaker}]           ;# JA1
#set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports {JA[2]}]
#set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {JA[3]}]
#set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {JA[4]}]
#set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports {JA[7]}]
#set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {JA[8]}]
#set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33} [get_ports {JA[9]}]
#set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports {JA[10]}]
