interface router_if(input bit clock);
	
	logic [7:0] data_in;
	logic [7:0] data_out;
	logic rst;
	logic error;
	logic busy;
	bit read_enb;
	logic v_out;
	bit pkt_valid;
	
	// Clocking Blocks

	// Write Driver
	clocking wdr_cb@(posedge clock);
		default input #1 output #1;
		output data_in;
		output pkt_valid;
		output rst;
		input error;
		input busy;
	endclocking

	// Read Driver
	clocking rdr_cb@(posedge clock);
		default input #1 output #1;
		output read_enb;
		input v_out;
	endclocking

	// Write Monitor
	clocking wmon_cb@(posedge clock);
		default input #1 output #1;
		input data_in;
		input pkt_valid;
		input error;
		input busy;
		input rst;
	endclocking

	// Read Monitor
	clocking rmon_cb@(posedge clock);
		default input #1 output #1;
		input data_out;
		input read_enb;
	endclocking

	// Modports
	modport WDR_MP (clocking wdr_cb); // Write Driver
	modport RDR_MP (clocking rdr_cb); // Read Driver
	modport WMON_MP (clocking wmon_cb); // Write Monitor
	modport RMON_MP (clocking rmon_cb); // Read Monitor

endinterface
