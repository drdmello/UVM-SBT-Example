`ifndef __TB_SV
 `define __TB_SV

interface in_chan_if(input clock, input reset);

   logic [7:0] data;
   logic       packet_valid;
   logic       err;
   logic       suspend_data_in;
  
endinterface // in_chan_if


module tb();
   
   import uvm_pkg::*;
 `include "uvm_macros.svh"
 
   reg clock, reset;

   reg [7:0] data;
   reg       packet_valid;
   wire      err;
   wire      suspend_data_in;

   wire [7:0] channel0, channel1, channel2;
   wire       vld_chan_0, vld_chan_1, vld_chan_2;
   reg 	      read_enb_0, read_enb_1, read_enb_2;

   initial begin
      clock = 0;
      forever begin
	 #(10) clock = ~clock;
      end
   end

   initial begin
      // perform reset
      reset = 1'b0;
      repeat (2) @(posedge clock);
      reset = 1'b1;
      repeat (2) @(posedge clock);
      reset = 1'b0;

      
      repeat (1000) @(posedge clock);
      `uvm_fatal("WATCHDOG", "Testbench watchdog timer expired");
      
   end // initial begin
   


   in_chan_if in_if(
		    .clock(clock),
		    .reset(reset)
		    );
 
   initial begin
      // Register the interfaces so the class-based code can find them
      uvm_config_db#(virtual in_chan_if)::set(null, "*in_agent*", "vif", in_if);
      
      // Global UVM task - starts the simulation
      run_test();
   end
   
   router dut (
	       .clock(clock),
	       .reset(reset),

	       .data(data),
	       .packet_valid(packet_valid),
	       .err(err),  
	       .suspend_data_in(suspend_data_in),

	       .channel0(channel0),
	       .vld_chan_0(vld_chan_0),
	       .read_enb_0(read_enb_0),

	       .channel1(channel1),
	       .vld_chan_1(vld_chan_1),
	       .read_enb_1(read_enb_1),

	       .channel2(channel2),
	       .vld_chan_2(vld_chan_2),
	       .read_enb_2(read_enb_2)

	       );
   
endmodule // tb
`endif //  `ifndef __TB_SV
