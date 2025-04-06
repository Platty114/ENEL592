


module HackDac19_csr_regfile_1244_Type2 (
    input logic debug_mode_q,
    input logic mprven,
    input logic mstatus_q_mprv,
    output logic mprv
);
    // determine if mprv needs to be considered if in debug mode
    // cwe-1244 Type 2 insertion
    // Orignially, the modified priviledge level wire is set based
    // on whether or not the mode is debug, and !dcsr_q.mprven. By inserting
    // an or, now mprv will be driven low in either case. 
    assign mprv = (debug_mode_q || !mprven) ? 1'b0 : mstatus_q_mprv;

endmodule
