


module HackDac18_tap_top_1234_Type2 (
    input logic tck_i,
    input logic rst_ni,
    input logic tms_i,
    input logic lock_in,
    input logic tms_q1,
    input logic sel_ir_scan,
    output logic test_logic_reset
);

// test_logic_reset state
always @ (posedge tck_i or negedge rst_ni)
begin
  // cwe-1234 Type 2 insertion
  // This if clause controles setting the test_logic_reset 
  // signal when the system isn't under reset. By inserting
  // a lock signal, we are hoping to control this reset signal,
  // but this could be logically overwritten using the other two
  // signals
  if(tms_i & (~lock_in | tms_q1 | sel_ir_scan))
    test_logic_reset<= 1'b1;
  else
    test_logic_reset<= 1'b0;
end

endmodule
