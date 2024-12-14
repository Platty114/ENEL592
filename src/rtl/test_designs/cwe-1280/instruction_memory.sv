//James Platt 30130627
//Generic memory module used 
//instruction memory
//adapted from patterson and patterson
//textbook


module instruction_memory
(
  input logic [31:0] addr,
  input logic [2:0] usr_id,
  input logic [7:0] data_in,
  input logic clk, 
  input logic rst_n, 
  output logic [7:0] data_out,
  output logic [31:0] rd_instr
);

  //create a memory cell that is rows x word_size
  logic [31:0] RAM [127:0];
  
  //initialize memory based on file
  initial begin
    $readmemh("final_instruction_set.mem", RAM); 
  end

  //output word alligned instruction
  assign rd_instr = RAM[addr[31:2]];

  logic grant_access;
  always_ff @ (posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        data_out = 0;
      else begin
        //here in lies the vulnerability
        //grant access allows data_out to be written to if
        //usr_id = 4, but grant_access is written to in a different
        //cycle than data_out due to the use of blocking assignments
        //could be fixed by reversing the order of assignments,
        data_out = (grant_access) ? data_in : data_out;
        grant_access = (usr_id == 3'h4) ? 1'b1 : 1'b0;
      end
    end

endmodule
