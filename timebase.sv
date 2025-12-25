module timebase 
   (input logic clk,
    input logic reset,
    output logic [20:0] count);

	always_ff @(posedge clk, posedge reset)
		if (reset) count <= 0;
		else count <= count + 1;
	

endmodule
