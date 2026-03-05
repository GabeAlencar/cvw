module ieu(
    input  logic        clk, reset,
    input  logic [31:0] Instr, PC, PCPlus4, ReadData,
    output logic [3:0]  WriteByteEn,
    output logic [31:0] IEUAdr, WriteData,
    output logic        PCSrc, MemEn
);
    // Added 'Branch' to the wire list here:
    logic       Eq, LT, LTU, ALUResultSrc, RegWrite, MemWrite, Branch;
    logic [3:0] ALUControl;
    logic [2:0] ImmSrc;
    logic [1:0] ALUSrc, ResultSrc;
    logic       IsAdd, IsBranch, BranchTaken, IsLoad, IsStore, IsJump, IsShift;

    controller c(
        .Op(Instr[6:0]), .Funct3(Instr[14:12]), .Funct7b5(Instr[30]), .Funct7b0(Instr[25]),
        .Eq(Eq), .LT(LT), .LTU(LTU), .ALUResultSrc(ALUResultSrc), .ResultSrc(ResultSrc),
        .MemWrite(MemWrite), .PCSrc(PCSrc), .ALUSrc(ALUSrc), .RegWrite(RegWrite),
        .ImmSrc(ImmSrc), .ALUControl(ALUControl), .MemEn(MemEn),
        .Branch(Branch), // <--- Added the missing connection here!
        .IsAdd(IsAdd), .IsBranch(IsBranch), .BranchTaken(BranchTaken),
        .IsLoad(IsLoad), .IsStore(IsStore), .IsJump(IsJump), .IsShift(IsShift)
    );

    datapath dp(
        .clk(clk), .reset(reset), .Funct3(Instr[14:12]), .ALUResultSrc(ALUResultSrc),
        .ResultSrc(ResultSrc), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .MemWrite(MemWrite),
        .ImmSrc(ImmSrc), .ALUControl(ALUControl), .Eq(Eq), .LT(LT), .LTU(LTU),
        .PC(PC), .PCPlus4(PCPlus4), .Instr(Instr), .IEUAdr(IEUAdr), .WriteData(WriteData),
        .WriteByteEn(WriteByteEn), .ReadData(ReadData),
        .IsAdd(IsAdd), .IsBranch(IsBranch), .BranchTaken(BranchTaken),
        .IsLoad(IsLoad), .IsStore(IsStore), .IsJump(IsJump), .IsShift(IsShift)
    );
endmodule
