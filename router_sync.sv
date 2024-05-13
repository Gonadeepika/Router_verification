module router_sync(clock, resetn, data_in, detect_add, full_0, full_1, full_2, empty_0, empty_1, empty_2, write_enb_reg, read_enb_0, read_enb_1, 
			read_enb_2, write_enb, fifo_full, vld_out_0, vld_out_1, vld_out_2, soft_reset_0, soft_reset_1, soft_reset_2);

	input clock, resetn, detect_add, full_0, full_1, full_2, empty_0, empty_1, empty_2, write_enb_reg, read_enb_0, read_enb_1, read_enb_2;
	input [1:0]data_in;
	output  vld_out_0, vld_out_1, vld_out_2;
	output reg fifo_full, soft_reset_0, soft_reset_1, soft_reset_2;
	output reg [2:0]write_enb;

	reg [1:0] int_addr_reg;
	reg [4:0] timer_0, timer_1, timer_2;

// Latch the Address

	always@(posedge clock)
	begin
		if(!resetn)
			int_addr_reg <= 2'b11;
		else if(detect_add)
			int_addr_reg <= data_in;
	end

//fifo full logic and write enable logic
	
	always@(*)
  	begin
    		case(int_addr_reg)
    			2'b00:begin
	  			fifo_full<=full_0;
	  			if(write_enb_reg)
	  				write_enb<=3'b001;
	  			else
	  				write_enb<=0;
	  			end
    			2'b01:begin
	  			fifo_full<=full_1;
	  			if(write_enb_reg)
	  				write_enb<=3'b010;
	  			else
	  				write_enb<=0;
	  			end
    			2'b10:begin
				fifo_full<=full_2;
				if(write_enb_reg)
	  				write_enb<=3'b100;
	  			else
	  				write_enb<=0;
	  			end
    			default:begin
	  			fifo_full<=0;
	  			write_enb<=0;
	  			end
    		endcase
  	end
// Valid Out Logic

	assign vld_out_0 = ~empty_0;
	assign vld_out_1 = ~empty_1;
	assign vld_out_2 = ~empty_2;

// Soft reset Logic
// Soft reset 0
	always@(posedge clock)
	begin
		if(!resetn)
		begin
			soft_reset_0 <= 1'b0;
			timer_0 <= 5'b0;
		end
		else if(vld_out_0)
		begin
			if(read_enb_0 == 1'b0)
			begin
				if(timer_0 == 29)
          			begin
               				soft_reset_0 <= 1'b1;
               				timer_0 <= 5'b0;
          			end
          			else
          			begin
               				soft_reset_0 <= 1'b0;
               				timer_0 <= timer_0+1;
          			end
      			end
			else
				timer_0 <= 0;
		end
	end

// Soft reset 1
	always@(posedge clock)
	begin
		if(!resetn)
		begin
			soft_reset_1 <= 1'b0;
			timer_1 <= 5'b0;
		end
		else if(vld_out_1)
		begin
			if(read_enb_1 == 1'b0)
			begin
				if(timer_1 == 29)
          			begin
               				soft_reset_1 <= 1'b1;
               				timer_1 <= 5'b0;
          			end
          			else
          			begin
               				soft_reset_1 <= 1'b0;
               				timer_1 <= timer_1+1;
          			end
      			end
			else
				timer_1 <= 0;
		end
	end	

// Soft reset 2
	always@(posedge clock)
	begin
		if(!resetn)
		begin
			soft_reset_2 <= 1'b0;
			timer_2 <= 5'b0;
		end
		else if(vld_out_2)
		begin
			if(read_enb_2 == 1'b0)
			begin
				if(timer_2 == 29)
				begin
					soft_reset_2 <= 1'b1;
					timer_2 <= 5'b0;
				end
				else
				begin
					soft_reset_2 <= 1'b0;
					timer_2 <= timer_2+1;
				end
			end
			else
				timer_2 <= 0;
		end
	end
endmodule
