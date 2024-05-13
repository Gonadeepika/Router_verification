module router_reg(clock, resetn, pkt_valid, data_in, fifo_full, detect_add, ld_state, laf_state, full_state, lfd_state, rst_int_reg, err, parity_done, low_packet_valid, dout);

	input clock, resetn, pkt_valid, fifo_full, detect_add, ld_state, laf_state, full_state, lfd_state, rst_int_reg;
	input [7:0]data_in;
	output reg err, parity_done, low_packet_valid; 
	output reg [7:0]dout;

	reg [7:0] hhb, ffb, ip, pp;

//logic for ffb and ffb and data out
	always@(posedge clock)
  	begin
    		if(~resetn)
      		begin
        		dout <= 0;
        		hhb <= 0;
        		ffb <= 0;
      		end
     		else if ((detect_add) && (pkt_valid) && (data_in[1:0]!=2'b11))
        		hhb <= data_in;
     		else if(lfd_state)
	     		dout<=hhb;
     		else if(ld_state && !fifo_full)
	     		dout<=data_in;
     		else if(ld_state && fifo_full)
	     		ffb<=data_in;
     		else if(laf_state)
	     		dout<=ffb;
    	 end
	
// Low Packet Valid
	always@(posedge clock)
	begin
		if(~resetn)
			low_packet_valid <= 1'b0;
		else if (rst_int_reg)
			low_packet_valid <= 1'b0;
		else if (ld_state && !pkt_valid)
			low_packet_valid <= 1'b1;
		else 
			low_packet_valid <= low_packet_valid;
	end

// Parity Done
	always@(posedge clock)
	begin
		if(~resetn)
			parity_done <= 1'b0;
		else if (detect_add)
			parity_done <= 1'b0;
		else if ((ld_state && !fifo_full && !pkt_valid) || (laf_state && low_packet_valid && !parity_done))
			parity_done <= 1'b1;
		else
			parity_done <= parity_done;
	end

// Packet Parity Logic
	always@(posedge clock)
	begin
		if(~resetn)
			pp <= 8'd0;
		else if (detect_add)
			pp <= 8'd0;
		else if ((ld_state && !fifo_full && !pkt_valid) || (laf_state && low_packet_valid && !parity_done))
			pp <= data_in;
		else
			pp <= pp;
	end

// Internal Parity Logic
	always@(posedge clock)
	begin
		if(~resetn)
			ip <= 8'd0;
		else if (detect_add)
			ip <= 8'd0;
		else if(lfd_state && pkt_valid)
			ip <= ip ^ hhb;
		else if(pkt_valid && ld_state && !full_state)
			ip <= ip ^ data_in;
		else 
			ip <= ip;
	end

// Error Logic
	always@(posedge clock)
	begin
		if(~resetn)
			err <= 1'b0;
		else if(parity_done)
	  	begin
	    		if (ip==pp)
	    			err <= 0;
	    		else 
	    			err <= 1;
	 	end
      		else
	 		err <= 0;
	end

endmodule

