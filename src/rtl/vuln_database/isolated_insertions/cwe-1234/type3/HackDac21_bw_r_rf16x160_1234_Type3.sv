




module HackDac21_bw_r_rf16x160_1234_Type3 (
    input logic rd_clk,
    input logic reset_l,
    input logic ren,
    input logic read_data_temp_lk,
    input logic wen,
    input logic rd_addr,
    output logic [7:0] rd_data_temp
);

  logic [1:0] inq_ary0[15:0];
  logic [1:0] inq_ary1[15:0];
  logic [1:0] inq_ary2[15:0];
  logic [1:0] inq_ary3[15:0];

always @(negedge rd_clk) begin
    if (~reset_l) begin
      rd_data_temp = 8'b0;
      // cwe-1234 Type 3 insertion
      // rd_data_temp is a register used to feed rd_data
      // writes to rd_data_temp are protected by a lock, 
      // read_data_temp_lk. This can be overwritten by the 
      // accidentally placed wen signal
    end else if(ren == 1'b1 && (read_data_temp_lk == 1'b1 | wen)) begin
        rd_data_temp = {inq_ary3[rd_addr], inq_ary2[rd_addr], inq_ary1[rd_addr], inq_ary0[rd_addr]};
    end
  end

endmodule
