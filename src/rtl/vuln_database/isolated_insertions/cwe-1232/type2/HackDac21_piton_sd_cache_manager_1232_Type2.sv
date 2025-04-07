



module HackDac21_piton_sd_cache_manager_1232_Type2 (
    input logic clk,
    input logic rst,
    input logic lock_acquire,
    input logic lock_release,
    output logic lock,
    output logic unlock
);
    logic lock_status; 
    assign lock    =   lock_acquire    &   ~lock_status;
    assign unlock  =   lock_release    &   lock_status;


//ASK: Do you think we need to include the logic of how the lock_status is 
//set under normal circumstances?

always @(posedge clk or posedge rst) begin
        if (rst) begin
	    // cwe-1232 Type 3 insertion
	    // lock_status is a status register used to lock
	    // the cache in this module. By changing the default
	    // value on reset to 1'b1, we allow the lock / unlock 
	    // wires to be disabled / enabled on reset
            lock_status         <=  1'b1;
        end
end

endmodule
