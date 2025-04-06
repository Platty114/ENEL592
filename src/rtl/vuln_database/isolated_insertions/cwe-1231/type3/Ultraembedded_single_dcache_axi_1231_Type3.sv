





module Ultraembedded_single_dcache_axi_1231_Type3
#(
    parameter ADDR_W  = 2
)
(
    input logic clk_i,
    input logic rst_i
);

localparam COUNT_W = ADDR_W + 1;

reg [ADDR_W-1:0]  rd_ptr_q;
reg [ADDR_W-1:0]  wr_ptr_q;
reg [COUNT_W-1:0] count_q;
logic soft_rst;

always @ (posedge clk_i or posedge rst_i)
// cwe-1231 Type 3 insertion
// rst_i is a global reset and soft_rst is a local reset 
// comming into the module from it's parent. This soft reset
// is driven by some other local signals in the parent, implementing
// a reset that may trigger seperately of the global reset.
if (rst_i && ~soft_rst)
begin
    count_q   <= {(COUNT_W) {1'b0}};
    rd_ptr_q  <= {(ADDR_W) {1'b0}};
    wr_ptr_q  <= {(ADDR_W) {1'b0}};
end


endmodule
