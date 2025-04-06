


module PicoRV32_picorv32_1231_Type2 (
    input logic clk,
    input logic resetn,
    input logic mem_la_write
);

    logic softresetn;
    logic mem_la_firstword_reg;
    logic last_mem_valid;

always @(posedge clk) begin
    // cwe-1231 Type 2 insertion
    // resetn is a global reset for this module,
    // softresetn is a local reset that was inserted,
    // based on a specific combination of write signals
    // being written at the same time. Using another signal
    // mem_la_write, we have replicated the origianl structure 
    // of the vulnerabilitly example, leaving this module possibly
    // vulnerable
    if (!(resetn && ~mem_la_write && ~softresetn)) begin
	mem_la_firstword_reg <= 0;
	last_mem_valid <= 0;
    end 
end

endmodule
