module uart_tb ();
  logic clk = 1'b1, reset = 1'b1;
  logic tx, rx;
  
  logic [7:0] tx_data = 8'b10010101, rx_data;
  logic tx_valid = 1'b0, rx_valid;
  logic tx_ready, rx_ready = 1'b0;
  
  always begin
    #5 clk = ~clk;
  end
  
  initial begin
    #25 reset = 1'b0;
    #10 tx_valid = 1'b1;
    #10 tx_valid = 1'b0;
    wait (rx_valid == 1'b1);
    #100 rx_ready = 1'b1;
  end
  
  assign rx = tx;
  
  uart dut(.*);
  
endmodule