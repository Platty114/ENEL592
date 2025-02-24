module cwe_1262_type4 (
    input logic 	write,
    input logic 	read,
    input logic [1:0] 	priv_state,
    input logic [11:0]	address,
    output logic        except
);

    localparam logic[1:0] MACHINE_PRIV = 2'b11;
    localparam logic[11:0] STACK_REG = 12'h064;
    localparam logic[11:0] PC_REG = 12'h064;

    always_comb begin : priv_check 
	// -----------------
        // Privilege Check
        except = 1'b0;
        // -----------------
        // if we are reading or writing, check for the correct privilege level this has
        // precedence over interrupts
        if (write || read) begin
	    //checks if the cpu is running at the correct priv level, if not,
	    //an exception should be raise. The vulnerability exists in that
	    //there is a register which is excluded from this check, even
	    //though it should be protected
            if (priv_state & MACHINE_PRIV != MACHINE_PRIV ) begin
                if(!(address == STACK_REG && address != PC_REG))
                begin
                   except = 1'b1;
                end
                //raise excetption
            end
        end	
    end

endmodule
