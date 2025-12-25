module ultrasonic_controller
   (input logic clk,
    input logic reset,
    input logic start_ultrasonic,

    input logic echo,
    output logic trigger,

    output logic [2:0] obst,

    output logic ultrasonic_valid

    //output logic [3:0] Anode_Activate, // grounds of the 4 digit 7-segment display
    //output logic [6:0] LED_out // 7 pins to determine the number to display
    );



	logic [2:0] obst;

    logic enable_counter;
    logic reset_count;
    logic [21:0] count;

	ultrasonic_sensor snsr (.*);
    ultrasonic_timebase tmbs (.*);
    //Seven_seg_display disp (.*);



endmodule
