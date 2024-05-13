class router_rd_sequencer extends uvm_sequencer #(read_xtn);

	// Factory registration using `uvm_component_utils
        `uvm_component_utils(router_rd_sequencer)

	// Standard UVM Methods:
        extern function new(string name = "router_rd_sequencer",uvm_component parent);
endclass


//-----------------  constructor new method  -------------------//
function router_rd_sequencer::new(string name="router_rd_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction
