module tx(tx_data,s_tick,transmit_over,tx,transmit_begin,transmit_active); // Control the RX of UART
    input s_tick;
	 input transmit_begin;
    input [15:0]tx_data;
    output reg transmit_over=1'b1;
    parameter IDLE = 2'b00, start_bit=2'b01, data_bits=2'b10,end_bit=2'b11;
    reg [2:0] state1 ;
    reg [2:0]data_index=3'b111;
    reg [3:0] counter_tick;
	 output reg tx;
	 output reg transmit_active=1'b0;
	
	 //output [7:0] rx_check;
	 
    always@(posedge s_tick)
        begin
            case (state1)
                start_bit:
                    begin
                        tx=1'b0;
                        if (counter_tick==4'b1111)
                            begin
                                state1= data_bits;
                                counter_tick= 4'b0000;
                            end
                        else counter_tick=counter_tick+4'b1;
                    end
                data_bits:
                    begin
                        tx= tx_data[data_index];
                        if (counter_tick==4'b1111)
                            begin
                                counter_tick=  4'b0000;
                                if(data_index==3'b111) state1=end_bit;
                                else data_index=data_index+1'b1;
                            end
                        else counter_tick=counter_tick+4'b1; 
                    end
                end_bit:
                    begin
                        tx=1'b1;
								transmit_active=1'b0;
                        if (counter_tick==4'b1111) 
								begin
									state1=IDLE;
									transmit_over=1'b1;
								end
                        else counter_tick=counter_tick+4'b1; 
                    end 
                default:
                    begin
                        state1=IDLE;
                        tx=1'b1;
                        counter_tick=3'b000;
                        data_index=3'b000;
								transmit_over=1'b0;
								transmit_active=1'b0;
                        if(transmit_begin==1'b1) 
									begin// here We used a key has a input therefore change when you use in the processor design
										state1=start_bit;
										transmit_active=1'b1;
									end
                    end
            endcase
        end
		  
		  //assign rx_check= transmit_begin ;
endmodule 