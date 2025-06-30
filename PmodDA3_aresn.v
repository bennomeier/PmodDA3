module PmodDA3(
	       input  clk, // 50 MHz
	       input  resetn,
	       input  [15:0] data,
	       input  start,

	       output sclk,
	       output reg din,
	       output reg nLDAC,
	       output reg nCS,
	       output reg done);
   
   // state machine parameters
   parameter	      idle = 3'b000;
   parameter	      cs = 3'b001;
   parameter	      shifting = 3'b010;
   parameter	      waiting = 3'b011;
   parameter	      latch = 3'b100;
   
   reg [15:0]	      shifting_data;
	      
   
   reg [2:0]	      state_reg;
   reg [3:0]	      shift_counter;
   reg		      conversion_finished;
   
   //clock_divider #(
   //     .divisor(50)
   // ) clk_div1er (
   //     .clk(clk), 
   //     .rst(reset), 
   //     .clk_div(sclk)
   // );
   
   
   assign sclk = clk;
   
   
   // State Machine
   always @(posedge clk or negedge resetn)
     begin
	if (!resetn)
	  state_reg <= idle;
	else
	  case ( state_reg )
	    idle :
	      if (start) state_reg <= cs;
	    cs :
	       state_reg <= shifting; /// shifting to waiting transition is further below
	    shifting:
	       if (shift_counter == 4'b1111) state_reg <= waiting;
	    waiting :
	      if (conversion_finished)	      state_reg <= latch;	    
	    latch :
	      state_reg <= idle;
	    default : state_reg <= idle;
	  endcase // case ( state_reg )
     end // always @ (posedge clk or posedge reset)


   // the next block goes through most of the sequence,
   // only the dataashifting has been coded in a separate block.
   always @(posedge clk or negedge resetn)
     begin
	if (!resetn || state_reg == idle)
	  begin
	     shift_counter <= 0;	     
	     conversion_finished <= 0;
	     nCS <= 1;
	     nLDAC <= 1;
	     done <= 0;
	  end
	else if (state_reg == cs)
	   begin  
	       nCS <= 0;
	       shifting_data <= data;
	   end
	else if (state_reg == shifting)
	  begin
	    nCS <= 0;
	    shift_counter<=shift_counter + 1;
	    shifting_data <= {shifting_data[14:0], shifting_data[15]};
	    din <= shifting_data[15];
	  end
	else if (state_reg == waiting)
	  begin
	     nCS <= 1;
	     conversion_finished <= 1;
	  end	
	else if (state_reg == latch)
	  begin
    	  nLDAC <= 0;
	     done <= 1;
	   end	
	 end // always @ (posedge clk or posedge reset)


//   always @(posedge clk or posedge reset)
//    begin
//	   if (state_reg == shifting)
//	       begin   
	           
//	           shifting_data <= {shifting_data[14:0], shifting_data[15]};
//	           ///din <= shifting_data[15]; // not sure about this one
	       //end
//   end // always @ (posedge clk or posedge reset)

   
   
   

endmodule
	
	
	      
	
