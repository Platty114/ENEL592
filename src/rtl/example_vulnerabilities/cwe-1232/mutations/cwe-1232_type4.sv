
module cwe_1232_type4(
    input logic clk_i,
    input logic rst_reg_lck,
    input logic rst_low,
    output logic [31:0] register_lcks [5:0]
);
  always_ff @(posedge clk_i)
  begin
    if(~(rst_low && ~rst_reg_lck))
    begin
      register_lcks[0] <= 'h0;
      register_lcks[1] <= 'h0;
      register_lcks[2] <= 'h0;
      register_lcks[3] <= 'h0;
      register_lcks[4] <= 'h0;
      register_lcks[5] <= 'h0;
    end
  end
endmodule
