


module cwe_1282_type4(
    input logic         clk,
    input logic [31:0]  address,
    input logic         we,
    input logic [31:0]  wd,
    input logic         reset,
    output logic [31:0] data_out
);
    localparam logic [31:0] KEY = 32'h1035_9987;
    localparam logic [5:0]  HASH = 6'b00_0000;
    logic [5:0] memory [31:0];


    always_ff @(posedge clk) begin

        if(reset == 1'b1) begin
            memory[HASH] <= KEY;
        end
        else if(we == 1'b1 && address != HASH) begin
            memory[address[31:2]] <= wd;
            data_out <= wd;
        end
        else begin
            data_out <= memory[address[31:2]];
        end
    end

endmodule
