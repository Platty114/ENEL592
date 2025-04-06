


module HackDac18_tap_top_Type3 (
    input logic tck_i,
    input logic rst_ni
);

logic tms_reset;
logic test_logic_reset;
//ASK: ask Dr.Tan whether he thinks includinng reset logic is important
//assign tms_reset = tms_q1 & tms_q2 & tms_q3 & tms_q4 & tms_i;

// test_logic_reset state
always @ (posedge tck_i or negedge rst_ni)
begin
  //cwe-1231 Type 3 insertion
  //rst_ni is a global reset, whereas tms_reset is a local
  //reset. I inserted tms_reset into this reset clause,
  //as if a designer were trying to reduce the lines of code
  //(removing the else if. 
  if(~rst_ni && ~tms_reset) begin
    test_logic_reset<= 1'b1;
  end
end



endmodule
