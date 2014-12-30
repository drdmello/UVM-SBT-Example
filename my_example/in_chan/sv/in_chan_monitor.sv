`ifndef __IN_CHAN_MONITOR_SV
 `define __IN_CHAN_MONITOR_SV

import uvm_pkg::*;
 `include "in_chan_pkt.sv"

class in_chan_monitor extends uvm_monitor;

   `uvm_component_utils(in_chan_monitor)
   
   virtual in_chan_if vif;

   in_chan_pkt current_pkt;
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern virtual task life_cycle();
   extern virtual task collect_pkt(in_chan_pkt pkt);
   
   
endclass // in_chan_monitor

task in_chan_monitor::collect_pkt(in_chan_pkt pkt);
endtask // collect_pkt


task in_chan_monitor::life_cycle();

   integer length;
   integer address;
   bit [7:0] current_data;

   bit [7:0] raw_data[$] = {};

   integer   data_count;
   
   @(negedge vif.reset);
   
   forever begin
      current_pkt = in_chan_pkt::type_id::create("current_pkt");
   
      @(posedge vif.packet_valid); // Start of a new packet
      
      raw_data = {};
      data_count = 0;

      // Get first byte (header info) from the bus
      current_data = vif.data;
      raw_data.push_back(current_data);

      length = current_data[7:2];
      address = current_data[1:0];

      `uvm_info("IN_CHAN", $sformatf("Read header of packet with length=%d to address=%d", length, address), UVM_MEDIUM);

      // Now get (length+1) more bytes (data[length] + parity)
      while (data_count <= length) begin
	 @(posedge vif.clock);
	 
	 if (vif.packet_valid === 1'b1) begin
	    current_data = vif.data;	    
	    raw_data.push_back(current_data);
	    `uvm_info("IN_CHAN", $sformatf("Packet Raw Data = %p", raw_data), UVM_HIGH);
	    data_count++;	 
	 end
	 
      end
      
      `uvm_info("IN_CHAN", $sformatf("Packet Raw Data = %p", raw_data), UVM_MEDIUM);
      
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
     `uvm_error("NOVIF", $sformatf("Unable to get Virtual Interface for %s, vif", get_full_name()))
endfunction // connect_phase

`endif
