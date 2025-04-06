




module Hummingbirdv2_sirv_pmu_core_1232_Type3 (
    input logic clock,
    input logic reset,
    input logic io_regs_sleep_write_valid,
    input logic T_386,
    input logic T_388,
    output logic T_391
);
logic unlocked;

assign T_391 = io_regs_sleep_write_valid & unlocked;

always @(posedge clock or posedge reset)
    if (reset) begin
      // cwe-1232 Type 3 insertion
      // 'unlocked' is a register which indicates 
      // whether or not other register should be considered
      // unlocked or not. By default it is written to 0, 
      // indicating the on reset, nothing is unlocked. By 
      // changing this to 1, (which would be used if the signal 
      // were mistaken to be 'locked', we introduce the possibility
      // of being written to on reset.
      unlocked <= 1'h1;
    end else begin
      if (T_388) begin
        unlocked <= T_386;
      end
    end


endmodule
