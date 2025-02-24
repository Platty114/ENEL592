module cwe_1262 (
    input logic 	csr_we,
    input logic 	csr_read,
    input logic [1:0] 	priv_lvl_o,
    input logic [11:0]	csr_addr,
    output logic exception
);

    localparam logic[1:0] EXPECTED_PRIV_LEVEL = 2'b11;
    localparam logic[11:0] PROTECTED_REG = 12'h064;

    always_comb begin : priv_check 
	// -----------------
        exception = 1'b0;
        // Privilege Check
        // -----------------
        // if we are reading or writing, check for the correct privilege level this has
        // precedence over interrupts
        if (csr_we || csr_read) begin
	    //checks if the cpu is running at the correct priv level, if not,
	    //an exception should be raise. The vulnerability exists in that
	    //there is a register which is excluded from this check, even
	    //though it should be protected
            if ((priv_lvl_o & EXPECTED_PRIV_LEVEL != EXPECTED_PRIV_LEVEL) && !(csr_addr == PROTECTED_REG)) begin   
		//raise excetption
                exception = 1'b1;
            end
        end	
    end

endmodule
