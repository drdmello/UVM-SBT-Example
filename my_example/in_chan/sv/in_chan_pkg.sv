`ifndef __IN_CHAN_PKG_SV
 `define __IN_CHAN_PKG_SV

package in_chan_pkg;
   
import uvm_pkg::*;
 `include "uvm_macros.svh"

`include "in_chan_pkt.sv"
`include "in_chan_monitor.sv"
`include "in_chan_driver.sv"
`include "in_chan_sequencer.sv"
`include "in_chan_seq_lib.sv"
`include "in_chan_agent.sv"
`include "in_chan_env.sv"

endpackage // in_chan_pkg
   
`endif
