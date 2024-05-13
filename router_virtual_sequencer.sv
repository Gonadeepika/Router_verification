class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

    	// Factory Registration
        `uvm_component_utils(router_virtual_sequencer)

   	// Declare dynamic array of handles for router_wr_sequencer and router_rd_sequencer as wr_seqrh[] & rd_seqrh[]
        router_wr_sequencer wr_seqrh[];
        router_rd_sequencer rd_seqrh[];

    	// Declare handle for ram_env_config
         router_env_config m_cfg;

        // Standard UVM Methods:
        extern function new(string name = "router_virtual_sequencer",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
endclass



//--------------------------------Constructor new()--------------------------------//
function router_virtual_sequencer::new(string name="router_virtual_sequencer",uvm_component parent);
        super.new(name,parent);
endfunction


//--------------------------------Build Phase---------------------------------//
function void router_virtual_sequencer::build_phase(uvm_phase phase);
        // get the config object using uvm_config_db
        if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
        	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
    	super.build_phase(phase);

    	wr_seqrh = new[m_cfg.no_of_write_agent];
    	rd_seqrh = new[m_cfg.no_of_read_agent];
endfunction

