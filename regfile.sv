module regfile(
	input logic clk,
	input logic rst_n,
	input logic WE,
	input logic [1:0] selA,
	input logic [1:0] selB,
	input logic [7:0] dataW,
	output logic [7:0] dataA,
	output logic [7:0] dataB
);

	logic [7:0] R [3:0]; 
	int i;

	always_ff @(posedge clk) begin
		if( !rst_n ) begin
			for( i=0; i<4; i++ ) R[i] <= 8'b0; // clear all 4 regs
		end else begin
			if( WE ) R[selA] <= dataW;
		end
	end

	// Asynchronous reads (2 ports)
	always_comb begin
		dataA = R[selA];
		dataB = R[selB];
	end

endmodule