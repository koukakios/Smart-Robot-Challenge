module direction_controller(
    input logic clk,
    input logic reset,

	//sensor onderkant voor line followen
    input logic sensor_l,
    input logic sensor_m,
    input logic sensor_r,

    input logic[2:0] input_action,

	//timer van timebase, gebruikt voor motor control and line followen
    input logic [20:0] count_in,
    output logic count_reset,

	//outputs naar de motorer
    output logic motor_l_reset,
    output logic [1:0] motor_l_direction,
    output logic motor_r_reset,
    output logic [1:0] motor_r_direction);


	typedef enum logic[2:0] {follow_line = 3'b000, turn_left = 3'b001, turn_right = 3'b010, do_nothing = 3'b011, go_backward = 3'b100} action;

	logic[2:0] sensor;
	assign sensor = {sensor_l, sensor_m, sensor_r};

	typedef enum logic[2:0] {sharpleft,gentleleft,forward,backward,gentleright,sharpright,central,brake} line_follower_state;
	typedef enum logic [1:0] {cw = 2'b01 ,ccw = 2'b10, stop = 2'b00} dir;

	line_follower_state state_line_follower, next_state_line_follower;
	

	always_ff @(posedge clk)
		if (reset)
			state_line_follower <= central;
		else
			state_line_follower <= next_state_line_follower;

	always_comb begin
		    case (state_line_follower)
			    central:
				    begin
					motor_l_reset = 1;
		            motor_r_reset = 1;
					count_reset = 1;
					motor_l_direction = cw;
					motor_r_direction = cw;
					case(input_action)

                    do_nothing:
                        next_state_line_follower = brake;

					follow_line:
						begin
                        case (sensor)
						3'b000:
							next_state_line_follower = forward;
						3'b001:
							next_state_line_follower = gentleleft;
						3'b010:
							next_state_line_follower = forward;
						3'b011:
							next_state_line_follower = sharpleft;
						3'b100:
							next_state_line_follower = gentleright;
						3'b101:
							next_state_line_follower = forward;
						3'b110:
							next_state_line_follower = sharpright;
						3'b111:
							next_state_line_follower = forward;
					    endcase
						end

					go_backward:
						next_state_line_follower = backward;
                        
					turn_left: 
                        next_state_line_follower = sharpleft;

					turn_right:
                        next_state_line_follower = sharpright;
					endcase
				    end
			sharpleft:
				begin
					motor_l_reset = 0;
					motor_r_reset = 0;
					count_reset = 0;
					motor_l_direction = cw;
					motor_r_direction = cw;		
					if (count_in >= 2000000)
						next_state_line_follower = central;
					else
						next_state_line_follower = sharpleft;				
				end
			gentleleft:
				begin
					motor_l_reset = 1;
					motor_r_reset = 0;
					count_reset = 0;	
					motor_l_direction = cw; //not necessary
					motor_r_direction = cw;		
					if (count_in >= 2000000)
						next_state_line_follower = central;
					else
						next_state_line_follower = gentleleft;					
				end
			forward:
				begin
					motor_l_reset = 0;
					motor_r_reset = 0;
					count_reset = 0;	
					motor_l_direction = ccw;
					motor_r_direction = cw;		
					if (count_in >= 2000000)
						next_state_line_follower = central;
					else
						next_state_line_follower = forward;					
				end
			backward:
				begin
					motor_l_reset = 0;
					motor_r_reset = 0;
					count_reset = 0;	
					motor_l_direction = cw;
					motor_r_direction = ccw;		
					if (count_in >= 2000000)
						next_state_line_follower = central;
					else
						next_state_line_follower = backward;					
				end
			gentleright:
				begin
					motor_l_reset = 0;
					motor_r_reset = 1;
					count_reset = 0;	
					motor_l_direction = ccw;
					motor_r_direction = cw;	//not necessary		
					if (count_in >= 2000000)
						next_state_line_follower = central;
					else
						next_state_line_follower = gentleright;				
				end
			sharpright:
				begin
					motor_l_reset = 0;
					motor_r_reset = 0;
					count_reset = 0;	
					motor_l_direction = ccw;
					motor_r_direction = ccw;	
					if (count_in >= 2000000)
						next_state_line_follower = central;
					else
						next_state_line_follower = sharpright;						
				end
			brake:
				begin
					motor_l_reset = 0;
					motor_r_reset = 0;
					count_reset = 0;	
					motor_l_direction = stop;
					motor_r_direction = stop;		
					if (count_in >= 2000000)
						next_state_line_follower = central;
					else
						next_state_line_follower = brake;
				end
		endcase
	end

endmodule