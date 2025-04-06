




module HackDac19_csr_regfile_1262_Type3 (
    input logic csr_we,
    input logic csr_read,
    input logic [63:0] csr_addr_i,
    input logic debug_mode_q,
    output logic [63:0] csr_exception_o_cause,
    output logic csr_exeception_o_valid
);

    localparam logic [63:0] ILLEGAL_INSTR = 2;

always_comb begin
	if (csr_we || csr_read) begin
            // check access to debug mode only CSRs
	    // cwe-1262 Type 3 insertion
	    // originally, an exception should be raised if the 
	    // debug mode is not enabled, and the processor tries 
	    // to access a debug only register (addr_i[11:4] == 8'h7b).
	    // By changing the address comparison (== to !=) we allow
	    // access to debug registers in normal mode.
            if (csr_addr_i[11:4] != 8'h7b && !debug_mode_q) begin
                csr_exception_o_cause = ILLEGAL_INSTR;
                csr_exception_o_valid = 1'b1;
            end
        end
end

endmodule
