`ifndef __IN_CHAN_PKT_SV
 `define __IN_CHAN_PKT_SV

import uvm_pkg::*;

typedef enum bit {BAD, GOOD} e_parity_type;

class in_chan_pkt extends uvm_sequence_item;

   rand bit [5:0] length;
   rand bit [1:0] addr;

   rand bit [7:0] data[];  
   bit [7:0] parity;

   rand e_parity_type parity_type;
   rand int unsigned inter_packet_delay;
   

   `uvm_object_utils_begin(in_chan_pkt)
      `uvm_field_int(length, UVM_DEFAULT)
      `uvm_field_int(addr, UVM_DEFAULT)
      `uvm_field_array_int(data, UVM_DEFAULT)
      `uvm_field_int(parity, UVM_DEFAULT)
      `uvm_field_enum(e_parity_type, parity_type, UVM_DEFAULT | UVM_NOPACK | UVM_NOCOMPARE)
      `uvm_field_int(inter_packet_delay, UVM_DEFAULT | UVM_NOPACK | UVM_NOCOMPARE)
   `uvm_object_utils_end


   constraint architecture {
      data.size == length;
   }
   
   constraint c_defaults {
      length < 10;
      addr <= 2;
      parity_type == GOOD;
      inter_packet_delay <= 10;
   }

   function new (string name="in_chan_pkt");
     super.new(name);
   endfunction // new   

   function bit [7:0] calc_parity ();
      int    iii;
      bit [7:0] temp;
      `uvm_info("DEBUG", $sformatf("length=%d", length), UVM_HIGH);
      for (iii=0; iii < length; iii++) begin
	 temp ^= data[iii];
      end
      calc_parity = temp;
   endfunction // calc_parity

   function void set_parity();
      
      if (parity_type == GOOD) begin
	 parity = calc_parity();
      end else begin
	 parity = ~calc_parity();  //TODO: randomize bad parity	 
      end

   endfunction // calc_parity

   function void post_randomize();
      set_parity();
      `uvm_info("DEBUG", $sformatf("inter_packet_delay=%d", inter_packet_delay), UVM_HIGH);
   endfunction // post_randomize
   
endclass // in_chan_pkt

`endif
