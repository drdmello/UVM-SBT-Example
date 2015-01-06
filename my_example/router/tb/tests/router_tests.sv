`ifndef __ROUTER_TESTS_SV
`define __ROUTER_TESTS_SV

import uvm_pkg::*;
import in_chan_pkg::*;
import router_pkg::*;


class router_base_test extends uvm_test;

   router_env env;
   
   `uvm_component_utils(router_base_test)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new
   
   virtual function void build_phase(uvm_phase phase);      
      super.build_phase(phase);
      env = router_env::type_id::create("env", this);
   endfunction
   
endclass // router_base_test

class simple_test extends router_base_test;

   `uvm_component_utils(simple_test)
   
   function new (string name, uvm_component parent);
     super.new(name, parent);
   endfunction // new
   
   virtual function void build_phase(uvm_phase phase);      
      super.build_phase(phase);

      uvm_config_wrapper::set(this, "env.in_env.sequencer.run_phase", "default_sequence", in_chan_base_seq::type_id::get());
      
   endfunction

   virtual task run_phase(uvm_phase phase);
      in_chan_base_seq my_seq;
      my_seq = in_chan_base_seq::type_id::create("my_seq");
      if (!my_seq.randomize())
	`uvm_fatal("RANDFAIL", "Failure when randomizing my_seq");

      phase.raise_objection(this, "Running some sequences");
      
      my_seq.start(env.in_env.in_agent.sequencer);
      
      phase.drop_objection(this, "Done running some sequences");
      
   endtask // run_phase
   
   
endclass // simple_test

class counted_test extends simple_test;

   `uvm_component_utils(counted_test)
   
   function new (string name, uvm_component parent);
     super.new(name, parent);
   endfunction // new

   virtual task run_phase(uvm_phase phase);

      factory.set_type_override_by_type(in_chan_base_seq::get_type(), in_chan_counted_seq::get_type());
      
      super.run_phase(phase);
      
   endtask
   
endclass // counted_test

// SImple test using a virtual sequence
class simple_vseq_test extends router_base_test;

   `uvm_component_utils(simple_vseq_test)
   
   function new (string name, uvm_component parent);
     super.new(name, parent);
   endfunction // new
   
   virtual function void build_phase(uvm_phase phase);      
      super.build_phase(phase);
   endfunction

   virtual task run_phase(uvm_phase phase);
      router_base_vseq my_seq;
      my_seq = router_base_vseq::type_id::create("my_seq");
      if (!my_seq.randomize())
	`uvm_fatal("RANDFAIL", "Failure when randomizing my_seq");

      phase.raise_objection(this, "Running some sequences");
      
      my_seq.start(env.virtual_sequencer);
      
      phase.drop_objection(this, "Done running some sequences");
      
   endtask // run_phase
   
   
endclass // simple_vseq_test

class counted_vseq_test extends simple_vseq_test;

   `uvm_component_utils(counted_vseq_test)
   
   function new (string name, uvm_component parent);
     super.new(name, parent);
   endfunction // new

   virtual task run_phase(uvm_phase phase);

      factory.set_type_override_by_type(router_base_vseq::get_type(), router_counted_vseq::get_type());
      
      super.run_phase(phase);
      
   endtask
   
endclass // counted_vseq_test

`endif
