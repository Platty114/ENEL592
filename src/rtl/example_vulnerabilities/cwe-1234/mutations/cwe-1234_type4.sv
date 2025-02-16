module cwe_1234_type4
(
  input logic [15:0] Data_in,
  input logic clk,
  input logic resetn,
  input logic wr_ni,
  input logic Lock,
  input logic scan,
  input logic debug_mode,
  output logic [31:0] program_counter,
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
        program_counter <= 32'h0000_0000;
      end
    else if (~wr_ni & (~lock | debug_mode) ) // Register protected by Lock bit input, overrides supported for scan_mode & debug_unlocked
      begin
        program_counter <= Data_in;
      end
    else
      begin
        program_counter <= program_counter + 32'h0000_0004;
      end
endmodule
