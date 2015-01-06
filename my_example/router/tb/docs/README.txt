This is the testbench for a router DUT 

DUT Spec: Please see the file DUT_buffer.pdf

Testbench includes:

- in_chan UVC to provide stimulus and monitoring, including an analysis port for sending collected packets to a scoreboard

- out_chan UVC to collect output packets and provide back-pressure stimulus

- scoreboard to check that:
  - All expected packets are seen at the outputs
  - No unexpected packets are seen
  - Content of packets is correct

- Virtual sequencer to coordinate activity at different stimulus points




  
