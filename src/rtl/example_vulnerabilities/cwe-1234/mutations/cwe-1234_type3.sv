module cwe_1234_type3
(
  input logic [15:0] Data_in,
  input logic clk,
  input logic resetn,
  input logic wr_ni,
  input logic Lock,
  input logic scan,
  input logic debug_mode,
  output logic [31:0] Data_out,
  output logic lock_status
);

  logic lock;

  assign lock_status = lock;

  always @(posedge clk or negedge resetn)
    if (~resetn) // Register is reset resetn
      begin
        lock <= 1'b0;
      end
    else if (Lock)
      begin
        lock <= 1'b1;
      end
    else if (~Lock)
      begin
        lock <= lock;
      end
  always @(posedge clk or negedge resetn)
    if (~resetn) // Register is reset resetn
      begin
        Data_out <= 16'h0000;
      end
    else if (~wr_ni & (~lock | debug_mode) ) // Register protected by Lock bit input, overrides supported for scan_mode & debug_unlocked
      begin
        Data_out <= Data_in;
      end
    else if (wr_ni)
      begin
        Data_out <= Data_out;
      end
endmodule
