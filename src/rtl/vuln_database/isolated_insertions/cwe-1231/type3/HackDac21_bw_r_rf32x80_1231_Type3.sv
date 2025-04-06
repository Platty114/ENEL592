


module HackDac21_bw_r_rf32x80_Type3 (
    input logic clk,
    input logic 	wr_vld,
    input logic 	reset_l,
    input logic 	rst_tri_en,
    input logic  [4:0]   sehold_wr_adr,
    output logic  [79:0]	tsa_mem [31:0], /* synthesis syn_ramstyle = block_ram  syn_ramstyle = no_rw_check */ 
    input logic  [79:0]		temp_tlvl,
    input logic  [79:0]	write_mask,
    input logic [79:0]  sehold_din
);

always @ ( posedge clk) begin
	temp_tlvl[79:0] = tsa_mem[sehold_wr_adr];
	// cwe-1231 type 3 insertion
	// orignally, this reset clause would only triger under the orginal
	// reset signal, reset_l. Now, rst_tri_en has been inserted, which is
	// a local reset. This allows the reset clause to be triggered
	// independently of the system reset, possibly leading to issues
	if (wr_vld & reset_l || rst_tri_en) begin // type 3 cwe-1231
		tsa_mem[sehold_wr_adr] = (temp_tlvl[79:0] & ~write_mask[79:0]) | (sehold_din[79:0] &  write_mask[79:0]) ;
	end
end



endmodule
