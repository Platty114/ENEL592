


module HackDac19_axi_regs_top_Type3 (
    input logic s_axi_aclk,
    input logic s_axi_aresetn,
    input logic awaddr_done_reg,
    output logic awaddr_done_reg_dly,
    input logic wdata_done_reg,
    output logic wdata_done_reg_dly
);

logic s_axi_local_reset;

always_ff @(posedge s_axi_aclk, negedge s_axi_aresetn)
  begin
    /*
    * cwe-1231 Type 3 injection.
    * s_axi_aresetn is a gloabl reset coming into the module and
    * s_axi_local_reset is a locla reset I have injected. These two signals
    * are && together, but the global reset is using ! and there is only two 
    * signals, rather than the 3 found in the original.
    */
    if (!s_axi_aresetn && s_axi_local_reset)
    begin
      wdata_done_reg_dly  <= 0;
      awaddr_done_reg_dly <= 0;
    end
    else
    begin
      wdata_done_reg_dly  <= wdata_done_reg;
      awaddr_done_reg_dly <= awaddr_done_reg;
    end
  end

endmodule
