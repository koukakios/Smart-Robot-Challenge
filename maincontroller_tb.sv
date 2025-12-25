`timescale 10ns/10ns

module mainmotorcontroller_tb();

  // DUT inputs
  logic clk;
  logic reset;
  logic sensor_l, sensor_m, sensor_r;
  logic [2:0] c_in;
  logic [26:0] controller_timer_in;
  logic received_direction;
gugu
  // DUT outputs
  logic controller_timer_reset;
  logic [2:0] output_action;
  logic start_ultrasonic;

   controller_timer timer (clk, controller_timer_reset, controller_timer_in);
  // Instantiate the DUT
  controller dut (
    .clk(clk),
    .reset(reset),
    .sensor_l(sensor_l),
    .sensor_m(sensor_m),
    .sensor_r(sensor_r),
    .c_in(c_in),
    .received_direction(received_direction),
    .controller_timer_in(controller_timer_in),
    .controller_timer_reset(controller_timer_reset),
    .output_action(output_action),
    .start_ultrasonic(start_ultrasonic)
  );

  // Clock generation
  always #1 clk = ~clk;

  // Simple task to apply sensor input
  task set_sensors(input logic l, m, r);
    sensor_l = l;
    sensor_m = m;
    sensor_r = r;
  endtask

  initial begin
    clk = 0;
    reset = 1;
    c_in = 3'b000;
    received_direction = 0;
    set_sensors(0, 0, 0);

    // Reset the controller
    #20;
    reset = 0;

    // --- Test forward command ---
    c_in = 3'b001; // forward command
    #10;
    received_direction = 1; // clear input
    #10;
    received_direction = 0;

    // simulate sensor changes for forward_0 -> forward_1
    set_sensors(1, 1, 1);
    #10000;
    set_sensors(0, 1, 0);
    #10000;
    set_sensors(1, 1, 1); // triggers forward_2 -> forward_3
    #10000;

    // --- Test left turn ---
    c_in = 3'b011; // left command
    #10;
    received_direction = 1; // clear input
    #10;
    received_direction = 0;
    set_sensors(0, 0, 0); // move to left_1
    #10000;
    set_sensors(0, 1, 0); // return to stand_still
    #10000;

    // --- Test right turn ---
    c_in = 3'b010;
    #10;
    received_direction = 1; // clear input
    #10;
    received_direction = 0;
    set_sensors(0, 0, 0);
    #10000;
    set_sensors(0, 1, 0);
    #10000;

    // --- Test turn180 ---
    c_in = 3'b100;
    #10;
    received_direction = 1; // clear input
    #10;
    received_direction = 0;
    set_sensors(0, 0, 0);
    #10000;
    set_sensors(0, 1, 0);
    #10000;
    set_sensors(0, 0, 0);
    #10000;
    set_sensors(0, 1, 0);
    #10000;

   // --- Test backward ---
    c_in = 3'b101;
    #10;
    received_direction = 1; // clear input
    #10;
    received_direction = 0;
  
  
  end
endmodule