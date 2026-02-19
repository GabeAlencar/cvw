module datapath(
    input   logic           clk, reset,
    input   logic [2:0]     Funct3,
    input   logic           ALUResultSrc, ResultSrc,
    input   logic [1:0]     ALUSrc,
    input   logic           RegWrite,
    input   logic           MemWrite,
    input   logic [2:0]     ImmSrc,
    input   logic [3:0]     ALUControl,
    output  logic           Eq, LT, LTU,
    input   logic [31:0]    PC, PCPlus4,
    input   logic [31:0]    Instr,
    output  logic [31:0]    IEUAdr, WriteData,
    output  logic [3:0]     WriteByteEn,
    input   logic [31:0]    ReadData
);

    logic [31:0] RD1, RD2;
    logic [31:0] SrcA, SrcB;
    logic [31:0] ALUResult;
    logic [31:0] ImmExt;
    logic [31:0] Result;
    logic [31:0] ALUOut;
    logic [31:0] LoadData;

    regfile rf(
        .clk(clk),
        .WE3(RegWrite),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WD3(Result),
        .RD1(RD1),
        .RD2(RD2)
    );

    extend ext(.Instr(Instr[31:7]), .ImmSrc(ImmSrc), .ImmExt(ImmExt));

    // SrcA: 00=RD1, 10=0 (LUI), 11=PC (AUIPC/JAL)
    assign SrcA = ALUSrc[1] ? (ALUSrc[0] ? PC : 32'b0) : RD1;

    // SrcB: 00=RD2, else ImmExt
    assign SrcB = (|ALUSrc) ? ImmExt : RD2;

    // Write data lane alignment for SB/SH
    always_comb begin
        case (Funct3)
            3'b000: // SB — shift byte into correct lane
                case (IEUAdr[1:0])
                    2'b00: WriteData = {24'b0, RD2[7:0]};
                    2'b01: WriteData = {16'b0, RD2[7:0], 8'b0};
                    2'b10: WriteData = {8'b0,  RD2[7:0], 16'b0};
                    2'b11: WriteData = {RD2[7:0],         24'b0};
                    default: WriteData = RD2;
                endcase
            3'b001: // SH — shift halfword into correct lane
                case (IEUAdr[1])
                    1'b0: WriteData = {16'b0, RD2[15:0]};
                    1'b1: WriteData = {RD2[15:0], 16'b0};
                    default: WriteData = RD2;
                endcase
            default: WriteData = RD2; // SW — full word, no shift needed
        endcase
    end

    cmp cmp(.R1(RD1), .R2(RD2), .Eq(Eq), .LT(LT), .LTU(LTU));

    alu alu(.SrcA(SrcA), .SrcB(SrcB), .ALUControl(ALUControl),
            .ALUResult(ALUResult), .IEUAdr(IEUAdr));

    // Load data extractor
    always_comb begin
        case (Funct3)
            3'b000: // LB
                case (IEUAdr[1:0])
                    2'b00: LoadData = {{24{ReadData[7]}},  ReadData[7:0]};
                    2'b01: LoadData = {{24{ReadData[15]}}, ReadData[15:8]};
                    2'b10: LoadData = {{24{ReadData[23]}}, ReadData[23:16]};
                    2'b11: LoadData = {{24{ReadData[31]}}, ReadData[31:24]};
                    default: LoadData = 32'bx;
                endcase
            3'b001: // LH
                case (IEUAdr[1])
                    1'b0: LoadData = {{16{ReadData[15]}}, ReadData[15:0]};
                    1'b1: LoadData = {{16{ReadData[31]}}, ReadData[31:16]};
                    default: LoadData = 32'bx;
                endcase
            3'b010: LoadData = ReadData;  // LW
            3'b100: // LBU
                case (IEUAdr[1:0])
                    2'b00: LoadData = {24'b0, ReadData[7:0]};
                    2'b01: LoadData = {24'b0, ReadData[15:8]};
                    2'b10: LoadData = {24'b0, ReadData[23:16]};
                    2'b11: LoadData = {24'b0, ReadData[31:24]};
                    default: LoadData = 32'bx;
                endcase
            3'b101: // LHU
                case (IEUAdr[1])
                    1'b0: LoadData = {16'b0, ReadData[15:0]};
                    1'b1: LoadData = {16'b0, ReadData[31:16]};
                    default: LoadData = 32'bx;
                endcase
            default: LoadData = ReadData;
        endcase
    end

    // WriteByteEn generation (needs IEUAdr[1:0], so lives here not in controller)
    always_comb begin
        if (MemWrite) begin
            case (Funct3)
                3'b000: // SB
                    case (IEUAdr[1:0])
                        2'b00: WriteByteEn = 4'b0001;
                        2'b01: WriteByteEn = 4'b0010;
                        2'b10: WriteByteEn = 4'b0100;
                        2'b11: WriteByteEn = 4'b1000;
                        default: WriteByteEn = 4'b0000;
                    endcase
                3'b001: // SH
                    case (IEUAdr[1])
                        1'b0: WriteByteEn = 4'b0011;
                        1'b1: WriteByteEn = 4'b1100;
                        default: WriteByteEn = 4'b0000;
                    endcase
                default: WriteByteEn = 4'b1111; // SW
            endcase
        end else
            WriteByteEn = 4'b0000;
    end

    assign ALUOut  = ALUResultSrc ? PCPlus4 : ALUResult;
    assign Result  = ResultSrc    ? LoadData : ALUOut;

endmodule
