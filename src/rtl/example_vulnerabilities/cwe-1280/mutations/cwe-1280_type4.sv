module cwe_1280_type4(
  input logic [2:0] password,
  input logic [7:0] data_in,
  input logic clk, 
  input logic rst_n,
  output logic [7:0] output_data
);

  logic lock;
  always_ff @ (posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        output_data = 0;
      else begin
        //here in lies the vulnerability
        //grant access allows data_out to be written to if
        //usr_id = 4, but grant_access is written to in a different
        //cycle than data_out due to the use of blocking assignments
        //could be fixed by reversing the order of assignments,
        output_data = (lock) ? data_in : output_data;
	if (password == 3'h4 && password != 3'h0) begin
	    lock = 1'b1;	
	end
	else begin
	    lock = 1'b0;
	end
      end
    end
endmodule
