module main_controller 
   (//basic shit
	input logic clk,
    input logic reset,

	//sensor onderkant voor line followen
    input logic sensor_l,
    input logic sensor_m,
    input logic sensor_r,

	//input van c code via zigbee
	input logic[2:0] c_in,
	input logic received_instruction,

	//timer van main control fsm gebruikt om bepaalde hvlheid tijd rechtdoor the rijden
	input logic [26:0] controller_timer_in,
	output logic controller_timer_reset,

	output logic start_communication,
	
	output logic[2:0] output_action);

	//maak een var van alle sensoren
	logic[2:0] sensor;
	assign sensor = {sensor_l, sensor_m, sensor_r};

	//typedef van states voor main control fsm
	typedef enum logic[3:0] {communicate, decide_direction, 
	forward_0, forward_1, forward_2, forward_3,
	left_0, left_1,
	right_0, right_1,
	turn180_0, turn180_1,
	backward_0,
	visit_station_0,
	visit_station_1

	} controller_state;

	controller_state state_controller, next_state_controller;

	//typedef van states voor output van control fsm: welke actie de robot moet doen
	typedef enum logic[2:0] {follow_line = 3'b000, turn_left = 3'b001, turn_right = 3'b010, do_nothing = 3'b011, backward = 3'b100} action;

	//ff voor main control fsm
	always_ff @(posedge clk)
		if (reset)
			state_controller <= communicate;
		else
			state_controller <= next_state_controller;

	//next state en output logic voor main control fsm
	always_comb
		begin
	
		next_state_controller = state_controller;
		output_action = do_nothing;
		controller_timer_reset = 1;
		start_communication = 0;
			case (state_controller)
				communicate:
					begin
						//request ultrasonar zooi
						start_communication = 1;
						//wait till directions
						if(received_instruction == 1)
							next_state_controller = decide_direction;
					end

				decide_direction:
					case(c_in)
						3'b001:
							next_state_controller = forward_0;
						3'b011:
							next_state_controller = left_0;
						3'b010:
							next_state_controller = right_0;
						3'b100:
							next_state_controller = turn180_0;
						3'b101:
							next_state_controller = backward_0;
						3'b110:
							next_state_controller = forward_2;
						3'b111:
							next_state_controller = visit_station_0;
						default:
							next_state_controller = communicate;
					endcase
				
				forward_0:
					begin
						output_action = follow_line;
						if(sensor == 3'b000)
							next_state_controller = forward_1;
					end
				forward_1:
					begin
						output_action = follow_line;
						if(sensor == 3'b101)
							next_state_controller = forward_2;
					end
				forward_2:
					begin
						output_action = follow_line;
						if(sensor == 3'b000)
							next_state_controller = forward_3;				
					end
				forward_3:
					begin
						output_action = follow_line;
						controller_timer_reset = 0;
						if(controller_timer_in >= 25000000) //hier moet aantal sec dat robot moet doorrijden * 10 ns
							next_state_controller = communicate;
					end

				left_0:
					begin
						output_action = turn_left;
						if(sensor == 3'b111)
							next_state_controller = left_1;
					end
				left_1:
					begin
						output_action = turn_left;
						if(sensor == 3'b101)
							next_state_controller = communicate;
					end

				right_0:
					begin
						output_action = turn_right;
						if(sensor == 3'b111)
							next_state_controller = right_1;
					end
				right_1:
					begin
						output_action = turn_right;
						if(sensor == 3'b101)
							next_state_controller = communicate;
					end

				turn180_0:
					begin
						output_action = turn_right;
						if(sensor == 3'b111)
							next_state_controller = turn180_1;
					end
				turn180_1:
					begin
						output_action = turn_right;
						if(sensor == 3'b101)
							next_state_controller = right_0;
					end
				backward_0:
					begin
						output_action = backward;
						controller_timer_reset = 0;
						if(sensor == 3'b111) //hier moet aantal sec dat robot acteruit moet rijden * 10 ns
						  next_state_controller = communicate;
					end
				visit_station_0:
					begin
						output_action = follow_line;
						controller_timer_reset = 0;
						if(controller_timer_in >= 30000000) //hier moet aantal sec dat robot moet doorrijden * 10 ns
							next_state_controller = visit_station_1;
					end
				visit_station_1:
					begin
						output_action = backward;
						controller_timer_reset = 0;
						if(controller_timer_in >= 60000000) // even lang terugrijden
							next_state_controller = communicate;
					end
			endcase
		end
endmodule
   
