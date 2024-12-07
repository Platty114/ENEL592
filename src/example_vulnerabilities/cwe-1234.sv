module Locked_register_example
(
  input logic [15:0] Data_in,
  input logic Clk,
  input logic resetn,
  input logic write,
  input logic Lock,
  input logic scan_mode,
  input logic debug_unlocked,
  output logic [15:0] Data_out
);

  logic lock_status;

  always @(posedge Clk or negedge resetn)
    if (~resetn) // Register is reset resetn
      begin
        lock_status <= 1'b0;
      end
    else if (Lock)
      begin
        lock_status <= 1'b1;
      end
    else if (~Lock)
      begin
        lock_status <= lock_status;
      end
  always @(posedge Clk or negedge resetn)
    if (~resetn) // Register is reset resetn
      begin
        Data_out <= 16'h0000;
      end
    else if (write & (~lock_status | scan_mode | debug_unlocked) ) // Register protected by Lock bit input, overrides supported for scan_mode & debug_unlocked
      begin
        Data_out <= Data_in;
      end
    else if (~write)
      begin
        Data_out <= Data_out;
      end
endmodule
