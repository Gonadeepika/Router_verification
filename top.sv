module top;
	
	//Import Packages
	import router_pkg::*;
	import uvm_pkg::*;
	
	//Generate Clock
	bit clock;
	
	initial
	begin	
		forever
			#10 clock = ~clock;
	end

	//Interface instances
	router_if in(clock);
	router_if in0(clock);
	router_if in1(clock);
	router_if in2(clock);

	router_top DUV(.clock(clock), 
			.resetn(in.rst), 
			.pkt_valid(in.pkt_valid), 
			.data_in(in.data_in), 
			.err(in.error), 
			.busy(in.busy), 
			.read_enb_0(in0.read_enb), 
			.read_enb_1(in1.read_enb), 
			.read_enb_2(in2.read_enb), 
			.vldout_0(in0.v_out), 
			.vldout_1(in1.v_out), 
			.vldout_2(in2.v_out), 
			.data_out_0(in0.data_out), 
			.data_out_1(in1.data_out), 
			.data_out_2(in2.data_out));

	initial
	begin

		//$sdf_annotate("router.sdf",DUV);
		
		//set the virtual interface instances as srings vif_0, vif_1, vif_2, vif_3 using the uvm_config_db

		//$fsdbDumpSVA;
		//$fsdbDumpvars(0, top);
		//$fsdbDumpSVA();

		uvm_config_db #(virtual router_if)::set(null,"*","vif",in);
		uvm_config_db #(virtual router_if)::set(null,"*","vif_0",in0);
		uvm_config_db #(virtual router_if)::set(null,"*","vif_1",in1);
		uvm_config_db #(virtual router_if)::set(null,"*","vif_2",in2);
	
		// Call run_test
		run_test();
	end

endmodule
