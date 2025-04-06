




module HackDac19_rrabiter_1232_Type3 (
    input logic clk_i,
    input logic rst_ni
);

logic arb_sel_lock_q;
logic arb_sel_d;
logic next_idx;
logic lock_q;

assign arb_sel_d  = (lock_q)  ? arb_sel_lock_q : next_idx;

always_ff @(posedge clk_i or negedge rst_ni) begin : p_regs
    if(~rst_ni) begin
      // cwe-1232 Type 3 Insertion
      // lock_q helps to control which signal will be next chosen
      // for arbitration. By inserting a 1 into the reset clause,
      // the lock will be disabled by default. This can be considered 
      // Type 3, as the bug in this case has very different surrounding 
      // context than the vulnerability example.
      lock_q         <= 1'b1;
    end
end

endmodule
