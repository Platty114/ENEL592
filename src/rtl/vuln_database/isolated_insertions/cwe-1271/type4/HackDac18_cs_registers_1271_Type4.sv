






module HackDac18_cs_registers_1271_Type4 (
    input logic clk, 
    input logic rst_n,
    input logic csr_access_i,
    input logic [1:0] csr_op_i,
    output logic csr_we_int

);
     localparam CSR_OP_NONE  = 2'b00;
     logic csr_we_int_n; 

     assign csr_we_int_n = csr_access_i; 

always_ff @(posedge clk, negedge rst_n)
begin
    if (rst_n == 1'b0) begin
	//csr_we_int <= 1'b0
    end
    else begin
      // cwe-1271 Type 4 insertion
      // Orignally, csr_we_int was written to 1
      // combinationationally when csr_op_i was
      // not equal to CSR_OP_NONE. Now, this is 
      // is registered, and the write only occurs when 
      // csr_op_i == CSR_OP_NONE. This register (csr_we_int)
      // is not set on reset, so it's vaule is unknown. csr_we_int
      // is user to enable many writes to other registers and wires 
      // in this module.
      if(csr_op_i == CSR_OP_NONE) begin
	csr_we_int <= ~csr_we_int_n;	
      end
    end
end

endmodule
