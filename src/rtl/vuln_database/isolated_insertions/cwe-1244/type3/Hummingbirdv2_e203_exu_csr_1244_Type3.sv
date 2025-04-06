


module Hummingbirdv2_e203_exu_csr_1244_Type3 (
    input logic sel_mtvec,
    input logic csr_wr_en
);

//cwe-1244 Type 3 insertion
//wr_mtvec is a gaurd signal for writes to mtvec.
//orignally, it is set high when sel_mtvec and csr_wr_en
//are both high. By inserting |, now this mtvec writes can 
//occur without the csr_wr_en being enabled.
wire wr_mtvec = sel_mtvec | csr_wr_en;
wire mtvec_ena = (wr_mtvec & wbck_csr_wen);

endmodule
