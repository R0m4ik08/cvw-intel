// sram_model.sv
// Модель SRAM 2MB (1M×16 бит) для симуляции
// Асинхронный интерфейс с байтовым доступом

module sram_model
#(
    parameter ADDR_WIDTH = 10,  // 5 бит = 1K адресов
    parameter DATA_WIDTH = 16,  // 16 бит данных
    parameter INIT_FILE  = ""   // Путь к файлу инициализации (пустая строка = без инициализации)
)
(
    // Шина данных (тристабильная)
    inout  wire [DATA_WIDTH-1:0] DQ,
    
    // Адресная шина
    input  wire [ADDR_WIDTH-1:0] ADDR,
    
    // Управляющие сигналы (активный низкий уровень)
    input  wire                  CE_N,  // Chip Enable
    input  wire                  OE_N,  // Output Enable
    input  wire                  WE_N,  // Write Enable
    input  wire                  LB_N,  // Lower Byte Enable
    input  wire                  UB_N   // Upper Byte Enable
);

    // Внутренняя память: 1M×16 бит
    logic [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0];
    
    // Внутренние сигналы для управления шиной данных
    logic [DATA_WIDTH-1:0] data_out;
    logic                  output_enable;
    
    // Определение режима работы
    wire chip_selected = ~CE_N;
    wire read_mode     = chip_selected && ~OE_N && WE_N;
    wire write_mode    = chip_selected && ~WE_N;
    
    // Управление выходом данных (тристабильная шина)
    assign output_enable = read_mode;
    assign DQ = output_enable ? data_out : {DATA_WIDTH{1'bz}};
    
    // Операция чтения
    always_comb begin
        if (read_mode) begin
            data_out = memory[ADDR];
        end else begin
            data_out = {DATA_WIDTH{1'b0}};
        end
    end
    
    // Операция записи (асинхронная, по уровню сигналов)
    // Запись происходит когда WE_N низкий, CE_N низкий, и адрес/данные стабильны
    always @(WE_N or CE_N or ADDR or DQ or LB_N or UB_N) begin
        if (write_mode) begin
            // Запись младшего байта (DQ[7:0])
            if (~LB_N) begin
                memory[ADDR][7:0] = DQ[7:0];
            end
            
            // Запись старшего байта (DQ[15:8])
            if (~UB_N) begin
                memory[ADDR][15:8] = DQ[15:8];
            end
        end
    end
    
    // Инициализация памяти
    initial begin
        if (INIT_FILE != "") begin
            // Загружаем данные из файла
            $display("[SRAM_MODEL] Loading initialization file: %s", INIT_FILE);
            $readmemh(INIT_FILE, memory);
            $display("[SRAM_MODEL] Memory initialized from file");
        end else begin
            $readmemh("sram_init.hex", memory);
            // // Инициализируем память нулями
            // for (int i = 0; i < (1<<ADDR_WIDTH); i++) begin
            //     memory[i] = {DATA_WIDTH{1'b0}};
            // end
            $display("[SRAM_MODEL] Memory initialized with zeros");
        end
    end

endmodule
