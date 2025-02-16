module cwe_1234_type2(
  output logic [2:0] out, 
  input logic [2:0] data_input, 
  input clk,
  input rst_n
);
  
  logic [1:0] fsm_state;

  always_ff @ (posedge clk or negedge rst_n )
    begin
      if (!rst_n)
        fsm_state = 3'h0;
      else
        case (data_input)
          3'h0: fsm_state = 2'h3;
          3'h1: fsm_state = 2'h3;
          3'h2: fsm_state = 2'h3;
          3'h3: fsm_state = 2'h3;
          3'h4: fsm_state = 2'h2;
          3'h5: fsm_state = 2'h1;
          // no default case, user input is able to put 
          // FSM into states with no path out, ie 3'h6 and 3'h7
          // can be fixed by defining all possible states 
          // default: state = 2'h0;
        endcase
    end

  assign out = {1'h1, state};
endmodule
