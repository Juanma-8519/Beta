# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
  set_property IOSTANDARD LVCMOS33 [get_ports clk]
  create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
	
set_property PACKAGE_PIN A18 [get_ports txd]						
  set_property IOSTANDARD LVCMOS33 [get_ports txd]
set_property PACKAGE_PIN B18 [get_ports rxd]						
  set_property IOSTANDARD LVCMOS33 [get_ports rxd]
      
set_property PACKAGE_PIN U16 [get_ports {uart_tx_led}]					
  set_property IOSTANDARD LVCMOS33 [get_ports {uart_tx_led}]
set_property PACKAGE_PIN E19 [get_ports {adc_led}]                    
  set_property IOSTANDARD LVCMOS33 [get_ports {adc_led}]
  
  #Sch name = XA1_P
  set_property PACKAGE_PIN J3 [get_ports {vauxp6}]                
      set_property IOSTANDARD LVCMOS33 [get_ports {vauxp6}]
  #Sch name = XA2_P
  set_property PACKAGE_PIN L3 [get_ports {vauxp14}]                
      set_property IOSTANDARD LVCMOS33 [get_ports {vauxp14}]
  #Sch name = XA3_P
  set_property PACKAGE_PIN M2 [get_ports {vauxp7}]                
      set_property IOSTANDARD LVCMOS33 [get_ports {vauxp7}]
  #Sch name = XA4_P
  set_property PACKAGE_PIN N2 [get_ports {vauxp15}]                
      set_property IOSTANDARD LVCMOS33 [get_ports {vauxp15}]
  #Sch name = XA1_N
  set_property PACKAGE_PIN K3 [get_ports {vauxn6}]                
      set_property IOSTANDARD LVCMOS33 [get_ports {vauxn6}]
  #Sch name = XA2_N
  set_property PACKAGE_PIN M3 [get_ports {vauxn14}]                
      set_property IOSTANDARD LVCMOS33 [get_ports {vauxn14}]
  #Sch name = XA3_N
  set_property PACKAGE_PIN M1 [get_ports {vauxn7}]                
      set_property IOSTANDARD LVCMOS33 [get_ports {vauxn7}]
  #Sch name = XA4_N
  set_property PACKAGE_PIN N1 [get_ports {vauxn15}]                
      set_property IOSTANDARD LVCMOS33 [get_ports {vauxn15}]