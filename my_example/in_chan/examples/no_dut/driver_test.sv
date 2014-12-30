module test();
   import uvm_pkg::*;

`include "uvm_macros.svh"
`include "in_chan_pkt.sv"
`include "in_chan_driver.sv"

   in_chan_pkt my_pkt;
   in_chan_driver my_driver;

   initial begin
      my_pkt = in_chan_pkt::type_id::create("my_pkt");
      my_driver = in_chan_driver::type_id::create("my_driver", null);
      repeat (5) begin
	 if (!my_pkt.randomize())
	   `uvm_fatal("RANDFAIL", "Failure when randomizing my_pkt")
	 my_pkt.print();
	 my_driver.drive_pkt(my_pkt);
      end   	 
   end
   
endmodule // test
