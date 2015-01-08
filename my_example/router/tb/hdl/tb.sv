`ifndef __TB_SV
 `define __TB_SV

interface in_chan_if(
		     input clock,
		     input reset
		     );

   logic [7:0] 		   data;
   logic 		   packet_valid;
   logic 		   err;
   logic 		   suspend_data_in;
   
   clocking cb @(posedge clock);
      inout 		   err, suspend_data_in;
      inout 		   packet_valid, data;
   endclocking // cb
   
   modport in_chan(input packet_valid, input data, output err, output suspend_data_in);  // For connection to DUT
   
  
endinterface // in_chan_if

interface out_chan_if (
		       input clock,
		       input reset
		       );
   logic [7:0] 		     channel;
   logic 		     vld_chan;
   logic 		     read_enb;

   clocking cb @(posedge clock);
      input 		     channel, vld_chan;
      inout 		     read_enb;
   endclocking // cb

   modport out_chan(input read_enb, output channel, output vld_chan);  // For connection to DUT   
   
endinterface // out_chan_if


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
   
   out_chan_if out_if0(
		       .clock(clock),
		       .reset(reset)
		       );

   out_chan_if out_if1(
		       .clock(clock),
		       .reset(reset)
		       );

   out_chan_if out_if2(
		       .clock(clock),
		       .reset(reset)
		       );
   
   initial begin
      // Register the interfaces so the class-based code can find them
      uvm_config_db#(virtual in_chan_if)::set(null, "*in_agent*", "vif", in_if);
      
      uvm_config_db#(virtual out_chan_if)::set(null, "*out_agent0*", "vif", out_if0);
      uvm_config_db#(virtual out_chan_if)::set(null, "*out_agent1*", "vif", out_if1);
      uvm_config_db#(virtual out_chan_if)::set(null, "*out_agent2*", "vif", out_if2);
     
      // Global UVM task - starts the simulation
      run_test();
   end
   
   router dut (
	       .clock(clock),
	       .reset(reset),

	       .data(in_if.in_chan.data),
	       .packet_valid(in_if.in_chan.packet_valid),
	       .err(err),  
	       .suspend_data_in(suspend_data_in),

	       .channel0(out_if0.out_chan.channel),
	       .vld_chan_0(out_if0.out_chan.vld_chan),
	       .read_enb_0(out_if0.out_chan.read_enb),

	       .channel1(out_if1.out_chan.channel),
	       .vld_chan_1(out_if1.out_chan.vld_chan),
	       .read_enb_1(out_if1.out_chan.read_enb),

	       .channel2(out_if2.out_chan.channel),
	       .vld_chan_2(out_if2.out_chan.vld_chan),
	       .read_enb_2(out_if2.out_chan.read_enb)

	       );
   
endmodule // tb
`endif //  `ifndef __TB_SV
