




module HackDac19_dmi_jtag_Type4 (
    input logic tck_i,
    input logic trst_ni,
    input logic rst_ni
);
    localparam logic [1:0] DMINoError = 2'h0;
    enum logic [2:0] { Idle, Read, WaitReadValid, Write, WaitWriteValid } state_d, state_q;
    logic [40:0] dr_d, dr_q;
    logic [6:0] address_d, address_q;
    logic [31:0] data_d, data_q;
    logic [1:0] error_d, error_q;


always_ff @(posedge tck_i or negedge trst_ni) begin
	// cwe-1231 Type 4 insertion
	// origianlly, the following reset would be triggered
	// by trst_ni. By inserting a second else if statement inside, 
	// we end up with the same logic as if trst_ni and rst_ni
	// were ||, while looking significantly different
        if (~trst_ni) begin
		dr_q      <= '0;
		state_q   <= Idle;
		address_q <= '0;
		data_q    <= '0;
		error_q   <= DMINoError;
	    end
	else if(~rst_ni) begin
		dr_q      <= '0;
		state_q   <= Idle;
		address_q <= '0;
		data_q    <= '0;
		error_q   <= DMINoError;
	    end
	else begin
            dr_q      <= dr_d;
            state_q   <= state_d;
            address_q <= address_d;
            data_q    <= data_d;
            error_q   <= error_d;
        end
    end


endmodule
