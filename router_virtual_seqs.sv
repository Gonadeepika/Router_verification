class router_vbase_seq extends uvm_sequence #(uvm_sequence_item);

  	// Factory registration
        `uvm_object_utils(router_vbase_seq)
  
	// Declare dynamic array of handles for write sequencer and read sequencer as wr_seqrh[] & rd_seqrh[]
        router_wr_sequencer wr_seqrh[];
        router_rd_sequencer rd_seqrh[];
  
	// Declare handle for virtual sequencer
        router_virtual_sequencer vsqrh;

	// Declare handle for router_env_config
        router_env_config m_cfg;

	extern function new(string name = "router_vbase_seq");
        extern task body();
endclass 



//-------------------Constructor New -----------------------//
function router_vbase_seq::new(string name ="router_vbase_seq");
        super.new(name);
endfunction


//-----------------  task body() method  -------------------//

task router_vbase_seq::body();
        // get the config object using uvm_config_db
        if(!uvm_config_db #(router_env_config)::get(null,get_full_name(),"router_env_config",m_cfg))
        	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
        
	// initialize the dynamic arrays for write & read sequencers and all the write & read sequences declared above to m_cfg.no_of_duts
        	wr_seqrh = new[m_cfg.no_of_write_agent];
        	rd_seqrh = new[m_cfg.no_of_read_agent];

  		assert($cast(vsqrh,m_sequencer))//m_sequencer is the object of the sequencer, the sequencer object is available in the sequence.
  	else
        begin
                `uvm_error("BODY", "Error in $cast of virtual sequencer")
        end

        // Assign router_wr_sequencer & router_rd_sequencer handles to virtual sequencer's
        // router_wr_sequencer & router_rd_sequencer handles
        // Hint : use foreach loop
        foreach(wr_seqrh[i])
                wr_seqrh[i] = vsqrh.wr_seqrh[i];
        foreach(rd_seqrh[i])
               rd_seqrh[i] = vsqrh.rd_seqrh[i];

endtask: body



//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------

class router_small_pkt_vseq extends router_vbase_seq;

        `uvm_object_utils(router_small_pkt_vseq)
	
	bit [1:0] addr;
	
	router_wxtns_small_pkt wrtns;
	router_rxtns1 rdtns;

        // Standard UVM Methods:
        extern function new(string name = "router_small_pkt_vseq");
        extern task body();
endclass 


//-----------------  constructor new method  -------------------//
function router_small_pkt_vseq::new(string name ="router_small_pkt_vseq");
        super.new(name);
endfunction



//-----------------  task body() method  -------------------//

task router_small_pkt_vseq::body();
    	super.body();

	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"cannot get() addr from uvm_config_db. Have you set() it?")

	if(m_cfg.has_wagent)
		begin	
			wrtns= router_wxtns_small_pkt::type_id::create("wrtns");
   		end
	
	if(m_cfg.has_ragent)
        	begin
        	        rdtns= router_rxtns1::type_id::create("rdtns");
        	end


  	fork
		// Therad 1 : Start the Write Sequence on Write Sequencer
		begin
			wrtns.start(wr_seqrh[0]);
		end
		 
		// Thread 2 : Start the Read sequence on Read sequencer
		begin
			if(addr == 2'b00)
                		rdtns.start(rd_seqrh[0]);

               		if(addr == 2'b01)
                		rdtns.start(rd_seqrh[1]);

			if(addr == 2'b10)
                		rdtns.start(rd_seqrh[2]);
		end
	join
endtask



//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------

class router_medium_pkt_vseq extends router_vbase_seq;

        `uvm_object_utils(router_medium_pkt_vseq)
	
	bit [1:0] addr;
	
	router_wxtns_medium_pkt wrtns;
	router_rxtns1 rdtns;

        // Standard UVM Methods:
        extern function new(string name = "router_medium_pkt_vseq");
        extern task body();
endclass 


//-----------------  constructor new method  -------------------//
function router_medium_pkt_vseq::new(string name ="router_medium_pkt_vseq");
        super.new(name);
endfunction



//-----------------  task body() method  -------------------//

task router_medium_pkt_vseq::body();
    	super.body();

	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"cannot get() addr from uvm_config_db. Have you set() it?")

	if(m_cfg.has_wagent)
		begin	
			wrtns= router_wxtns_medium_pkt::type_id::create("wrtns");
   		end
	
	if(m_cfg.has_ragent)
        	begin
        	        rdtns= router_rxtns1::type_id::create("rdtns");
        	end


  	fork
		// Therad 1 : Start the Write Sequence on Write Sequencer
		begin
			wrtns.start(wr_seqrh[0]);
		end
		 
		// Thread 2 : Start the Read sequence on Read sequencer
		begin
			if(addr == 2'b00)
                		rdtns.start(rd_seqrh[0]);

               		if(addr == 2'b01)
                		rdtns.start(rd_seqrh[1]);

			if(addr == 2'b10)
                		rdtns.start(rd_seqrh[2]);
		end
	join
endtask



//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------

class router_large_pkt_vseq extends router_vbase_seq;

        `uvm_object_utils(router_large_pkt_vseq)
	
	bit [1:0] addr;
	
	router_wxtns_large_pkt wrtns;
	router_rxtns1 rdtns;

        // Standard UVM Methods:
        extern function new(string name = "router_large_pkt_vseq");
        extern task body();
endclass 


//-----------------  constructor new method  -------------------//
function router_large_pkt_vseq::new(string name ="router_large_pkt_vseq");
        super.new(name);
endfunction



//-----------------  task body() method  -------------------//

task router_large_pkt_vseq::body();
    	super.body();

	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"cannot get() addr from uvm_config_db. Have you set() it?")

	if(m_cfg.has_wagent)
		begin	
			wrtns= router_wxtns_large_pkt::type_id::create("wrtns");
   		end
	
	if(m_cfg.has_ragent)
        	begin
        	        rdtns= router_rxtns1::type_id::create("rdtns");
        	end


  	fork
		// Therad 1 : Start the Write Sequence on Write Sequencer
		begin
			wrtns.start(wr_seqrh[0]);
		end
		 
		// Thread 2 : Start the Read sequence on Read sequencer
		begin
			if(addr == 2'b00)
                		rdtns.start(rd_seqrh[0]);

               		if(addr == 2'b01)
                		rdtns.start(rd_seqrh[1]);

			if(addr == 2'b10)
                		rdtns.start(rd_seqrh[2]);
		end
	join
endtask


