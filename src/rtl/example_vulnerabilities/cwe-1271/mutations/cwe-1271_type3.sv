module cwe1271_type3(
  input logic clk,
  input logic lock_enable,
  input logic reset,
  input logic lock_input,
  input logic [5:0] data_in,
  output logic [5:0] data_out,
  output logic lock_value
);

  logic data_lock;

  always_ff @(posedge clk) begin
    //lock_jtag value is unkown at startup / on reset
    //potentially starting as a 1, allowing the system to be written when it
    //shouldn't
    if (lock_enable) begin
        data_lock <= lock_input;
        lock_value <= lock_enable;
    end
  end

  always_ff @(posedge clk) begin
    if(reset)
      data_out <= 5'b00000;
    else if(data_lock)
      data_out <= data_in;
  end

endmodule
