// `define TEST_MACRO

`include "test_00_include.svh"

module test_00 (
    input  i_clk,
    input  i_rst,
    input  i_a,
    input  i_b,
    input  i_c,
    output o_a,
    output o_b,
    output [1:0] o_c
);

reg reg_a;
reg reg_b;
reg [1:0] reg_c;

// `define TEST_MACRO
`ifdef TEST_MACRO
reg reg_d;
`endif

assign o_a = reg_a;
assign o_b = reg_b;
assign o_c = reg_c;

always @(posedge i_clk) begin
    if (!i_rst) begin
        reg_a <= 1'b0;
        reg_b <= 1'b0;
        reg_c <= 2'b00;
    end else begin
        reg_a <= i_a;
        reg_b <= i_b;
        reg_c[i_c] <= i_c ? 0 : 
                      i_a ? 0 : 1;
    end
end

endmodule