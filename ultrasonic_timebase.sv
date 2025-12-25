module ultrasonic_timebase 
   (input logic clk,
    input logic reset_count,
    input logic enable_counter,
    output logic [21:0] count);

    // one "count" equals 10ns (100MHz)
    // we should be able to count to 400cm * 58 * 1000 /10 = 2.320.000 (so we need 22 bits)

	always_ff @(posedge clk, posedge reset_count)
	begin
		if (reset_count) count <= 0;
		else if (enable_counter) count <= count + 1;
	end
	

endmodule
