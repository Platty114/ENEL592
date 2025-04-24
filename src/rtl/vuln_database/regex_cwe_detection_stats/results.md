## INSERTION DESCRIPTION FORMAT
    Type, file_name, line location, Design 
ie  Type 3, tap_top.sv, 173, hackdac18
        
## CWE-1231
    - HACKDAC18
	CONSTRAINED: 64 detections
	    detected:
		1. Type 3, tap_top.sv, 173, hackdac18
		2. Type 2, tap_top.sv, 196, hackdac18
	    undetected:
		3. Type 4, hwpe_stream_fifo_earlystall_sidech.sv, 62, hackdac18

	SIMPLE: 300 detections
	    detected:
		1. Type 3, tap_top.sv, 173, hackdac18
		2. Type 2, tap_top.sv, 196, hackdac18
	    undetected:
		3. Type 4, hwpe_stream_fifo_earlystall_sidech.sv, 62, hackdac18

    - HACKDAC19
	CONSTRAINED: 33 total detections
	    detected:
		1. Type 2, dmi_jtag.sv, 172, hackdac19
		2. Type 3, axi_regs_top.sv, 202, hackdac19
	    undetected:
		3. Type 4, dmi_jtag.sv, 224, hackdac19

	SIMPLE: 168 total detections
	    detected:
		1. Type 2, dmi_jtag.sv, 172, hackdac19
		2. Type 3, axi_regs_top.sv, 202, hackdac19
	    undetected:
		3. Type 4, dmi_jtag.sv, 224, hackdac19

    - HACKDAC21
	CONSTRAINED: 197 total detections 
	    detected:
		1. Type 2, bw_r_rf16x160.v, 395, hackdac21
		2. Type 3, bw_r_rf16x160.v, 405, hackdac21
		3. Type 4, bw_r_rf16x160.v, 411, hackdac21
	    undetected:
		4. Type 3, bw_r_rf32x80.v, 277, hackdac21
	SIMPLE: 1126 Total detections
	    detected:
		1. Type 2, bw_r_rf16x160.v, 395, hackdac21
		2. Type 3, bw_r_rf16x160.v, 405, hackdac21
		3. Type 4, bw_r_rf16x160.v, 411, hackdac21
		4. Type 3, bw_r_rf32x80.v, 277, hackdac21
	    undetected:
		none

    - PICORV32
	CONSTRAINED: 35 Total detections
	    detected:
		1. Type 3, spimemio.sv, 215, picorv32 
		2. Type 2, picorv32.v, 400, picorv32 	
	    undetected:
		none
	SIMPLE: 99 Total detections
	    detected:
		1. Type 3, spimemio.sv, 215, picorv32 
		2. Type 2, picorv32.v, 400, picorv32 	
	    undetected:
		none

    - HUMMINGBIRDV2
	CONSTRAINED: 15 total detections
	    detected: 
		none
	    undetected:
		1. Type 3, spi_master_fifo.v, 47, hummingbirdv2
		2. Type 4, sirv_qspi_arbiter.v, 218, hummingbirdv2
		3. Type 3, e203_subsys_hclkgen_rstsync.v, 51, hummingbirdv2

	SIMPLE: 44 total detections 
	    detected:
		none
	    undetected:
		1. Type 3, spi_master_fifo.v, 47, hummingbirdv2
		2. Type 4, sirv_qspi_arbiter.v, 218, hummingbirdv2
		3. Type 3, e203_subsys_hclkgen_rstsync.v, 51, hummingbirdv2

    - ULTRAEMBEDDED_SINGLE
	CONSTRAINED: 256 Total Detections
	    detected:
		1. Type 3, dcache_axi.v, 308, ultraembeddedold
	    undetected:
		
	SIMPLE:
	    detected:
		1. Type 3, dcache_axi.v, 308, ultraembeddedold
	    undetected:
    - ULTRAEMBEDDED_DUAL
	CONSTRAINED: 24 Total Detections
	    detected:
		1. Type 2, icache.v, 172, ultraembeddedNew
	    undetected:
		
	SIMPLE: 133 Total Detections
	    detected:
		1. Type 2, icache.v, 172, ultraembeddedNew
	    undetected:

