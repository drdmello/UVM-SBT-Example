`ifndef __ROUTER_SEQ_LIB_SV
 `define __ROUTER_SEQ_LIB_SV

class router_base_vseq extends uvm_sequence;

   `uvm_object_utils(router_base_vseq)

   function new (string name = "router_base_vseq");
      super.new(name);
   endfunction // new

   `uvm_declare_p_sequencer(router_virtual_sequencer)

   virtual task pre_body();
      if (starting_phase != null)
	starting_phase.raise_objection(this, "Starting a virtual sequence");
   endtask // pre_body

   virtual task post_body();
      if (starting_phase != null)
	starting_phase.drop_objection(this, "Done with virtual sequence");    
   endtask // post_body

   
endclass // router_base_vseq


class router_counted_vseq extends router_base_vseq;
   `uvm_object_utils(router_counted_vseq)

   in_chan_counted_seq in_seq;

   virtual task body();
      `uvm_do_on(in_seq, p_sequencer.in_sequencer)
   endtask // body
   
endclass // router_counted_vseq

`endif
