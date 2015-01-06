`ifndef __OUT_CHAN_ENV_SV
 `define __OUT_CHAN_ENV_SV

class out_chan_env extends uvm_env;

   `uvm_component_utils_begin(out_chan_env)
   `uvm_component_utils_end

     integer num_ports = 3;
   
   out_chan_agent out_agents[];

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   extern function void build_phase(uvm_phase phase);
   
endclass // out_chan_env

function void out_chan_env::build_phase(uvm_phase phase);
   integer   iii;
   out_chan_agent curr_agent;

   super.build_phase(phase);
   
   out_agents = new[num_ports];
   
   for (iii=0; iii < num_ports; iii++) begin 
      curr_agent = out_chan_agent::type_id::create($sformatf("out_agent%0d", iii), this);
      out_agents[iii] = curr_agent;
   end
   
endfunction // build_phase

`endif

