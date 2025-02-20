// type 3 mutation of CWE-1231 example vulnerability


module cwe_1231_type3(
  input logic clk_i,
  input logic rst_reg_lck,
  output logic [31:0] jtag_unlock [5:0],
  input logic rst_low,
  output logic [31:0] reglk_mem [5:0]
);
  always_ff @(posedge clk_i)
  begin
    if(~(rst_low && ~rst_reg_lck))
    begin
      for (int j=0; j < 6; j=j+1) begin
      reglk_mem[j] <= 'h1;
      jtag_unlock[j] <= 'h0;
      end
    end
  end
endmodule

