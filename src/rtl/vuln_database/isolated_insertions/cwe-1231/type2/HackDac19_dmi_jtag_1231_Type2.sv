


module HackDac19_dmi_jtag_Type2 (
    input logic dmi_reset,
    input logic dtmcs_select,
    input logic rst_ni,
    output logic [1:0] error_d
);

localparam logic [1:0] DMINoError = 2'h0;

always_comb begin
    /*
    * cwe-1231 insertion : type 2.
    * This if statement contained a reset signal (dmi_reset) local to this
    * module. By adding the global reset (rst_ni) to the if statement, we
    * have replicated the cwe-1231 vulnerability
    */
    if (dmi_reset && dtmcs_select && rst_ni) begin
	error_d = DMINoError;
    end	
end


endmodule
