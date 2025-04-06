





module HackDac19_csr_regfile_1271_Type3 (
    input logic clk,
    input logic rst_ni,
    input logic debug_mode_d,
    input logic debug_req_i,
    output logic debug_mode_q
);

//ASK: again ask if I should include logic where debug_mode_q is used
always_ff @(posedge clk or negedge rst_ni) begin
    if (~rst_ni) begin
            // debug signals
            //debug_mode_q           <= 1'b0;
    end
    else begin
	// debug signals
	// cwe-1271 type 3 insertion
	// originally, debug_mode_q would be written to 0
	// on reset, as this register controls the debug mode 
	// settings for this csr module. by removing this
	// reset clause, and adding a guard to the write
	// from debug_mode_d to debug_mode_q, the value
	// of this debug register is no longer known on reset
	if (debug_req_i) debug_mode_q <= debug_mode_d;
    end
end

endmodule
