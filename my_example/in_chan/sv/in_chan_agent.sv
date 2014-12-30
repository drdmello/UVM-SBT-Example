`ifndef __IN_CHAN_AGENT_SV
 `define __IN_CHAN_AGENT_SV

import uvm_pkg::*;
 `include "in_chan_monitor.sv"
 `include "in_chan_driver.sv"
 `include "in_chan_sequencer.sv"

class in_chan_agent extends uvm_agent;

   `uvm_component_utils_begin(in_chan_agent)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
   `uvm_component_utils_end
     
   in_chan_monitor monitor; 
   in_chan_driver driver;
   in_chan_sequencer sequencer;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);

endclass // in_chan_agent

function void in_chan_agent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   
   monitor = in_chan_monitor::type_id::create("monitor", this);

   if (is_active == UVM_ACTIVE) begin
      driver = in_chan_driver::type_id::create("driver", this);
      sequencer = in_chan_sequencer::type_id::create("sequencer", this);
   end
endfunction // build_phase

function void in_chan_agent::connect_phase(uvm_phase phase);
   if (is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
   end 
endfunction // connect_phase

`endif
