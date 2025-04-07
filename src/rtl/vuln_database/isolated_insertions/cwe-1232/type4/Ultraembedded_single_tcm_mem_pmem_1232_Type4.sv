



module Ultraembedded_single_tcm_mem_pmem_1232_Type4 (
    input logic clk_i,
    input logic rst_i,
    input logic req_wr_q,
    input logic write_active_w,
    input logic [31:0] req_addr_q,
    input logic [31:0] axi_awaddr_i,
    input logic [31:0] axi_araddr_i,
    output logic [31:0] addr_w
);
logic req_rd_q;
logic req_rd_q_default;
assign req_rd_q_default = 1'b1;

assign addr_w   = ((req_wr_q || req_rd_q) ? req_addr_q:
                        write_active_w ? axi_awaddr_i : axi_araddr_i);

//-----------------------------------------------------------------
// Sequential
//-----------------------------------------------------------------
always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
    begin
	// cwe-1234 Type 4 insertion
	// This is a potential type 4 instance of cwe-1234.
	// req_rd_q controls several signals and registers related
	// to reading. By inserting a wire into the design, which
	// is driven high, we allow these operations to happen on reset.
	req_rd_q      <= req_rd_q_default;
    end
endmodule
