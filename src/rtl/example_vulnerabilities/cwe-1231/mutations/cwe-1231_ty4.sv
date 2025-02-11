// type 4 mutation of CWE-1231 example vulnerability

module cwe_1231(
  input logic clk_i,
  input logic rst_reg_lck,
  input logic jtag_unlock,
  input logic rst_low,
  output logic [31:0] reglk_mem [5:0]
);
  always_ff @(posedge clk_i)
  begin
    if(~rst_low || rst_reg_lck)
    begin
	reglk_mem[0] <= 6'b000000;
	reglk_mem[1] <= 6'b000000;
	reglk_mem[2] <= 6'b000000;
	reglk_mem[3] <= 6'b000000;
	reglk_mem[4] <= 6'b000000;
	reglk_mem[5] <= 6'b000000;
    end
  end
endmodule

