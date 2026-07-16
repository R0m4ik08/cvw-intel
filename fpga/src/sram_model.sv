// sram_model.sv
// Модель SRAM для симуляции с поддержкой динамической загрузки
// Асинхронный интерфейс с байтовым доступом

module sram_model #(
    parameter ADDR_WIDTH = 10,
    parameter DATA_WIDTH = 16,
    parameter INIT_FILE  = ""
) (
    inout wire [DATA_WIDTH-1:0] DQ,
    input wire [ADDR_WIDTH-1:0] ADDR,

    // Управляющие сигналы (активный низкий уровень)
    input wire CE_N,  // Chip Enable
    input wire OE_N,  // Output Enable
    input wire WE_N,  // Write Enable
    input wire LB_N,  // Lower Byte Enable
    input wire UB_N   // Upper Byte Enable
);

    // Внутренняя память
    logic [DATA_WIDTH-1:0] memory                                     [(1<<ADDR_WIDTH)-1:0];


    // Внутренние сигналы для управления шиной данных
    logic [DATA_WIDTH-1:0] data_out;
    logic                  output_enable;

    // Определение режима работы
    wire                   chip_selected = ~CE_N;
    wire                   read_mode = chip_selected && ~OE_N && WE_N;
    wire                   write_mode = chip_selected && ~WE_N;

    // Управление выходом данных
    assign output_enable = read_mode;
    assign DQ            = output_enable ? data_out : {DATA_WIDTH{1'bz}};

    // Чтение
    always_comb begin
        if (read_mode) begin
            data_out = memory[ADDR];
        end else begin
            data_out = {DATA_WIDTH{1'b0}};
        end
    end

    // Запись (асинхронная, по уровню сигналов)
    // Происходит когда WE_N низкий, CE_N низкий, и адрес/данные стабильны
    always @(WE_N or CE_N or ADDR or DQ or LB_N or UB_N) begin
        if (write_mode) begin
            if (~LB_N) memory[ADDR][7:0] = DQ[7:0];
            if (~UB_N) memory[ADDR][15:8] = DQ[15:8];
        end
    end

`ifndef QUARTUS_PRJ

    // Первоначальная инициализация
    initial begin
        clear_memory();
        if (INIT_FILE != "") begin
            load_file(INIT_FILE);
        end
    end

    // =========================================================================
    // API ДЛЯ ДИНАМИЧЕСКОГО ДОСТУПА (Используется тестбенчем / UVM-окружением)
    // =========================================================================

    // Функция динамической загрузки HEX-файла
    function automatic void load_file(input string file_path);
        // Проверка наличия файла (чтобы избежать падения симулятора)
        int file_desc;
        file_desc = $fopen(file_path, "r");
        if (file_desc == 0) begin
            $warning("[SRAM_MODEL] Cannot open initialization file: %s", file_path);
        end else begin
            $fclose(file_desc);
            $display("[SRAM_MODEL] Dynamically loading file: %s", file_path);
            $readmemh(file_path, memory);
        end
    endfunction

    // Функция очистки памяти
    function automatic void clear_memory();
        for (int i = 0; i < (1 << ADDR_WIDTH); i++) begin
            memory[i] = {DATA_WIDTH{1'b0}};
        end
        $display("[SRAM_MODEL] Memory cleared");
    endfunction

    // Функция для записи одного слова напрямую (Backdoor Write)
    function automatic void backdoor_write(input [ADDR_WIDTH-1:0] addr,
                                           input [DATA_WIDTH-1:0] data);
        memory[addr] = data;
    endfunction

    // Функция для чтения одного слова напрямую (Backdoor Read)
    function automatic bit [DATA_WIDTH-1:0] backdoor_read(input [ADDR_WIDTH-1:0] addr);
        return memory[addr];
    endfunction

`endif

endmodule
