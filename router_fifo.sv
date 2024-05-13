module router_fifo(clock, resetn, write_enb, soft_reset, read_enb, data_in, lfd_state, empty, data_out, full);

	input clock, resetn, write_enb, soft_reset, read_enb, lfd_state;
	input [7:0]data_in;
	output reg [7:0]data_out;
	output full, empty;

	reg [4:0]wr_pt, rd_pt;
	reg [6:0]fifo_counter;
	reg [8:0]mem[15:0];
        reg lfd_temp;

	integer i;

// delay lfd_state by one cycle

	always@(posedge clock)
	begin
		if(~resetn)
			lfd_temp<=0;
		else
			lfd_temp<=lfd_state;
	end

// logic for increment the pointer

//logic for incrementing write pointer ---- no soft_reset

	always@(posedge clock)
  	begin
    		if(~resetn)
     		begin
       			wr_pt<=1'b0;
     		end
    		else if((write_enb) && (~full)) 
      			wr_pt <= wr_pt+1;
    		else
       			wr_pt <= wr_pt;
  	end

// logic for incrementing read pointer ---- no soft_reset
	always@(posedge clock)
  	begin
    		if(~resetn)
      		begin
        		rd_pt<=1'b0;
      		end
    		else if((read_enb) && (~empty)) 
        		rd_pt <= rd_pt+1;
    		else
        		rd_pt <= rd_pt;
  	end

// Logic for fifo counter
	always@(posedge clock)
	begin
		if(~resetn || soft_reset)
			fifo_counter <= 0;

		else if(!empty && read_enb)
			begin
				if(mem[rd_pt[3:0]][8] == 1'b1)
					fifo_counter <= mem[rd_pt[3:0]][7:2] + 1;	
				else if(fifo_counter != 0)
					fifo_counter <= fifo_counter - 1;			
			end
		else
			fifo_counter <= fifo_counter;
	end

// Logic for Read logic
	always@(posedge clock)
	begin
		if(!resetn)
			data_out <= 8'b0;
		else if(soft_reset)
			data_out <= 8'bz;
		else if(read_enb && !empty)
			data_out <= mem[rd_pt[3:0]][7:0];
                else if(fifo_counter==0)
                        data_out<=8'bz;
		else
			data_out<=data_out;
                
	end

// Logic for Write
	always@(posedge clock)
	begin
		if(!resetn || soft_reset)
			for(i=0;i<16;i=i+1)
			begin
				mem[i] <= 9'b0;
			end
	
		else if(write_enb && !full)
		begin
           		if(lfd_temp)
	           	begin
                 		mem[wr_pt[3:0]][8]<=1'b1;
                 		mem[wr_pt[3:0]][7:0]<=data_in;
	          	end
      
	   		else
	         	begin
                  		mem[wr_pt[3:0]][8]<=1'b0;
                  		mem[wr_pt[3:0]][7:0]<=data_in;
	          	end
         	end
	end
	
	assign full = (wr_pt == {~rd_pt[4],rd_pt[3:0]})?1'b1:1'b0;
	assign empty = (wr_pt == rd_pt)?1'b1:1'b0;

endmodule

