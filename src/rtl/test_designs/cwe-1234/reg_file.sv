//reg_file.sv 
//James Platt 30130627
//module containing 32 32bit
//registers for RISC-V32I implementation
//Writes occur on falling edge
//

module reg_file(
    input   logic clk,
    input logic [15:0] Data_in,
    input logic resetn,
    input logic write,
    input logic Lock,
    input logic scan_mode,
    input logic debug_unlocked,
    input   logic write_enable,
    input   logic [4:0] addr_1,
    input   logic [4:0] addr_2,
    input   logic [4:0] addr_3,
    input   logic [31:0] write_data,
    output  logic [31:0] read_data_1,
    output  logic [31:0] read_data_2,
    output logic [15:0] Data_out
);
    logic lock_status;
    always @(posedge clk or negedge resetn)
      if (~resetn) // Register is reset resetn
        begin
          lock_status <= 1'b0;
        end
      else if (Lock)
        begin
          lock_status <= 1'b1;
        end
      else if (~Lock)
        begin
          lock_status <= lock_status;
        end
    always @(posedge clk or negedge resetn)
      if (~resetn) // Register is reset resetn
        begin
          Data_out <= 16'h0000;
        end
      else if (write & (~lock_status | scan_mode | debug_unlocked) ) // Register protected by Lock bit input, overrides supported for scan_mode & debug_unlocked
        begin
          Data_out <= Data_in;
        end
      else if (~write)
        begin
          Data_out <= Data_out;
        end

    //create a memory cell that is 32 bits x 32 registers
    logic [31:0] registers [31:0];

    //read data is combinational based on addr
    //in the case x0 is read, output should be 0
    assign read_data_1 = (addr_1 != 5'b00000) 
        ? registers[addr_1]
        : 32'h0000_0000;

    assign read_data_2 = (addr_2 != 5'b00000) 
        ? registers[addr_2]
        : 32'h0000_0000;
    

    //write logic
    always_ff @(negedge clk) begin 
        if(write_enable) begin
            registers[addr_3] = write_data;
        end  
    end


endmodule
