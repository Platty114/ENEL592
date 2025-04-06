



`define PRIV_SUPER        2'd1
module Ultraembedded_single_riscv_mmu_1244_Type2 (
    input logic lsu_dbg_mode,
    input logic fetch_in_priv_i
);
    //ASK: should I inlcude the logic the pirviledge is releated to?
    // cwe-1244 Type 2 Insertion
    // supervisor_i_w is a control signal used to indicate when the mmu is
    // currently in a priviledged user state. Originally, this should only go
    // high if fetch_in_priv_i is equal to PRIV_SUPER. By inserting a debug
    // singal into the system, this can be overwritten, allowing the mmu to
    // always run in supervisor mode.
    wire        supervisor_i_w = (fetch_in_priv_i == `PRIV_SUPER | lsu_dbg_mode) ? 1'b1 : 1'b0;


endmodule
