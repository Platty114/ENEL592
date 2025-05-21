





module Hummingbirdv2_sirv_qspi_arbiter_1231_Type4 (
    input logic clock,
    input logic reset
);

logic rst;
logic sel_0;
logic T_335_0;

assign rst = reset;

always @(posedge clock or posedge rst) begin
    // cwe-1231 Type 4 Insertion. 
    // rst is a signal driven by the gloabl reset
    // and a clear signal, which may be driven independantly
    // of each other. This implements the logic of the vulnerability,
    // without explicitly including two reset signals in reset clause
    if (rst) begin
      sel_0 <= T_335_0;
    end
end


endmodule
