class router_wr_seq extends uvm_sequence #(write_xtn);

  	// Factory registration using `uvm_object_utils
        `uvm_object_utils(router_wr_seq)

	// Standard UVM Methods:
        extern function new(string name ="router_wr_seq");
endclass



//-----------------  constructor new method  -------------------//
function router_wr_seq::new(string name ="router_wr_seq");
	super.new(name);
endfunction




//--------------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class router_wxtns_small_pkt extends router_wr_seq;

  	// Factory registration using `uvm_object_utils
        `uvm_object_utils(router_wxtns_small_pkt)
	
	bit [1:0]addr;
 
	// Standard UVM Methods:
        extern function new(string name ="router_wxtns_small_pkt");
        extern task body();
endclass



//-----------------  constructor new method  -------------------//
function router_wxtns_small_pkt::new(string name = "router_wxtns_small_pkt");
	super.new(name);
endfunction



//-----------------  task body method  -------------------//
      // Generate 10 sequence items with address always equal to 55
      // Hint use create req, start item, assert for randomization with in line
      //  constraint (with) finish item inside repeat's begin end block

task router_wxtns_small_pkt::body();
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
        	`uvm_fatal(get_type_name(),"cannot get() addr from uvm_config_db. Have you set() it?")
       
        req=write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {header[7:2] inside {[1:15]} && header[1:0] == addr;});
           `uvm_info("ROUTER_WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
        finish_item(req);
endtask




//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class router_wxtns_medium_pkt extends router_wr_seq;

  	// Factory registration using `uvm_object_utils
        `uvm_object_utils(router_wxtns_medium_pkt)

        bit [1:0]addr;

	// Standard UVM Methods:
        extern function new(string name ="router_wxtns_medium_pkt");
        extern task body();
endclass


//-----------------  constructor new method  -------------------//
function router_wxtns_medium_pkt::new(string name = "router_wxtns_medium_pkt");
	super.new(name);
endfunction


//-----------------  task body method  -------------------//
      // Generate 10 sequence items with address always equal to 55
      // Hint use create req, start item, assert for randomization with in line
      //  constraint (with) finish item inside repeat's begin end block

task router_wxtns_medium_pkt::body();
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
        	`uvm_fatal(get_type_name(),"cannot get() addr from uvm_config_db. Have you set() it?")

        req=write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {header[7:2] inside {[16:30]} && header[1:0] == addr;});
        	`uvm_info("ROUTER_WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
        finish_item(req);
endtask



//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class router_wxtns_large_pkt extends router_wr_seq;


  	// Factory registration using `uvm_object_utils
        `uvm_object_utils(router_wxtns_large_pkt)

        bit [1:0]addr;

	// Standard UVM Methods:
        extern function new(string name ="router_wxtns_large_pkt");
        extern task body();
endclass


//-----------------  constructor new method  -------------------//
function router_wxtns_large_pkt::new(string name = "router_wxtns_large_pkt");
        super.new(name);
endfunction


//-----------------  task body method  -------------------//
      // Generate 10 sequence items with address always equal to 55
      // Hint use create req, start item, assert for randomization with in line
      //  constraint (with) finish item inside repeat's begin end block

task router_wxtns_large_pkt::body();
        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal(get_type_name(),"cannot get() addr from uvm_config_db. Have you set() it?")

        req=write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {header[7:2] inside {[31:63]} && header[1:0] == addr;});
        	`uvm_info("ROUTER_WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
        finish_item(req);   
endtask
