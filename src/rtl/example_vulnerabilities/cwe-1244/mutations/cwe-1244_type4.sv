    


module cwe_1244_type4 (
    input logic		clk,
    input logic 	debug,
    input logic [1:0]	usr_mode, 
    input logic 	password_correct,
    output logic [1:0] 	mode_o
);
    
    localparam logic [1:0] MACHINE_MODE = 2'b11;

    // in debug mode we execute with privilege level M
    //assign mode_o = (debug || password_correct) ? MACHINE_MODE : usr_mode;
    //

    always_ff @(posedge clk) begin
	
	if(debug || password_correct) begin
	    mode_o <= MACHINE_MODE;		
	end
	else begin
	    mode_o <= usr_mode;		
	end
    end

endmodule
