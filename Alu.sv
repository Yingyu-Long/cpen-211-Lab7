module Alu (input logic [9:0] SW,
				output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
				output logic [9:0] LEDR);
				
				logic [7:0] dataA, dataB, result;
				logic C,B,VP,VM,N,Z;
				logic [1:0] aluOp;
				
				assign dataA = {{4{SW[7]}},SW[7:4]};
				assign dataB = {{4{SW[3]}},SW[3:0]};
				assign aluOp = SW[9:8];
				assign LEDR[5:0] = {C,B,VP,VM,N,Z};
				
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
				
				sevenseg hex5 (.data(dataA[7:4]),
									.segments(HEX5));
				
				sevenseg hex4 (.data(dataA[3:0]),
									.segments(HEX4));
									
				sevenseg hex3 (.data(dataB[7:4]),
									.segments(HEX3));
									
				sevenseg hex2 (.data(dataB[3:0]),
									.segments(HEX2));
									
				sevenseg hex1 (.data(result[7:4]),
									.segments(HEX1));
							
				sevenseg hex0 (.data(result[3:0]),
									.segments(HEX0));
				
				
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
					 
					 

		