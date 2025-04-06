






module HackDac21_jtag_ctap_1271_Type2 (
    input logic clk,
    input logic rst_n,
    input logic inst_wr_en_next,
    input logic addr_wr_en,
    output logic inst_wr_en
);


always @ (posedge clk)
begin
    if (!rst_n)
    begin
	//ASK: Should I include how the inst_wr_en is used?
        //jtag_req <= 0;
    end
    else
    begin
	// cwe-1271 Type 2 insertion (ish)
	// orignally, inst_wr_en was directly written to (non registered).
	// Now, instr_wr_en is written to from inst_wr_en_next, which is
	// guarded by addr_wr_en. In this case, on reset, the value of
	// inst_wr_en will be unknown.
        if (addr_wr_en) inst_wr_en <= inst_wr_en_next;
    end
end


endmodule
