module alu(
	input logic [7:0] dataA,
	input logic [7:0] dataB,
	input logic [1:0] aluOp,
	output logic [7:0] R,
	output logic [5:0] CC
);
				logic[7:0] result;
				logic Z, N, VM, VP, B, C;
				assign CC = {Z, N, VM, VP, B, C};
				assign R = result;
				
			   always_comb begin
					case(aluOp)
						2'b00: begin
							result = dataA + dataB;
						end
						
						2'b01: begin
							result = dataA - dataB;
						end
						
						2'b10: begin
							result = dataA * dataB;
						end
						
						2'b11: begin
							result = dataA / dataB;
						end
					endcase
					
					 C = (dataA[7] & dataB[7]) | (dataA[7] & ~result[7]) | (dataB[7] & ~result[7]);
					 VP = (dataA[7] & dataB[7] & ~result[7]) | (~dataA[7] & ~dataB[7] & result[7]);
					 VM = (dataA[7] & ~dataB[7] & ~result[7]) | (~dataA[7] & dataB[7] & result[7]);
					 N = result[7];
					 B = (~dataA[7] & dataB[7]) | (dataB[7] & result[7]) | (~dataA[7] & result[7]);
					 Z = (result == 8'b0);
				end
				
							
endmodule


					 
					 

		