## CWE-1232
    - HACKDAC18
	CONSTRAINED: 144 total detections
	    detected:
		1. Type 3, apb_gpio.sv, 305, hackdac18
		2. Type 2, safe_domain_reg_if.sv, 142, hackdac18
	    undetected:
		3. Type 4, apb_gpio.sv, 301, hackdac18

	SIMPLE: 2771 total detections
	    detected:
		1. Type 3, apb_gpio.sv, 305, hackdac18
		2. Type 2, safe_domain_reg_if.sv, 142, hackdac18
	    undetected:
		3. Type 4, apb_gpio.sv, 301, hackdac18

    - HACKDAC19
	CONSTRAINED: 38 total detections
	    detected:

	    undetected:
		1. Type 3, rrabiter.sv, 137, hackdac19 

	SIMPLE: 1327 total detections
	    detected:

	    undetected:
		1. Type 3, rrabiter.sv, 137, hackdac19 

    - HACKDAC21
	CONSTRAINED: 226 total detections
	    detected:

	    undetected:
		1. Type 3, piton_sd_cache_manager.v, 171, hackdac21

	SIMPLE: 5536 total detections
	    detected:

	    undetected:
		1. Type 3, piton_sd_cache_manager.v, 171, hackdac21

    - PICORV32
	CONSTRAINED:
	    detected:
	    undetected:
	SIMPLE:
	    detected:
	    undetected:

    - HUMMINGBIRDV2
	CONSTRAINED: 34 total detections
	    detected:
	    undetected:
		1. Type 3, sirv_pmu_core.sv, 500, hummingbirdv2

	SIMPLE: 646 total detections
	    detected:
	    undetected:
		1. Type 3, sirv_pmu_core.sv, 500, hummingbirdv2
    
    - ULTRAEMBEDDED_SINGLE
	CONSTRAINED: 13 total detections
	    detected:
	    undetected:
		1. Type 4, tcm_mem_pmem.sv, 165, ultraembedded(old)

	SIMPLE: 471 Total Detections
	    detected:
	    undetected:
		1. Type 4, tcm_mem_pmem.sv, 165, ultraembedded(old)

## CWE-1234
    - HACKDAC18
	CONSTRAINED: 0 total detections
	    detected:
	    undetected:
		1. Type 2, tap_top.v, 186, hackdac18

	SIMPLE: 22 total detections
	    detected:
		1. Type 2, tap_top.v, 186, hackdac18
	    undetected:
	
    -HACKDAC19
	CONSTRAINED: 0 total detections
	    detected:
	    undetected:
		1. Type 4, dmi_jtag.sv, 127, hackdac19

	SIMPLE: 0 total detections
	    detected:
	    undetected:
		1. Type 4, dmi_jtag.sv, 127, hackdac19
	
    -HACKDAC21
	CONSTRAINED: 4 total detections
	    detected:
	    undetected:
		1. Type 3, bw_r_rf16x160.v, 412, hackdac21

	SIMPLE: 121 total detections
	    detected:
	    undetected:
		1. Type 3, bw_r_rf16x160.v, 412, hackdac21
	
    - PICORV32
	CONSTRAINED: 0 total detections
	    detected:
	    undetected:
		1. Type 3, spimemo.v, 117, picorv32

	SIMPLE: 0 total detections
	    detected:
	    undetected:
		1. Type 3, spimemo.v, 117, picorv32
	
    - HUMMINGBIRDV2
	CONSTRAINED: 1 total detections
	    detected:
		1. Type 4, sirv_pmu_core.v, 339, humingbirdv2 
	    undetected:

	SIMPLE: 17 total detections
	    detected:
		1. Type 4, sirv_pmu_core.v, 339, humingbirdv2 
	    undetected:
	
    - ULTRAEMBEDDED_SINGLE
	CONSTRAINED: 0 total detections
	    detected:
	    undetected:
		1. Type 2, dcache_axi_axi.v, 115, ultraembedded(old)

	SIMPLE: 8 total detections
	    detected:
	    undetected:
		1. Type 2, dcache_axi_axi.v, 115, ultraembedded(old)
	
    - ULTRAEMBEDDED_DUAL
	CONSTRAINED: 0 total detections
	    detected:
	    undetected:
		1. Type 4, biriscv_lsu.v, 311, ultraemebedded(new)

	SIMPLE: 2 total detections
	    detected:
	    undetected:
		1. Type 4, biriscv_lsu.v, 311, ultraemebedded(new)
	
