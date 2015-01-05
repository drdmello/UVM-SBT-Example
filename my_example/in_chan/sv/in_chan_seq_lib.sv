`ifndef __IN_CHAN_SEQ_LIB_SV
 `define __IN_CHAN_SEQ_LIB_SV

class in_chan_base_seq extends uvm_sequence #(in_chan_pkt);
   `uvm_object_utils(in_chan_base_seq)

   function new (string name = "in_chan_base_seq");
     super.new(name);
   endfunction // new

   virtual task body();
     `uvm_do(req);
   endtask // body
 
endclass // in_chan_base_seq

class in_chan_counted_seq extends in_chan_base_seq;

   `uvm_object_utils(in_chan_counted_seq)

   rand integer count;
   constraint c_default {
      count >= 1;
      count <= 5;
   }

   function new (string name = "in_chan_counted_seq");
     super.new(name);
   endfunction // new

   virtual task body();
      
      integer iii;

      `uvm_info("IN_CHAN", $sformatf("Sending a sequence of %d packets", count), UVM_MEDIUM);
      
      for (iii=0; iii<count; iii++) begin
	 `uvm_do(req);
      end
   
   endtask // body
   
endclass // in_chan_counted_seq



`endif