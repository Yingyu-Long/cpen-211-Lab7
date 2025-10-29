module cpu_top (
	input logic       	MAX10_CLK1_50, // DE10-Lite only
	input logic  [9:0]	SW,
	input logic  [3:0]	KEY,
	output logic [9:0]	LEDR,
	output logic [7:0]	HEX5,
	output logic [7:0]	HEX4,
	output logic [7:0]	HEX3,
	output logic [7:0]	HEX2,
	output logic [7:0]	HEX1,
	output logic [7:0]	HEX0
);



// For remapping board-specific pin names to portable pin names
	logic CLK50; // portable signal name
	assign CLK50 = MAX10_CLK1_50;


// Choose which design to implement
	localparam enum { ALU, REGFILE, CPU }
		DESIGN = REGFILE;

	
// Design follows below:


	// user interface (inputs)
	logic clk, rst_n, wrA, imm;
	logic [1:0] selA, selB, aluOp, selR;
	assign rst_n = KEY[0];
	assign clk   = KEY[1];
	assign wrA   = SW[9];
	assign selA  = SW[8:7];
	assign selB  = SW[6:5];
	assign imm   = SW[2];
	assign selR  = SW[1:0];

	// user interface (outputs)
	logic [5:0] CC;
	logic [7:0] dataA, outReg, result;		
	sevenseg( .data(dataA[7:4]),  .segments(HEX5) );
	sevenseg( .data(dataA[3:0]),  .segments(HEX4) );
	sevenseg( .data(outReg[7:4]), .segments(HEX3) );
	sevenseg( .data(outReg[3:0]), .segments(HEX2) );
	sevenseg( .data(result[7:4]), .segments(HEX1) );
	sevenseg( .data(result[3:0]), .segments(HEX0) );
	assign LEDR[5:0] = CC;


	generate

		if( DESIGN == ALU ) begin

			// manually input dataA, dataB, aluOp from switches
			logic [7:0] dataB;
			assign aluOp      = SW[9:8];
			assign dataA[3:0] = SW[7:4];
			assign dataB[3:0] = SW[3:0];
			assign dataA[7:4] = { 4{dataA[3]} }; // sign-extended to 8b
			assign dataB[7:4] = { 4{dataB[3]} }; // sign-extended to 8b
			alu(
				.aluOp(aluOp), .dataA(dataA), .dataB(dataB), // inputs
				.R(result), .CC(CC)                  // outputs
			);
			assign outReg = dataB; // for visualization

		end else if( DESIGN == REGFILE ) begin

			logic [7:0] dataW;
			assign dataW[3:0] = SW[3:0]; // manually input dataW
			assign dataW[7:4] = { 4{dataW[3]} }; // sign-extended to 8b
			regfile(
				.clk(clk), .rst_n(rst_n),
				.WE(wrA), .selA(selA), .selB(selB), .dataW(dataW), // inputs
				.dataA(dataA), .dataB(outReg)                      // outputs
			);
			assign result = dataW;

		end else if( DESIGN == CPU ) begin

			assign aluOp = SW[4:3];
			cpu(
				.clk(clk), .rst_n(rst_n),
				.wrA(wrA), .selA(selA), .selB(selB),             // inputs
				.aluOp(aluOp), .imm(imm), .selR(selR),           // inputs
				.dataA(dataA), .outReg(outReg), .result(result), // outputs
				.CC(CC)
			);
		
		end

	endgenerate

endmodule

module sevenseg (input logic [3:0] data,
						output logic[6:0] segments);
						
						logic  D3, D2, D1, D0;
						assign D3 = data[3];
						assign D2 = data[2];
						assign D1 = data[1];
						assign D0 = data[0];
						
						assign segments[6] = (~D3 && ~D2 && ~D1 && ~D0) | (~D3 && ~D2 && ~D1 && D0) | (~D3 && D2 && D1 && D0);
						assign segments[5] = (~D3 && ~D2 && ~D1 && D0) | (~D3 && ~D2 && D1 && ~D0) | (~D3 && ~D2 && D1 && D0) | (~D3 && D2 && D1 && D0)  | (D3 && D2 && ~D1 && ~D0) | (D3 && D2 && ~D1 && D0);
						assign segments[4] = (~D3 && ~D2 && ~D1 && D0) | (~D3 && ~D2 && D1 && D0) | (~D3 && D2 && ~D1 && ~D0) | (~D3 && D2 && ~D1 && D0)  | (D3 && ~D2 && ~D1 && D0)  | (~D3 && D2 && D1 && D0);
						assign segments[3] = (~D3 && ~D2 && ~D1 && D0) | (~D3 && D2 && ~D1 && ~D0) | (~D3 && D2 && D1 && D0) | (D3 && ~D2 && D1 && ~D0) | (D3 && D2 && D1 && D0);
						assign segments[2] = (~D3 && ~D2 && D1 && ~D0) | (D3 && D2 && ~D1 && ~D0) | (D3 && D2 && D1 && ~D0) |  (D3 && D2 && D1 && D0);
						assign segments[1] = (~D3 &&  D2 && ~D1 && D0) | (~D3 &&  D2 &&  D1 && ~D0) | ( D3 &&  D2 &&  ~D1 && ~D0) | (D3 && D2 && D1 && ~D0) | (D3 && D2 && D1 && D0) | (D3 && ~D2 && D1 && D0);
						assign segments[0] = (~D3 && ~D2 && ~D1 && D0) | (D3 && D2 && ~D1 && ~D0) | (~D3 && D2 && ~D1 && ~D0) | (D3 && D2 && ~D1 && D0) |(D3 && ~D2 && D1 && D0);
						
endmodule