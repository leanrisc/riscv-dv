/*
 * Copyright 2019 Google LLC
 * Copyright 2022 Coverify Systems Technology
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//-----------------------------------------------------------------------------
// Processor feature configuration
//-----------------------------------------------------------------------------
// XLEN

module riscv.gen.target.rv64imafdc.riscv_core_setting;

import riscv.gen.riscv_instr_pkg: satp_mode_t, privileged_mode_t,
  riscv_instr_name_t, mtvec_mode_t, interrupt_cause_t,
  exception_cause_t, riscv_instr_group_t, privileged_reg_t;
import esdl: ubvec, flog2;

enum int XLEN = 64;

// Parameter for SATP mode, set to BARE if address translation is not supported
enum satp_mode_t SATP_MODE = satp_mode_t.SV39;

// Supported Privileged mode
privileged_mode_t[] supported_privileged_mode = [privileged_mode_t.USER_MODE,
						 privileged_mode_t.SUPERVISOR_MODE,
						 privileged_mode_t.MACHINE_MODE];

// Unsupported instructions
riscv_instr_name_t[] unsupported_instr = [];

// ISA supported by the processor
riscv_instr_group_t[] supported_isa = [riscv_instr_group_t.RV32I,
				       riscv_instr_group_t.RV32M,
				       riscv_instr_group_t.RV64I,
				       riscv_instr_group_t.RV64M,
				       riscv_instr_group_t.RV32C,
				       riscv_instr_group_t.RV64C,
				       riscv_instr_group_t.RV32A,
				       riscv_instr_group_t.RV64A,
				       riscv_instr_group_t.RV32F,
				       riscv_instr_group_t.RV64F,
				       riscv_instr_group_t.RV32D,
				       riscv_instr_group_t.RV64D,
				       riscv_instr_group_t.RV32X];

// Interrupt mode support
mtvec_mode_t[] supported_interrupt_mode = [mtvec_mode_t.DIRECT,
					   mtvec_mode_t.VECTORED];

// The number of interrupt vectors to be generated, only used if VECTORED interrupt mode is
// supported
enum int max_interrupt_vector_num = 16;

// Physical memory protection support
enum bool support_pmp = false;

// Enhanced physical memory protection support
enum bool support_epmp = false;

// Debug mode support
enum bool support_debug_mode = false;

// Support delegate trap to user mode
enum bool support_umode_trap = false;

// Support sfence.vma instruction
enum bool support_sfence = true;

// Support unaligned load/store
enum bool support_unaligned_load_store = true;

// GPR setting
enum int NUM_FLOAT_GPR = 32;
enum int NUM_GPR = 32;
enum int NUM_VEC_GPR = 32;
// ----------------------------------------------------------------------------
// Vector extension configuration
// ----------------------------------------------------------------------------

// Parameter for vector extension
enum int VECTOR_EXTENSION_ENABLE = 0;

enum int VLEN = 512;

// Maximum size of a single vector element
enum int ELEN = 32;

// Minimum size of a sub-element, which must be at most 8-bits.
enum int SELEN = 8;

// Maximum size of a single vector element (encoded in vsew format)
enum int VELEN = flog2(ELEN) - 3;

static assert (VELEN == 2);

// Maxium LMUL supported by the core
enum int MAX_LMUL = 8;

// ----------------------------------------------------------------------------
// Multi-harts configuration
// ----------------------------------------------------------------------------

// Number of harts
enum int NUM_HARTS = 1;

// ----------------------------------------------------------------------------
// Previleged CSR implementation
// ----------------------------------------------------------------------------

// Implemented previlieged CSR list
enum privileged_reg_t[] implemented_csr = [
    // User mode CSR
    privileged_reg_t.USTATUS,    // User status
    privileged_reg_t.UIE,        // User interrupt-enable register
    privileged_reg_t.UTVEC,      // User trap-handler base address
    privileged_reg_t.USCRATCH,   // Scratch register for user trap handlers
    privileged_reg_t.UEPC,       // User exception program counter
    privileged_reg_t.UCAUSE,     // User trap cause
    privileged_reg_t.UTVAL,      // User bad address or instruction
    privileged_reg_t.UIP,        // User interrupt pending
    // Supervisor mode CSR
    privileged_reg_t.SSTATUS,    // Supervisor status
    privileged_reg_t.SEDELEG,    // Supervisor exception delegation register
    privileged_reg_t.SIDELEG,    // Supervisor interrupt delegation register
    privileged_reg_t.SIE,        // Supervisor interrupt-enable register
    privileged_reg_t.STVEC,      // Supervisor trap-handler base address
    privileged_reg_t.SCOUNTEREN, // Supervisor counter enable
    privileged_reg_t.SSCRATCH,   // Scratch register for supervisor trap handlers
    privileged_reg_t.SEPC,       // Supervisor exception program counter
    privileged_reg_t.SCAUSE,     // Supervisor trap cause
    privileged_reg_t.STVAL,      // Supervisor bad address or instruction
    privileged_reg_t.SIP,        // Supervisor interrupt pending
    privileged_reg_t.SATP,       // Supervisor address translation and protection
    // Machine mode mode CSR
    privileged_reg_t.MVENDORID,  // Vendor ID
    privileged_reg_t.MARCHID,    // Architecture ID
    privileged_reg_t.MIMPID,     // Implementation ID
    privileged_reg_t.MHARTID,    // Hardware thread ID
    privileged_reg_t.MSTATUS,    // Machine status
    privileged_reg_t.MISA,       // ISA and extensions
    privileged_reg_t.MEDELEG,    // Machine exception delegation register
    privileged_reg_t.MIDELEG,    // Machine interrupt delegation register
    privileged_reg_t.MIE,        // Machine interrupt-enable register
    privileged_reg_t.MTVEC,      // Machine trap-handler base address
    privileged_reg_t.MCOUNTEREN, // Machine counter enable
    privileged_reg_t.MSCRATCH,   // Scratch register for machine trap handlers
    privileged_reg_t.MEPC,       // Machine exception program counter
    privileged_reg_t.MCAUSE,     // Machine trap cause
    privileged_reg_t.MTVAL,      // Machine bad address or instruction
    privileged_reg_t.MIP,        // Machine interrupt pending
    // Floating point CSR
    privileged_reg_t.FCSR        // Floating point control and status
];

// Implementation-specific custom CSRs
ubvec!12[] custom_csr = [];

// ----------------------------------------------------------------------------
// Supported interrupt/exception setting, used for functional coverage
// ----------------------------------------------------------------------------

enum interrupt_cause_t[] implemented_interrupt = [interrupt_cause_t.U_SOFTWARE_INTR,
						  interrupt_cause_t.S_SOFTWARE_INTR,
						  interrupt_cause_t.M_SOFTWARE_INTR,
						  interrupt_cause_t.U_TIMER_INTR,
						  interrupt_cause_t.S_TIMER_INTR,
						  interrupt_cause_t.M_TIMER_INTR,
						  interrupt_cause_t.U_EXTERNAL_INTR,
						  interrupt_cause_t.S_EXTERNAL_INTR,
						  interrupt_cause_t.M_EXTERNAL_INTR];

enum exception_cause_t[] implemented_exception = [exception_cause_t.INSTRUCTION_ACCESS_FAULT,
						  exception_cause_t.ILLEGAL_INSTRUCTION,
						  exception_cause_t.BREAKPOINT,
						  exception_cause_t.LOAD_ADDRESS_MISALIGNED,
						  exception_cause_t.LOAD_ACCESS_FAULT,
						  exception_cause_t.STORE_AMO_ADDRESS_MISALIGNED,
						  exception_cause_t.STORE_AMO_ACCESS_FAULT,
						  exception_cause_t.ECALL_UMODE,
						  exception_cause_t.ECALL_SMODE,
						  exception_cause_t.ECALL_MMODE,
						  exception_cause_t.INSTRUCTION_PAGE_FAULT,
						  exception_cause_t.LOAD_PAGE_FAULT,
						  exception_cause_t.STORE_AMO_PAGE_FAULT
						  ];
