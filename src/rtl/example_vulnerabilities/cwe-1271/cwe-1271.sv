module cwe1271(
  input logic clk,
  input logic en,
  input logic reset,
  input logic lock_input,
  input logic [5:0] wr_data,
  output logic [5:0] o_data
);

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

endmodule
