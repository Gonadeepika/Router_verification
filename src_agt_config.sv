class router_wr_agt_config extends uvm_object;

	`uvm_object_utils(router_wr_agt_config)
	
	virtual router_if vif;
	static int drv_data_count = 0;
	static int mon_data_count = 0;

	uvm_active_passive_enum is_active = UVM_ACTIVE;

	extern function new(string name = "router_wr_agt_config");

endclass



//-----------------  constructor new method  -------------------//

function router_wr_agt_config::new(string name = "router_wr_agt_config");
  	super.new(name);
endfunction

