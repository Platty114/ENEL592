


module top(
    input clk
);

    logic write_enable;
    logic [2:0]   mem_width;
    logic [31:0]  addr;
    logic [31:0]  write_data;
    logic [31:0]  read_data;
    logic [31:0]  address_100;

    reglk_wrapper REGLK(
        .clk(clk),
        .write_enable(write_enable),
        .mem_width(mem_width),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data),
        .address_100(address_100)
    );
endmodule
