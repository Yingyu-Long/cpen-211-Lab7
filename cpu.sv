module cpu(
	input logic clk,
	input logic rst_n,
	input logic wrA,
	input logic [1:0] selA,
	input logic [1:0] selB,
	input logic [1:0] aluOp,
	input logic imm,
	input logic [1:0] selR,
	output logic [7:0] dataA,
	output logic [7:0] outReg,
	output logic [7:0] result,
	output logic [5:0] CC
);

	logic [7:0] dataB, dataW, aluResult;
	logic [7:0] dataMem [127:0]; // 128 bytes

	// Register File and ALU
	regfile(
		.clk(clk), .rst_n(rst_n),
		.WE(wrA), .selA(selA), .selB(selB), .dataW(result), // inputs
		.dataA(dataA), .dataB(dataB)                        // outputs
	);
	alu(
		.aluOp(aluOp), .dataA(dataA), .dataB(dataB), // inputs
		.R(aluResult), .CC(CC)               // outputs
	);

	// Result mux
	always_comb begin
		case( selR )
			0: result = dataMem[ dataB[6:0] ];
			1: result = aluResult;
			2: result = dataB;
			3: result = imm ? -1 : 1;
		endcase
	end

	// Memory and OutReg (synchronous writes)
	always_ff @(posedge clk) begin
		if( !rst_n ) outReg <= 0;
		else begin
			if( ~wrA & ~dataB[7] ) dataMem[ dataB[6:0] ] <= dataA;
			if( ~wrA &  dataB[7] ) outReg                <= dataA;
		end
	end

endmodule
