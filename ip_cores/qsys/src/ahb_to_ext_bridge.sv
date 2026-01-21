// ahb_to_ext_bridge.sv
// AHB-Lite to External Bus Bridge
//
// Debug output can be enabled by setting parameter DEBUG=1:
//   - State transitions
//   - Address and data phase captures
//   - External bus read/write operations
//   - Protocol violations and warnings
//   - Timing issues (stuck states, long waits)
//
`timescale 1ns/1ps
module ahb_to_ext_bridge #(
    parameter integer AHB_ADDR_W = 32,
    parameter integer AHB_DATA_W = 32,
    parameter integer EXT_ADDR_W = 30,
    parameter integer EXT_DATA_W = 32,  // must be multiple of 8 and one of {8,16,32,64,128}
    parameter integer DEBUG = 0           // Enable debug output (0=off, 1=on)
) (
    // Global
    input  wire                    clk,
    input  wire                    rst_n,

    // AHB slave interface (AHB-Lite)
    input  wire                    hsel,
    input  wire [AHB_ADDR_W-1:0]   haddr,
    input  wire [1:0]              htrans,
    input  wire                    hwrite,
    input  wire [2:0]              hsize,
    input  wire [AHB_DATA_W-1:0]   hwdata,
    output reg  [AHB_DATA_W-1:0]   hrdata,
    output reg  [1:0]              hresp,
    output reg                     hreadyout,

    // External bus (to External Bus to Avalon Bridge IP)
    output reg  [EXT_ADDR_W-1:0]   ext_addr,
    output reg                     ext_read,
    output reg                     ext_write,
    output reg  [EXT_DATA_W-1:0]   ext_wdata,
    output reg  [(EXT_DATA_W/8)-1:0] ext_byteenable,
    input  wire [EXT_DATA_W-1:0]   ext_rdata,
    input  wire                    ext_ack
);

    // local params
    localparam IDLE = 2'd0, ADDR = 2'd1, WAIT_ACK = 2'd2, RESP = 2'd3;
    localparam EXT_ADDR_OFFSET = $clog2(EXT_DATA_W/8); // 2 for 32-bit, 3 for 64-bit, etc.
    reg [1:0] state, next_state;
    
    // Combinational hreadyout signal (based on next_state for zero-latency response)
    reg hreadyout_next;

    // store captured control during address phase
    reg [AHB_ADDR_W-1:0] addr_reg;
    reg                  write_reg;
    reg [2:0]            size_reg;
    reg [AHB_DATA_W-1:0] wdata_reg;
    
    // Debug counters (only used when DEBUG=1)
    integer wait_cycles;
    integer stuck_count;

    // helper: HTRANS decode (NONSEQ/SEQ are valid)
    wire trans_valid = (htrans == 2'b10) || (htrans == 2'b11); // NONSEQ or SEQ
    
    // Byte offset for data alignment (synthesizable)
    wire [EXT_ADDR_OFFSET-1:0] byte_offset = addr_reg[EXT_ADDR_OFFSET-1:0];

    // Debug: State name function
    function string get_state_name(input [1:0] st);
        case (st)
            IDLE:     get_state_name = "IDLE";
            ADDR:     get_state_name = "ADDR";
            WAIT_ACK: get_state_name = "WAIT_ACK";
            RESP:     get_state_name = "RESP";
            default:  get_state_name = "UNKNOWN";
        endcase
    endfunction

    // Debug: Size name function
    // HSIZE encoding (bit 2 = unsigned flag, bits [1:0] = size):
    //   000 = Byte (8-bit signed)
    //   001 = Halfword (16-bit signed)
    //   010 = Word (32-bit)
    //   011 = Doubleword (64-bit)
    //   100 = Unsigned Byte (8-bit)
    //   101 = Unsigned Halfword (16-bit)
    function string get_size_name(input [2:0] size);
        case (size)
            3'b000: get_size_name = "BYTE";
            3'b001: get_size_name = "HWORD";
            3'b010: get_size_name = "WORD";
            3'b011: get_size_name = "DWORD";
            3'b100: get_size_name = "UBYTE";
            3'b101: get_size_name = "UHWORD";
            default: get_size_name = "UNKNOWN";
        endcase
    endfunction

    // Get number of bytes for transfer based on HSIZE
    // HSIZE[2] = unsigned flag (doesn't affect byte count)
    // HSIZE[1:0] = actual size (0=1byte, 1=2bytes, 2=4bytes, 3=8bytes)
    function automatic integer get_transfer_bytes(input [2:0] size);
        begin
            // Use only lower 2 bits for size calculation
            // size[2] is the unsigned flag and doesn't affect byte count
            get_transfer_bytes = 1 << size[1:0];
        end
    endfunction

    // Generate read data mask based on HSIZE
    // Masks out upper bits to return only the requested data size
    function automatic [AHB_DATA_W-1:0] calc_read_mask(input [2:0] size);
        begin
            case (size[1:0])
                2'b00: calc_read_mask = {{(AHB_DATA_W-8){1'b0}}, 8'hFF};           // Byte: 0x000000FF
                2'b01: calc_read_mask = {{(AHB_DATA_W-16){1'b0}}, 16'hFFFF};       // Halfword: 0x0000FFFF
                2'b10: calc_read_mask = {AHB_DATA_W{1'b1}};                        // Word: 0xFFFFFFFF
                2'b11: calc_read_mask = {AHB_DATA_W{1'b1}};                        // Doubleword: full width
                default: calc_read_mask = {AHB_DATA_W{1'b1}};
            endcase
        end
    endfunction

    // Compute byteenable function (handles EXT_DATA_W >= AHB_DATA_W)
    function automatic [(EXT_DATA_W/8)-1:0] calc_byteenable;
        integer bs, i, byte_index;
        integer total_bytes;
        input [AHB_ADDR_W-1:0] addr;
        input [2:0] size;
        begin
            // zero default
            calc_byteenable = '0;
            // number of bytes for transfer (using only size[1:0])
            bs = get_transfer_bytes(size);
            // total bytes in EXT word (constant)
            total_bytes = EXT_DATA_W/8;
            // byte_offset = addr[log2(EXT_DATA_W/8)-1:0]
            byte_index = addr[$clog2(EXT_DATA_W/8)-1:0];
            // iterate over constant bound total_bytes to satisfy synthesizer
            for (i = 0; i < total_bytes; i = i + 1) begin
                if ((i >= byte_index) && (i < byte_index + bs))
                    calc_byteenable[i] = 1'b1;
            end
        end
    endfunction

    // capture address phase
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            addr_reg <= '0;
            write_reg <= 1'b0;
            size_reg <= 3'b000;
            wdata_reg <= '0;
            hreadyout <= 1'b1;
            hresp <= 2'b00; // OKAY
            ext_read <= 1'b0;
            ext_write <= 1'b0;
            ext_addr <= '0;
            ext_wdata <= '0;
            ext_byteenable <= '0;
            hrdata <= '0;
            if (DEBUG) begin
                wait_cycles <= 0;
                stuck_count <= 0;
            end
        end else begin
            // Debug: State transition
            if (DEBUG && (state != next_state)) begin
                $display("[%0t] [AHB_BRIDGE] State transition: %s -> %s", 
                         $time, get_state_name(state), get_state_name(next_state));
            end
            
            state <= next_state;
            hreadyout <= hreadyout_next;  // Update hreadyout from combinational logic

            // Capture address phase signals only when hreadyout = 1 (AHB-Lite requirement)
            // This allows capture in IDLE state or RESP state (for back-to-back transfers)
            if ((state == IDLE || state == RESP) && hreadyout) begin
                if (hsel && trans_valid) begin
                    addr_reg <= haddr;
                    write_reg <= hwrite;
                    size_reg <= hsize;
                    // Note: hwdata is captured in ADDR state (data phase)
                    
                    // Debug: Address phase capture
                    if (DEBUG) begin
                        $display("[%0t] [AHB_BRIDGE] Address phase captured: addr=0x%0h, %s, size=%s, htrans=%b, hreadyout=%b", 
                                 $time, haddr, hwrite ? "WRITE" : "READ", get_size_name(hsize), htrans, hreadyout);
                    end
                end else begin
                    // Debug: Invalid transaction attempt
                    if (DEBUG && hsel && !trans_valid) begin
                        $display("[%0t] [AHB_BRIDGE] WARNING: hsel=1 but trans invalid (htrans=%b)", 
                                 $time, htrans);
                    end
                end
            end

            // Capture hwdata in ADDR state (data phase of AHB-Lite)
            // hwdata is valid when we enter ADDR state (hreadyout was 1 in previous cycle)
            // Store it for potential use in WAIT_ACK state
            if (state == ADDR) begin
                wdata_reg <= hwdata;
                
                // Debug: Data phase capture
                if (DEBUG) begin
                    $display("[%0t] [AHB_BRIDGE] Data phase captured: hwdata=0x%0h (stored in wdata_reg)", 
                             $time, hwdata);
                end
            end

            // handle ext signals and outputs in states
            case (state)
                IDLE: begin
                    // hreadyout is driven by hreadyout_next combinational logic
                    hresp <= 2'b00;
                    ext_read <= 1'b0;
                    ext_write <= 1'b0;
                end
                ADDR: begin
                    // Reset debug counters when entering ADDR state
                    if (DEBUG) begin
                        wait_cycles <= 0;
                        stuck_count <= 0;
                    end
                    
                    // Address alignment: drop lower bits for word alignment
                    // ext_addr is word-aligned (lower EXT_ADDR_OFFSET bits are dropped)
                    ext_addr <= addr_reg[AHB_ADDR_W-EXT_ADDR_OFFSET-1:0];
                    
                    if (write_reg) begin
                        // Data alignment: shift data by byte offset
                        // Use hwdata directly (valid in data phase) or use wdata_reg from previous cycle
                        // For first cycle in ADDR, use hwdata; it will be captured in wdata_reg for next cycle
                        ext_wdata <= (hwdata << (byte_offset * 8));
                        ext_byteenable <= calc_byteenable(addr_reg, size_reg);
                        ext_write <= 1'b1;
                        ext_read <= 1'b0;
                        
                        // Debug: External bus write
                        if (DEBUG) begin
                            $display("[%0t] [AHB_BRIDGE] EXT_WRITE: ext_addr=0x%0h, ext_wdata=0x%0h, byteen=0x%0h, byte_offset=%0d", 
                                     $time, addr_reg[AHB_ADDR_W-1:EXT_ADDR_OFFSET], 
                                     (hwdata << (byte_offset * 8)), 
                                     calc_byteenable(addr_reg, size_reg), byte_offset);
                            $display("[%0t] [AHB_BRIDGE]   AHB: addr=0x%0h, wdata=0x%0h, size=%s", 
                                     $time, addr_reg, hwdata, get_size_name(size_reg));
                        end
                    end else begin
                        ext_byteenable <= calc_byteenable(addr_reg, size_reg);
                        ext_read <= 1'b1;
                        ext_write <= 1'b0;
                        
                        // Debug: External bus read
                        if (DEBUG) begin
                            $display("[%0t] [AHB_BRIDGE] EXT_READ: ext_addr=0x%0h, byteen=0x%0h, byte_offset=%0d", 
                                     $time, addr_reg[AHB_ADDR_W-1:EXT_ADDR_OFFSET], 
                                     calc_byteenable(addr_reg, size_reg), byte_offset);
                            $display("[%0t] [AHB_BRIDGE]   AHB: addr=0x%0h, size=%s", 
                                     $time, addr_reg, get_size_name(size_reg));
                        end
                    end
                    // hreadyout is driven by hreadyout_next combinational logic
                end
                WAIT_ACK: begin
                    // hold ext_* asserted until ext_ack asserted
                    // hreadyout is driven by hreadyout_next combinational logic
                    
                    // Debug: Waiting for ack
                    if (DEBUG && !ext_ack) begin
                        $display("[%0t] [AHB_BRIDGE] WAIT_ACK: Waiting for ext_ack (ext_read=%b, ext_write=%b)", 
                                 $time, ext_read, ext_write);
                    end
                    
                    if (ext_ack) begin
                        // Reset debug counters on ack
                        if (DEBUG) begin
                            wait_cycles <= 0;
                            stuck_count <= 0;
                        end
                        
                        // capture read data
                        if (!write_reg) begin
                            // Data alignment: 
                            // 1. Shift data right to extract bytes from byte_offset position
                            // 2. Apply mask based on hsize to clear unused upper bits
                            hrdata <= (ext_rdata >> (byte_offset * 8)) & calc_read_mask(size_reg);
                            
                            // Debug: Read data received
                            if (DEBUG) begin
                                $display("[%0t] [AHB_BRIDGE] EXT_ACK received (READ): ext_rdata=0x%0h, shifted=0x%0h, mask=0x%0h, hrdata=0x%0h", 
                                         $time, ext_rdata, ext_rdata >> (byte_offset * 8), calc_read_mask(size_reg),
                                         (ext_rdata >> (byte_offset * 8)) & calc_read_mask(size_reg));
                            end
                        end else begin
                            // Debug: Write ack received
                            if (DEBUG) begin
                                $display("[%0t] [AHB_BRIDGE] EXT_ACK received (WRITE): Write completed", $time);
                            end
                        end
                        hresp <= 2'b00; // OKAY (future: set ERROR if ext indicates)
                        ext_read <= 1'b0;
                        ext_write <= 1'b0;
                        ext_byteenable <= '0;
                    end else begin
                        // Debug: Warning if waiting too long
                        if (DEBUG) begin
                            wait_cycles <= wait_cycles + 1;
                            if (wait_cycles > 10) begin
                                $display("[%0t] [AHB_BRIDGE] WARNING: Waiting for ext_ack for %0d cycles!", 
                                         $time, wait_cycles);
                                wait_cycles <= 0;
                            end
                            
                            // Check for stuck state
                            stuck_count <= stuck_count + 1;
                            if (stuck_count > 20) begin
                                $display("[%0t] [AHB_BRIDGE] ERROR: Stuck in WAIT_ACK for %0d cycles! ext_ack=%b, ext_read=%b, ext_write=%b", 
                                         $time, stuck_count, ext_ack, ext_read, ext_write);
                                stuck_count <= 0;
                            end
                        end
                    end
                end
                RESP: begin
                    // short state to present HRDATA/HRESP if needed
                    // hreadyout is driven by hreadyout_next combinational logic
                    
                    // Debug: Response phase
                    if (DEBUG) begin
                        if (!write_reg) begin
                            $display("[%0t] [AHB_BRIDGE] RESP: Presenting hrdata=0x%0h to AHB master", 
                                     $time, hrdata);
                        end else begin
                            $display("[%0t] [AHB_BRIDGE] RESP: Write transaction completed", $time);
                        end
                    end
                end
            endcase
        end
    end

    // next_state combinatorial
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (hsel && trans_valid) next_state = ADDR;
            end
            ADDR: begin
                next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ext_ack) begin
                    next_state = RESP;
                    if (DEBUG) stuck_count <= 0; // Reset counter on successful ack
                end else begin
                    // Debug: Check for stuck state (handled in always block)
                end
            end
            RESP: begin
                // go back to IDLE or accept next transfer immediately (if HTRANS==SEQ and HSEL)
                if (hsel && trans_valid) next_state = ADDR;
                else next_state = IDLE;
            end
            default: begin
                // Debug: Invalid state (only report if not during reset)
                if (DEBUG && rst_n) begin
                    $display("[%0t] [AHB_BRIDGE] ERROR: Invalid state %b!", $time, state);
                end
                next_state = IDLE;
            end
        endcase
    end

    // hreadyout_next combinatorial (based on next_state for zero-latency response)
    // This ensures hreadyout changes in the same cycle as the state transition decision
    always @(*) begin
        case (next_state)
            IDLE:     hreadyout_next = 1'b1;  // Ready to accept new transaction
            ADDR:     hreadyout_next = 1'b0;  // Processing - insert wait state
            WAIT_ACK: hreadyout_next = ext_ack;  // Wait for external bus acknowledgment
            RESP:     hreadyout_next = 1'b1;  // Transaction complete, data ready
            default:  hreadyout_next = 1'b1;  // Default to ready
        endcase
    end

    // Debug: Monitor critical signals
    generate
        if (DEBUG) begin
            always @(posedge clk) begin
                // Check for protocol violations
                if (hsel && !hreadyout && (htrans == 2'b10 || htrans == 2'b11)) begin
                    $display("[%0t] [AHB_BRIDGE] WARNING: AHB transaction active but hreadyout=0 (state=%s)", 
                             $time, get_state_name(state));
                end
                
                // Check for unexpected ext_ack
                if (ext_ack && !ext_read && !ext_write) begin
                    $display("[%0t] [AHB_BRIDGE] ERROR: ext_ack asserted without ext_read or ext_write! (state=%s)", 
                             $time, get_state_name(state));
                end
                
                // Check for simultaneous read and write
                if (ext_read && ext_write) begin
                    $display("[%0t] [AHB_BRIDGE] ERROR: Both ext_read and ext_write asserted simultaneously! (state=%s)", 
                             $time, get_state_name(state));
                end
                
                // Check for address alignment issues
                if (state == ADDR) begin
                    if (addr_reg[EXT_ADDR_OFFSET-1:0] != 0 && size_reg >= 2'b10) begin
                        $display("[%0t] [AHB_BRIDGE] WARNING: Word/DWord access to unaligned address 0x%0h (offset=%0d)", 
                                 $time, addr_reg, addr_reg[EXT_ADDR_OFFSET-1:0]);
                    end
                end
            end
        end
    endgenerate

endmodule
