// Mux designs
module mux16_2to1(out,in0,in1,sel);
	output [15:0] out;
	input [15:0] in0,in1;
	input sel;
	wire [15:0] out;
	assign out=(sel==0)? in0:in1;
endmodule

module mux6_2to1(out,in0,in1,sel);
	output [5:0] out;
	input [5:0] in0,in1;
	input sel;
	wire [5:0] out;
	assign out=(sel==0)? in0:in1;
endmodule

module mux16_4to1(out,in0,in1,in2,in3,sel);
	output [15:0] out;
	input [15:0] in0,in1,in2,in3;
	input [1:0] sel;
	wire [15:0] t1,t2,out;
	mux16_2to1 mux2_1(t1,in0,in1,sel[0]);
	mux16_2to1 mux2_2(t2,in2,in3,sel[0]);
	mux16_2to1 mux2_3(out,t1,t2,sel[1]);
endmodule

module mux16_16to1(out,in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,sel);
	output [15:0] out;
	input [15:0] in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15;
	input [3:0] sel;
	wire [15:0] t1,t2,t3,t4,out;
	mux16_4to1 mux4_1(t1,in0,in1,in2,in3,sel[1:0]);
	mux16_4to1 mux4_2(t2,in4,in5,in6,in7,sel[1:0]);
	mux16_4to1 mux4_3(t3,in8,in9,in10,in11,sel[1:0]);
	mux16_4to1 mux4_4(t4,in12,in13,in14,in15,sel[1:0]);
	mux16_4to1 mux4_5(out,t1,t2,t3,t4,sel[3:2]);
endmodule

module mux18_2to1(out,in0,in1,sel);
	output [17:0] out;
	input [17:0] in0,in1;
	input sel;
	wire [17:0] out;
	assign out=(sel==0)? in0:in1;
endmodule

module mux18_4to1(out,in0,in1,in2,in3,sel);
	output [17:0] out;
	input [17:0] in0,in1,in2,in3;
	input [1:0] sel;
	wire [17:0] t1,t2,out;
	mux18_2to1 mux2_1(t1,in0,in1,sel[0]);
	mux18_2to1 mux2_2(t2,in2,in3,sel[0]);
	mux18_2to1 mux2_3(out,t1,t2,sel[1]);
endmodule
module mux18_16to1(out,in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,sel);
	output [17:0] out;
	input [17:0] in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15;
	input [3:0] sel;
	wire [17:0] t1,t2,t3,t4,out;
	mux18_4to1 mux4_1(t1,in0,in1,in2,in3,sel[1:0]);
	mux18_4to1 mux4_2(t2,in4,in5,in6,in7,sel[1:0]);
	mux18_4to1 mux4_3(t3,in8,in9,in10,in11,sel[1:0]);
	mux18_4to1 mux4_4(t4,in12,in13,in14,in15,sel[1:0]);
	mux18_4to1 mux4_5(out,t1,t2,t3,t4,sel[3:2]);
endmodule
	