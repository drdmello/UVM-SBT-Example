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
   output 	vld_chan_0, vld_chan_1, vld_chan_2;
   input 	read_enb_0, read_enb_1, read_enb_2;
   
   
endmodule // router
`endif



