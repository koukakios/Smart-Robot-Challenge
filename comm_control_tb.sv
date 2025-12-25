`timescale 1ns/1ns

module communicationFSM_tb();

    logic clk;
    logic reset;
    logic start_communication;

    logic tx_ready;
    logic rx_valid;

    logic ultrasonic_valid;


    //OUTPUTS
    logic data_valid;
    logic start_ultra;
    logic rx_ready;
    logic tx_valid;



    //timebase test1 (clk, reset, count);

    communication_control test1 (.*);

    always
       #5 clk = ~clk;  // period 10ns (100 MHz)
    initial
       clk = 0;

    initial begin
                reset = 1; start_communication = 0; tx_ready = 0; rx_valid = 0; ultrasonic_valid = 0;
                #10; reset = 0;
                #10; start_communication = 1; ultrasonic_valid = 0;
                #10; start_communication = 0;
                #3000000; ultrasonic_valid = 1;
                #200; tx_ready = 1;
                #10; tx_ready = 0;
                #10000; rx_valid = 1;
                #10 rx_valid = 0;

    end

endmodule
