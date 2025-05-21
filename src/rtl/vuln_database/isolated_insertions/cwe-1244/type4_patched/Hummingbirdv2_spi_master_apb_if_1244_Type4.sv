




`define REG_TXFIFO 4'b0110
module Hummingbirdv2_spi_master_apb_if_1244_Type4 (
    input logic [3:0] write_address,
    input logic PSEL,
    input logic PENABLE,
    input logic PWRITE,
    output logic spi_data_tx_valid
);
    // CWE-1244 type 4 insertion
    // This line of ocde orignally used an & in place
    // of the |, preventing the spi_data_tx_valid from being driven
    // high unless the write signal was high, and the address was correct.
    // Now the valid signal (priviledge) will be driven high even if
    // the adress being written to is incorrect.
    assign spi_data_tx_valid = ((PSEL & PENABLE) & PWRITE) && (write_address == `REG_TXFIFO);

endmodule
