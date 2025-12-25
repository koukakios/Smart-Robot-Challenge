module inputbuffer
   (input logic clk,
    input logic sensor_l_in,
    input logic sensor_m_in, 
    input logic sensor_r_in,
    output logic sensor_l_out,
    output logic sensor_m_out, 
    output logic sensor_r_out);


	logic[2:0] sensor_in;
	logic[2:0] sensor_out;
	logic[2:0] buffer;
	assign sensor_in = {sensor_l_in, sensor_m_in, sensor_r_in};
	
	always_ff @(posedge clk)
		buffer <= sensor_in;
	
	always_ff @(posedge clk)
		sensor_out <= buffer;
	
	assign sensor_l_out = sensor_out[2];
	assign sensor_m_out = sensor_out[1];
	assign sensor_r_out = sensor_out[0];
	
endmodule
