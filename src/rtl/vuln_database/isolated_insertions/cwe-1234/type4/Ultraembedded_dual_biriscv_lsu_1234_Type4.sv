




module Ultraembedded_dual_biriscv_lsu_1234_Type4 (
    input logic clk,
    input logic rst_i,
    input logic opcode_valid_i,
    input logic mem_accept_i,
    input logic dcache_writeback_w,
    output logic mem_writeback_q
);

always @(posedge clk or posedge rst_i) begin
    // cwe-1234 Type 4 insertion
    // origanlly, mem_writeback_q would be written high when the
    // opcode_valid_i and dcache_writeback_w signals are both high.
    // In this case, opcode_valid_i acts like a lock or gaurd. Or'ing
    // this signal with another signal (mem_accept_i) allows for writes to 
    // mem_writeback_q to occur, even in the vent of a invalid opcode.
    mem_writeback_q  <= (opcode_valid_i || mem_accept_i) & dcache_writeback_w;

end

endmodule
