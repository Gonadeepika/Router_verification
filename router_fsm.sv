module router_fsm(clock, resetn, pkt_valid, data_in, fifo_full, empty_0, empty_1, empty_2, soft_reset_0, soft_reset_1, soft_reset_2, parity_done, 
		low_packet_valid, write_enb_reg, detect_add, ld_state, laf_state, lfd_state, full_state, rst_int_reg, busy);

	input clock, resetn, pkt_valid, fifo_full, empty_0, empty_1, empty_2, soft_reset_0, soft_reset_1, soft_reset_2, parity_done, low_packet_valid;
	input [1:0] data_in;
	output write_enb_reg, detect_add, ld_state, laf_state, lfd_state, full_state, rst_int_reg, busy;

	parameter DECODE_ADDRESS     = 3'b000;
	parameter LOAD_FIRST_DATA    = 3'b001;
	parameter LOAD_DATA          = 3'b010;
	parameter FIFO_FULL_STATE    = 3'b011;
	parameter LOAD_AFTER_FULL    = 3'b100;
	parameter LOAD_PARITY        = 3'b101;
	parameter CHECK_PARITY_ERROR = 3'b110;
	parameter WAIT_TILL_EMPTY    = 3'b111;

	reg [2:0] NS, PS;

// Present State Logic

	always@(posedge clock)
	begin
		if(!resetn)
			PS <= DECODE_ADDRESS;
		else if (soft_reset_0 || soft_reset_1 || soft_reset_2)
			PS <= DECODE_ADDRESS;
		else
			PS <= NS;
	end

// Next State Logic

	always@(*)
	begin
		case(PS)
			DECODE_ADDRESS :
					begin
					if((pkt_valid && (data_in[1:0] == 2'b00) && empty_0)||(pkt_valid && (data_in[1:0] == 2'b01) && empty_1)||(pkt_valid && (data_in[1:0] == 2'b10) && empty_2))
						NS = LOAD_FIRST_DATA;
					else if((pkt_valid && (data_in[1:0] == 2'b00) && !empty_0)||(pkt_valid && (data_in[1:0] == 2'b01) && !empty_1)||(pkt_valid && (data_in[1:0] == 2'b10) && !empty_2))
						NS = WAIT_TILL_EMPTY;
					else
						NS = DECODE_ADDRESS;
					end

			LOAD_FIRST_DATA : NS = LOAD_DATA;

			LOAD_DATA : 
					begin
					if(fifo_full)
						NS = FIFO_FULL_STATE;
				    	else if(!pkt_valid && !fifo_full)
						NS = LOAD_PARITY;
				    	else
						NS = LOAD_DATA;
				    	end

			FIFO_FULL_STATE : 
					begin
					if(!fifo_full)
						NS = LOAD_AFTER_FULL;
					else if(fifo_full)
						NS = FIFO_FULL_STATE;
					end

			LOAD_AFTER_FULL : 
					begin
					if(!parity_done && low_packet_valid)
						NS = LOAD_PARITY;
					else if(!parity_done && !low_packet_valid)
						NS = LOAD_DATA;
					else if(parity_done)
						NS = DECODE_ADDRESS;
					end

			LOAD_PARITY : NS = CHECK_PARITY_ERROR;

			CHECK_PARITY_ERROR :
					begin
					if(!fifo_full)
						NS = DECODE_ADDRESS;
					else
						NS = FIFO_FULL_STATE;
					end

			WAIT_TILL_EMPTY :
					begin
					if((empty_0&&(data_in[1:0] == 2'b00)) || (empty_1&&(data_in[1:0] == 2'b01)) || (empty_2&&(data_in[1:0] == 2'b10)))
						NS = LOAD_FIRST_DATA;
					else
						NS = WAIT_TILL_EMPTY;
					end

			default : NS = DECODE_ADDRESS;
		endcase
	end

// Output Logic

	assign write_enb_reg = ((PS == LOAD_DATA)||(PS == LOAD_AFTER_FULL)||(PS == LOAD_PARITY))?1'b1:1'b0;
	assign detect_add = (PS == DECODE_ADDRESS)?1'b1:1'b0;
	assign ld_state = (PS == LOAD_DATA)?1'b1:1'b0;
	assign laf_state = (PS == LOAD_AFTER_FULL)?1'b1:1'b0;
	assign lfd_state = (PS == LOAD_FIRST_DATA)?1'b1:1'b0;
	assign full_state = (PS == FIFO_FULL_STATE)?1'b1:1'b0;
	assign rst_int_reg = (PS == CHECK_PARITY_ERROR)?1'b1:1'b0;
	assign busy = (PS == DECODE_ADDRESS || PS == LOAD_DATA)?1'b0:1'b1;

endmodule