## CWE-1244
    - HACKDAC18
	CONSTRAINED: 0 total detections
	    detected:
	    undetected:
		1. Type 3, adbg_or1k_module.sv, 258, hackdac18
		2. Type 3, dc_token_ring_fifo_din.sv, 39, hackdac18

	SIMPLE: 1187 total detections
	    detected:
	    undetected:
		1. Type 3, adbg_or1k_module.sv, 258, hackdac18
		2. Type 3, dc_token_ring_fifo_din.sv, 39, hackdac18
	
	MODIFIED: 711 total detections
	    detected:
		1. Type 3, adbg_or1k_module.sv, 258, hackdac18
		2. Type 3, dc_token_ring_fifo_din.sv, 39, hackdac18
	    undetected:

	MODIFIED_CONSTRAINED: 20 total detections
	    detected:
	    undetected:
		1. Type 3, adbg_or1k_module.sv, 258, hackdac18
		2. Type 3, dc_token_ring_fifo_din.sv, 39, hackdac18
    
    -HACKDAC19
	CONSTRAINED: 0 total detections
	    detected:
	    undetected:
		1. Type 2, csr_regfile.sv, 963, hackdac19

	SIMPLE: 696 total detections
	    detected:
		1. Type 2, csr_regfile.sv, 963, hackdac19
	    undetected:
	
	MODIFIED: 1120 total detections
	    detected:
		1. Type 2, csr_regfile.sv, 963, hackdac19
	    undetected:

	MODIFIED_CONSTRAINED: 26 total detections
	    detected:
		1. Type 2, csr_regfile.sv, 963, hackdac19
	    undetected:

    -HACKDAC21
	CONSTRAINED: 1 total detections
	    detected:
	    undetected:
		1. Type 4, sparc_ifu_fcl.v, 2134, hackdac21

	SIMPLE: 3353 total detections
	    detected:
	    undetected:
		1. Type 4, sparc_ifu_fcl.v, 2134, hackdac21
	
	MODIFIED: 3001 total detections
	    detected:
		1. Type 4, sparc_ifu_fcl.v, 2134, hackdac21
	    undetected:

	MODIFIED_CONSTRAINED: 109 total detections
	    detected:
		1. Type 4, sparc_ifu_fcl.v, 2134, hackdac21
	    undetected:

    - PICORV32
	CONSTRAINED: 0 total detections
	    detected:
	    undetected:
		1. Type 3, picorv32.v, 380, picorv32

	SIMPLE: 3353 total detections
	    detected:
	    undetected:
		1. Type 3, picorv32.v, 380, picorv32
	
	MODIFIED: 91 total detections
	    detected:
		1. Type 3, picorv32.v, 380, picorv32
	    undetected:

	MODIFIED_CONSTRAINED: 0 total detections
	    detected:
	    undetected:
		1. Type 3, picorv32.v, 380, picorv32

    - HUMMINGBIRDV2
	CONSTRAINED: 1 total detections
	    detected:
	    undetected:
		1. type 4, spi_master_apb_if.v, 181-181, hummingbirdv2   
		2. typ3 3, e203_exu_csr.v, 304, hummingbirdv2

	SIMPLE: 1831 total detections
	    detected:
	    undetected:
		1. type 4, spi_master_apb_if.v, 181-181, hummingbirdv2   
		2. typ3 3, e203_exu_csr.v, 304, hummingbirdv2
	
	MODIFIED: 593 total detections
	    detected:
	    undetected:
		1. type 4, spi_master_apb_if.v, 181-181, hummingbirdv2   
		2. typ3 3, e203_exu_csr.v, 304, hummingbirdv2

	MODIFIED_CONSTRAINED: 16 total detections
	    detected:
	    undetected:
		1. type 4, spi_master_apb_if.v, 181-181, hummingbirdv2   
		2. typ3 3, e203_exu_csr.v, 304, hummingbirdv2

    - ULTRAEMBEDDED_SINGLE
	CONSTRAINED: 1 total detections
	    detected:
		1. Type 2, riscv_mmu.v, 205, ultraemebedded(old)
	    undetected:

	SIMPLE: 182 total detections
	    detected:
		1. Type 2, riscv_mmu.v, 205, ultraemebedded(old)
	    undetected:
	
	MODIFIED: 215 total detections
	    detected:
		1. Type 2, riscv_mmu.v, 205, ultraemebedded(old)
	    undetected:

	MODIFIED_CONSTRAINED: 1 total detections
	    detected:
	    undetected:
		1. Type 2, riscv_mmu.v, 205, ultraemebedded(old)

    - ULTRAEMBEDDED_DUAL
	CONSTRAINED: 0 total detections
	    detected:
	    undetected:
		1. Type 4, birisc_csr.v, 220, ultraembedded(new)

	SIMPLE: 193 total detections
	    detected:
	    undetected:
		1. Type 4, birisc_csr.v, 220, ultraembedded(new)
	
	MODIFIED: 182 total detections
	    detected:
		1. Type 4, birisc_csr.v, 220, ultraembedded(new)
	    undetected:

	MODIFIED_CONSTRAINED: 0 total detections
	    detected:
	    undetected:
		1. Type 4, birisc_csr.v, 220, ultraembedded(new)

