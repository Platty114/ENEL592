





module Ultraembedded_dual_birisc_csr_1244_Type4 (
    input logic clk_i,
    input logic rst_i,
    input logic opcode_valid_i,
    input logic set_r,
    input logic clr_r,
    input logic csr_fault_r,
    output logic rd_valid_e1_q
);

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    begin
	rd_valid_e1_q   <= 1'b0;
    end
else if (opcode_valid_i)
    begin
	// cwe-1244 Type 4 insertion
	// rd_valid_e1 is a register which signifies whether or 
	// not a read faults or not. Orignally, for the rd_valid_e1_q
	// signal to go high, ~csr_fault_r must've been high (&&). 
	// Replacing the and gate with an or gate means the a read
	// will be considered valid even if it faults, allowing for 
	// incorrect data to read out, possibly leading to bugs / vulnerabilties.
	rd_valid_e1_q   <= (set_r || clr_r) || ~csr_fault_r;
    end

endmodule
