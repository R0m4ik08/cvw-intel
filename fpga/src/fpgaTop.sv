// fpgaTop.sv
// Top-level wrapper for the generated SoC (Wally_CS)
// Exposes board pins and wires them to the SoC ports.

module fpgaTop
#(
    parameter clk_mhz = 50,
    parameter w_key   = 4,
    parameter w_sw    = 18,
    parameter w_ledr  = 18,
    parameter w_ledg  = 9
)
(
    // Board clock / reset
    input  wire                 CLOCK_50,

    // Board GPIO (buttons / switches)
    input  wire [w_key-1:0]     KEY,
    input  wire [w_sw-1:0]      SW,

    // User LEDs and HEX displays
    output wire [17:0]          LEDR,
    output wire [8:0]           LEDG,

    output wire [6:0]           HEX0,
    output wire [6:0]           HEX1,
    output wire [6:0]           HEX2,
    output wire [6:0]           HEX3,
    output wire [6:0]           HEX4,
    output wire [6:0]           HEX5,
    output wire [6:0]           HEX6,
    output wire [6:0]           HEX7,

    // SDRAM external pins
    output wire [1:0]           SDRAM_BA,
    output wire [12:0]          SDRAM_ADDR,
    output wire                 SDRAM_CAS_N,
    output wire                 SDRAM_CKE,
    output wire                 SDRAM_CS_N,
    inout  wire [31:0]          SDRAM_DQ,
    output wire [3:0]           SDRAM_DQM,
    output wire                 SDRAM_RAS_N,
    output wire                 SDRAM_WE_N,
    output wire                 SDRAM_CLK,

    // SRAM external pins
    inout  wire [15:0]          SRAM_DQ,
    output wire [19:0]          SRAM_ADDR,
    output wire                 SRAM_LB_N,
    output wire                 SRAM_UB_N,
    output wire                 SRAM_CE_N,
    output wire                 SRAM_OE_N,
    output wire                 SRAM_WE_N,

    // PLL reset (top-level input so user can reset PLL)
    input  wire                 system_pll_ref_reset_reset,

    // SD Card
    inout  wire [3:0]           SD_DAT,
    output wire                 SD_CLK,
    output wire                 SD_CMD,
    input  wire                 SD_WP_N,

    // SPI
    output wire                 SPI_CLK,
    output wire                 SPI_MOSI,
    input  wire                 SPI_MISO,
    output wire                 SPI_CS,

    // UART
    input  wire                 UART_RXD,
    output wire                 UART_TXD
);

// ---------------------------------------------------------------------------
// Internal wiring
// Connect PLL ref clock internally to board 50 MHz clock as requested
wire system_pll_ref_clk_clk_internal = CLOCK_50;

// GPIOEN from SoC to external (not used in this example)
wire [31:0]          wally_gpio_en; // SoC -> external

wire [31:0] wally_gpio_out3;

// ---------------------------------------------------------------------------
// Instantiate generated SoC (Wally_CS) and connect ports
Wally_CS Wally_CS_inst (
    //Reset
    .reset_export_reset       (KEY[0]),

    // SDRAM
    .sdram_ba                 (SDRAM_BA),
    .sdram_addr               (SDRAM_ADDR),
    .sdram_cas_n              (SDRAM_CAS_N),
    .sdram_cke                (SDRAM_CKE),
    .sdram_cs_n               (SDRAM_CS_N),
    .sdram_dq                 (SDRAM_DQ),
    .sdram_dqm                (SDRAM_DQM),
    .sdram_ras_n              (SDRAM_RAS_N),
    .sdram_we_n               (SDRAM_WE_N),
    .sdram_clk_clk            (SDRAM_CLK),

    // SRAM
    .sram_external_interface_DQ   (SRAM_DQ),
    .sram_external_interface_ADDR (SRAM_ADDR),
    .sram_external_interface_LB_N (SRAM_LB_N),
    .sram_external_interface_UB_N (SRAM_UB_N),
    .sram_external_interface_CE_N (SRAM_CE_N),
    .sram_external_interface_OE_N (SRAM_OE_N),
    .sram_external_interface_WE_N (SRAM_WE_N),

    // PLL ref clk/reset
    .system_pll_ref_clk_clk   (system_pll_ref_clk_clk_internal),
    .system_pll_ref_reset_reset (system_pll_ref_reset_reset),

    // GPIO
    .wally_gpio_export1       (wally_gpio_en),
    .wally_gpio_export2       ({ {(32 - w_key - w_sw){1'b0}}, SW, KEY[w_key-1:1], 1'b0}),
    .wally_gpio_export3       (wally_gpio_out3),

    // SD Card
    .wally_sdc_export1        (SD_CLK),
    .wally_sdc_export2        (SD_DAT),
    .wally_sdc_export3        (SD_CMD),
    .wally_sdc_export4        (SD_WP_N),

    // SPI
    .wally_spi_export1        (SPI_CLK),
    .wally_spi_export2        (SPI_MOSI),
    .wally_spi_export3        (SPI_MISO),
    .wally_spi_export4        (SPI_CS),

    // UART
    .wally_uart_export1       (UART_RXD),
    .wally_uart_export2       (UART_TXD)
);

assign LEDR = wally_gpio_out3[w_ledr-1 : 0];
assign LEDG = wally_gpio_out3[w_ledr + w_ledg - 1 : w_ledr];

// Tie HEX displays off by default (safe inactive value)
assign HEX0 = 7'h7f;
assign HEX1 = 7'h7f;
assign HEX2 = 7'h7f;
assign HEX3 = 7'h7f;
assign HEX4 = 7'h7f;
assign HEX5 = 7'h7f;
assign HEX6 = 7'h7f;
assign HEX7 = 7'h7f;

endmodule