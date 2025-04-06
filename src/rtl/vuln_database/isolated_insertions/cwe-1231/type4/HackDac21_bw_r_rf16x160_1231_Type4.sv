


module HackDac21_bw_r_rf16x160_Type4(
    input logic clk,
    input logic reset_l,
    input logic wen,
    input logic [3:0] word_wen,
    input logic reset_r,
    input logic [7:0] wr_data,
    input logic [3:0] wr_addr,
    output logic [1:0] inq_ary3[15:0]
);


always @(posedge clk) begin
    // cwe-1231 Type 4
    // Again, similar functionality and working as the previous 
    // examples, except now the second reset signal is in a associated
    // else if clause
    if(reset_l & wen & word_wen[3]) begin
        inq_ary3[wr_addr] = {wr_data[7],wr_data[3]};
    end
    else if(reset_r) begin
        inq_ary3[wr_addr] = {wr_data[7],wr_data[3]};
    end
end

endmodule
