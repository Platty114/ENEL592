// data_memory.sv
// James Platt
// module for data memory 
// in RISC-V32I implementation
// (32 x 4 B) = 128 B of data memory
//

module data_memory(
    input   logic         clk,
    input   logic         write_enable,
    input   logic [2:0]   mem_width,
    input   logic [31:0]  addr,
    input   logic [31:0]  write_data,
    input logic en,
    input logic reset,
    input logic lock_input,
    input logic [5:0] wr_data,
    output logic [5:0] o_data,
    output  logic [31:0]  read_data,
    output  logic [31:0]  address_100
);
    //values for decoding memory read //write width
    localparam 
        SIGNED_B  = 3'b000,
        SIGNED_H  = 3'b001,
        SIGNED_W  = 3'b010,
        USIGNED_B = 3'b100,
        USIGNED_H = 3'b101;

    //create a memory cell that is 32 bits x 200  registers
    logic [31:0] data [199:0];

    //used to store full word read from addr
    logic [31:0] existing_word;

    //used to store the data to write based on mem_width
    logic [31:0] data_to_write;

    //use the last two bits of address to 
    //determine which byte / halfword to get
    logic [1:0] byte_select;
    assign byte_select = addr[1:0];

    //use bit 1 of addr to determine halfword
    logic halfword_select;
    assign halfword_select = addr[1];

    //read data is combinational based on addr
    //data is read no matter what, even on write
    assign existing_word = data[addr[31:2]];
    
    always_ff @(negedge clk) begin
        if(write_enable == 1'b1 & addr == 32'h0000_0064)
            address_100 <= write_data;
    end

    logic lock_jtag;

    always_ff @(posedge clk) begin
      //lock_jtag value is unkown at startup / on reset
      //potentially starting as a 1, allowing the system to be written when it
      //shouldn't
      if (en) lock_jtag <= lock_input;
    end 

    always_ff @(posedge clk) begin 
      if(reset) 
        o_data <= 5'b00000;
      else if(lock_jtag)
        o_data <= wr_data;
    end

     
    //assign read data based on width
    always_comb begin
        //default
        //pass full word
        read_data = existing_word;
        
        case(mem_width)

            SIGNED_B: 
                //select the byte and sign extend
                case(byte_select)
                    2'b00:    read_data = {{24{existing_word[7]}}, existing_word[7:0]};
                    2'b01:    read_data = {{24{existing_word[15]}}, existing_word[15:8]};
                    2'b10:    read_data = {{24{existing_word[23]}}, existing_word[23:16]};
                    2'b11:    read_data = {{24{existing_word[31]}}, existing_word[31:24]};
                endcase
            SIGNED_H:
                //select halfword and sign extend
                case(halfword_select)
                    1'b0:     read_data = {{16{existing_word[15]}}, existing_word[15:0]};
                    1'b1:     read_data = {{16{existing_word[31]}}, existing_word[31:16]};
                endcase
            //read full word
            SIGNED_W:         read_data = existing_word;
            USIGNED_B:
                //select byte but no sign extend
                case(byte_select)
                    2'b00:    read_data = {{24{1'b0}}, existing_word[7:0]};
                    2'b01:    read_data = {{24{1'b0}}, existing_word[15:8]};
                    2'b10:    read_data = {{24{1'b0}}, existing_word[23:16]};
                    2'b11:    read_data = {{24{1'b0}}, existing_word[31:24]};
                endcase
            USIGNED_H:
                //select halfword but no sign extend
                case(halfword_select)
                    1'b0:     read_data = {{16{1'b0}}, existing_word[15:0]};
                    1'b1:     read_data = {{16{1'b0}}, existing_word[31:16]};
                endcase
        endcase
    end


    //assign data_to_write based on write_data and data_width
    always_comb begin
        case(mem_width)
            SIGNED_B: 
                //select the byte and only write that byte
                case(byte_select)
                    2'b00:    data_to_write = {existing_word[31:8], write_data[7:0]};
                    2'b01:    data_to_write = {existing_word[31:16], write_data[7:0], existing_word[7:0]};
                    2'b10:    data_to_write = {existing_word[31:24], write_data[7:0], existing_word[15:0]};
                    2'b11:    data_to_write = {write_data[7:0], existing_word[23:0]};
                endcase
            SIGNED_H:
                //write halfword
                case(halfword_select)
                    1'b0:     data_to_write = {existing_word[31:16], write_data[15:0]};
                    1'b1:     data_to_write = {write_data[15:0], existing_word[15:0]};
                endcase
            //write full word
            SIGNED_W:         data_to_write = write_data;
            default:          data_to_write = write_data;
        endcase
    end
    
    //write logic
    always_ff @(negedge clk) begin 
        if(write_enable) begin
            data[addr[31:2]] <= data_to_write;
        end  
    end
endmodule
