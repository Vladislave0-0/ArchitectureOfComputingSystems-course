// File alu_register_tb.v
`timescale 1ns/1ps

module alu_register_tb();
  // alu_register localparam.
  localparam WIDTH = 8;
  
  // alu_register ports:
  //    `reg` for inputs;
  //    `wire` for outputs.
  reg                clk_i;
  reg                rst_i;
  reg  [WIDTH-1:0]   first_i;
  reg  [WIDTH-1:0]   second_i;
  reg  [2:0]         opcode_i;
  wire [WIDTH-1:0]   result_o;

  // alu_register instance.
  alu_register #(
    .WIDTH(WIDTH)
  ) dut (
    .clk_i    (clk_i),
    .rst_i    (rst_i),
    .first_i  (first_i),
    .second_i (second_i),
    .opcode_i (opcode_i),
    .result_o (result_o)
  );

  // Clock signal generation (10 ns period).
  initial begin
    clk_i = 0;
    forever #5 clk_i = ~clk_i;
  end

  // Testbench logic
  initial begin
    // For waveforms
    $dumpfile("dump.vcd");
    $dumpvars(0, alu_register_tb);

    // 1. Initialization and synchronous reset.
    rst_i    = 1'b1;
    first_i  = 8'h00;
    second_i = 8'h00;
    opcode_i = 3'b000;
    
    #10;
    rst_i    = 1'b0;
    
    // 2. Checking arith-logical operations. The result will
    // appear on result_o after the next posedge clk_i.

    // NAND (000): ~(0xFF & 0x0F) = 0xF0
    @(negedge clk_i);
    opcode_i = 3'b000;
    first_i  = 8'hFF;
    second_i = 8'h0F;

    // XOR (001): 0xAA ^ 0x55 = 0xFF
    @(negedge clk_i);
    opcode_i = 3'b001;
    first_i  = 8'hAA;
    second_i = 8'h55;

    // uADD (010): 0x12 + 0x34 = 0x46
    @(negedge clk_i);
    opcode_i = 3'b010; 
    first_i  = 8'h12; 
    second_i = 8'h34;

    // ASR (011): 0x80 (-128) >>> 1 = 0xC0 (-64)
    @(negedge clk_i);
    opcode_i = 3'b011;
    first_i  = 8'h80;
    second_i = 8'h01;

    // OR (100): 0xF0 | 0x0F = 0xFF
    @(negedge clk_i);
    opcode_i = 3'b100;
    first_i  = 8'hF0;
    second_i = 8'h0F;

    // LSL (101): 0x01 << 3 = 0x08
    @(negedge clk_i);
    opcode_i = 3'b101;
    first_i  = 8'h01;
    second_i = 8'h03;

    // NOT (110): ~0x00 = 0xFF
    @(negedge clk_i);
    opcode_i = 3'b110;
    first_i  = 8'h00;

    // SLT (111): 0x05 < 0x10 = 1 (0x01)
    @(negedge clk_i);
    opcode_i = 3'b111;
    first_i  = 8'h05;
    second_i = 8'h10;

    // 3. Checking for a re-reset.
    @(negedge clk_i);
    rst_i = 1'b1;
    #10;
    rst_i = 1'b0;

    #20;
    $display("The simulation is completed. Check file dump.vcd");
    $finish;
  end

endmodule
