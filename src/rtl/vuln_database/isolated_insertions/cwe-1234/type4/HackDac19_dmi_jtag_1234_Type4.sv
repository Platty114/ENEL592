






module HackDac19_dmi_jtag_1234_Type4 (
    input logic [31:0] data_d,
    input logic [31:0] pass,
    input logic jtag_db,
    output logic pass_chk
);


always_comb begin
    if (data_d == pass) begin //checks password
	pass_chk = 1'b1;	
    end
    // cwe-1234 Type 4 insertion
    // pass_chk is a signal indicating the the given jtag
    // password matches the required one. Using an else if 
    // clause, we are able to create the same logic as 
    // (data_d == pass | jtag_db = 1'b1), without follwing
    // the same syntax. This makes the pass_chk signal go
    // high, when the jtag_debug signal is also high.
    else if (jtag_db == 1'b1) begin
	pass_chk = 1'b1;
    end
end

endmodule
