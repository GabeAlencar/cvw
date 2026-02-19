module datapath(
    input   logic           clk, reset,
    input   logic [2:0]     Funct3,
    input   logic           ALUResultSrc, ResultSrc,
    input   logic [1:0]     ALUSrc,
    input   logic           RegWrite,
    input   logic [2:0]     ImmSrc,      // Expanded
    input   logic [3:0]     ALUControl,  // Expanded
    output  logic           Eq, LT, LTU, // Added flags
    input   logic [31:0]    PC, PCPlus4,
    input   logic [31:0]    Instr,
    output  logic [31:0]    IEUAdr, WriteData,
    input   logic [31:0]    ReadData
);
    // ... existing logic ...

    // ALU logic
    cmp cmp(.R1(R1), .R2(R2), .Eq(Eq), .LT(LT), .LTU(LTU)); // Connected new flags

    // Muxes ...
    // Note: For LUI, if your SrcA mux doesn't have a 0 input,
    // ensure your Extend unit handles U-type correctly or rely on software using x0
    // (LUI x1, imm -> addi x1, x0, (imm<<12)).
    // But standardized LUI ignores Rs1.

    alu alu(.SrcA(SrcA), .SrcB(SrcB), .ALUControl(ALUControl), .ALUResult(ALUResult), .IEUAdr(IEUAdr));

    // ... rest of file ...
endmodule
