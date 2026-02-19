module ieu(
    // ... same inputs ...
);
    // Internal signals
    logic Eq, LT, LTU; // Added
    logic [3:0] ALUControl; // Expanded
    logic [2:0] ImmSrc; // Expanded

    controller c(
        .Op(Instr[6:0]),
        .Funct3(Instr[14:12]),
        .Funct7b5(Instr[30]),
        .Eq(Eq), .LT(LT), .LTU(LTU), // Connect new flags
        .ALUResultSrc(ALUResultSrc),
        .ResultSrc(ResultSrc),
        .WriteByteEn(WriteByteEn),
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
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl),
        .Eq(Eq), .LT(LT), .LTU(LTU), // Connect new flags
        .PC(PC), .PCPlus4(PCPlus4), .Instr(Instr),
        .IEUAdr(IEUAdr), .WriteData(WriteData), .ReadData(ReadData)
    );
endmodule
