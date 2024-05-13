class router_env extends uvm_env;

`uvm_component_utils(router_env)

router_env_config e_cfg;
//router_scoreboard sb;
router_virtual_sequencer vsqrh;

src_agt_top sagt_top;
dst_agt_top dagt_top;

extern function new(string name="router_env",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function router_env::new(string name="router_env",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
$display("build phase of env");
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",e_cfg))

	`uvm_fatal("ram_tb","getting of env_config failed.have u set it?")
	
	if(e_cfg.has_virtual_sequencer)
	begin
	sagt_top=src_agt_top::type_id::create("sagt_top",this);
	dagt_top=dst_agt_top::type_id::create("dagt_top",this);

	vsqrh=router_virtual_sequencer::type_id::create("vsqrh",this);
	end

/*	if(e_cfg.has_scoreboard)
	sb=router_scoreboard::type_id::create("sb",this);*/
endfunction

function void router_env::connect_phase(uvm_phase phase);
super.connect_phase(phase);
if(e_cfg.has_virtual_sequencer)
begin
		foreach(vsqrh.src_seqrh[i])
	vsqrh.src_seqrh[i]=sagt_top.src_agnth[i].seqrh;
	foreach(vsqrh.dst_seqrh[i])
	vsqrh.dst_seqrh[i]=dagt_top.agnth[i].seqrh;
	
//endfunction

/*if(e_cfg.has_scoreboard)
begin
	//foreach(sagt_top.src_agnth[i])
	sagt_top.src_agnth[0].monh.ap.connect(sb.fifo_src.analysis_export);
	foreach(dagt_top.agnth[i])
	dagt_top.agnth[i].monh.ap1.connect(sb.fifo_dst[i].analysis_export);
end*/

end
endfunction

