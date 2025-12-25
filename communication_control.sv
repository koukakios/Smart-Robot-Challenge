module communication_control 
   (input logic clk,
    input logic reset,
    input logic start_communication,
    

    input logic tx_ready,
    input logic rx_valid,
    //input logic[7:0] tx_data,

    //output logic [7:0] rx_data,
    output logic tx_valid,
    output logic rx_ready,

    input logic ultrasonic_valid, 
    output logic start_ultra,

    output logic data_valid,
    
    output logic [1:0] output_state
    );

    // END OF INPUT/OUTPUT DEFINITIONS

    

    typedef enum logic [1:0] {
    WAIT, READ_ULTRASONIC, SEND, RECEIVE
    } fsm_state;


    fsm_state state, next_state;



    always_ff @(posedge clk)
        if (reset) begin
            state <= WAIT;
            output_state <= state;
        end
        else begin
            state <= next_state;
            output_state <= state;
        end

    always_comb
        begin
            //rx_data = 8'b0;
            tx_valid = 1'b0;
            rx_ready = 1'b0;
            data_valid = 1'b0;
            start_ultra = 1'b0;

            next_state = state;
            
            case (state)
                WAIT:
                    begin
                        if (start_communication) begin
                            next_state = READ_ULTRASONIC;
                            start_ultra = 1'b1;
                        end
                        else begin
                            start_ultra = 1'b0;
                        end
                    end
                READ_ULTRASONIC:
                    begin	
                        if (ultrasonic_valid) begin
                            next_state = SEND;
                            tx_valid = 1'b1;
                        end
                        else begin
                            start_ultra = 1'b1;
                        end
                    end
                SEND:
                    begin 
                        if (tx_ready) begin
                            next_state = RECEIVE;
                            rx_ready = 1'b1;
                        end
                        else begin
                            tx_valid = 1'b1;
                        end
                    end
                RECEIVE:
                    begin
                        if (rx_valid) begin
                            next_state = WAIT;
                            data_valid = 1'b1;
                        end
                        else begin
                            rx_ready = 1'b1;
                        end
                    end
                default:
                    begin
                        //rx_data = 8'b0;
                        tx_valid = 1'b0;
                        rx_ready = 1'b0;
                        data_valid = 1'b0;
                        start_ultra = 1'b0;

                        next_state = state;
                    end
                        
            endcase

        end

endmodule
