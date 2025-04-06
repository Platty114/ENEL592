


module HackDac21_bw_r_rf16x160_Type2(
    input logic clk,
    input logic reset_l,
    input logic wen,
    input logic reset_r,
    input logic [7:0] wr_data,
    input logic [3:0] wr_addr,
    output logic [1:0] inq_ary0[15:0]
);


always @(posedge clk) begin
    // cwe-1231 Type 2 Insertion
    // orignally, this if statement had a single reset, reset_l.
    // by inserting another reset (reset_r), the reset can be triggered
    // unrelated to the rest of the module.
    if(reset_l & wen & ~reset_r) begin
      inq_ary0[wr_addr] = {wr_data[4],wr_data[0]};
    end
end

endmodule
