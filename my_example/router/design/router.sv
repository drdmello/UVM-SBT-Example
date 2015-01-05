`ifndef __ROUTER_SV
 `define __ROUTER_SV

module router (

	       clock,
	       reset,

	       data,
	       packet_valid,
	       err,  
	       suspend_data_in,

	       channel0,
	       vld_chan_0,
	       read_enb_0,

	       channel1,
	       vld_chan_1,
	       read_enb_1,

	       channel2,
	       vld_chan_2,
	       read_enb_2
	       );
   

   input clock, reset;

   input [7:0] data;
   input       packet_valid;
   output      err;
   output      suspend_data_in;

   output [7:0] channel0, channel1, channel2;
   reg [7:0] channel0, channel1, channel2;

   output 	vld_chan_0, vld_chan_1, vld_chan_2;
   reg 	vld_chan_0, vld_chan_1, vld_chan_2;

   input 	read_enb_0, read_enb_1, read_enb_2;

   // very basic dut to enable testbench development
   // just repeat the input packet on all ports

   always @(posedge clock or posedge reset) begin
      if (reset) begin

	 vld_chan_0 <= 0;
	 vld_chan_1 <= 0;
	 vld_chan_2 <= 0;

	 channel0 <= 0;
	 channel1 <= 0;
	 channel2 <= 0;

      end else begin // if (reset)

	 vld_chan_0 <= packet_valid;
	 vld_chan_1 <= packet_valid;
	 vld_chan_2 <= packet_valid;

	 channel0 <= data;
	 channel1 <= data;
	 channel2 <= data;

      end
   end
   // end : very basic dut to enable testbench development
   
   
endmodule // router
`endif



