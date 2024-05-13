class router_rd_agent extends uvm_agent;

   	// Factory Registration
        `uvm_component_utils(router_rd_agent)

  	// Declare handle for configuration object
    	router_rd_agt_config m_cfg;

   	// Declare handles of router_wr_monitor,router_wr_sequencer and router_wr_driver with Handle names as monh, seqrh, drvh respectively
        router_rd_monitor monh;
        router_rd_sequencer seqrh;
        router_rd_driver drvh;

        extern function new(string name = "router_rd_agent", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);

endclass



//-----------------  constructor new method  -------------------//
function router_rd_agent::new(string name = "router_rd_agent",uvm_component parent = null);
        super.new(name,parent);
endfunction



//----------------- build method ------------------//

function void router_rd_agent::build_phase(uvm_phase phase);

        super.build_phase(phase);
   	// get the config object using uvm_config_db
        if(!uvm_config_db #(router_rd_agt_config)::get(this,"","router_rd_agt_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
        monh=router_rd_monitor::type_id::create("monh",this);
        if(m_cfg.is_active==UVM_ACTIVE)
                begin
                        drvh=router_rd_driver::type_id::create("drvh",this);
                        seqrh=router_rd_sequencer::type_id::create("seqrh",this);
                end
endfunction



//-----------------  connect  method  -------------------//

function void router_rd_agent::connect_phase(uvm_phase phase);
 	if(m_cfg.is_active==UVM_ACTIVE)
                begin
                        drvh.seq_item_port.connect(seqrh.seq_item_export);
                end
endfunction

