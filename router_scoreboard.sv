class router_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(router_scoreboard)

	uvm_tlm_analysis_fifo#(write_xtn) fifo_wrh;
	uvm_tlm_analysis_fifo#(read_xtn) fifo_rdh[];

	router_env_config e_cfg;
	
	write_xtn wr_data;
	write_xtn write_cov_data;

	read_xtn rd_data;
	read_xtn read_cov_data;

	int data_verified_count;

//	COVERAGE
//------for Write Side
	covergroup router_fcov1;
	
		option.per_instance = 1; //gives detailed coverage

		HEADER : coverpoint write_cov_data.header[1:0]{
							bins fifo0 = {2'b00};
							bins fifo1 = {2'b01};
							bins fifo2 = {2'b10};}
	
		//PAYLOAD SIZE
		PAYLOAD_SIZE : coverpoint write_cov_data.header[7:2]{
								bins small_packet = {[1:15]};
								bins medium_packet = {[16:30]};
								bins large_packet = {[31:63]};}

		//BAD PACKET
		BAD_PKT : coverpoint write_cov_data.err {bins bad_pkt = {1};}
	
		HEADER_X_PAYLOAD_SIZE : cross HEADER, PAYLOAD_SIZE;
	
	endgroup

//------for READ Side
	covergroup router_fcov2;
	
		option.per_instance = 1; //gives detailed coverage

		HEADER : coverpoint read_cov_data.header[1:0]{
							bins fifo0 = {2'b00};
							bins fifo1 = {2'b01};
							bins fifo2 = {2'b10};}
	
		//PAYLOAD SIZE
		PAYLOAD_SIZE : coverpoint read_cov_data.header[7:2]{
								bins small_packet = {[1:15]};
								bins medium_packet = {[16:30]};
								bins large_packet = {[31:63]};}
	
		HEADER_X_PAYLOAD_SIZE : cross HEADER, PAYLOAD_SIZE;
	
	endgroup

	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void check_data(read_xtn rd);
	extern function void report_phase(uvm_phase phase);

endclass



//-----------------------------------Constructor New------------------------------//
function router_scoreboard::new(string name, uvm_component parent);
	super.new(name, parent);
	router_fcov1 = new();
	router_fcov2 = new();	
endfunction



//-----------------------------------Build Phase-------------------------------//
function void router_scoreboard::build_phase(uvm_phase phase);
	
	super.build_phase(phase);
        // get the config object using uvm_config_db
        if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",e_cfg))
                `uvm_fatal("CONFIG","cannot get() e_cfg from uvm_config_db. Have you set() it?")

	fifo_wrh = new("fifo_wrh",this);

	fifo_rdh = new[e_cfg.no_of_read_agent];
	foreach(fifo_rdh[i])
		fifo_rdh[i] = new($sformatf("fifo_rdh[%0d]",i),this);
	
endfunction



//-----------------------------------Run Phase------------------------------------//
task router_scoreboard::run_phase(uvm_phase phase);

	fork
//		Thread 1 : getting Data from write monitor
		begin
			forever
			begin
				fifo_wrh.get(wr_data);
				`uvm_info(get_type_name(),"Data Received from Write Monitor to Scoreboard : \n",UVM_LOW)
				wr_data.print();
				write_cov_data = wr_data;
				router_fcov1.sample();
			end
		end

//		Thread 2 : getting Data from read monitor
		begin
			forever
			begin
				fork
//					Thread 1: read_data of fifo 0
					begin
						fifo_rdh[0].get(rd_data);
						`uvm_info(get_type_name(),"Data Received from Read Monitor to Scoreboard : \n",UVM_LOW)
						rd_data.print();
						check_data(rd_data);
						read_cov_data = rd_data;
						router_fcov2.sample();
					end
	
//					Thread 2: read_data of fifo 1
					begin
						fifo_rdh[1].get(rd_data);
						`uvm_info(get_type_name(),"Data Received from Read Monitor to Scoreboard : \n",UVM_LOW)
						rd_data.print();
						check_data(rd_data);
						read_cov_data = rd_data;
						router_fcov2.sample();
					end

//					Thread 3: read_data of fifo 2
					begin
						fifo_rdh[2].get(rd_data);
						`uvm_info(get_type_name(),"Data Received from Read Monitor to Scoreboard : \n",UVM_LOW)
						rd_data.print();
						check_data(rd_data);
						read_cov_data = rd_data;
						router_fcov2.sample();
					end
				join_any
				disable fork;
			end
		end
	join
endtask




//------------------------------------------Check Data----------------------------------------//
function void router_scoreboard::check_data(read_xtn rd);
	
//	Header comparision
	if(wr_data.header == rd.header)
		`uvm_info("SB","HEADER MATCHED SUCCESSFULLY", UVM_MEDIUM)
	else
		`uvm_error("SB","HEADER COMPARISION FAILED")


//	Payload comparision	
	if(wr_data.payload_data == rd.payload_data)
		`uvm_info("SB","PAYLOAD MATCHED SUCCESSFULLY", UVM_MEDIUM)
	else
		`uvm_error("SB","PAYLOAD COMPARISION FAILED")

//	Parity comparision
	if(wr_data.parity == rd.parity)
		`uvm_info("SB","PARITY MATCHED SUCCESSFULLY", UVM_MEDIUM)
	else
		`uvm_error("SB","PARITY COMPARISION FAILED")

	data_verified_count++;

endfunction



//-----------------------------------------Report Phase---------------------------------------//
function void router_scoreboard::report_phase(uvm_phase phase);
  	`uvm_info(get_type_name(), $sformatf("Report: Number of DATA VERIFIED ---> %0d", data_verified_count), UVM_LOW) 
endfunction
