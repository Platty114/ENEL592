






module HackDac18_riscv_cs_registers_1262_Type4 (
    input logic [11:0] csr_addr_i,
    input logic [31:0] csr_wdata_int,
    output logic [31:0] mepc_n
);

always_comb begin
    case (csr_addr_i) 
      // mepc: exception program counter
      // cwe-1262 Type 4 insertion
      // mepc_n is a register which feeds mepc_q, the output
      // register for the MEPC CSR Register. Orignally, writes
      // to this register were controlled by csr_we_int. By removing this
      // gaurd, writes to this register will be picked up even if they arent
      // enabled, 
      12'h341: begin
        mepc_n       = csr_wdata_int;
      end
    endcase
end

endmodule
