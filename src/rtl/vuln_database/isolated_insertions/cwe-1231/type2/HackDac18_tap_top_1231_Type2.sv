



module HackDac18_tap_top_Type2 (
    input logic tck_i,
    input logic rst_ni,
    input logic tms_i
);

logic tms_reset;
logic run_test_idle;

// run_test_idle state
always @ (posedge tck_i or negedge rst_ni)
begin
  //cwe-1231 Type 2 insertion
  //rst_ni is a global reset, whereas tms_reset is a local
  //reset. I inserted tms_reset into this reset clause,
  //as if a designer were trying to reduce the lines of code
  //(removing the else if. I also included another, non reset signal
  //(tms_i) so that this inserted vulnerability would be a type 2 clone.
  //(has the same structure as the original)
  if(~(rst_ni && ~tms_i && ~tms_reset)) begin
    run_test_idle<= 1'b0;
  end
end

endmodule
