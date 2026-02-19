// riscvsingle.sv
// RISC-V single-cycle processor
// David_Harris@hmc.edu 2020

`include "parameters.svh"

module controller(
    input  logic [6:0] Op,
    input  logic       Eq, LT, LTU, // ADDED: New flags from CMP
    input  logic [2:0] Funct3,
    input  logic       Funct7b5,
    output logic       ALUResultSrc,
    output logic       ResultSrc,
    output logic [3:0] WriteByteEn,
    output logic       PCSrc,
    output logic       RegWrite,
    output logic [1:0] ALUSrc,
    output logic [2:0] ImmSrc,      // CHANGED: Expanded to 3 bits for U-type support
    output logic [3:0] ALUControl,  // CHANGED: Expanded to 4 bits
    output logic       MemEn
    `ifdef DEBUG
    , input logic [31:0] insn_debug
    `endif
);

    logic       Branch, Jump;
    logic [1:0] ALUOp;
    logic       MemWrite;
    logic [12:0] controls; // Expanded to accommodate ImmSrc width

    // Main Decoder
    always_comb begin
        case(Op)
            // RegWrite_ImmSrc(3)_ALUSrc(2)_ALUOp(2)_ALUResultSrc_MemWrite_ResultSrc_Branch_Jump_Load

            // LW
            7'b0000011: controls = 13'b1_000_01_00_0_0_1_0_0_1;
            // SW
            7'b0100011: controls = 13'b0_001_01_00_0_1_0_0_0_1;
            // R-type
            7'b0110011: controls = 13'b1_xxx_00_10_0_0_0_0_0_0;
            // I-type ALU
            7'b0010011: controls = 13'b1_000_01_10_0_0_0_0_0_0;
            // BEQ (Branches)
            7'b1100011: controls = 13'b0_010_00_01_0_0_0_1_0_0;
            // JAL
            7'b1101111: controls = 13'b1_011_11_00_1_0_0_0_1_0;
            // JALR (New)
            // ALUSrc=01 (Reg+Imm), ResultSrc=0 (ALU), ALUResultSrc=1 (PC+4), Jump=1
            7'b1100111: controls = 13'b1_000_01_10_1_0_0_0_1_0;
            // LUI (New)
            // ALUSrc=1x, ImmSrc=100 (U-type), ALUOp=Copy/Add
            7'b0110111: controls = 13'b1_100_11_00_0_0_0_0_0_0; // ALUSrc 11 makes SrcA=PC, but LUI needs 0.
                                                                // Actually LUI is often handled by SrcA=0 (x0) or ignoring SrcA.
                                                                // For this datapath: we'll assume LUI is "Imm + 0".
                                                                // Need to ensure SrcA Mux can select 0 or rely on ALU ignoring it.
                                                                // Or: AUIPC uses PC+Imm. LUI uses Imm.
                                                                // If we can't select 0, we treat LUI as "Add x0, Imm".
            // AUIPC (New)
            7'b0010111: controls = 13'b1_100_11_00_0_0_0_0_0_0;

            default: begin
                `ifdef DEBUG
                    controls = 13'bx_xxx_xx_xx_x_x_x_x_x_x;
                    if (insn_debug !== 'x) begin
                        $display("Instruction not implemented: %h", insn_debug);
                        $finish(-1);
                    end
                `else
                    controls = 13'b0;
                `endif
            end
        endcase
    end

    assign {RegWrite, ImmSrc, ALUSrc, ALUOp, ALUResultSrc, MemWrite, ResultSrc, Branch, Jump, MemEn} = controls;

    // ALU Decoder
    always_comb begin
        if (ALUOp == 2'b00) begin
            ALUControl = 4'b0000; // ADD (lw, sw, auipc)
        end else if (ALUOp == 2'b01) begin
            ALUControl = 4'b0001; // SUB (beq)
        end else begin
            // R-type or I-type ALU
            case (Funct3)
                3'b000: begin
                    // True if R-type and Sub bit set
                    if (Op[5] && Funct7b5) ALUControl = 4'b0001; // SUB
                    else                   ALUControl = 4'b0000; // ADD
                end
                3'b001: ALUControl = 4'b0111; // SLL
                3'b010: ALUControl = 4'b0101; // SLT
                3'b011: ALUControl = 4'b0110; // SLTU
                3'b100: ALUControl = 4'b0100; // XOR
                3'b101: begin
                    if (Funct7b5) ALUControl = 4'b1001; // SRA
                    else          ALUControl = 4'b1000; // SRL
                end
                3'b110: ALUControl = 4'b0011; // OR
                3'b111: ALUControl = 4'b0010; // AND
                default: ALUControl = 4'bxxxx;
            endcase
        end
    end

    // Branch Logic (PCSrc)
    logic ConditionMet;
    always_comb begin
        case (Funct3)
            3'b000: ConditionMet = Eq;      // BEQ
            3'b001: ConditionMet = !Eq;     // BNE
            3'b100: ConditionMet = LT;      // BLT
            3'b101: ConditionMet = !LT;     // BGE
            3'b110: ConditionMet = LTU;     // BLTU
            3'b111: ConditionMet = !LTU;    // BGEU
            default: ConditionMet = 1'b0;
        endcase
    end

    // For JAL/JALR, Jump is 1. For Branches, check condition.
    assign PCSrc = (Branch & ConditionMet) | Jump;

    assign WriteByteEn = {4{MemWrite}};
endmodule
