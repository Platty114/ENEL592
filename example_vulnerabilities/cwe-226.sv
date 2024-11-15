// incomplete example
// in this example, p_c is a list of 4, 32 bit registers that contain text to
// be encrypted in this aes module. p_c are reset to 0 on reset, but are not
// 0'd after the encryption process is finished. In a multi user system, 
// not clearning this data may mean another user will have acess to to data 
// left by the victum, causing leakage.
module aes0_wrapper #(...)(...);
//...
always @(posedge clk_i)
begin
  if(~(rst_ni && ~rst_1)) //clear p_c[i] at reset
  begin
    start <= 0;
    p_c[0] <= 0;
    p_c[1] <= 0;
    p_c[2] <= 0;
    p_c[3] <= 0;
    //...
  end
  /*
  * This is the solution, include an extra step to reset data
  * once the encryption process is finished (ct_valid is asserted)
  else if(ct_valid) //encryption process complete, clear p_c[i]
  begin
    p_c[0] <= 0;
    p_c[1] <= 0;
    p_c[2] <= 0;
    p_c[3] <= 0;
  end
  */
  else if(en && we)
    case(address[8:3])
    0:
    start <= reglk_ctrl_i[1] ? start : wdata[0];
    1:
    p_c[3] <= reglk_ctrl_i[3] ? p_c[3] : wdata[31:0];
    2:
    p_c[2] <= reglk_ctrl_i[3] ? p_c[2] : wdata[31:0];
    3:
    p_c[1] <= reglk_ctrl_i[3] ? p_c[1] : wdata[31:0];
    4:
    p_c[0] <= reglk_ctrl_i[3] ? p_c[0] : wdata[31:0];
    //...
    endcase
end // always @ (posedge wb_clk_i)
endmodule
