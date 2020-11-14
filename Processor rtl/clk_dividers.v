module CLOCK_DIVIDER(clk_IN,clk); // clock divider for top design

	input clk_IN;
	reg [7:0] counter=8'd0;
	output reg clk=1'd0;

	always@(posedge clk_IN)
		begin
			if (counter==8'd9) // generate 1mhz frequency from 50mhz internal oscillator
				begin
					counter=8'd0;
					clk=~clk;
				end
			else
				begin
					counter=counter +8'd1;
					
				end
		end
endmodule


module clk_generator(clk, s_tick); // Simple clock divider module to for UART 9600 baudrate(can use PLLs alse)
	input clk;
	output s_tick;
	parameter clk_devide_count=9'd320;
	reg [8:0]count =9'd0;
	
	always@(posedge clk)
		begin
			if(clk_devide_count==count) count =9'd0;
			else count=count + 1'b1;
		end
	
	assign s_tick =(count == clk_devide_count) ? 1'b1:1'b0;
endmodule