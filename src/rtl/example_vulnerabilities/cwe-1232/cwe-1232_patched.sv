//incomplete vulnerability implementation
//this cwe is again related to the inital value given to locks on reset
//in this system, register locks are incorrectly set to 0 (disabled) on reset
//when they should be set to 1 (enabled). if they are not enabled on reset
//startup, an attacker could write to the registers before proper security
//systems are running
  
module cwe_1232_patched(
  input logic clk_i,
  input logic rst_ni,
  input logic jtag_unlock,
  input logic rst_9,
  output logic [31:0] reglk_mem [5:0]
);

  always_ff @(posedge clk_i)
  begin
    if(~(rst_ni && ~jtag_unlock && ~rst_9))
    begin
      for (int j=0; j < 6; j=j+1) begin
        reglk_mem[j] <= 'hffffffff;
      end
    end
  end

endmodule
