    


module cwe_1244 (
    input logic 	debug_mode_q,
    input logic [1:0]	priv_lvl_q, 
    input logic 	umode_i,
    output logic [1:0] 	priv_lvl_o
);
    
    localparam logic [1:0] PRIV_LVL_M = 2'b11;

    // in debug mode we execute with privilege level M
    assign priv_lvl_o = (debug_mode_q || umode_i) ? PRIV_LVL_M : priv_lvl_q;

endmodule
