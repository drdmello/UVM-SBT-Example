`ifndef __ROUTER_SCOREBOARD_SV
 `define __ROUTER_SCOREBOARD_SV

// Analysis (im)ports for communication with interface UVC monitors:
`uvm_analysis_imp_decl(_in_chan)
`uvm_analysis_imp_decl(_out_chan)

class router_scoreboard extends uvm_scoreboard;

   `uvm_component_utils(router_scoreboard)

   integer num_ports = 3;

   typedef in_chan_pkt in_chan_pkt_queue_t[$];  
   in_chan_pkt_queue_t posted_packets [];  // A dynamic array of queues
   
   
   uvm_analysis_imp_in_chan #(in_chan_pkt, router_scoreboard) in_chan_add; // in_chan UVC posts packets to SCBD
   uvm_analysis_imp_out_chan #(in_chan_pkt, router_scoreboard) out_chan_match_ports[]; // out_chan UVC sends response packets to SCBD for match

   function new(string name, uvm_component parent);
      integer iii;
      uvm_analysis_imp_out_chan #(in_chan_pkt, router_scoreboard) curr_port;
      
      super.new(name, parent);
      in_chan_add = new("in_chan_add", this);
      
      out_chan_match_ports = new[num_ports];

      for (iii=0; iii < num_ports; iii++) begin
	 curr_port = new($sformatf("out_chan_match%0d", iii), this);
	 out_chan_match_ports[iii] = curr_port;
      end
      
   endfunction // new

   function void build_phase (uvm_phase phase);
      posted_packets = new[num_ports];
   endfunction // build_phase

   function void post_packet(in_chan_pkt pkt);
      `uvm_info("ROUTER", $sformatf("Scoreboard posting in-chan packet %s\n%s", pkt, pkt.sprint()), UVM_MEDIUM);
      posted_packets[pkt.addr].push_back(pkt);
   endfunction // post_packet
   
   function void match_packet(in_chan_pkt pkt);
      `uvm_info("ROUTER", $sformatf("Scoreboard matching out-chan packet %s\n%s", pkt, pkt.sprint()), UVM_MEDIUM);
   endfunction // match_packet

   virtual function void write_in_chan(in_chan_pkt pkt);
      `uvm_info("ROUTER", $sformatf("Scoreboard received in-chan packet %s\n%s", pkt, pkt.sprint()), UVM_HIGH);
      post_packet(pkt);
   endfunction // write_in_chan
   
   virtual function void write_out_chan(in_chan_pkt pkt);
      `uvm_info("ROUTER", $sformatf("Scoreboard received out-chan packet %s\n%s", pkt, pkt.sprint()), UVM_HIGH);
      match_packet(pkt);
   endfunction // write_out_chan

 
endclass // router_scoreboard

`endif
