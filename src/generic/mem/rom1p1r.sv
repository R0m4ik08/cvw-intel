///////////////////////////////////////////
// rom1p1r
//
// Written: David_Harris@hmc.edu 8/24/22
//
// Purpose: Single-ported ROM
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

// This model actually works correctly with vivado.

module rom1p1r #(parameter ADDR_WIDTH = 8, DATA_WIDTH = 32, PRELOAD_ENABLED = 0)
  (input  logic                  clk,
   input  logic                  ce,
   input  logic [ADDR_WIDTH-1:0] addr,
   output logic [DATA_WIDTH-1:0] dout
);

rom1p1r_	#(.DEPTH(2**ADDR_WIDTH), .WIDTH(DATA_WIDTH))	rom1p1r__inst (
	.address ( addr ),
	.clken ( ce ),
	.clock ( clk ),
	.q ( dout )
	);
   

endmodule 
