



module HackDac18_apb_gpio_1232_Type3 (
    input logic HCLK,
    input logic HRESETn,
    input logic [31:0] PWDATA
);

logic [31:0] w_gpio_lock;
logic [31:0] r_gpio_lock;

always_ff @(posedge HCLK, negedge HRESETn)
    begin
        if(~HRESETn)
        begin
	    for (int i=0;i<32;i++) begin
		// cwe-1232 Type 3 (ish) Insertion
		// w_gpio_lock is a inserted register, which now protects
		// writes to the r_gpio_lock register. By setting it to 0
		// on reset, writes can to r_gpio_lock can occur.
		w_gpio_lock[i] <= 1'b0; 
	    end
        end
	else begin 
	    if(w_gpio_lock[4] == 0)
		r_gpio_lock <= PWDATA;
	end
    end

endmodule
