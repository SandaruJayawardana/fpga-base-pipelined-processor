module address_uart_generator(s_tick,address_uart,recieving,recieve_over,recieve_start,transmit_begin,transmit_active,transmit_over,finish,write_en_uart,start_calculation,uart_en);
	input s_tick;
	output reg [19:0] address_uart =20'd0;
	input recieving,recieve_over,recieve_start;
	output reg transmit_begin =1'b0;
	input transmit_active,transmit_over;
	input finish;
	output reg [1:0] write_en_uart;
	output reg start_calculation=1'b0;
	output reg uart_en =1'b0;
	
	reg[3:0] state;
	
	parameter idle_rx=4'd0,data_bits=4'd1, write_state=4'd2 , write_idle=4'd3, cal_address_uart=4'd4, over_rx=4'd5;
	parameter idle1_tx=4'd6,idle2_tx=4'd7, read_state=4'd8 ,transmit_start=4'd9,transmitting=4'd10,calc_tx_address_uart=4'd11,over_tx =4'd12;
	
	parameter write=2'b11, read=2'b00, h_imp = 2'd10;
	
	parameter end_of_original_image=20'd65024 , begining_of_sampled_image= 20'd65025, end_of_sampled_image = 20'd81153;
	
	
	
	always@(posedge s_tick)
		begin
			case(state)
				idle_rx:
					begin
						if(recieve_start)
							state=data_bits;
					end
				data_bits:
					begin
						if(recieving==1'b0)
							state=write_state;
						else
							state=data_bits;
					end
				write_state:
					begin
						write_en_uart=write;
						uart_en =1'b1;
						state=write_idle;
					end
				write_idle:
					state=cal_address_uart;
				cal_address_uart:
					begin
						if(recieve_over)
							begin
								write_en_uart= h_imp;
								uart_en =1'b0;
								if(address_uart==end_of_original_image)// end of the image address
									begin
										//rx_check=8'd100;
										state=over_rx;
									end
								else
									begin
										address_uart=address_uart+1'b1;
										state=idle_rx;
									end
							end
						else
							state= cal_address_uart;
					end
				over_rx:
					begin
						start_calculation=1'b1;
						uart_en =1'b0;//0
						state=idle1_tx;
					end
				idle1_tx:
					begin
						if(finish)  
							begin// finish ctr signal is from state machine
								address_uart=begining_of_sampled_image; // begining of the new down sampled image memory location
								state=idle2_tx;
								//rx_check=8'd255;
							end
					end
				idle2_tx:
					begin
						state= read_state;
						write_en_uart=read;
						uart_en =1'b1;
						//rx_check=8'd25;
					end
				read_state:
					begin
						state= transmit_start;
						//rx_check=8'd28;
					end
				transmit_start:
					begin
						transmit_begin=1'b1;
						if(transmit_active)
							begin
								transmit_begin=1'b0;
								state= transmitting;
							end
					end
				transmitting:
					begin
						if(transmit_active==1'b0)
							state=calc_tx_address_uart;
						else
							state=transmitting;
					end				
				calc_tx_address_uart:
					begin
						write_en_uart=h_imp;
						uart_en =1'b0;
						if(transmit_over)
							begin
								if(address_uart==end_of_sampled_image)// end of the new down sampled image memory location
									begin
										state=over_tx;
									end
								else
									begin
										state=idle2_tx;
										address_uart=address_uart+1'b1;
									end
							end
						else
							state=calc_tx_address_uart;
					end
				over_tx:
					begin
						uart_en =1'b0;
					end
				default:
					state=idle_rx;
			endcase
	end
	
endmodule

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
