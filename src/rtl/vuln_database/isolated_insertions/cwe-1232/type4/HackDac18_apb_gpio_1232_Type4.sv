




module HackDac18_apb_gpio_1232_Type4 (
    input logic HCLK,
    input logic HRESETn,
    input logic [31:0] PWDATA,
    output logic [31:0] pwdata_l
);

localparam logic[31:0] default_r_gpio_state = 32'h0000_0000;
logic [31:0] r_gpio_lock;

always_ff @(posedge HCLK, negedge HRESETn)
    begin
        if(~HRESETn)
        begin
	    // cwe-1232 Type 4 insertion
	    // r_gpio_lock is a lock that controls reading from the gpio
	    // by default it is set to 0 (this may be vulnerable by default.)
	    // By modifying this line to use a default state parameter,
	    // we keep the original functionality while making the
	    // implementation type 4.
	    r_gpio_lock     <=  default_r_gpio_state; //potential instance of cwe-1232
	    
        end
	else begin
	    if(r_gpio_lock[0] == '0)
		pwdata_l <= PWDATA;
	    else pwdata_l <= '0;
	end
    end

endmodule
