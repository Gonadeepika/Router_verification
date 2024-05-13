class router_test extends uvm_test;

	`uvm_component_utils(router_test)

	//parameters
	router_env env;
	router_env_config e_cfg;

	router_wr_agt_config wcfg[];
	router_rd_agt_config rcfg[];

	bit has_ragent=1;
	bit has_wagent=1;
	
	int no_of_read_agent=3;
	int no_of_write_agent=1;

	bit has_scoreboard = 1;

	extern function new (string name="router_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_router();
	extern function void end_of_elaboration_phase(uvm_phase phase);

endclass



function router_test::new(string name="router_test",uvm_component parent);
	super.new(name,parent);
endfunction



function void router_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	e_cfg = router_env_config::type_id::create("e_cfg");

	//create env_config object
	if(has_wagent)
		e_cfg.wr_agt_cfg=new[no_of_write_agent];
	if(has_ragent)
		e_cfg.rd_agt_cfg=new[no_of_read_agent];
	config_router();

	uvm_config_db #(router_env_config)::set(this,"*","router_env_config",e_cfg);
	//creating obj of env
	env=router_env::type_id::create("env",this);

//	`uvm_info("TEST", "i am in the build phase of driver",UVM_LOW);
endfunction



function void router_test::config_router();
	//creating write & rd agent 
	if(has_wagent)
		begin
			wcfg=new[no_of_write_agent];
			foreach(wcfg[i])
				begin
					wcfg[i]=router_wr_agt_config::type_id::create($sformatf("wcfg[%0d]",i));
		
					if(!uvm_config_db #(virtual router_if)::get(this,"","vif",wcfg[i].vif))
					`uvm_fatal("VIF CONFIG- WRITE","cannot get() interface from uvm_config_db.have you set() it?")
	
					wcfg[i].is_active=UVM_ACTIVE;
					e_cfg.wr_agt_cfg[i]=wcfg[i];
				end
		end


 	if(has_ragent)
          	begin
          		rcfg=new[no_of_read_agent];
          		foreach(rcfg[i])
                		begin
                          		rcfg[i]=router_rd_agt_config::type_id::create($sformatf("rcfg[%0d]",i));
 	
        		                if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("vif_%0d",i),rcfg[i].vif))
                          			`uvm_fatal("VIF CONFIG- READ","cannot get() interface from uvm_config_db.have you set() it?")
                           		
					rcfg[i].is_active=UVM_ACTIVE;
                          		e_cfg.rd_agt_cfg[i]=rcfg[i];
 				end
 		end

	e_cfg.has_ragent=has_ragent;
	e_cfg.has_wagent=has_wagent;
	e_cfg.no_of_read_agent=no_of_read_agent;
	e_cfg.no_of_write_agent=no_of_write_agent;
	e_cfg.has_scoreboard = has_scoreboard;

endfunction



function void router_test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction




//-------------------------------------------------------------------------------------------------------------------------//

// Extend router_small_pkt_test from router_test;
class router_small_pkt_test extends router_test;

        // Factory Registration
        `uvm_component_utils(router_small_pkt_test)

        // Declare the handle for  ram_single_vseq virtual sequence
    	router_small_pkt_vseq router_seqh;
	
	bit [1:0]addr;
        
        // Standard UVM Methods:
        extern function new(string name = "router_small_pkt_test" , uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass



//-----------------  constructor new method  -------------------//

function router_small_pkt_test::new(string name = "router_small_pkt_test" , uvm_component parent);
        super.new(name,parent);
endfunction




//-----------------  build() phase method  -------------------//

function void router_small_pkt_test::build_phase(uvm_phase phase);
    	super.build_phase(phase);
endfunction


//-----------------  run() phase method  -------------------//
task router_small_pkt_test::run_phase(uvm_phase phase);
        //raise objection
    	phase.raise_objection(this);
	
	repeat(20)
	begin
		addr = {$random}%3;
		uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
        	//create instance for sequence
    		router_seqh=router_small_pkt_vseq::type_id::create("router_seqh");
       	 	//start the sequence wrt virtual sequencer
    		router_seqh.start(env.v_sequencer);
        	//drop objection
	end    

	phase.drop_objection(this);
endtask




//----------------------------------------------------------------------------------------------------------------------------//

// Extend router_medium_pkt_test from router_test;
class router_medium_pkt_test extends router_test;

        // Factory Registration
        `uvm_component_utils(router_medium_pkt_test)

        // Declare the handle for  ram_single_vseq virtual sequence
    	router_medium_pkt_vseq router_seqh;
        
	bit [1:0]addr;
        
        // Standard UVM Methods:
        extern function new(string name = "router_medium_pkt_test" , uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass



//-----------------  constructor new method  -------------------//

function router_medium_pkt_test::new(string name = "router_medium_pkt_test" , uvm_component parent);
        super.new(name,parent);
endfunction



//-----------------  build() phase method  -------------------//

function void router_medium_pkt_test::build_phase(uvm_phase phase);
    	super.build_phase(phase);
endfunction



//-----------------  run() phase method  -------------------//
task router_medium_pkt_test::run_phase(uvm_phase phase);
        //raise objection
    	phase.raise_objection(this);
        repeat(20)
		begin
 			addr = {$random}%3;
                	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
        		//create instance for sequence
    			router_seqh=router_medium_pkt_vseq::type_id::create("router_seqh");
        		//start the sequence wrt virtual sequencer
    			router_seqh.start(env.v_sequencer);
        		//drop objection
		end   
 	phase.drop_objection(this);
endtask



//-----------------------------------------------------------------------------------------------------------------//

// Extend router_large_pkt_test from router_test;
class router_large_pkt_test extends router_test;

        // Factory Registration
        `uvm_component_utils(router_large_pkt_test)

        // Declare the handle for  ram_single_vseq virtual sequence
    	router_large_pkt_vseq router_seqh;
        
	bit [1:0]addr;
        
        // Standard UVM Methods:
        extern function new(string name = "router_large_pkt_test" , uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass



//-----------------  constructor new method  -------------------//

function router_large_pkt_test::new(string name = "router_large_pkt_test" , uvm_component parent);
        super.new(name,parent);
endfunction



//-----------------  build() phase method  -------------------//

function void router_large_pkt_test::build_phase(uvm_phase phase);
    	super.build_phase(phase);
endfunction



//-----------------  run() phase method  -------------------//
task router_large_pkt_test::run_phase(uvm_phase phase);
        //raise objection
    	phase.raise_objection(this);
        repeat(20)
		begin
 			addr = {$random}%3;
                	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
        		//create instance for sequence
    			router_seqh=router_large_pkt_vseq::type_id::create("router_seqh");
        		//start the sequence wrt virtual sequencer
    			router_seqh.start(env.v_sequencer);
		end
        //drop objection
   	phase.drop_objection(this);

endtask

