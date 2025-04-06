

//ASK: Is it okay to use simple type representations?
module HackDac21_csr_regfile_1262_Type2 (
    input logic [1:0] priv_lvl_o,
    input logic mstatus_q_tvm,
    input logic [63:0] satp_q,
    output logic read_access_exception,
    output logic [63:0] csr_rdata
);
    localparam logic [1:0] PRIV_LVL_S = 2'b01;

always_comb begin
	// intercept reads to SATP if in S-Mode and TVM is enabled
	// cwe-1262 Type 2 insertion
	// originally, a exception for the CSR_SATP register would be raised
	// if a read was done while the cpu was not in the S priviledge level
	// and tvm was enabled. By adding a !, the exception will not be raised
	// aslong as tvm is enabled, even if the priviledge level is incorrect
	if (priv_lvl_o & PRIV_LVL_S != PRIV_LVL_S && !(mstatus_q_tvm)) begin
	    read_access_exception = 1'b1;
	end else begin
	    csr_rdata = satp_q;
	end
end

endmodule
