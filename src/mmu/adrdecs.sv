///////////////////////////////////////////
// adrdecs.sv
//
// Written: David_Harris@hmc.edu 22 June 2021
// Modified: 
//
// Purpose: All the address decoders for peripherals
// 
// Documentation: RISC-V System on Chip Design
//
// A component of the CORE-V-WALLY configurable RISC-V project.
// https://github.com/openhwgroup/cvw
// 
// Copyright (C) 2021-23 Harvey Mudd College & Oklahoma State University
//
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the “License”); you may not use this file 
// except in compliance with the License, or, at your option, the Apache License version 2.0. You 
// may obtain a copy of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work distributed under the 
// License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
// either express or implied. See the License for the specific language governing permissions 
// and limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////

  // verilator lint_off UNOPTFLAT 

module adrdecs import config_pkg::*; (
  input  logic [PA_BITS-1:0] PhysicalAddress,
  input  logic                 AccessRW, AccessRX, AccessRWXC,
  input  logic [1:0]           Size,
  output logic [11:0]          SelRegions
);

  localparam logic [3:0]       SUPPORTED_SIZE = (LLEN == 32 ? 4'b0111 : 4'b1111);
 // Determine which region of physical memory (if any) is being accessed
  adrdec #(PA_BITS) dtimdec(PhysicalAddress, DTIM_BASE[PA_BITS-1:0], DTIM_RANGE[PA_BITS-1:0], DTIM_SUPPORTED, AccessRW, Size, SUPPORTED_SIZE, SelRegions[1]);  
  adrdec #(PA_BITS) iromdec(PhysicalAddress, IROM_BASE[PA_BITS-1:0], IROM_RANGE[PA_BITS-1:0], IROM_SUPPORTED, AccessRX, Size, SUPPORTED_SIZE, SelRegions[2]);  
  adrdec #(PA_BITS) ddr4dec(PhysicalAddress, EXT_MEM_BASE[PA_BITS-1:0], EXT_MEM_RANGE[PA_BITS-1:0], EXT_MEM_SUPPORTED, AccessRWXC, Size, SUPPORTED_SIZE, SelRegions[3]);  
  adrdec #(PA_BITS) bootromdec(PhysicalAddress, BOOTROM_BASE[PA_BITS-1:0], BOOTROM_RANGE[PA_BITS-1:0], BOOTROM_SUPPORTED, AccessRX, Size, SUPPORTED_SIZE, SelRegions[4]);
  adrdec #(PA_BITS) uncoreramdec(PhysicalAddress, UNCORE_RAM_BASE[PA_BITS-1:0], UNCORE_RAM_RANGE[PA_BITS-1:0], UNCORE_RAM_SUPPORTED, AccessRWXC, Size, SUPPORTED_SIZE, SelRegions[5]);
  adrdec #(PA_BITS) clintdec(PhysicalAddress, CLINT_BASE[PA_BITS-1:0], CLINT_RANGE[PA_BITS-1:0], CLINT_SUPPORTED, AccessRW, Size, SUPPORTED_SIZE, SelRegions[6]);
  adrdec #(PA_BITS) gpiodec(PhysicalAddress, GPIO_BASE[PA_BITS-1:0], GPIO_RANGE[PA_BITS-1:0], GPIO_SUPPORTED, AccessRW, Size, 4'b0100, SelRegions[7]);
  adrdec #(PA_BITS) uartdec(PhysicalAddress, UART_BASE[PA_BITS-1:0], UART_RANGE[PA_BITS-1:0], UART_SUPPORTED, AccessRW, Size, 4'b0001, SelRegions[8]);
  adrdec #(PA_BITS) plicdec(PhysicalAddress, PLIC_BASE[PA_BITS-1:0], PLIC_RANGE[PA_BITS-1:0], PLIC_SUPPORTED, AccessRW, Size, 4'b0100, SelRegions[9]);
  adrdec #(PA_BITS) sdcdec(PhysicalAddress, SDC_BASE[PA_BITS-1:0], SDC_RANGE[PA_BITS-1:0], SDC_SUPPORTED, AccessRW, Size, SUPPORTED_SIZE & 4'b1100, SelRegions[10]); 
  adrdec #(PA_BITS) spidec(PhysicalAddress, SPI_BASE[PA_BITS-1:0], SPI_RANGE[PA_BITS-1:0], SPI_SUPPORTED, AccessRW, Size, 4'b0100, SelRegions[11]);

  assign SelRegions[0] = ~|(SelRegions[11:1]); // none of the regions are selected
endmodule

  // verilator lint_on UNOPTFLAT 
