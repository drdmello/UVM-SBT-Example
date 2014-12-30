module test();
   import uvm_pkg::*;
`include "uvm_macros.svh"

`include "in_chan_pkt.sv"

   in_chan_pkt my_pkt;

   initial begin
      my_pkt = in_chan_pkt::type_id::create("my_pkt");

      repeat (5) begin
	 if (!my_pkt.randomize())
	   `uvm_fatal("RANDFAIL", "Failure when randomizing my_pkt")
	 my_pkt.print();
	 
      end;
      
   end
   
   

   
endmodule // test
