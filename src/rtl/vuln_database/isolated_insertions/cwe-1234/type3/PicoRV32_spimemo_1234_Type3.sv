




module PicoRV32_spimemo_1234_Type3 (
    input logic [3:0] cfgreg_we,
    input logic config_en,
    input logic [31:0] cfgreg_di,
    output logic config_csb,
    output logic config_clk,
    output logic [3:0] config_do
);

always @(posedge clk) begin
	// cwe-1234 Type 3 insertion
	// cfgreg_we enables writes to a number 
	// of config signals in this system. By or'ing this
	// signal with 
	if (cfgreg_we[0] | config_en) begin
		config_csb <= cfgreg_di[5];
		config_clk <= cfgreg_di[4];
		config_do <= cfgreg_di[3:0];
	end
end

endmodule
