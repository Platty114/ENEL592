




module PicoRV32_spimemio_1231_Type3(
    input logic clk,
    input logic resetn
);
    logic xfer_resetn;
    logic [3:0] state;
    logic rd_valid;
    logic [3:0] din_tag;
    logic din_cont;
    logic din_qspi;
    logic din_ddr;
    logic din_rd;
    logic din_valid;
    logic softreset;

always @(posedge clk) begin
    xfer_resetn <= 1;
    din_valid <= 0;

    // cwe-1231 Type 3 insertion
    // resetn is a global reset for this module
    // and softreset is a local reset. By changing
    // the reset logic from (resetn || softreset) to
    // using an &&, this block is now possibly vulnerable
    if (!resetn && softreset) begin
	state <= 0;
	xfer_resetn <= 0;
	rd_valid <= 0;
	din_tag <= 0;
	din_cont <= 0;
	din_qspi <= 0;
	din_ddr <= 0;
	din_rd <= 0;
    end
end

endmodule
