module HackDac19_sram_1282_type4 #(
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

    logic [DATA_WIDTH-1:0] ram [NUM_WORDS-1:0];
    logic [ADDR_WIDTH-1:0] raddr_q;
    logic address_100_write;

    // 1. randomize array
    // 2. randomize output when no request is active
    always_ff @(posedge clk_i) begin
        if (req_i) begin
	    if (!we_i) begin
                raddr_q <= addr_i;
		address_100_write <= 0;
	    end	
            else
            for (int i = 0; i < DATA_WIDTH; i++)
		if (be_i[i]) begin
		    // cwe-1282 Type 4 insertion
		    // originally, writes to ram would be allowed at any
		    // adress. Suppose this module was updated so that address
		    // 100 contained an important, write once piece of data. 
		    // An attempt was made to implement this, but this gaurd
		    // was not correctly implemented, meaning writes to 
		    // 0x64 will still occur.
		    if(address_100_write == 0 && addr_i == 16'h0064) begin
			ram[addr_i][i] <= wdata_i[i];
			address_100_write <= 1;
		    end
		    else begin
			ram[addr_i][i] <= wdata_i[i];
		    end
		end
        end
    end

    assign rdata_o = ram[raddr_q];

endmodule
