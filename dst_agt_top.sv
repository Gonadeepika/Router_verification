class router_rd_agt_top extends uvm_env;

        `uvm_component_utils(router_rd_agt_top)

	router_rd_agent agnth[];

	router_env_config m_cfg;

	extern function new (string name="router_rd_agt_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass



//-----------------  constructor new method  -------------------//

function router_rd_agt_top ::new(string name="router_rd_agt_top",uvm_component parent);
        super.new(name,parent);
endfunction



//-----------------  build  method  -------------------//

function void router_rd_agt_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
        if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

	agnth = new[m_cfg.no_of_read_agent];

 	foreach(agnth[i])
        	begin
                	// set router_wr_agent_config into the database using the
                        // router_env_config's router_wr_agent_config object
                        agnth[i]=router_rd_agent::type_id::create($sformatf("agnth[%0d]",i) ,this);

                        uvm_config_db #(router_rd_agt_config)::set(this,$sformatf("agnth[%0d]*",i),  "router_rd_agt_config", m_cfg.rd_agt_cfg[i]);

               	end
endfunction

