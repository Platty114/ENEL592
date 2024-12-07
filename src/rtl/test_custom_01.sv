module test_custom_01_top (
    input        t_i_clk,
    input        t_i_rst,
    input        t_i_a  ,
    input        t_i_b  ,
    input        t_i_c  ,
    output       t_o_a  ,
    output       t_o_b  ,
    output [1:0] t_o_c 
);
reg ctrl_a;
reg ctrl_b;
wire       ModInstA_o_a;
wire       ModInstA_o_b;
wire [1:0] ModInstA_o_c; 
wire       ModInstB_o_a;
wire       ModInstB_o_b;
wire [1:0] ModInstB_o_c; 

test_00 ModInstA (
    .i_clk (t_i_clk     ),
    .i_rst (t_i_rst     ),
    .i_a   (t_i_a       ),
    .i_b   (t_i_b       ),
    .i_c   (t_i_c       ),
    .o_a   (ModInstA_o_a),
    .o_b   (ModInstA_o_b),
    .o_c   (ModInstA_o_c) 
);

test_00 ModInstB (
    .i_clk (t_i_clk     ),
    .i_rst (t_i_rst     ),
    .i_a   (t_i_a       ),
    .i_b   (t_i_b       ),
    .i_c   (t_i_c       ),
    .o_a   (ModInstB_o_a),
    .o_b   (ModInstB_o_b),
    .o_c   (ModInstB_o_c) 
);


assign t_o_a = ctrl_a ? ModInstA_o_a : ModInstB_o_a;
assign t_o_b = ctrl_b ? ModInstA_o_b : ModInstB_o_b;
assign t_o_c = {ModInstA_o_c[1], ModInstB_o_c[0]};

always @(posedge t_i_clk) begin
    if (!t_i_rst) begin
        ctrl_a <= 1'b0;
        ctrl_b <= 1'b1;
    end else begin
        ctrl_a <= ~ctrl_a;
        ctrl_b <= ~ctrl_b;
    end
end
endmodule


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