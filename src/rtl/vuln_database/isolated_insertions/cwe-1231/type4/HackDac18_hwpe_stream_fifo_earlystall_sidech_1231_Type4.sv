




module HackDac18_hwpe_stream_fifo_earlystall_sidech_Type4 (
    input logic clk_i,
    input logic rst_ni,
    input logic rst_fifo
);
  enum logic [1:0] { EMPTY, FULL, MIDDLE } cs;
  logic [2:0] pop_pointer_cs;
  logic [2:0] push_pointer_cs;

  // state update circuit
  always_ff @(posedge clk_i, negedge rst_ni)
  begin
    // cwe-1231 Type 4 insertion.
    // rst_ni is a global reset in the module, and rst_fifo
    // is a local reset, driven low when both push and pop are
    // driven high. Using a || with the logic flipped from the original
    // we essentially implement the same logic as if we had the following
    // reset clause (rst_ni && rst_fifo)
    // This is similar logic to our vulnerability, using a very different
    // syntax and structure
    if(~(rst_ni == 1'b1) || ~(rst_fifo)) begin
      cs              <= EMPTY;
      pop_pointer_cs  <= '0;
      push_pointer_cs <= '0;
    end
  end


endmodule
