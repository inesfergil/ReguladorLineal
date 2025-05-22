## Clock
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports {clk_t}];

## Reset
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {rst_t}];
# set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports {switch}];

## Boton START
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {start_t}];
# set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {botones[1]}]
# set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {botones[2]}]
# set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {botones[3]}]

#Selectores Displays
# Disp4
set_property -dict { PACKAGE_PIN F20   IOSTANDARD LVCMOS33 } [get_ports { selector_t[0] }]; 
# Disp3
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports { selector_t[1] }]; 
# Disp2
set_property -dict { PACKAGE_PIN B19   IOSTANDARD LVCMOS33 } [get_ports { selector_t[2] }]; 
# Disp1
set_property -dict { PACKAGE_PIN B20   IOSTANDARD LVCMOS33 } [get_ports { selector_t[3] }]; 

#Segments
#--24 segment 0 (g)
set_property -dict { PACKAGE_PIN Y7    IOSTANDARD LVCMOS33 } [get_ports { segmentos_t[0] }]; 
#--20 segment 1 (f)
set_property -dict { PACKAGE_PIN A20   IOSTANDARD LVCMOS33 } [get_ports { segmentos_t[1] }]; 
#--14 segment 2 (e)
set_property -dict { PACKAGE_PIN V6    IOSTANDARD LVCMOS33 } [get_ports { segmentos_t[2] }];
#--15 segment 3 (d)
set_property -dict { PACKAGE_PIN Y6    IOSTANDARD LVCMOS33 } [get_ports { segmentos_t[3] }];
#--23 segment 4 (c)
set_property -dict { PACKAGE_PIN W6    IOSTANDARD LVCMOS33 } [get_ports { segmentos_t[4] }];
#--8  segment 5 (b)
set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS33 } [get_ports { segmentos_t[5] }];
#--21 segment 6 (a)
set_property -dict { PACKAGE_PIN Y9    IOSTANDARD LVCMOS33 } [get_ports { segmentos_t[6] }];


# Entrada ADC del pin A0
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {vaux1_v_p}];
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports {vaux1_v_n}];

# Entrada ADC del pin A1
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {vaux9_v_p}];
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {vaux9_v_n}];

set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports {pwm_t}];

