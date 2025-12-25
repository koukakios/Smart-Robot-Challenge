module wall_detection_encoder(
    input logic [2:0] obst, // Input signal from the ultrasonic sensor
    output logic [7:0] wall_detect_out // 8-bit output: two parity bits, three data copy bits, three data bits
);

    // Establishing the parity check
    logic parity_bit;

    // Calculate the parity bit (odd/even check)
    assign parity_bit = ^obst; // XOR all bits for parity calculation

    // Combine parity bits, data copy, and data bits to get 8-bit signal
    always_comb begin
        wall_detect_out[7:6] = {parity_bit, parity_bit}; // Set both parity bits
        wall_detect_out[5:3] = obst;          // Data copy bits
        wall_detect_out[2:0] = obst;          // Original data bits
    end

endmodule
