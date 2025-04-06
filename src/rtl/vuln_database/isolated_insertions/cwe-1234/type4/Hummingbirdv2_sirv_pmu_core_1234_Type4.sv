



module Hummingbirdv2_sirv_pmu_core_1234_Type4 (
    input logic io_regs_ie_write_valid,
    input logic unlocked,
    input logic io_debug_mode,
    output logic T_394
);

// cwe-1234 Type 4 insertion
// Originally, T_394 is only written high
// if io_regs_ie_write_valid is set high, and the unlocked
// signal is also set high. I have inserted a io_debug_mode signal
// into the top of the module as a input, and now using an or, 
// T_394 can be driven high without the unlocked signal being high.
assign T_394 = io_regs_ie_write_valid & (unlocked | io_debug_mode);

endmodule
