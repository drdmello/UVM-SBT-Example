`ifndef __IN_CHAN_DRIVER_SV
 `define __IN_CHAN_DRIVER_SV

class in_chan_driver extends uvm_driver #(in_chan_pkt);

   `uvm_component_utils(in_chan_driver)

   virtual in_chan_if vif;
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);

   extern virtual protected task get_and_drive();
   extern virtual protected task reset_signals();
   extern virtual task drive_pkt(in_chan_pkt pkt);
   
endclass // in_chan_driver

task in_chan_driver::run_phase(uvm_phase phase);
   fork
      reset_signals();
      get_and_drive();
   join
endtask // run_phase

task in_chan_driver::get_and_drive();
   
   @(negedge vif.reset);
   
   forever begin
      seq_item_port.get_next_item(req);
      drive_pkt(req);
      seq_item_port.item_done(req);
   end
endtask // get_and_drive

task in_chan_driver::reset_signals();
   vif.packet_valid = 1'b0;
endtask // reset_signals

task in_chan_driver::drive_pkt(in_chan_pkt pkt);

   integer iii;
   bit [7:0] packed_data[];
   

   `uvm_info("IN_CHAN", $sformatf("Driving packet %s\n%s", pkt, pkt.sprint()), UVM_MEDIUM)

   void'(pkt.pack_bytes(packed_data));
   `uvm_info("IN_CHAN", $sformatf("Packet Packed Data = %p", packed_data), UVM_HIGH);

   repeat (pkt.inter_packet_delay) @(vif.driver_cb);
   
   for (iii=0; iii< $size(packed_data); iii++) begin
      if (iii != 0)
	@(vif.driver_cb);
      
      vif.driver_cb.packet_valid <= 1'b1;
      vif.driver_cb.data <= packed_data[iii];
   end
   
   // Finally release packet_valid
   @(vif.driver_cb);
   vif.packet_valid <= 1'b0;
  	          
endtask // drive_pkt


function void in_chan_driver::connect_phase(uvm_phase phase);
   super.connect_phase(phase);

   if(!uvm_config_db#(virtual in_chan_if)::get(this, get_full_name(), "vif", vif))
     `uvm_error("NOVIF", $sformatf("Unable to get Virtual Interface for %s, vif", get_full_name()))
   
endfunction // connect_phase


`endif
