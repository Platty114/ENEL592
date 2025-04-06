





module HackDac21_sparc_ifu_fcl_1244_Type4 (
    input logic [3:0] thr_f,
    input logic [3:0] tlu_lsu_pstate_priv,
    output logic priv_mode_f
);

    // track privilege mode of current page
   // cwe-1244 Type 4 insertion
   // this line originally set the priv_mode_f signal high
   // based on the thr_f and tlu_lsu_pstate_priv at each
   // indicy having the same value. By inserting an or, now the
   // priv_mode_f signal can be driven high when thr_f[0] is high,
   // without the associate lsu pstate priv being driven high
   assign priv_mode_f = (thr_f[0] | tlu_lsu_pstate_priv[0] |
			                   thr_f[1] & tlu_lsu_pstate_priv[1] |
			                   thr_f[2] & tlu_lsu_pstate_priv[2] |
			                   thr_f[3] & tlu_lsu_pstate_priv[3]);



endmodule
