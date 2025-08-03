module top (
    input  wire CLOCK_50,
    output wire [7:0] LEDG
);
    assign LEDG = {8{CLOCK_50}};
endmodule