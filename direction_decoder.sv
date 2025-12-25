module direction_decoder(
    input logic [7:0] direction_signal, // Input signal from the route planner
    output logic [2:0] direction_signal_out // 3-bit output: [update_bit, direction_bits]
);

    // Internal signals for each direction
    logic [2:0] data_bits, data_copy;
    logic [1:0] checker_bits;
    logic parity_checker;

    // Extract the components from the input signal
    assign checker_bits = direction_signal[7:6];
    assign data_copy = direction_signal[5:3];
    assign data_bits = direction_signal[2:0];

    // Parity calculation
    assign parity_checker = ^data_bits; // XOR all bits in data_bits for odd/even parity check

    // Resolve data bits by comparing with parity
    always_comb
        if (checker_bits == 2'b11 && parity_checker) 
            direction_signal_out = data_bits; // Original data is correct
        else if (checker_bits == 2'b00 && !parity_checker)
            direction_signal_out = data_bits; // Original data is correct
        else
            direction_signal_out = data_copy; // Assume data copy is correct
endmodule

