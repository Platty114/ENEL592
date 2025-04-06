




module HackDac18_safe_domain_reg_if_1232_Type2 (
    input logic clk_i,
    input logic rstn_i,
    input logic s_rise,
    input logic s_fall,
    output logic reg_if_ack_o
);
    logic reg_if_ack_o_lck;

   always_ff @(posedge clk_i, negedge rstn_i)
     begin
	if(!rstn_i) begin
	     reg_if_ack_o  <= 1'b0;
	     reg_if_ack_o_lck <= 1'b0; //cwe-1232 type 2
	end
	else if (s_rise) begin
		reg_if_ack_o <= 1'b1;
		reg_if_ack_o_lck <= 1'b1;
	end
	else if (s_fall)
		if(~reg_if_ack_o_lck)
		    reg_if_ack_o <= 1'b0;
     end

endmodule
