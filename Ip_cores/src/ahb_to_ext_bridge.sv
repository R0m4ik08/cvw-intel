// ahb_to_ext_bridge.sv
`timescale 1ns/1ps
module ahb_to_ext_bridge #(
    parameter integer AHB_ADDR_W = 32,
    parameter integer AHB_DATA_W = 32,
    parameter integer EXT_ADDR_W = 30,
    parameter integer EXT_DATA_W = 32  // must be multiple of 8 and one of {8,16,32,64,128}
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
    reg [1:0] state, next_state;

    // store captured control during address phase
    reg [AHB_ADDR_W-1:0] addr_reg;
    reg                  write_reg;
    reg [2:0]            size_reg;
    reg [AHB_DATA_W-1:0] wdata_reg;

    // helper: HTRANS decode (NONSEQ/SEQ are valid)
    wire trans_valid = (htrans == 2'b10) || (htrans == 2'b11); // NONSEQ or SEQ

    // Compute byteenable function (handles EXT_DATA_W >= AHB_DATA_W)
    function automatic [(EXT_DATA_W/8)-1:0] calc_byteenable;
        integer bs, i, byte_index;

        input [AHB_ADDR_W-1:0] addr;
        input [2:0] size;
        begin
            // zero default
            calc_byteenable = '0;
            // number of bytes for transfer
            bs = 1 << size; // 1<<HSIZE gives bytes (HSIZE:0->1,1->2,2->4 etc.)
            // assume AHB_DATA_W <= EXT_DATA_W
            // byte_offset = addr[log2(EXT_DATA_W/8)-1:0]
            byte_index = addr[$clog2(EXT_DATA_W/8)-1:0];
            // set bs ones starting at byte_index
            for (i=0;i<bs;i=i+1) begin
                if ((byte_index + i) < (EXT_DATA_W/8))
                    calc_byteenable[byte_index + i] = 1'b1;
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
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                // if new transfer requested in address phase
                if (hsel && trans_valid) begin
                    addr_reg <= haddr;
                    write_reg <= hwrite;
                    size_reg <= hsize;
                    wdata_reg <= hwdata;
                end
            end

            // handle ext signals and outputs in states
            case (state)
                IDLE: begin
                    hreadyout <= 1'b1;
                    hresp <= 2'b00;
                    ext_read <= 1'b0;
                    ext_write <= 1'b0;
                end
                ADDR: begin
                    // assert external commands
                    ext_addr <= addr_reg[EXT_ADDR_W-1:0];
                    if (write_reg) begin
                        // align AHB write data into EXT width (lower bits)
                        ext_wdata <= {{(EXT_DATA_W-AHB_DATA_W){1'b0}}, wdata_reg}; // put AHB in LSB side
                        ext_byteenable <= calc_byteenable(addr_reg, size_reg);
                        ext_write <= 1'b1;
                        ext_read <= 1'b0;
                    end else begin
                        ext_byteenable <= calc_byteenable(addr_reg, size_reg);
                        ext_read <= 1'b1;
                        ext_write <= 1'b0;
                    end
                    // while waiting for ack, we'll set hreadyout=0 in WAIT_ACK
                    hreadyout <= 1'b1; // still claim ready in this cycle (address accepted)
                end
                WAIT_ACK: begin
                    // hold ext_* asserted until ext_ack asserted
                    hreadyout <= ext_ack ? 1'b1 : 1'b0;
                    if (ext_ack) begin
                        // capture read data
                        if (!write_reg) begin
                            // provide lower AHB_DATA_W bits; higher bits ignored for now
                            hrdata <= ext_rdata[AHB_DATA_W-1:0];
                        end
                        hresp <= 2'b00; // OKAY (future: set ERROR if ext indicates)
                        ext_read <= 1'b0;
                        ext_write <= 1'b0;
                        ext_byteenable <= '0;
                    end
                end
                RESP: begin
                    // short state to present HRDATA/HRESP if needed
                    hreadyout <= 1'b1;
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
                if (ext_ack) next_state = RESP;
            end
            RESP: begin
                // go back to IDLE or accept next transfer immediately (if HTRANS==SEQ and HSEL)
                if (hsel && trans_valid) next_state = ADDR;
                else next_state = IDLE;
            end
        endcase
    end

endmodule
