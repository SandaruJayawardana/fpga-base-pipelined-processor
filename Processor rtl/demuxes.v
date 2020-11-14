module demux16_1_16(out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,sel3); // Demux designs
	output out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15;
	//input  [15:0] in;
	input [3:0] sel3;
	wire  m1,m2,m3,m4,out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15;
	reg in=1'b1;
	demux16_1_4 mux4_1(in,m1,m2,m3,m4,sel3[3:2]);
	demux16_1_4 mux4_2(m1,out0,out1,out2,out3,sel3[1:0]);
	demux16_1_4 mux4_3(m2,out4,out5,out6,out7,sel3[1:0]);
	demux16_1_4 mux4_4(m3,out8,out9,out10,out11,sel3[1:0]);
	demux16_1_4 mux4_5(m4,out12,out13,out14,out15,sel3[1:0]);
endmodule

module demux16_1_2(in,out0,out1,sel);
	output out0,out1;
	input  in;
	input sel;
	wire out0,out1,in;
	assign out0=(sel==1'b0)? in:1'b0;
	assign out1=(sel==1'b1)? in:1'b0;
endmodule

module demux16_1_4(in,out0,out1,out2,out3,sel2);
	output out0,out1,out2,out3;
	input  in;
	input [1:0] sel2;
	wire  out0,out1,out2,out3,in,m1,m2;
	demux16_1_2 mux2_1(in,m1,m2,sel2[1]);
	demux16_1_2 mux2_2(m1,out0,out1,sel2[0]);
	demux16_1_2 mux2_3(m2,out2,out3,sel2[0]);
	
endmodule

	