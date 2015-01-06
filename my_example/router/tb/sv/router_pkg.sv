`ifndef __ROUTER_PKG_SV
 `define __ROUTER_PKG_SV

package router_pkg;

   import uvm_pkg::*;
   import in_chan_pkg::*;

 `include "router_scoreboard.sv"
 `include "router_virtual_sequencer.sv"
 `include "router_seq_lib.sv"
   
 `include "router_env.sv"
   
   
endpackage // router_pkg
   
`endif