## CWE-1262
    - HACKDAC18
	STANDARD: 0 Total Detections
	    datected:
	    undetected:
		1. Type 4, riscv_cs_registers.sv, 377, hackdac18

    - HACKDAC19
	STANDARD: 7 Total Detections
	    datected:
	    undetected:
		1. Type 3, csr_regfile.sv, 865, hackatdac19

    - HACKDAC21
	STANDARD: 14 Total Detections
	    datected:
	    undetected:
		1. Type 2, csr_regfile.sv, 248, hackatdac21

## CWE-1271
    - HACKDAC18
	CONSTRAINED: 54 Total Detections
	    datected:
	    undetected:
		1. Type 4, cs_registers.sv, 637-700, hackdac18

	SIMPLIFIED: 96 Total Detections
	    datected:
	    undetected:
		1. Type 4, cs_registers.sv, 637-700, hackdac18

    - HACKDAC19
	CONSTRAINED: 14 Total Detections
	    datected:
	    undetected:
		1. Type 3, csr_regfile.sv, 980-1020, hackdac19 

	SIMPLIFIED: 17 Total Detections
	    datected:
		1. Type 3, csr_regfile.sv, 980-1020, hackdac19 
	    undetected:

    - HACKDAC21
	CONSTRAINED: 91 Total Detections
	    datected:
		1. Type 2, jtag_ctap.v, 115-151, hackdac21
	    undetected:

	SIMPLIFIED: 142 Total Detections
	    datected:
		1. Type 2, jtag_ctap.v, 115-151, hackdac21
	    undetected:

## CWE-1282
    - HACKDAC19
	CONSTRAINED: 0 Total Detections
	    datected:
	    undetected:
		1. Type 4, sram.sv, 31-57, hackdac19

	SIMPLE: 17 Total Detections
	    datected:
	    undetected:
		1. Type 4, sram.sv, 31-57, hackdac19

    - HACKDAC21
	CONSTRAINED: 1 Total Detections
	    datected:
	    undetected:
		1. Type 3, sram.sv, 28-51, hackdac21

	SIMPLE: 142 Total Detections
	    datected:
	    undetected:
		1. Type 3, sram.sv, 28-51, hackdac21

