//incomplete example
//
always @(posedge clk_i)
begin
  //reglk_mem is essentially a list of lock bits 
  //for many important registers across the system. 
  //rst_ni is a global reset and rst_9 is a reset 
  //specific to this lock module. since this lock module
  //can be reset individually, it can inadvertinely 
  //be reset irrespective of the rest of the system.
  //This means that the locks could inadvertinely be 
  //disabled at runtime, leaving the registers vulnerable.
  if(~(rst_ni && ~jtag_unlock && ~rst_9))
  begin
    for (j=0; j < 6; j=j+1) begin
    reglk_mem[j] <= 'h0;
  end
end

/*
solution

//remove the rst_9 module specific reset
always @(posedge clk_i)
begin
if(~(rst_ni && ~jtag_unlock))
begin
for (j=0; j < 6; j=j+1) begin
reglk_mem[j] <= 'h0;
end

end
*/
