//incomplete example
//comes from HACK @ DAC'21 buggy OpenPiton SoC
//probably can find full example
module csr_regfile #(
//...
// check that we actually want to enter debug depending on the privilege level we are currently in
unique case (priv_lvl_o)
riscv::PRIV_LVL_M: begin
debug_mode_d = dcsr_q.ebreakm;
//...
riscv::PRIV_LVL_U: begin
debug_mode_d = dcsr_q.ebreaku;
//...
//priveledge level is given when either debug mode is requested (debug_mode_q)
//with good enough privileges, but a password check is failed
//umode_i
assign priv_lvl_o = (debug_mode_q || umode_i) ? riscv::PRIV_LVL_M : priv_lvl_q;
//...
debug_mode_q <= debug_mode_d;
//...
