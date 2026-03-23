// File alu_register.v
module alu_register #(
  parameter WIDTH = 8               // Parameter of the width of the operands and the result.
)(
  input  wire             clk_i,    // Clock signal
  input  wire             rst_i,    // Synchronous reset (active high level)
  input  wire [WIDTH-1:0] first_i,  // The bus of the first operand
  input  wire [WIDTH-1:0] second_i, // The bus of the second operand
  input  wire [2:0]       opcode_i, // Operation code
  output reg  [WIDTH-1:0] result_o  // Result bus
);

  // Updating on the positive edge of the clock signal.
  always @(posedge clk_i) begin
    if (rst_i) begin
      result_o <= {WIDTH{1'b0}};
    end else begin
      case (opcode_i)
        3'b000: result_o <= ~(first_i & second_i);          // NAND
        3'b001: result_o <= first_i ^ second_i;             // XOR
        3'b010: result_o <= first_i + second_i;             // uADD
        3'b011: result_o <= $signed(first_i) >>> second_i;  // ASR
        3'b100: result_o <= first_i | second_i;             // OR
        3'b101: result_o <= first_i << second_i;            // LSL
        3'b110: result_o <= ~first_i;                       // NOT
        3'b111: result_o <= (first_i < second_i) ? {{WIDTH-1{1'b0}}, 1'b1} : {WIDTH{1'b0}}; // SLT
      endcase
    end
  end

endmodule
