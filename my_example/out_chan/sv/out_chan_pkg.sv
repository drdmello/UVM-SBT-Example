`ifndef __OUT_CHAN_PKG_SV
 `define __OUT_CHAN_PKG_SV

package out_chan_pkg;

   import uvm_pkg::*;
 `include "uvm_macros.svh"

   import in_chan_pkg::*;  // Share packet definitions

 `include "out_chan_monitor.sv"
 `include "out_chan_agent.sv"
 `include "out_chan_env.sv"
   
   
     
endpackage // out_chan_pkg
   


`endif
