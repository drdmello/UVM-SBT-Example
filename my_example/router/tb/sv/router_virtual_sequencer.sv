`ifndef __ROUTER_VIRTUAL_SEQUENCER_SV
 `define __ROUTER_VIRTUAL_SEQUENCER_SV

class router_virtual_sequencer extends uvm_sequencer;

   `uvm_component_utils(router_virtual_sequencer)

   // References to sequencersd that are associated with drivers
   in_chan_sequencer in_sequencer;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new
   
endclass // router_virtual_sequencer


`endif
