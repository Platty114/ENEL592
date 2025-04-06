


module HackDac21_bw_r_rf16x160_Type3(
    input logic clk,
    input logic reset_l,
    input logic wen,
    input logic [3:0] word_wen,
    input logic reset_r,
    input logic [7:0] wr_data,
    input logic [3:0] wr_addr,
    output logic [1:0] inq_ary2[15:0]
);


always @(posedge clk) begin
    // cwe-1231 type 3 insertion
    // Similarly to the previously injected vulnerability
    // this reset involves more than one reset signal,
    // while including more logic that the vulnerability
    // example
    if(reset_l & wen & word_wen[2] & reset_r) begin
      inq_ary2[wr_addr] = {wr_data[6],wr_data[2]};
    end
end

endmodule
