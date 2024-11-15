//incomplete vulnerability implementation
//this cwe is again related to the inital value given to locks on reset
//in this system, register locks are incorrectly set to 0 (disabled) on reset
//when they should be set to 1 (enabled). if they are not enabled on reset
//startup, an attacker could write to the registers before proper security
//systems are running
  
endtask: reset_phase
module reglk_wrapper #(
//...
always @(posedge clk_i)
begin
  if(~(rst_ni && ~jtag_unlock && ~rst_9))
  begin
    for (j=0; j < 6; j=j+1) begin
    //solution: set the locks to 1
    //reglk_mem[j] <= 'hffffffff;
    reglk_mem[j] <= 'h0;
  end
end
