`ifndef __ROUTER_ENV_SV
 `define __ROUTER_ENV_SV

  
class router_env extends uvm_env;
   `uvm_component_utils_begin(router_env)
   `uvm_component_utils_end
     
   in_chan_env in_env;
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   extern function void build_phase(uvm_phase phase);
   
endclass // router_env

function void router_env::build_phase(uvm_phase phase);
   `uvm_info("DEBUG", $sformatf("Building %s\n", get_name()), UVM_LOW)
   super.build_phase(phase);

   in_env = in_chan_env::type_id::create("in_env", this);
   
endfunction // build_phase

`endif