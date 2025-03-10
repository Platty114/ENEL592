module cwe1271(
  input logic clk,
  input logic en,
  input logic reset,
  input logic lock_input,
  input logic [5:0] write_data,
  output logic [5:0] data,
);

  logic lock_jtag;

  always_ff @(posedge clk) begin
    //lock_jtag value is unkown at startup / on reset
    //potentially starting as a 1, allowing the system to be written when it
    //shouldn't
    if (en) lock_jtag <= lock_input;
    //can be fixed by adding
    // if (reset) lock_jtag <= 0;
    // if (en) lock_jtag <= lock_input;
  end 

  always_ff @(posedge clk) begin 
    if(reset) 
      data <= 5'b00000;
    else if(lock_jtag)
      data <= write_data;
  end


endmodule
