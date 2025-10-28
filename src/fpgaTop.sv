// fpgaTop.sv
// Top-level wrapper for the generated SoC (Wally_CS)
// Exposes board pins and wires them to the SoC ports.

module fpgaTop
#(
    parameter clk_mhz = 50,
    parameter w_key   = 4,
    parameter w_sw    = 18,
    parameter w_led   = 27,
    parameter w_gpio  = 36
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
    output wire [1:0]           sdram_ba,
    output wire [12:0]          sdram_addr,
    output wire                 sdram_cas_n,
    output wire                 sdram_cke,
    output wire                 sdram_cs_n,
    inout  wire [31:0]          sdram_dq,
    output wire [3:0]           sdram_dqm,
    output wire                 sdram_ras_n,
    output wire                 sdram_we_n,
    output wire                 sdram_clk_clk,

    // SRAM external pins
    inout  wire [15:0]          sram_external_interface_DQ,
    output wire [19:0]          sram_external_interface_ADDR,
    output wire                 sram_external_interface_LB_N,
    output wire                 sram_external_interface_UB_N,
    output wire                 sram_external_interface_CE_N,
    output wire                 sram_external_interface_OE_N,
    output wire                 sram_external_interface_WE_N,

    // PLL reset (top-level input so user can reset PLL)
    input  wire                 system_pll_ref_reset_reset,

    // GPIO exposed to SoC
    output wire [31:0]          wally_gpio_export1, // SoC -> external (driven to LEDs)
    // wally_gpio_export2 will be driven internally from KEY/SW
    output wire [31:0]          wally_gpio_export3, // SoC -> external

    // SDC (SD card)
    output wire                 wally_sdc_export1,
    output wire [3:0]           wally_sdc_export2,
    output wire                 wally_sdc_export3,
    input  wire                 wally_sdc_export4,

    // SPI
    output wire                 wally_spi_export1,
    output wire [3:0]           wally_spi_export2,
    input  wire                 wally_spi_export3,
    output wire                 wally_spi_export4,

    // UART
    input  wire                 wally_uart_export1,
    output wire                 wally_uart_export2
);

// ---------------------------------------------------------------------------
// Internal wiring
// Connect PLL ref clock internally to board 50 MHz clock as requested
wire system_pll_ref_clk_clk_internal = CLOCK_50;

// Build the 32-bit GPIO input to SoC from KEY and SW
// Layout: [31:22]=0, [21:18]=KEY[w_key-1:0] (padded), [17:0]=SW
wire [31:0] wally_gpio_export2_internal;
assign wally_gpio_export2_internal = { {(32 - w_key - w_sw){1'b0}}, KEY, SW };

// ---------------------------------------------------------------------------
// Instantiate generated SoC (Wally_CS) and connect ports
Wally_CS Wally_CS_inst (
    // SDRAM
    .sdram_ba                 (sdram_ba),
    .sdram_addr               (sdram_addr),
    .sdram_cas_n              (sdram_cas_n),
    .sdram_cke                (sdram_cke),
    .sdram_cs_n               (sdram_cs_n),
    .sdram_dq                 (sdram_dq),
    .sdram_dqm                (sdram_dqm),
    .sdram_ras_n              (sdram_ras_n),
    .sdram_we_n               (sdram_we_n),
    .sdram_clk_clk            (sdram_clk_clk),

    // SRAM
    .sram_external_interface_DQ   (sram_external_interface_DQ),
    .sram_external_interface_ADDR (sram_external_interface_ADDR),
    .sram_external_interface_LB_N (sram_external_interface_LB_N),
    .sram_external_interface_UB_N (sram_external_interface_UB_N),
    .sram_external_interface_CE_N (sram_external_interface_CE_N),
    .sram_external_interface_OE_N (sram_external_interface_OE_N),
    .sram_external_interface_WE_N (sram_external_interface_WE_N),

    // PLL ref clk/reset
    .system_pll_ref_clk_clk   (system_pll_ref_clk_clk_internal),
    .system_pll_ref_reset_reset (system_pll_ref_reset_reset),

    // GPIO
    .wally_gpio_export1       (wally_gpio_export1),
    .wally_gpio_export2       (wally_gpio_export2_internal),
    .wally_gpio_export3       (wally_gpio_export3),

    // SDC
    .wally_sdc_export1        (wally_sdc_export1),
    .wally_sdc_export2        (wally_sdc_export2),
    .wally_sdc_export3        (wally_sdc_export3),
    .wally_sdc_export4        (wally_sdc_export4),

    // SPI
    .wally_spi_export1        (wally_spi_export1),
    .wally_spi_export2        (wally_spi_export2),
    .wally_spi_export3        (wally_spi_export3),
    .wally_spi_export4        (wally_spi_export4),

    // UART
    .wally_uart_export1       (wally_uart_export1),
    .wally_uart_export2       (wally_uart_export2)
);

// ---------------------------------------------------------------------------
// Simple user glue
// Drive LEDs from wally_gpio_export1 (simple mapping)
assign LEDR = wally_gpio_export1[17:0];
assign LEDG = wally_gpio_export1[26:18];

// Tie HEX displays off by default (safe inactive value)
assign HEX0 = 7'b1111111;
assign HEX1 = 7'b1111111;
assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;
assign HEX6 = 7'b1111111;
assign HEX7 = 7'b1111111;

endmodule