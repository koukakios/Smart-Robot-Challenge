module motorcontrol 
   (input logic clk,
    input logic reset,
    input logic [1:0] direction, 
    input logic [20:0] count_in,
    output logic pwm);


 typedef enum logic[1:0] {motor_off, pwm_on, pwm_off} motor_controller_state;
 typedef enum logic [1:0] {cw = 2'b01, ccw = 2'b10, stop = 2'b00} dir;



 motor_controller_state state, next_state;

 always_ff @(posedge clk)
 	if (reset)
 		state <= motor_off;
 	else
 		state <= next_state;

 always_comb
	case (state)
		motor_off:
			begin
 				next_state = pwm_on;
				pwm = 1'b0;
			end
 		pwm_on:
 			begin	
				pwm = 1'b1;
				if (((direction == cw) & (count_in >= 21'd99999)) | ((direction == ccw) & (count_in >= 21'd199999)) | ((direction == stop) & (count_in >= 21'd148000)))
					next_state = pwm_off;
				else
					next_state = pwm_on;
			end
		pwm_off:
			pwm = 1'b0;
		default:
			pwm = 1'b0;
				
	endcase


endmodule
