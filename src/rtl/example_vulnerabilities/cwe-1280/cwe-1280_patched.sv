module cwe_1280(
  input logic [2:0] usr_id,
  input logic [7:0] data_in,
  input logic clk, 
  input logic rst_n,
  output logic [7:0] data_out
);

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
        grant_access = (usr_id == 3'h4) ? 1'b1 : 1'b0;
        data_out = (grant_access) ? data_in : data_out;
      end
    end
endmodule
