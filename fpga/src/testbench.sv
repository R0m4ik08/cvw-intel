`timescale 1ns / 1ns

module testbench;

    // ------------------------------------------------------------------------
    // Параметры, совпадающие с top-level
    localparam CLK_PERIOD_NS = 20;  // 50 МГц = 20 нс

    // ------------------------------------------------------------------------
    // Сигналы для подключения
    logic        CLOCK_50;
    logic [ 3:0] KEY;
    logic [17:0] SW;
    wire  [17:0] LEDR;
    wire  [ 8:0] LEDG;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;

    // SDRAM
    wire [ 1:0] DRAM_BA;
    wire [12:0] DRAM_ADDR;
    wire        DRAM_CAS_N;
    wire        DRAM_CKE;
    wire        DRAM_CS_N;
    tri  [31:0] DRAM_DQ;
    wire [ 3:0] DRAM_DQM;
    wire        DRAM_RAS_N;
    wire        DRAM_WE_N;
    wire        DRAM_CLK;

    // SRAM
    tri  [15:0] SRAM_DQ;
    wire [19:0] SRAM_ADDR;
    wire SRAM_LB_N, SRAM_UB_N, SRAM_CE_N, SRAM_OE_N, SRAM_WE_N;

    // PLL
    logic       system_pll_ref_reset_reset;

    // SD Card
    tri   [3:0] SD_DAT;
    wire        SD_CLK;
    wire        SD_CMD;
    logic       SD_WP_N;

    // SPI
    wire SPI_CLK, SPI_MOSI, SPI_MISO, SPI_CS;

    // UART
    logic       UART_RXD;
    wire        UART_TXD;

    // UART_2 / EXT_IO
    wire  [0:6] EXT_IO;

    // ------------------------------------------------------------------------
    // Генерация тактового сигнала
    initial CLOCK_50 = 0;
    always #(CLK_PERIOD_NS / 2) CLOCK_50 = ~CLOCK_50;

    // ------------------------------------------------------------------------
    // Начальные условия и сброс
    initial begin
        KEY = 4'hF;  // Все кнопки отпущены (активный уровень 0)
        SW = 18'h2CE32;
        UART_RXD = 1'b1;  // Линия RX в "idle"
        SD_WP_N = 1'b1;  // SD не заблокирована
        system_pll_ref_reset_reset = 1'b0;

        // Подадим reset
        #100;
        KEY[0] = 1'b0;  // Активный сброс
        #200;
        KEY[0] = 1'b1;  // Снимаем сброс

        // Основной сценарий тестирования
        repeat (10000) @(posedge CLOCK_50);


        // Конец сценария тестирования
        $display("Simulation finished at time %0t", $time);
        $stop;
    end

    // ------------------------------------------------------------------------
    // Подключение тестируемого модуля
    fpgaTop dut (
        .CLOCK_50(CLOCK_50),
        .KEY     (KEY),
        .SW      (SW),
        .LEDR    (LEDR),
        .LEDG    (LEDG),
        .HEX0    (HEX0),
        .HEX1    (HEX1),
        .HEX2    (HEX2),
        .HEX3    (HEX3),
        .HEX4    (HEX4),
        .HEX5    (HEX5),
        .HEX6    (HEX6),
        .HEX7    (HEX7),

        .DRAM_BA   (DRAM_BA),
        .DRAM_ADDR (DRAM_ADDR),
        .DRAM_CAS_N(DRAM_CAS_N),
        .DRAM_CKE  (DRAM_CKE),
        .DRAM_CS_N (DRAM_CS_N),
        .DRAM_DQ   (DRAM_DQ),
        .DRAM_DQM  (DRAM_DQM),
        .DRAM_RAS_N(DRAM_RAS_N),
        .DRAM_WE_N (DRAM_WE_N),
        .DRAM_CLK  (DRAM_CLK),

        .SRAM_DQ  (SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_LB_N(SRAM_LB_N),
        .SRAM_UB_N(SRAM_UB_N),
        .SRAM_CE_N(SRAM_CE_N),
        .SRAM_OE_N(SRAM_OE_N),
        .SRAM_WE_N(SRAM_WE_N),

        .system_pll_ref_reset_reset(system_pll_ref_reset_reset),

        .SD_DAT (SD_DAT),
        .SD_CLK (SD_CLK),
        .SD_CMD (SD_CMD),
        .SD_WP_N(SD_WP_N),

        .SPI_CLK (SPI_CLK),
        .SPI_MOSI(SPI_MOSI),
        .SPI_MISO(SPI_MISO),
        .SPI_CS  (SPI_CS),


        .EXT_IO(EXT_IO)
    );

    // ------------------------------------------------------------------------
    // Модель SRAM 2MB (1M×16)
    // Для инициализации из файла укажите параметр INIT_FILE:
    // .INIT_FILE("fpga/src/sram_init.hex")
    // Если INIT_FILE не указан или пустой, память инициализируется нулями
    sram_model #(
        .ADDR_WIDTH(10),
        .DATA_WIDTH(16),
        .INIT_FILE("sram_init.hex"
            )  // Раскомментируйте для использования файла
        //.INIT_FILE("")  // Или оставьте пустым для инициализации нулями
    ) sram_inst (
        .DQ  (SRAM_DQ),
        .ADDR(SRAM_ADDR),
        .CE_N(SRAM_CE_N),
        .OE_N(SRAM_OE_N),
        .WE_N(SRAM_WE_N),
        .LB_N(SRAM_LB_N),
        .UB_N(SRAM_UB_N)
    );

    // ------------------------------------------------------------------------
    // Мониторинг UART вывода (пример)
    always @(posedge UART_TXD) begin
        $display("UART TX toggled at %0t ns", $time);
    end

endmodule
