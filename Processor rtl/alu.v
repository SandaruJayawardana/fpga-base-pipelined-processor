module ALU(A_bus,B_bus,AC16,AC2,sel,z_flag,N_flag,clk); // ALU has two flags 'zero flag' and 'A greater than  B flag'. Mul operation is power of 2 and division is power of 2 (can be changed if necessary)
	output [15:0] AC16;
	output [1:0] AC2;
	output z_flag,N_flag;
	input [17:0] A_bus,B_bus;
	input [3:0] sel;
	input clk;
	reg [15:0] AC16;
	reg [1:0] AC2;
	wire z_flag,N_flag;
	parameter NOP=4'd0,ADD=4'd1,SUB=4'd2,XOR=4'd3,MUL=4'd4,DIV=4'd5,JUMPZ=4'd6,JUMPNZ=4'd7,SUBI=4'd8,ADDI=4'd9,WRITE=4'd10,READ=4'd11,INCR_R=4'd12,MARMEM=4'd13,MOV=4'd14,CLAC=4'd15,STOP=8'd255;
	always @(posedge clk)
		begin
			case (sel)
					ADD	: 	{AC2,AC16}=A_bus+B_bus;
					SUB	: {AC2,AC16}=A_bus-B_bus;
					XOR	: {AC2,AC16}=A_bus ^ B_bus;
					MUL	:begin
								// A_bus * B_bus; // general Multiplication
								if (B_bus== 16'd2)
									{AC2,AC16}=A_bus<<1;
								else if(B_bus== 16'd4)
									{AC2,AC16}=A_bus<<2;
								else if(B_bus== 16'd8)
									{AC2,AC16}=A_bus<<3;
								else if(B_bus== 16'd16)
									{AC2,AC16}=A_bus<<4;
							end	
					DIV	: begin // A_bus / B_bus; // general division
								if (B_bus== 16'd2)
									{AC2,AC16}=A_bus>>1;
								else if(B_bus== 16'd4)
									{AC2,AC16}=A_bus>>2;
								else if(B_bus== 16'd8)
									{AC2,AC16}=A_bus>>3;
								else if(B_bus== 16'd16)
									{AC2,AC16}=A_bus>>4;
							end
					JUMPZ : {AC2,AC16}=B_bus;
					JUMPNZ: {AC2,AC16}=B_bus;
					SUBI	: {AC2,AC16}=A_bus-B_bus;
					ADDI	: {AC2,AC16}=A_bus+B_bus;
					MOV   : {AC2,AC16}=A_bus;
					default: {AC2,AC16}=AC16;
			endcase
		end
	assign z_flag=({AC2,AC16}==18'd0)? 1'b1:1'b0;
	assign N_flag=(A_bus > B_bus)? 1'b1:1'b0;
endmodule
