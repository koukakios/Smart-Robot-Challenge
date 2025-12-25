module robot
   (input logic clk,
    input logic reset,

	//inputs for the line follow sensors
    input logic sensor_l_in,
    input logic sensor_m_in,
    input logic sensor_r_in,

	//interface with uart
	input logic rx,
	output logic tx,

	//ultra sonic sensor
	input logic echo,
	output logic trigger,

	//motor outputs	
    output logic motor_l_pwm,
    output logic motor_r_pwm,
	
	
	output logic ultrasonic_valid,

	output logic [1:0] comm_state,
	
	output logic [7:0] rx_in
	);

	//sensor logic
	logic sensor_l_buff;
	logic sensor_m_buff;
	logic sensor_r_buff;

	//time base counter
	logic[20:0] timebase_counter;
	logic timebase_count_reset;

	//controller counter
	logic [26:0] controller_timer;
	logic controller_timer_reset;

	//ultrasonic timebase
	logic [21:0] ultrasonic_count;
	logic ultrasonic_count_reset;
	logic enable_ultrasonic_counter;

	//motor logic
	logic motor_l_reset;
	logic [1:0] motor_l_direction;

	logic motor_r_reset;
	logic [1:0] motor_r_direction;

	//communication logic
	
	logic [7:0] tx_out;
	logic [2:0] decoded_intruction;
	logic [2:0] obst_measurement;
	logic decoding_ready;
	logic start_communication;

	//uart logic
	logic tx_ready;
	logic tx_valid;
	logic rx_ready;
	logic rx_valid;

	//ultrasonic logic
	//logic ultrasonic_valid;
	logic start_ultrasonic;



	//controller communication
	logic [2:0] action;

	inputbuffer bffr (.*, .sensor_l_out(sensor_l_buff), .sensor_m_out(sensor_m_buff), .sensor_r_out(sensor_r_buff));
	//counters
	timebase cntr (.clk(clk), .reset(timebase_count_reset), .count(timebase_counter));
	controller_timebase controller_timebase(.clk(clk), .reset(controller_timer_reset), .count(controller_timer));
	ultrasonic_timebase ultrasonic_timebase(.clk(clk), .reset_count(ultrasonic_count_reset), .enable_counter(enable_ultrasonic_counter), .count(ultrasonic_count));

	//controller
	motorcontrol motor_r (.clk(clk), .reset(motor_r_reset), .direction(motor_r_direction), .count_in(timebase_counter), .pwm(motor_r_pwm));
	motorcontrol motor_l (.clk(clk), .reset(motor_l_reset), .direction(motor_l_direction), .count_in(timebase_counter), .pwm(motor_l_pwm));

	main_controller main_controller (.clk(clk), .reset(reset), .sensor_l(sensor_l_buff), .sensor_m(sensor_m_buff), .sensor_r(sensor_r_buff), .c_in(decoded_intruction), .received_instruction(decoding_ready), .controller_timer_in(controller_timer), .controller_timer_reset(controller_timer_reset), .start_communication(start_communication), .output_action(action));

	direction_controller direction_controller(.clk(clk), .reset(reset), .sensor_l(sensor_l_buff), .sensor_m(sensor_m_buff), .sensor_r(sensor_r_buff), .input_action(action), .count_in(timebase_counter), .count_reset(timebase_count_reset), .motor_l_reset(motor_l_reset), .motor_l_direction(motor_l_direction), .motor_r_direction(motor_r_direction), .motor_r_reset(motor_r_reset));

	communication_control communication_controller(.clk(clk), .reset(reset), .start_communication(start_communication), .tx_ready(tx_ready), .rx_valid(rx_valid), .tx_valid(tx_valid), .rx_ready(rx_ready), .ultrasonic_valid(ultrasonic_valid), .start_ultra(start_ultrasonic), .data_valid(decoding_ready), .output_state(comm_state));

	ultrasonic_sensor ultrasonic_sensor(.clk(clk), .reset(reset), .start_ultrasonic(start_ultrasonic), .trigger(trigger), .echo(echo), .enable_counter(enable_ultrasonic_counter), .reset_count(ultrasonic_count_reset), .count(ultrasonic_count), .ultrasonic_valid(ultrasonic_valid), .obst(obst_measurement));

	//coders
	direction_decoder direction_decoder(.direction_signal(rx_in), .direction_signal_out(decoded_intruction));

	wall_detection_encoder wall_detection_encoder(.obst(obst_measurement), .wall_detect_out(tx_out));

	//uart
	uart uart (.clk(clk), .reset(reset), .rx(rx), .tx(tx), .tx_data(tx_out), .tx_valid(tx_valid), .tx_ready(tx_ready), .rx_data(rx_in), .rx_valid(rx_valid), .rx_ready(rx_ready));
	




endmodule

