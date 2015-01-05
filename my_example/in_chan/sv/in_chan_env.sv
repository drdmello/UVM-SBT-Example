`ifndef __IN_CHAN_ENV_SV
 `define __IN_CHAN_ENV_SV

class in_chan_env extends uvm_env;

   `uvm_component_utils_begin(in_chan_env)
   `uvm_component_utils_end
      
   in_chan_agent in_agent;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   extern function void build_phase(uvm_phase phase);
   
endclass // in_chan_env

function void in_chan_env::build_phase(uvm_phase phase);
   super.build_phase(phase);
   in_agent = in_chan_agent::type_id::create("in_agent", this);
endfunction // build_phase

`endif

