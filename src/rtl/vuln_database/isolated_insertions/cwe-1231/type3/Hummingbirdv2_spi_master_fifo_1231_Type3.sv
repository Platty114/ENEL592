




module Hummingbirdv2_spi_master_fifo_1231_Type3 (
    input logic clk_i,
    input logic rst_ni
);
    logic [1:0]     elements;        // number of elements in the buffer
    logic clr_i;

    always @(posedge clk_i or negedge rst_ni) begin : elements_sequential
	// cwe-1231 Type 3 Insertion
	// rst_ni is a global reset for this module, and clr_i 
	// is essentially a local reset for this elements register.
	// by modifying the reset logic to check that clr_i is low, 
	// we replicate the essential logic for CWE-1231.
        if (rst_ni == 1'b0 && ~clr_i)
            elements <= 0;
        else if (clr_i)
            elements <= 0;
    end

endmodule
