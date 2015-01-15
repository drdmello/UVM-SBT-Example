`ifndef __ROUTER_SV
 `define __ROUTER_SV

module input_stage (
		    clock,
		    reset,

		    data,
		    packet_valid,
		    err,
		    suspend_data_in,

		    data_out,
		    packet_valid_0,
		    packet_valid_1,
		    packet_valid_2
		    
		    );

   parameter IDLE = 3'b000;
   parameter DATA = 3'b001;
   
   input clock, reset;
   
   input [7:0] data;
   input       packet_valid;
   output      err;
   output      suspend_data_in;

   output [7:0] data_out;
   reg [7:0] data_out;
   
   output    packet_valid_0, packet_valid_1, packet_valid_2;
   reg 	     packet_valid_0, packet_valid_1, packet_valid_2;
   

   wire [5:0]   pkt_length = data[7:2];
   wire [1:0]   pkt_address = data[1:0];

   reg [2:0]   current_state, next_state;

   reg [7:0]   data_countdown;  // extra bit for parity byte

   wire        start_of_packet = (current_state == IDLE && packet_valid == 1'b1);
   wire        end_of_packet = current_state == DATA && packet_valid == 1'b1 && data_countdown == 1;
   reg 	       end_of_packet_d;
   
   
   
   
   always @(posedge clock or posedge reset) begin
      if (reset == 1'b1) begin
	 current_state <= IDLE;
	 end_of_packet_d <= 0;
      end else begin
	 current_state <= next_state;
	 end_of_packet_d <= end_of_packet;
      end
   end

   always @(posedge clock or posedge reset) begin
      if (reset == 1'b1) begin
	 data_countdown <= 0;
      end else begin
	 if (start_of_packet) begin
	    data_countdown = data[7:2]+1;  // +1 to get parity
	 end else if (current_state == DATA && packet_valid == 1'b1) begin
	    // Receiving valid data, decrement counter, freezing at 0
	    if (data_countdown != 0) begin
	       data_countdown -= 1;
	    end
	 end	 
      end
   end // always @ (posedge clock or posedge reset)

   always @(current_state or packet_valid or data_countdown) begin
      
      next_state = current_state;  // In case no change is needed
      
      case (current_state)
	IDLE : begin
	   if (packet_valid == 1'b1)
	     next_state = DATA;
	end
	DATA : begin
	   if (packet_valid == 1'b1 && data_countdown == 1)
	     next_state = IDLE;
	end
	default : $display ("*** Error: ILLEGAL STATE");
      endcase // case (current_state)
   end // always @ (current_state or packet_valid or data_countdown)

   always @(posedge clock or posedge reset) begin
      if (reset == 1'b1) begin
	 packet_valid_0 <= 0;
	 packet_valid_1 <= 0;
	 packet_valid_2 <= 0;
	 data_out <= 0;
      end else begin
	 data_out <= data;
	 if (start_of_packet) begin
	    case (pkt_address)
	      2'b00 : packet_valid_0 <= 1;
	      2'b01 : packet_valid_1 <= 1;
	      2'b10 : packet_valid_2 <= 1;
	      default : $display ("ILLEGAL ADDRESS");
	    endcase // case (pkt_addr)
	 end else if (end_of_packet_d) begin
	    packet_valid_0 <= 0;
	    packet_valid_1 <= 0;
	    packet_valid_2 <= 0;
	    data_out <= 0;	    
	 end
      end
   end
   
   
endmodule // input_stage


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


   wire [7:0] 	data_out;

   assign channel0 = data_out;
   assign channel1 = data_out;
   assign channel2 = data_out;

   input_stage in_stage (
			 .clock(clock),
			 .reset (reset),
			 
			 .data(data),
			 .packet_valid(packet_valid),
			 .err(err),
			 .suspend_data_in(suspend_data_in),

			 .data_out (data_out),
			 .packet_valid_0 (vld_chan_0),
			 .packet_valid_1 (vld_chan_1),
			 .packet_valid_2 (vld_chan_2)
			 );
   
   
endmodule // router
`endif



