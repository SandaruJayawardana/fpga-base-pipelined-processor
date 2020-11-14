//TOP MODULE
module processor(  
	// Clock input 
	input clk_real,
	
	// Rx and TX pins of UART
	input rx, 
	output tx,
	
	// SRAM Data bus 
	inout [15:0] bus,
	
	// SRAM IO signals
	output [19:0] sram_address,
	output output_enable,
	output data_enable,
	output chip_en,
	output UB,
	output LB,
	
	output [15:0]check_a
	
	);
	
	reg [5:0] instr_extended=6'b0,PC_6bit=6'b0;
	reg [15:0] zero_reg=16'b0;
	reg [1:0] zero_reg2=2'b0;

	wire [15:0] TR_in16;
	wire [1:0] TR_in2,d_bus;
	wire [17:0] Out18,MAR18,out_TR_MAR,r_i1_out,r_i2_out,r_i3_out;
	wire [15:0] Data_out_mem,data_out_from_reg;
	wire [17:0] Abus,A_bus,Bbus,B_bus,B_mux_out;
	wire [15:0] MDR_in,B_mux_in2,instr_reg_out,data_in,imem_out,AC16_out,c_bus,MAR16,MDR_out,PC_extend,r1_out,r2_out,r3_out,r4_out,r5_out,r6_out,r7_out,r8_out;
	wire [9:0] bit10line,pc_out;
	wire [5:0] bit6line,mux_in2;
	wire [3:0] sel_demux,dec_r0_out,dec_r0_out2,dec_r0_out3,dec_r1_out,dec_r2_out,op_out2,op_out3,op_out,sel_bits_B,sel_bits_A,sel_alu;
	wire R_I_2_incre,R_I_3_incre,clear,out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15;
	wire write_TR_1,write_TR_2,MDR_in_sel,M_READ,M_WRITE,sel_B_bus_mux,write_dec_op_reg,write_dec_reg,write_dec_reg2,s_tick;
	wire start_pr,end_pr,incre_MAR,MAR_in_sel,sel_mux6_2,recieving,recieve_over,recieve_start;
	wire clk, write_dec_reg3,long_inst_write,transmit_over,transmit_begin,transmit_active;
	wire write_en_imem,extra,A_reg_write,B_reg_write,z_flag,N_flag,PC_rst,clk_main,pc_incr,R_I_1_incre,uart_en;
	wire [19:0] address_d_RAM;
	wire [15:0] out_data,in_data;
	wire [15:0] tx_data;
	wire [19:0] address_uart;
	wire [1:0] write_en_uart;
	wire [15:0] uart_out_data;
	wire [1:0] write_en_reg;
	
	assign write_en_reg={(~M_READ),M_WRITE};
	assign TR_in2=dec_r2_out[3:2];
	assign TR_in16={op_out,dec_r0_out,dec_r1_out,dec_r2_out};
	assign PC_extend={PC_6bit,pc_out};
	assign mux_in2={op_out,dec_r0_out[3:2]};
	assign bit10line={dec_r0_out[1:0],dec_r1_out,dec_r2_out};
	assign B_mux_in2={bit6line,bit10line};
	assign c_bus=AC16_out;
	assign address_d_RAM={2'b00,MAR18};
	
	// clk divider (PLL or custom)
	CLOCK_DIVIDER clock_divide(clk_real,clk); // Custom clock divider
	
	// Address geenrator to store the data receiving from UART
	address_uart_generator add_uar_gen(.s_tick(s_tick),
	.address_uart(address_uart),
	.recieving(recieving),
	.recieve_over(recieve_over),
	.recieve_start(recieve_start),
	.transmit_begin(transmit_begin),
	.transmit_active(transmit_active),
	.transmit_over(transmit_over),
	.finish(end_pr),
	.write_en_uart(write_en_uart),
	.start_calculation(start_pr),
	.uart_en(uart_en));
	// Control transmitter for the receiving data from UART
	tx tx1 (.tx_data(tx_data),
	.s_tick(s_tick),
	.transmit_over(transmit_over),
	.tx(tx),
	.transmit_begin(transmit_begin),
	.transmit_active(transmit_active));
	// Control receiver for the receiving data from UART
	rx rx1(.rx(rx),
	.s_tick(s_tick),
	.out_data(uart_out_data),
	.recieve_over(recieve_over),
	.recieve_start(recieve_start),
	.recieving(recieving));
	
	// UART clock generator 9600 baudrate
	clk_generator clk_gen(.clk(clk_real),
	.s_tick(s_tick));
	
	// sram controller (IS61WV102416BLL ISSI SRAM) 
	// Note - SRAM can be replaced by either SDRAM or internal memory bits in the FPGA
	// This module work asa the data memory in the processor max 512Kb
	data_ram d_ram(.clk(clk),
	.write_en_reg(write_en_reg),
	.bus(bus),
	.data_in_reg(MDR_out),
	.data_out_reg(data_out_from_reg),
	.output_enable(output_enable),
	.data_enable(data_enable),
	.chip_en(chip_en),
	.UB(UB),
	.LB(LB),
	.address_reg(address_d_RAM),
	.sram_address(sram_address),
	.data_in_uart(uart_out_data),
	.data_out_uart(tx_data),
	.address_uart(address_uart),
	.uart_en(uart_en),
	.write_en_uart(write_en_uart));
	
	// This work as the Instruction memory of the pocessor max 128kb
	instuction_mem inst_mem(data_in,imem_out,pc_out,clk,write_en_imem);//(data_in,data_out,addr,clk,write_en);
	
	
	
	// Register bank
	TR_MAR    MAR_TR1(out_TR_MAR,TR_in16,TR_in2, write_TR_1,write_TR_2,clk);
	MAR       MAR1(MAR18,Out18, out0,incre_MAR,clk);
	register_ MDR(MDR_out,MDR_in,clk, out1,clear);
	PC 		 pc1(pc_out,c_bus[9:0],clk,pc_incr,PC_rst,out2);
	register_ R1(r1_out,c_bus,clk, out3,clear);
	register_ R2(r2_out,c_bus,clk, out4,clear);
	register_ R3(r3_out,c_bus,clk, out5,clear);
	register_ R4(r4_out,c_bus,clk, out6,clear);
	register_ R5(r5_out,c_bus,clk, out7,clear);
	register_ R6(r6_out,c_bus,clk, out8,clear);
	register_ R7(r7_out,c_bus,clk, out9,clear);
	register_ R8(r8_out,c_bus,clk, out10,clear);
	R_I R_I_1(r_i1_out,{d_bus,c_bus},clk,R_I_1_incre,clear,out11);
	R_I R_I_2(r_i2_out,{d_bus,c_bus},clk,R_I_2_incre,clear,out12);
	R_I R_I_3(r_i3_out,{d_bus,c_bus},clk,R_I_3_incre,clear,out13);
	
	//muxes
	mux18_16to1 mux_bus_A(Abus,MAR18,{zero_reg2,MDR_out},{zero_reg2,PC_extend},{zero_reg2,r1_out},{zero_reg2,r2_out},{zero_reg2,r3_out},{zero_reg2,r4_out},{zero_reg2,r5_out},{zero_reg2,r6_out},{zero_reg2,r7_out},{zero_reg2,r8_out},r_i1_out,r_i2_out,r_i3_out,{zero_reg2,AC16_out},{zero_reg2,zero_reg},sel_bits_A);
	mux18_16to1 mux_bus_B(Bbus,{zero_reg2,zero_reg},{zero_reg2,MDR_out},{zero_reg2,PC_extend},{zero_reg2,r1_out},{zero_reg2,r2_out},{zero_reg2,r3_out},{zero_reg2,r4_out},{zero_reg2,r5_out},{zero_reg2,r6_out},{zero_reg2,r7_out},{zero_reg2,r8_out},r_i1_out,r_i2_out,r_i3_out,{zero_reg2,AC16_out},{zero_reg2,zero_reg},sel_bits_B);
	mux18_2to1 MAR_input_mux(Out18,{d_bus,c_bus},out_TR_MAR,MAR_in_sel);
	mux16_2to1 MDR_input_mux(MDR_in,c_bus,data_out_from_reg,MDR_in_sel);
	
	// demuxes
	demux16_1_16 demux1(out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,sel_demux);
	
	// ALU
	ALU ALU1(A_bus,B_bus,AC16_out,d_bus,sel_alu,z_flag,N_flag,clk);//ALU(A_bus,B_bus,AC16,AC2,sel,z_flag,N_flag,clk);
	
	// A and B buses
	A_reg A_bus_reg(A_bus,Abus, A_reg_write,clk,clear);
	A_reg B_bus_reg(B_bus,B_mux_out, B_reg_write,clk,clear);
	mux18_2to1 B_bus_mux(B_mux_out,Bbus,{zero_reg2,B_mux_in2},sel_B_bus_mux);//mux18_2to1(out,in0,in1,sel);
	
	// Registers and muxes related to the pipeline process
	register_ instr_reg(instr_reg_out,imem_out,clk, long_inst_write,clear);//register_ (out,in,clk, write_en,clear);
	dec_reg op_code(op_out,instr_reg_out[15:12], write_dec_reg,clk);//dec_reg(out,in, write_en,clk);
	dec_reg op_code2(op_out2,op_out, write_dec_reg2,clk);//dec_reg(out,in, write_en,clk);
	dec_reg op_code3(op_out3,op_out2, write_dec_reg3,clk);//dec_reg(out,in, write_en,clk);
	dec_reg dec_r0(dec_r0_out,instr_reg_out[11:8], write_dec_reg,clk);//dec_reg(out,in, write_en,clk);
	dec_reg dec_r1(dec_r1_out,instr_reg_out[7:4], write_dec_reg,clk);//dec_reg(out,in, write_en,clk);
	dec_reg dec_r2(dec_r2_out,instr_reg_out[3:0], write_dec_reg,clk);//dec_reg(out,in, write_en,clk);
	dec_reg dec_r0_2(dec_r0_out2,dec_r0_out, write_dec_reg2,clk);//dec_reg(out,in, write_en,clk);
	dec_reg dec_r0_3(dec_r0_out3,dec_r0_out2, write_dec_reg3,clk);//dec_reg(out,in, write_en,clk);

	mux6_2to1 pc_inst_mux(bit6line,instr_extended,mux_in2,sel_mux6_2);//mux6_2to1(out,in0,in1,sel);
	
	// statemachine
	state_machine control_unit(start_pr,end_pr,dec_r0_out,dec_r1_out,dec_r2_out,MDR_in_sel,write_TR_1,write_TR_2,M_READ,M_WRITE,dec_r0_out3,op_out,op_out2,op_out3,clk,N_flag,z_flag,clear,pc_incr,PC_rst,R_I_1_incre,R_I_2_incre,R_I_3_incre,sel_bits_A,sel_bits_B,sel_alu,A_reg_write,B_reg_write,long_inst_write,write_dec_reg,write_dec_reg2,write_dec_reg3,sel_mux6_2,sel_B_bus_mux,sel_demux,MAR_in_sel,incre_MAR);
	
endmodule



