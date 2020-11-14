module state_machine(start_pr,end_pr,dec_r0_out,dec_r1_out,dec_r2_out,MDR_in_sel,write_TR_1,write_TR_2,M_READ,M_WRITE,dec_r0_out3,op_out,op_out2,op_out3,clk_in,N_flag,z_flag,clear,pc_incr,PC_rst,R_I_1_incre,R_I_2_incre,R_I_3_incre,sel_bits_A,sel_bits_B,sel_alu,A_reg_write,B_reg_write,long_inst_write,write_dec_reg,write_dec_reg2,write_dec_reg3,sel_mux6_2,sel_B_bus_mux,sel_demux,MAR_in_sel,incre_MAR);

	input clk_in,N_flag,z_flag,start_pr;
	input [3:0] dec_r0_out,dec_r1_out,dec_r2_out,op_out,op_out2,op_out3,dec_r0_out3;
	output end_pr,incre_MAR,MAR_in_sel,MDR_in_sel,write_TR_1,write_TR_2,M_WRITE,M_READ,clear,pc_incr,PC_rst,R_I_1_incre,R_I_2_incre,R_I_3_incre,A_reg_write,B_reg_write,long_inst_write,write_dec_reg,write_dec_reg2,write_dec_reg3,sel_mux6_2,sel_B_bus_mux;
	output [3:0] sel_bits_A,sel_bits_B,sel_demux,sel_alu;
	
	reg long_inst=1'b0,long_inst_2=1'b0,mem_access_inst=1'b0,mem_access_inst2=1'b0,stop_com=1'b0;	
	reg incre_MAR=1'b0,MAR_in_sel=1'b0,halt=1'b0,halt_PC=1'b0,halt_DECODE=1'b0,halt_IR_read=1'b0,halt_ALU=1'b0,halt_WRITEBACK=1'b0;
	reg MDR_in_sel=1'b0,write_back=1'b0,write_TR_1=1'b0,write_TR_2=1'b0,M_READ=1'b0,M_WRITE=1'b0,clear=1'b0,pc_incr=1'b0,PC_rst=1'b0,R_I_1_incre=1'b0,R_I_2_incre=1'b0,R_I_3_incre=1'b0,A_reg_write=1'b0,B_reg_write=1'b0,long_inst_write=1'b0,write_dec_reg=1'b0,write_dec_reg2=1'b0,write_dec_reg3=1'b0,sel_mux6_2=1'b0,sel_B_bus_mux=1'b0,stop_clk=1'b0;
	reg [3:0] sel_bits_A,sel_bits_B,sel_demux,sel_alu;
	
	parameter NOP=4'd0,ADD=4'd1,SUB=4'd2,XOR=4'd3,MUL=4'd4,DIV=4'd5,JUMPZ=4'd6,JUMPNZ=4'd7,SUBI=4'd8,ADDI=4'd9,WRITE=4'd10,READ=4'd11,INCR_R=4'd12,MARMEM=4'd13,MOV=4'd14,CLAC=4'd15,STOP=8'd255; // Instructions
	
	
	wire clk;
	assign end_pr=(stop_com==1'b0)? 1'b0:1'b1;
	assign clk = (stop_com==1'b0 && start_pr==1'b1)? clk_in:stop_clk;
	reg neg_edge=1'b0;
	
	always @(posedge clk)
		begin
			neg_edge<=~neg_edge; // Generated signal
		end
		
	always @(negedge clk )
		begin
		if(neg_edge == 1'b1)
			begin//NEGATIVE
				//PC->
					long_inst_write=1'b0;
					if(halt_PC==1'b0 )
						begin
							pc_incr<=1'b1;
							halt_PC<=halt_PC;
						end
					else
						begin
							halt_PC<=1'b0;
							pc_incr<=1'b0;
						end
					//<-PC
					//<-DECODE
					if(halt_DECODE==1'b0 && halt_IR_read==1'b1)
						begin
							halt_IR_read<=1'b0;
						end
					else
						begin
							halt_IR_read<=halt_IR_read;
						end
					if(halt_DECODE==1'b0 )
						begin
							write_dec_reg<=1'b1;
						end
					else 
						begin
							write_dec_reg<=1'b0;
						end
				//<-DECODE
				
				//<-IR READ
					write_TR_1<=1'b0;
					write_TR_2<=1'b0;
					write_dec_reg2<=1'b0;
					A_reg_write<=1'b0;
					B_reg_write<=1'b0;
				//<-IR READ
				
				//<-ALU
					if(halt_ALU==1'b0 && halt_WRITEBACK==1'b1)
						begin
							halt_WRITEBACK<=1'b0;
						end
					if(halt_ALU==1'b0)// && op_out2 !=NOP)
						
						begin	
							if (op_out2 ==JUMPZ )//z==1 goto x
								begin
									if(z_flag==1'b1)
										begin
											write_dec_reg3<=1'b1;
											sel_alu<=op_out2;
											halt<=1'b1;
											write_back<=1'b1;
										end
									else
										begin
											write_back<=1'b0;
											halt<=1'b0;
										end
								end
							else if (op_out2==JUMPNZ )//z==1 goto x
								begin
									if(z_flag==1'b0)
										begin
											write_dec_reg3<=1'b1;
											sel_alu<=op_out2;
											halt<=1'b1;
											write_back<=1'b1;
										end
									else
										begin
											write_back<=1'b0;
											halt<=1'b0;
										end
								end
							else if(long_inst==1'b1)
								begin
									long_inst_2<=1'b1;
									write_back<=1'b0;
									write_dec_reg3<=1'b1;
									sel_alu<=NOP;
								end
							else if(long_inst_2==1'b1)
								begin
									long_inst_2<=1'b0;
									write_back<=1'b1;
									write_dec_reg3<=1'b0;
									sel_alu<=op_out2;
								end
							else if(mem_access_inst==1'b1)
								begin
									write_back<=1'b0;
									write_dec_reg3<=1'b1;
									mem_access_inst2<=1'b1;
									sel_alu<=NOP;
								end
							else if(mem_access_inst2==1'b1)
								begin
									write_dec_reg3<=1'b0;
									mem_access_inst2<=1'b0;
									sel_alu<=NOP;
								end
							else if(op_out2 ==NOP)
								begin
									write_dec_reg3<=1'b1;
									sel_alu<=NOP;
								end
							else
								begin
									write_back<=1'b1;
									write_dec_reg3<=1'b1;
									sel_alu<=op_out2;
								end
						end
					else
						begin	
							write_dec_reg3<=1'b0;
							sel_alu<=NOP;			
						end
				//<-ALU
				
				//<-WRITE BACK
					clear<=1'b0;
					PC_rst<=1'b0;
					M_READ<=1'b0;
					M_WRITE<=1'b0;
					sel_demux <= 4'b1111;
					R_I_1_incre<=1'b0;
					R_I_2_incre<=1'b0;
					R_I_3_incre<=1'b0;
					incre_MAR<=1'b0;
				//<-WRITE BACK
			end
		else//POSITVE
			begin
			//<- PC
				pc_incr<=1'b0;
				if(halt_PC==1'b0 && halt_DECODE==1'b1)
					begin
						halt_DECODE<=1'b0;
					end
				if(halt_PC==1'b0 )
					begin
						long_inst_write<=1'b1;
					end
				else 
					begin
						long_inst_write<=1'b0;
					end
			//<-PC
			
			//<-DECODE
				write_dec_reg<=1'b0;
				
			//<-DECODE
			
			//<-IR READ
				if(halt_IR_read==1'b0 && halt_ALU==1'b1)
					begin
						halt_ALU<=1'b0;
					end
				if(halt_IR_read==1'b0 )
				
					begin	
						if (mem_access_inst==1'b1)
							begin 				
								write_TR_1<=1'b0;
								write_TR_2<=1'b1;			
								mem_access_inst<=1'b0;
								write_dec_reg2<=1'b0;
							end
									
						else if (long_inst==1'b1)
							begin 
								A_reg_write<=1'b0;
								B_reg_write<=1'b1;
								sel_B_bus_mux<=1'b1;
								sel_mux6_2<=1'b1;
								long_inst<=1'b0;
								write_dec_reg2<=1'b0;
							end
						else
							begin
								if({op_out,dec_r0_out}==STOP)
									begin
										stop_com<='b1;
									end
								else
									begin
										stop_com<=stop_com;
									end
								write_dec_reg2<=1'b1;	
						case (op_out)	
							ADD:
								begin
									long_inst<=1'b0;
									sel_bits_A<=dec_r1_out;
									sel_bits_B<=dec_r2_out; 
									A_reg_write<=1'b1;
									B_reg_write<=1'b1;
									sel_B_bus_mux<=1'b0;
								end
							SUB:
								begin
									long_inst<=1'b0;
									sel_bits_A<=dec_r1_out;
									sel_bits_B<=dec_r2_out; 
									A_reg_write<=1'b1;
									B_reg_write<=1'b1;
									sel_B_bus_mux<=1'b0;
								end
							XOR:
								begin 
									long_inst<=1'b0;
									sel_bits_A<=dec_r1_out;
									sel_bits_B<=dec_r2_out; 
									A_reg_write<=1'b1;
									B_reg_write<=1'b1;
									sel_B_bus_mux<=1'b0;
								end
							MUL:
								begin
									long_inst<=1'b0;
									sel_bits_A<=dec_r1_out;
									sel_bits_B<=dec_r2_out; 
									A_reg_write<=1'b1;
									B_reg_write<=1'b1;
									sel_B_bus_mux<=1'b0;
								end
							DIV:
								begin
									long_inst<=1'b0;
									sel_bits_A<=dec_r1_out;
									sel_bits_B<=dec_r2_out; 
									A_reg_write<=1'b1;
									B_reg_write<=1'b1;
									sel_B_bus_mux<=1'b0;
								end
							JUMPZ:
								begin
									long_inst<=1'b0;
									A_reg_write<=1'b0;
									B_reg_write<=1'b1;
									sel_B_bus_mux<=1'b1;
									sel_mux6_2<=1'b0;
								end
							JUMPNZ:
								begin
									long_inst<=1'b0;
									A_reg_write<=1'b0;
									B_reg_write<=1'b1;
									sel_B_bus_mux<=1'b1;
									sel_mux6_2<=1'b0;
								end
							SUBI:
								begin
									sel_bits_A<=dec_r1_out;
									A_reg_write<=1'b1;
									long_inst<=1'b1;
								end
							ADDI:
								begin
									sel_bits_A<=dec_r1_out;
									A_reg_write<=1'b1;
									long_inst<=1'b1;
								end
							MOV:
								begin
									long_inst<=1'b0;
									sel_bits_A<=dec_r1_out;
									A_reg_write<=1'b1;
								end
							WRITE:begin		
										
									end
							
							READ: begin
										
									end
							MARMEM:
								begin
									write_TR_1<=1'b1;
									write_TR_2<=1'b0;
									mem_access_inst<=1'b1;
								end
							CLAC: begin
								
									end
							default:
								begin	 
									A_reg_write<=1'b0;
									B_reg_write<=1'b0;
								end
							endcase		
						end
					end
				else 
					begin
						write_dec_reg2<=1'b0;
						A_reg_write<=1'b0;
						B_reg_write<=1'b0;
					end
			//IR READ
			
			//<-ALU
				write_dec_reg3<=1'b0;
				sel_alu<=NOP;
			//<-ALU
			
			//<-WRITE BACK
				if (halt ==1'b1)
					begin
						write_back<=1'b1;
						halt<=1'b0;
						halt_PC<=1'b1;
						halt_ALU<=1'b1;
						halt_DECODE<=1'b1;
						halt_IR_read<=1'b1;
						halt_WRITEBACK<=1'b1;
						sel_demux <= 4'd2;
						write_back<=1'b0;
					end
				else if (halt_WRITEBACK ==1'b0 && op_out3 !=NOP)
					begin
						if(op_out3==MARMEM)
							begin
								sel_demux <= dec_r0_out3;
								MAR_in_sel<=1'b1;
							end
						else if(op_out3==INCR_R)
							begin
							write_back<=1'b0;
							if (dec_r0_out3==4'd0)
								begin 
									incre_MAR<=1'b1;			
								end
							else if (dec_r0_out3==4'd1)
								begin 
									R_I_1_incre<=1'b1;		
								end
							else if (dec_r0_out3==4'd2)
								begin 
									R_I_2_incre<=1'b1;			
								end
							else
								begin 
									R_I_3_incre<=1'b1;
												
								end
							end
						else if(op_out3==WRITE)
							begin
								write_back<=1'b0;
								M_WRITE<=1'b1;
							end
						else if(op_out3==READ)
							begin
								sel_demux <= 4'd1;
								write_back<=1'b0;
								M_READ<=1'b1;
								MDR_in_sel<=1'b1;
							end
						else if(op_out3==CLAC)
							begin
								write_back<=1'b0;
								clear<=1'b1;
								//PC_rst<=1'b1;
							end
						else if(write_back == 1'b1)
							begin
								sel_demux <= dec_r0_out3;
								MDR_in_sel<=1'b0;
								MAR_in_sel<=1'b0;
								write_back<=1'b0;
								
							end
						else
							begin	
								sel_demux <= 4'b1111;
							end
					end
			//<-WRITE BACK
			end
		
		end
	
endmodule	
			
