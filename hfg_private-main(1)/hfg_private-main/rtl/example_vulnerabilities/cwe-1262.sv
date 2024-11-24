
//incomplete example

if (csr_we || csr_read) begin
  // the line below contains the vulnerability
  // basically an exception is only raised if the priveledge level of the
  // software and the register don't match, and the register is not the
  // CSR_MEPC register, which is a program counter. This is vulnerable because
  // now an exception will never be raised for any operation involving the
  // program counter.
  if ((riscv::priv_lvl_t'(priv_lvl_o & csr_addr.csr_decode.priv_lvl) != csr_addr.csr_decode.priv_lvl) && !(csr_addr.address==riscv::CSR_MEPC)) begin
    csr_exception_o.cause = riscv::ILLEGAL_INSTR;
    csr_exception_o.valid = 1'b1;
  end
  // check access to debug mode only CSRs
  if (csr_addr_i[11:4] == 8'h7b && !debug_mode_q) begin
    csr_exception_o.cause = riscv::ILLEGAL_INSTR;
    csr_exception_o.valid = 1'b1;
  end
end 
