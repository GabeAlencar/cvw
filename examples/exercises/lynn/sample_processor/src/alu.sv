// riscvsingle.sv
// RISC-V single-cycle processor
// David_Harris@hmc.edu 2020

module alu(
    input  logic [31:0] SrcA, SrcB,
    input  logic [3:0]  ALUControl, // CHANGED: Expanded to 4 bits
    output logic [31:0] ALUResult,
    output logic [31:0] IEUAdr
);

    logic [31:0] Sum;
    logic        Overflow;

    // The IEU address is always the sum (used for load/store addresses)
    assign Sum = SrcA + (ALUControl[0] ? ~SrcB : SrcB) + ALUControl[0];
    assign IEUAdr = Sum;

    always_comb begin
        case (ALUControl)
            4'b0000: ALUResult = SrcA + SrcB;         // ADD
            4'b0001: ALUResult = SrcA - SrcB;         // SUB
            4'b0010: ALUResult = SrcA & SrcB;         // AND
            4'b0011: ALUResult = SrcA | SrcB;         // OR
            4'b0100: ALUResult = SrcA ^ SrcB;         // XOR
            4'b0101: ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0; // SLT
            4'b0110: ALUResult = (SrcA < SrcB) ? 32'd1 : 32'd0;                   // SLTU
            4'b0111: ALUResult = SrcA << SrcB[4:0];   // SLL
            4'b1000: ALUResult = SrcA >> SrcB[4:0];   // SRL
            4'b1001: ALUResult = $signed(SrcA) >>> SrcB[4:0]; // SRA
            default: ALUResult = 32'bx;
        endcase
    end
endmodule
