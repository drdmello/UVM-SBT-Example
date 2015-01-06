`ifndef __OUT_CHAN_ENV_SV
 `define __OUT_CHAN_ENV_SV

class out_chan_env extends uvm_env;

   `uvm_component_utils_begin(out_chan_env)
   `uvm_component_utils_end
      
   out_chan_agent out_agent;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   extern function void build_phase(uvm_phase phase);
   
endclass // out_chan_env

function void out_chan_env::build_phase(uvm_phase phase);
   super.build_phase(phase);
   out_agent = out_chan_agent::type_id::create("out_agent", this);
endfunction // build_phase

`endif

