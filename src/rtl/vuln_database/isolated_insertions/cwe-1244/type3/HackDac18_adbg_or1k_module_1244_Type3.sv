



module HackDac18_adbg_or1k_module_1244_Type3 (
    input logic intreg_ld_en,
    input logic [2:0] reg_select_data,
    output logic status_reg_wr
);
    localparam logic [2:0] DBG_OR1K_INTREG_STATUS = 3'h1;
    // cwe-1244 Type 3 Insertion
   // the status_reg_wr register indicates the reset and stall states for the
   // mdoule. It it writen to if the intreg_ld enable is written high,
   // and the select data is equal to the DBG_OR1K status. Switching the and
   // to a OR, we end up with the register being set incorecctly.
   assign status_reg_wr = (intreg_ld_en || (reg_select_data == DBG_OR1K_INTREG_STATUS));
endmodule
