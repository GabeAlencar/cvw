`include "parameters.svh"

module controller(
    input  logic [6:0] Op,
    input  logic       Eq, LT, LTU,
    input  logic [2:0] Funct3,
    input  logic       Funct7b5,
    output logic       ALUResultSrc,
    output logic       ResultSrc,
    output logic       MemWrite,      // CHANGED: was WriteByteEn, now MemWrite
    output logic       PCSrc,
    output logic       RegWrite,
    output logic [1:0] ALUSrc,
    output logic [2:0] ImmSrc,
    output logic [3:0] ALUControl,
    output logic       MemEn
    `ifdef DEBUG
    , input logic [31:0] insn_debug
    `endif
);

    logic        Branch, Jump;
    logic [1:0]  ALUOp;
    logic [13:0] controls;

    always_comb begin
        case(Op)
            7'b0000011: controls = 14'b1_000_01_00_0_0_1_0_0_1; // LW
            7'b0100011: controls = 14'b0_001_01_00_0_1_0_0_0_1; // SW
            7'b0110011: controls = 14'b1_xxx_00_10_0_0_0_0_0_0; // R-type
            7'b0010011: controls = 14'b1_000_01_10_0_0_0_0_0_0; // I-type ALU
            7'b1100011: controls = 14'b0_010_11_00_0_0_0_1_0_0; // Branch
            7'b1101111: controls = 14'b1_011_11_00_1_0_0_0_1_0; // JAL
            7'b1100111: controls = 14'b1_000_01_00_1_0_0_0_1_0;
            7'b0110111: controls = 14'b1_100_10_00_0_0_0_0_0_0; // LUI
            7'b0010111: controls = 14'b1_100_11_00_0_0_0_0_0_0; // AUIPC
            default: begin
                `ifdef DEBUG
                    controls = 14'bx_xxx_xx_xx_x_x_x_x_x_x;
                    if (insn_debug !== 'x) begin
                        $display("Instruction not implemented: %h", insn_debug);
                        $finish(-1);
                    end
                `else
                    controls = 14'b0;
                `endif
            end
        endcase
    end

    assign {RegWrite, ImmSrc, ALUSrc, ALUOp, ALUResultSrc, MemWrite, ResultSrc, Branch, Jump, MemEn} = controls;

    always_comb begin
        if      (ALUOp == 2'b00) ALUControl = 4'b0000;
        else if (ALUOp == 2'b01) ALUControl = 4'b0001;
        else begin
            case (Funct3)
                3'b000: ALUControl = (Op[5] & Funct7b5) ? 4'b0001 : 4'b0000;
                3'b001: ALUControl = 4'b0111;
                3'b010: ALUControl = 4'b0101;
                3'b011: ALUControl = 4'b0110;
                3'b100: ALUControl = 4'b0100;
                3'b101: ALUControl = Funct7b5 ? 4'b1001 : 4'b1000;
                3'b110: ALUControl = 4'b0011;
                3'b111: ALUControl = 4'b0010;
                default: ALUControl = 4'bxxxx;
            endcase
        end
    end

    logic ConditionMet;
    always_comb begin
        case (Funct3)
            3'b000: ConditionMet = Eq;
            3'b001: ConditionMet = !Eq;
            3'b100: ConditionMet = LT;
            3'b101: ConditionMet = !LT;
            3'b110: ConditionMet = LTU;
            3'b111: ConditionMet = !LTU;
            default: ConditionMet = 1'b0;
        endcase
    end

    assign PCSrc = (Branch & ConditionMet) | Jump;

endmodule
