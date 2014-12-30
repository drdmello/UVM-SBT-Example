`ifndef __IN_CHAN_SEQUENCER_SV
 `define __IN_CHAN_SEQUENCER_SV

 `include "in_chan_pkt.sv"

class in_chan_sequencer extends uvm_sequencer #(in_chan_pkt);

   `uvm_component_utils(in_chan_sequencer)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new
   
endclass // in_chan_sequencer

`endif