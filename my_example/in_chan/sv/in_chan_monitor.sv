`ifndef __IN_CHAN_MONITOR_SV
 `define __IN_CHAN_MONITOR_SV

class in_chan_monitor extends uvm_monitor;

   `uvm_component_utils(in_chan_monitor)
   
   virtual in_chan_if vif;
   in_chan_pkt current_pkt;

   // Port for sending transactions to scoreboard
   uvm_analysis_port #(in_chan_pkt) item_collected_port;
   
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
      item_collected_port = new("item_collected_port", this);
   endfunction // new

   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern virtual task life_cycle();
   extern virtual task collect_pkt(in_chan_pkt pkt);
   extern virtual function void process_pkt(in_chan_pkt pkt);
   
endclass // in_chan_monitor

// Collect a single packet from the bus
task in_chan_monitor::collect_pkt(in_chan_pkt pkt);

   integer length;
   integer address;
   bit [7:0] current_data;

   byte      unsigned raw_data [];
   
   integer   data_count;

      @(posedge vif.packet_valid); // Start of a new packet      
      data_count = 0;

      // Get first byte (header info) from the bus
      current_data = vif.data;

      length = current_data[7:2];
      address = current_data[1:0];
      // TODO: Add some assertions on length and address
      raw_data = new[length+2];
      raw_data[0] = current_data;

      `uvm_info("IN_CHAN", $sformatf("Read header of packet with length=%d to address=%d", length, address), UVM_HIGH);

      // Now get (length+1) more bytes (data[length] + parity)
      while (data_count <= length) begin
	 @(posedge vif.clock);
	 
	 if (vif.packet_valid === 1'b1) begin
	    current_data = vif.data;	    
	    raw_data[data_count+1] = current_data; // +1 because header is already in raw_data[]
	    `uvm_info("IN_CHAN", $sformatf("Packet Raw Data = %p", raw_data), UVM_HIGH);
	    data_count++;	 
	 end
	 
      end
      
      `uvm_info("IN_CHAN", $sformatf("Packet Raw Data = %p", raw_data), UVM_HIGH);
      current_pkt.data = new[length];  // Size the array so that auto-unpack works as required
      
      void'(current_pkt.unpack_bytes(raw_data));
      `uvm_info("IN_CHAN", $sformatf("Collected packet %s\n%s", current_pkt, current_pkt.sprint()), UVM_HIGH);
   
endtask // collect_pkt


task in_chan_monitor::life_cycle();
   
   @(negedge vif.reset);
   
   forever begin
      current_pkt = in_chan_pkt::type_id::create("current_pkt");
      collect_pkt(current_pkt);
      process_pkt(current_pkt);
   end
endtask // life_cycle

task in_chan_monitor::run_phase(uvm_phase phase);
   fork
      life_cycle();
   join
endtask // run_phase

function void in_chan_monitor::connect_phase(uvm_phase phase);
   super.connect_phase(phase);

   if(!uvm_config_db#(virtual in_chan_if)::get(this, get_full_name(), "vif", vif))
     `uvm_error("NOVIF", $sformatf("Unable to get Virtual Interface for %s, vif", get_full_name()));
   
endfunction // connect_phase

function void in_chan_monitor::process_pkt(in_chan_pkt pkt);

   if (pkt.parity == pkt.calc_parity()) begin
      pkt.parity_type = GOOD;
   end else begin
      pkt.parity_type = BAD;
   end
   `uvm_info("IN_CHAN", $sformatf("Processed packet %s\n%s", current_pkt, current_pkt.sprint()), UVM_MEDIUM);

   item_collected_port.write(pkt);
endfunction

`endif
