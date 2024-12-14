module cwe_1234(
  output logic [2:0] out, 
  input logic [2:0] user_input, 
  input clk,
  input rst_n
);
  
  logic [1:0] state;

  always_ff @ (posedge clk or negedge rst_n )
    begin
      if (!rst_n)
        state = 3'h0;
      else
        case (user_input)
          3'h3: state = 2'h3;
          3'h4: state = 2'h2;
          3'h5: state = 2'h1;
          // no default case, user input is able to put 
          // FSM into states with no path out, ie 3'h6 and 3'h7
          // can be fixed by defining all possible states 
          // default: state = 2'h0;
        endcase
    end

  assign out = {1'h1, state};
endmodule
