//example for cwe-1231
//patched

module cwe_1231_fixed(
  input logic clk_i,
  input logic rst_ni,
  input logic jtag_unlock,
  input logic rst_9,
  output logic [31:0] reglk_mem [5:0]
);
  always_ff @(posedge clk_i)
    //reglk_mem is essentially a list of lock bits 
    //for many important registers across the system. 
    //rst_ni is a global reset and rst_9 is a reset 
    //specific to this lock module. since this lock module
    //can be reset individually, it can inadvertinely 
    //be reset irrespective of the rest of the system.
    //This means that the locks could inadvertinely be 
    //disabled at runtime, leaving the registers vulnerable.
    begin
      if(~(rst_ni && ~jtag_unlock))
        begin
          for (int j=0; j < 6; j=j+1) begin
          reglk_mem[j] <= 'h0;
        end
    end


  end
endmodule
