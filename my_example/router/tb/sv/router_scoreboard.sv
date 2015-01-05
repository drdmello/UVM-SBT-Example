`ifndef __ROUTER_SCOREBOARD_SV
 `define __ROUTER_SCOREBOARD_SV

// Analysis (im)ports for communication with interface UVC monitors:
`uvm_analysis_imp_decl(_in_chan)

class router_scoreboard extends uvm_scoreboard;

   `uvm_component_utils(router_scoreboard)
   
   uvm_analysis_imp_in_chan #(in_chan_pkt, router_scoreboard) in_chan_add; // in_chan UVC adds packets to SCBD

   function new(string name, uvm_component parent);
      super.new(name, parent);
      in_chan_add = new("in_chan_add", this);
   endfunction // new

   virtual function void write_in_chan(in_chan_pkt pkt);
      `uvm_info("ROUTER", $sformatf("Scoreboard received in-chan packet %s\n%s", pkt, pkt.sprint()), UVM_MEDIUM);
   endfunction // write_in_chan
 
endclass // router_scoreboard

`endif
