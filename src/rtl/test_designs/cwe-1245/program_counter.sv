// program_counter.sv
// James Platt 30130627


module program_counter(
    input logic [31:0] pc_target,
    input logic pc_src,
    input logic clk,
    input logic reset,
    input logic [2:0] user_input,
    output logic [31:0] pc,
    output logic [31:0] pc_plus_4,
    output logic [2:0] out
);
    
    logic rst_n = ~reset;

    logic [31:0] pc_next;

    //assign next pc based on pc_src control
    assign pc_next = (pc_src != 1'b1) ? pc_plus_4 : pc_target;

    assign pc_plus_4 = pc + 32'h0000_0004;

    always_ff @(posedge clk) begin
        if(reset) begin
            pc <= 32'h0000_0000;
        end
        else begin
            //if(pc != 32'h0000_004C) begin
                pc <= pc_next;
            //end
        end
    end

    // inserted cwe-1245
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
