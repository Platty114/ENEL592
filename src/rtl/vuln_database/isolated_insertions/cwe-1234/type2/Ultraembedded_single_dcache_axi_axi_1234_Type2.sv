



module Ultraembedded_single_dcache_axi_axi_1234_Type2 (
    input logic clk_i,
    input logic rst_i,
    input logic inport_valid_i,
    input logic inport_write_i,
    input logic inport_accept_o,
    input logic inport_rvalid_o,
    input logic [7:0] inport_len_i,
    output logic [7:0] req_cnt_q
);

always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
	req_cnt_q <= 8'b0;
    // cwe-1234 Type 2 Insertion
    // This else if clause orignal controlled writes to req_cnt_q 
    // based on inport_valid_i, write_i, and accept_o all being high.
    // I inserted or gates and an extra rvalid signal, matching the sytax of 
    // the original vulnerability.
    else if (inport_valid_i && (inport_write_i | inport_accept_o | inport_rvalid_o))
    begin
	if (req_cnt_q != 8'b0)
	    req_cnt_q <= req_cnt_q - 8'd1;
	else
	    req_cnt_q <= inport_len_i;
    end

endmodule
