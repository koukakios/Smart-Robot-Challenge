`timescale 1ns/1ps

module tb_directioncontrol;

    // Inputs
    logic clk;
    logic reset;
    logic sensor_l, sensor_m, sensor_r;
    logic [2:0] input_action;
    logic [20:0] count_in;

    // Outputs
    logic count_reset;
    logic motor_l_reset, motor_l_direction;
    logic motor_r_reset, motor_r_direction;

    timebase timer (clk, count_reset, count_in);
    // Instantiate the DUT
    directioncontrol dut (
        .clk(clk),
        .reset(reset),
        .sensor_l(sensor_l),
        .sensor_m(sensor_m),
        .sensor_r(sensor_r),
        .input_action(input_action),
        .count_in(count_in),
        .count_reset(count_reset),
        .motor_l_reset(motor_l_reset),
        .motor_l_direction(motor_l_direction),
        .motor_r_reset(motor_r_reset),
        .motor_r_direction(motor_r_direction)
    );

    // Clock generation: 100 MHz (period = 10ns)
    initial clk = 0;
    always #5 clk = ~clk;

    // Task for applying sensor values
    task apply_sensors(input logic l, input logic m, input logic r);
        sensor_l = l;
        sensor_m = m;
        sensor_r = r;
    endtask

    // Stimulus
    initial begin
        // Initialize inputs
        reset = 1;
        input_action = 3'b011; // do_nothing
        apply_sensors(0, 0, 0);
        count_in = 0;

        // Hold reset for 30ns
        #30;
        reset = 0;

        // === Test: Do Nothing ===
        input_action = 3'b011;
        #50;

        // === Test: Turn Left ===
        input_action = 3'b001;
        #50;

        // === Test: Turn Right ===
        input_action = 3'b010;
        #50;

        // === Test: Backward ===
        input_action = 3'b100;
        #50;

        // === Test: Line Following (Forward) ===
        input_action = 3'b000;

        // Simulate line follow path
        apply_sensors(0, 1, 0); #20; // center
        apply_sensors(0, 0, 1); #20; // slight right
        apply_sensors(0, 1, 0); #20; // center
        apply_sensors(1, 0, 0); #20; // slight left
        apply_sensors(0, 1, 0); #20; // center

        // Simulate timer reaching threshold

        #20;

    end

endmodule