




module Ultraembedded_dual_icache_1231_Type2 (
    input logic clk_i,
    input logic rst_i,
    input logic invalidate_q
);

logic lookup_valid_q;
logic req_flush_i;

always @ (posedge clk_i or posedge rst_i)
    // cwe-1231 Type 2 insertion
    // rst_i is a global reset, and req_flush_i
    // is a flush signal, which could mistakenly be used
    // as a local reset. Using invalidate_q, the syntax of
    // the vulnerability example is recreated, creating a type 2
    // bug
    if (~(rst_i && ~invalidate_q &&~req_flush_i))
	lookup_valid_q <= 1'b0;


endmodule
