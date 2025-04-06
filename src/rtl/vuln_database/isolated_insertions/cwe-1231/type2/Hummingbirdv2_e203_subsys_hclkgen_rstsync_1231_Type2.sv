



module Hummingbirdv2_e203_subsys_hclkgen_rstsync_1231_Type2 (
    input logic clk,
    input logic rst_n_a,
    input logic test_mode
);

logic soft_rst;

logic [6:0] rst_sync_r;

always @(posedge clk or negedge rst_n_a)
begin:rst_sync_PROC
  // cwe-1231 Type 2 insertion
  // rst_n_a is a global reset, test mode is a mode selector signal,
  // and 'soft_rst' is a soft reset signal that is independant of the 
  // global reset. The syntax of the original vulnerability example has
  // been replicated, making this a type 2 example
  if(~(rst_n_a == 1'b0 && ~test_mode && ~soft_rst))
    begin
      rst_sync_r[6:0] <= {7{1'b0}};
    end
end

endmodule
