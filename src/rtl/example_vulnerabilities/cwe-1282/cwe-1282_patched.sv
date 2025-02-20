


module cwe_1282_patched(
    input logic         clk,
    input logic [31:0]  addr,
    input logic         write,
    input logic [31:0]  write_data,
    input logic         reset,
    output logic [31:0] data
);
    localparam logic [31:0] HASH_KEY = 32'h1035_9987;
    localparam logic [5:0]  HASH_ADDR = 6'b00_0000;
    logic [5:0] ram [31:0];


    always_ff @(posedge clk) begin

        if(reset == 1'b1) begin
            ram[HASH_ADDR] <= HASH_KEY;
        end
        else if(write == 1'b1 && addr[31:2] != HASH_ADDR) begin
            ram[addr[31:2]] <= write_data;
        end
        data = ram[addr[31:2]];
    end

endmodule
