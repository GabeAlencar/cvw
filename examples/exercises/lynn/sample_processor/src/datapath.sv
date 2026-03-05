module datapath(
    input   logic           clk, reset, ALUResultSrc, RegWrite, MemWrite,
    input   logic [2:0]     Funct3, ImmSrc,
    input   logic [1:0]     ResultSrc, ALUSrc,
    input   logic [3:0]     ALUControl,
    input   logic [31:0]    PC, PCPlus4, Instr, ReadData,
    input   logic           IsAdd, IsBranch, BranchTaken, IsLoad, IsStore, IsJump, IsShift,
    output  logic           Eq, LT, LTU,
    output  logic [3:0]     WriteByteEn,
    output  logic [31:0]    IEUAdr, WriteData
);
    logic [31:0] RD1, RD2, SrcA, SrcB, ALUResult, ImmExt, Result, ALUOut, LoadData, CSRData, MulResult;
    logic [63:0] mul_ss, mul_su, mul_uu;
    wire signed [63:0] ext_a_s = {{32{SrcA[31]}}, SrcA};
    wire signed [63:0] ext_b_s = {{32{SrcB[31]}}, SrcB};
    wire        [63:0] ext_b_u = {32'b0, SrcB};

    assign mul_ss = ext_a_s * ext_b_s;
    assign mul_su = ext_a_s * $signed(ext_b_u);
    assign mul_uu = {32'b0, SrcA} * {32'b0, SrcB};

    always_comb begin
        case (Funct3[1:0])
            2'b00: MulResult = mul_ss[31:0];
            2'b01: MulResult = mul_ss[63:32];
            2'b10: MulResult = mul_su[63:32];
            2'b11: MulResult = mul_uu[63:32];
            default: MulResult = 32'b0; // Safety catch
        endcase
    end

    regfile rf(.clk(clk), .WE3(RegWrite), .A1(Instr[19:15]), .A2(Instr[24:20]), .A3(Instr[11:7]), .WD3(Result), .RD1(RD1), .RD2(RD2));
    extend ext(.Instr(Instr[31:7]), .ImmSrc(ImmSrc), .ImmExt(ImmExt));

    csr_unit csr (.clk(clk), .reset(reset), .csr_addr(Instr[31:20]), .is_add(IsAdd), .is_branch_eval(IsBranch), .is_branch_taken(BranchTaken), .is_load(IsLoad), .is_store(IsStore), .is_jump(IsJump), .is_shift(IsShift), .is_mul(ResultSrc == 2'b11), .csr_data(CSRData));

    assign SrcA = ALUSrc[1] ? (ALUSrc[0] ? PC : 32'b0) : RD1;
    assign SrcB = (|ALUSrc) ? ImmExt : RD2;

    cmp cmp(.R1(RD1), .R2(RD2), .Eq(Eq), .LT(LT), .LTU(LTU));
    alu alu(.SrcA(SrcA), .SrcB(SrcB), .ALUControl(ALUControl), .ALUResult(ALUResult), .IEUAdr(IEUAdr));

    always_comb begin
        case (Funct3)
            3'b000: WriteData = {4{RD2[7:0]}};
            3'b001: WriteData = {2{RD2[15:0]}};
            default: WriteData = RD2;
        endcase
    end

    always_comb begin
        if (MemWrite) begin
            case (Funct3)
                3'b000: case (IEUAdr[1:0])
                        2'b00: WriteByteEn = 4'b0001;
                        2'b01: WriteByteEn = 4'b0010;
                        2'b10: WriteByteEn = 4'b0100;
                        2'b11: WriteByteEn = 4'b1000;
                        default: WriteByteEn = 4'b0000;
                    endcase
                3'b001: case (IEUAdr[1])
                        1'b0: WriteByteEn = 4'b0011;
                        1'b1: WriteByteEn = 4'b1100;
                        default: WriteByteEn = 4'b0000;
                    endcase
                default: WriteByteEn = 4'b1111;
            endcase
        end else WriteByteEn = 4'b0000;
    end

    always_comb begin
        case (Funct3)
            3'b000: case (IEUAdr[1:0])
                    2'b00: LoadData = {{24{ReadData[7]}}, ReadData[7:0]};
                    2'b01: LoadData = {{24{ReadData[15]}}, ReadData[15:8]};
                    2'b10: LoadData = {{24{ReadData[23]}}, ReadData[23:16]};
                    2'b11: LoadData = {{24{ReadData[31]}}, ReadData[31:24]};
                    default: LoadData = 32'b0;
                endcase
            3'b001: case (IEUAdr[1])
                    1'b0: LoadData = {{16{ReadData[15]}}, ReadData[15:0]};
                    1'b1: LoadData = {{16{ReadData[31]}}, ReadData[31:16]};
                    default: LoadData = 32'b0;
                endcase
            3'b100: case (IEUAdr[1:0])
                    2'b00: LoadData = {24'b0, ReadData[7:0]};
                    2'b01: LoadData = {24'b0, ReadData[15:8]};
                    2'b10: LoadData = {24'b0, ReadData[23:16]};
                    2'b11: LoadData = {24'b0, ReadData[31:24]};
                    default: LoadData = 32'b0;
                endcase
            3'b101: case (IEUAdr[1])
                    1'b0: LoadData = {16'b0, ReadData[15:0]};
                    1'b1: LoadData = {16'b0, ReadData[31:16]};
                    default: LoadData = 32'b0;
                endcase
            default: LoadData = ReadData;
        endcase
    end

    assign ALUOut = ALUResultSrc ? PCPlus4 : ALUResult;

    always_comb begin
        case (ResultSrc)
            2'b00: Result = ALUOut;
            2'b01: Result = LoadData;
            2'b10: Result = CSRData;
            2'b11: Result = MulResult;
            default: Result = ALUOut; // Default squash to prevent X-propagation
        endcase
    end
endmodule
