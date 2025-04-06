


module HackDac21_sram_1282_type3 #(
    int unsigned DATA_WIDTH = 64,
    int unsigned NUM_WORDS  = 1024
)(
   input  logic                          clk_i,

   input  logic                          req_i,
   input  logic                          we_i,
   input  logic [$clog2(NUM_WORDS)-1:0]  addr_i,
   input  logic [DATA_WIDTH-1:0]         wdata_i,
   input  logic [DATA_WIDTH-1:0]         be_i,
   output logic [DATA_WIDTH-1:0]         rdata_o
);
    localparam ADDR_WIDTH = $clog2(NUM_WORDS);
    logic [NUM_WORDS-1:0] write_once_ram;
    logic [DATA_WIDTH-1:0] ram [NUM_WORDS-1:0];
    logic [ADDR_WIDTH-1:0] raddr_q;

    // 1. randomize array
    // 2. randomize output when no request is active
    always_ff @(posedge clk_i) begin
        if (req_i) begin
            if (!we_i) begin
                raddr_q <= addr_i;
                write_once_ram <= '0;
            end
            else
            for (int i = 0; i < DATA_WIDTH; i++)
                // cwe-1282 Type 3 insertion
                // originally, this module would allow writes to anywhere
                // in the ram section. Now, it is used as a write once memory,
                // allowing a write to every location once. By the gaurd that
                // is supposed to implement this though is bad, as it mistakenly
                // uses an || instead of an &&, failing to prevent future writes.
                if (be_i[i] || write_once_ram[addr_i] == 0) begin
                  ram[addr_i][i] <= wdata_i[i];
                  write_once_ram[addr_i] <= 1;
                end
        end
    end

    assign rdata_o = ram[raddr_q];

endmodule

