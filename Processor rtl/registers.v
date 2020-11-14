// Different register types
module MAR(Out18,in18, write_en,incre,clk);
	output [17:0] Out18;
	input [17:0] in18;

	//wire [1:0] in2;
	//wire [15:0] in16;
	input write_en,clk,incre;
	reg [17:0] Out18=18'b0;
	always @(posedge clk)
		begin
			if(write_en==1'b1)
				begin
					Out18=in18;
				end
			else if(incre==1'b1)
				begin
					Out18=Out18+1'b1;
				end
		end
endmodule

module TR_MAR(Out18,in16,in2, write_1,write_2,clk);
	output [17:0] Out18;
	input [15:0] in16;
	input [1:0] in2;
	//wire [1:0] in2;
	//wire [15:0] in16;
	input write_1,write_2,clk;
	reg [17:0] Out18;
	always @(posedge clk)
		begin
			if(write_2==1'b1)
				begin
					Out18[15:0]=in16;
					
				end
			
			if(write_1==1'b1)
				begin
					Out18[17:16]=in2;
				end
		end
endmodule

module dec_reg(out,in, write_en,clk);
	output [3:0] out;
	input [3:0] in;
	input write_en,clk;
	reg [3:0] out =4'b0;
	always @(posedge clk)
		begin
		if(write_en==1'b1)
			out=in;
		end
endmodule

module A_reg(out,in1, write_en,clk,clear);
	output [17:0] out;
	input [17:0] in1;
	input write_en,clk,clear;
	reg [17:0] out=18'b0;
	always @(posedge clk)
		begin
			if(write_en==1'b1)
				begin
					out=in1;	
				end
			if(clear==1'b1)
				out=18'b0;
		end
endmodule


module register_ (out,in,clk, write_en,clear);
	input [15:0] in;
	input clk,write_en,clear;
	output [15:0] out;
	wire clk,write_en,clear;
	wire [15:0] in;
	reg [15:0] out=16'b0;
	always @(posedge clk)
		begin
			if(write_en == 1'b1)
				out=in;
			else if(clear==1'b1)
				out=16'b0;
		end
endmodule
				
module R_I(out,in,clk,incr,rst,write_en);
	output [17:0] out;
	input [17:0] in;
	input clk,incr,rst,write_en;
	reg [17:0] out=18'b0;
	always @(posedge clk)
		begin
			if(rst==1'b1)
				out=18'b0;
			else	
				begin
					if(write_en==1'b1)
						out=in;
					else if(incr==1'b1)
						out=out+1'b1;
				end
			
		end

		
endmodule

module PC(out,in,clk,incr,rst,write_en);
	output [9:0] out;
	input [9:0] in;
	input clk,incr,rst,write_en;
	reg [9:0] out=10'b0;
	always @(posedge clk)
		begin
			if(rst==1'b1)
				out=10'b0;
			else
				begin
					if(write_en==1'b1)
						out=in;
					if(incr==1'b1)
						out=out+1'b1;
				end
		end
		
endmodule
