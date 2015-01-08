`ifndef __ROUTER_ENV_SV
 `define __ROUTER_ENV_SV

  
class router_env extends uvm_env;
   `uvm_component_utils_begin(router_env)
   `uvm_component_utils_end
   
   integer num_ports = 3;

   virtual tb_general_if vif;
  
   in_chan_env in_env;
   out_chan_env out_env;
   router_scoreboard scoreboard;
   router_virtual_sequencer virtual_sequencer;
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);
   
endclass // router_env

function void router_env::build_phase(uvm_phase phase);
   `uvm_info("DEBUG", $sformatf("Building %s\n", get_name()), UVM_LOW)
   super.build_phase(phase);

   in_env = in_chan_env::type_id::create("in_env", this);
   out_env = out_chan_env::type_id::create("out_env", this);
   scoreboard = router_scoreboard::type_id::create("scoreboard", this);
   virtual_sequencer = router_virtual_sequencer::type_id::create("virtual_sequencer", this);
   
endfunction // build_phase

function void router_env::connect_phase(uvm_phase phase);
   
   integer iii;

   super.connect_phase(phase);
   
   if(!uvm_config_db#(virtual tb_general_if)::get(this, get_full_name(), "vif", vif))
     `uvm_error("NOVIF", $sformatf("Unable to get Virtual Interface for %s, vif", get_full_name()));
   
   in_env.in_agent.monitor.item_collected_port.connect(scoreboard.in_chan_add);

   for (iii=0; iii < num_ports; iii++) begin   
      out_env.out_agents[iii].monitor.item_collected_port.connect(scoreboard.out_chan_match_ports[iii]);
   end
   
   if (in_env.in_agent.get_is_active() == UVM_ACTIVE)
     virtual_sequencer.in_sequencer = in_env.in_agent.sequencer;
   
endfunction // connect_phase

`endif