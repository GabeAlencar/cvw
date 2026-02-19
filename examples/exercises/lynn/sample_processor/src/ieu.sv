module ieu(
    input  logic        clk, reset,
    input  logic [31:0] Instr,
    input  logic [31:0] PC,
    input  logic [31:0] PCPlus4,
    input  logic [31:0] ReadData,
    output logic [3:0]  WriteByteEn,
    output logic [31:0] IEUAdr,
    output logic [31:0] WriteData,
    output logic        PCSrc,
    output logic        MemEn
);

    logic       Eq, LT, LTU;
    logic [3:0] ALUControl;
    logic [2:0] ImmSrc;
    logic [1:0] ALUSrc;
    logic       ALUResultSrc, ResultSrc, RegWrite;
    logic       MemWrite;   // ADDED

    controller c(
        .Op(Instr[6:0]),
        .Funct3(Instr[14:12]),
        .Funct7b5(Instr[30]),
        .Eq(Eq), .LT(LT), .LTU(LTU),
        .ALUResultSrc(ALUResultSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),        // CHANGED: was WriteByteEn
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl),
        .MemEn(MemEn)
        `ifdef DEBUG
        , .insn_debug(Instr)
        `endif
    );

    datapath dp(
        .clk(clk), .reset(reset),
        .Funct3(Instr[14:12]),
        .ALUResultSrc(ALUResultSrc),
        .ResultSrc(ResultSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),        // ADDED
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl),
        .Eq(Eq), .LT(LT), .LTU(LTU),
        .PC(PC), .PCPlus4(PCPlus4), .Instr(Instr),
        .IEUAdr(IEUAdr), .WriteData(WriteData),
        .WriteByteEn(WriteByteEn),  // ADDED
        .ReadData(ReadData)
    );

endmodule
