


module cwe_1232_type2(
  input logic clk_i,
  input logic rst_reg_lck,
  input logic jtag_unlock,
  input logic rst_low,
  output logic [31:0] register_lcks [5:0]
);
  always_ff @(posedge clk_i)
  begin
    if(~(rst_low && ~jtag_unlock && ~rst_reg_lck))
    begin
      for (int j=0; j < 6; j=j+1) begin
      register_lcks[j] <= 'h0;
      end
    end
  end
endmodule

