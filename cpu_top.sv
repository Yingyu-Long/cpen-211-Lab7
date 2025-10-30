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
		DESIGN = CPU;

	
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

module sevenseg
 ( input logic [3:0] data, output logic [7:0] segments );

	always_comb begin
		case (data)
			4'h0:	segments = 8'b1100_0000;
			4'h1:	segments = 8'b1111_1001;
			4'h2:	segments = 8'b1010_0100;
			4'h3:	segments = 8'b1011_0000;
			4'h4:	segments = 8'b1001_1001;
			4'h5:	segments = 8'b1001_0010;
			4'h6:	segments = 8'b1000_0010;
			4'h7:	segments = 8'b1111_1000;
			4'h8:	segments = 8'b1000_0000;
			4'h9:	segments = 8'b1001_1000;
			4'hA:	segments = 8'b1000_1000;
			4'hB:	segments = 8'b1000_0011;
			4'hC:	segments = 8'b1010_0111;
			4'hD:	segments = 8'b1010_0001;
			4'hE:	segments = 8'b1000_0110;
			4'hF:	segments = 8'b1000_1110;
			default: segments = 8'hFF; // all off
		endcase
	end

endmodule