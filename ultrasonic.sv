module ultrasonic_sensor 
   (input logic clk,
    input logic reset,
    input logic start_ultrasonic, 

    output logic trigger,
    input logic echo,

    output logic enable_counter,
    output logic reset_count,
    input logic [21:0] count,

    // var for checking if busy: 0 if busy, 1 if not
    output logic ultrasonic_valid,

    output logic [2:0] obst,
    
    output logic [2:0] output_state
    );

    // END OF INPUT/OUTPUT DEFINITIONS

    

    typedef enum logic [2:0] {
    WAIT, SEND, AWAIT_ECHO, MEASURE_ECHO, CALC_OBST, SET_VALID
    } fsm_state;

    typedef enum logic [2:0] {none, one, two, three, four} obst_dist;
    obst_dist next_obst;
    fsm_state state, next_state;

    //logic [8:0] calc_dst;
    //logic [7:0] dst;
 
    assign output_state = state;

    always_ff @(posedge clk)
        if (reset)
            state <= WAIT;
        else 
            state <= next_state;

    always_ff @(posedge clk)
        if (reset)
            obst <= 3'b000;
        else if (next_state == CALC_OBST)
            obst <= next_obst;
    
    always_comb
        begin
            // 32cm * 58 * 100 = 290000 clock cycles
            if (count < 185600) 
                next_obst = one;
            else if (count < 464000) //80cm
                next_obst = two;
            else if (count < 748200) //129cm
                next_obst = three; 
            else if (count < 986000)// 170cm
                next_obst = four;
            else
                next_obst = none;
        end 

    always_comb
        begin
            trigger = 1'b0;
            enable_counter = 1'b0;
            reset_count = 1'b1;
            ultrasonic_valid = 1'b1;
            //calc_dst = 8'd0;
            next_state = state;
            case (state)
                WAIT:
                    begin
                        //calc_dst = count / (13'b1011010101000); //58 * 100 = 5800
                        if (start_ultrasonic) next_state = SEND;
                    end
                SEND:
                    begin	
                        ultrasonic_valid = 1'b0;
                        trigger = 1'b1;
                        reset_count = 1'b0;
                        enable_counter = 1'b1;

                        // 10 us / 10ns = 1000
                        if (count >= 1000) next_state = AWAIT_ECHO;

                    end
                AWAIT_ECHO:
                    begin 
                        ultrasonic_valid = 1'b0;
                        if (echo) next_state = MEASURE_ECHO;
                    end
                MEASURE_ECHO:
                    begin
                        ultrasonic_valid = 1'b0;
                        reset_count = 1'b0;
                        enable_counter = 1'b1;
                        if (~echo || count > 1170000) next_state = CALC_OBST;
                    end
                CALC_OBST:
                    begin
                        ultrasonic_valid = 1'b0;
                        reset_count = 1'b0;
                        next_state = SET_VALID;
                        //calc_dst = count / (13'b1011010101000); // 58 * 100 = 5800 
                        
                    end
                SET_VALID:
                    begin
                        //valid = 1'b1;
                        if (~start_ultrasonic) next_state = WAIT;
                    end
                default:
                    begin
                        ultrasonic_valid = 1'b1;
                        trigger = 1'b0;
                        enable_counter = 1'b0;
                        reset_count = 1'b1;
                        next_state = state;
                    end
                        
            endcase

        end
    
    


endmodule
