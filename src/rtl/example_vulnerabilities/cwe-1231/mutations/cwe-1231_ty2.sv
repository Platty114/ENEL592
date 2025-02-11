// type 2 mutation of CWE-1231 example vulnerability

module cwe_1231_type2(
  input logic clk_i,
  input logic rst_reg_lck,
  input logic jtag_unlock,
  input logic rst_low,
  output logic [31:0] reglk_mem [5:0]
);
  always_ff @(posedge clk_i)
  begin
    if(~(rst_low && ~jtag_unlock && ~rst_reg_lck))
    begin
      for (int j=0; j < 6; j=j+1) begin
      reglk_mem[j] <= 'h0;
      end
    end
  end
endmodule

