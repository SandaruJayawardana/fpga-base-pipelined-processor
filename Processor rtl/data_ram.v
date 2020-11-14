module data_ram(clk,write_en_reg,bus,data_in_reg,data_out_reg,output_enable,data_enable,chip_en,UB,LB,address_reg,sram_address,data_in_uart,data_out_uart,address_uart,uart_en,write_en_uart); // this code is for the sram controoler
	input clk; 
	input [1:0] write_en_reg;
	input [1:0] write_en_uart;
	
	output output_enable;
	output data_enable;
	output chip_en;
	output UB;
	output LB;
	inout [15:0] bus;
	input [15:0] data_in_reg;
	output [15:0]data_out_reg;
	input [19:0] address_reg;
	
	input [15:0] data_in_uart;
	output [15:0]data_out_uart;
	input [19:0] address_uart;
	input uart_en;
	
	output [19:0] sram_address;
	
	reg [15:0] data_in;
	
	always @(*)
		begin
			if(uart_en)
				data_in= data_in_uart;
			else
				data_in= data_in_reg;
		end
			
		
	assign data_enable=(write_en_reg==2'b11 || write_en_uart== 2'b11) ? 1'b0 :1'b1 ;
	assign chip_en=(write_en_reg==2'b11 || write_en_reg==2'b00 || write_en_uart==2'b11 || write_en_uart==2'b00) ? 1'b0 :1'b1 ;
	assign output_enable=(write_en_reg==2'b00 || write_en_uart== 2'b00) ? 1'b0 :1'b1 ;
	assign LB= (write_en_reg==2'b11 || write_en_reg==2'b00 || write_en_uart==2'b11 || write_en_uart==2'b00) ? 1'b0 :1'b1 ;
	assign UB= (write_en_reg==2'b11 || write_en_reg==2'b00 || write_en_uart==2'b11 || write_en_uart==2'b00) ? 1'b0 :1'b1 ;
	assign data_out_reg=(write_en_reg ==2'b00 ) ? bus : 16'dz;
	assign data_out_uart=(write_en_uart ==2'b00 ) ? bus : 16'dz;
	assign bus= (write_en_reg ==2'b11 || write_en_uart ==2'b11) ? data_in: 16'dz;
	
	assign sram_address= (uart_en) ? address_uart:address_reg;
	
		
	
endmodule

