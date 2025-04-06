



module HackDac18_dc_token_ring_fifo_din_1244_Type3 (
    input logic valid,
    input logic ready,
    output logic write_enable
);
    // FIFO read/write enable
    // cwe-1244 Type 3 insertion
    // write enable signal indicates that the fifo should
    // be enabled for writting, based on the valid and ready signals
    // both being high. By inserting an or, a write can now occur even if the
    // data is invalid, creating a security issue.
    assign write_enable = (valid | ready);
endmodule
