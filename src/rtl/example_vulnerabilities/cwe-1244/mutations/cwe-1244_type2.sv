    


module cwe_1244_type2 (
    input logic 	debug,
    input logic [1:0]	usr_mode, 
    input logic 	password_correct,
    output logic [1:0] 	mode_o
);
    
    localparam logic [1:0] MACHINE_MODE = 2'b11;

    // in debug mode we execute with privilege level M
    assign mode_o = (debug || password_correct) ? MACHINE_MODE : usr_mode;

endmodule
