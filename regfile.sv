module regfile ( input logic [9:0]SW,
             input logic [1:0] KEY,
             output logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6);

             logic enable;
             logic [7:0] dataA, dataB,dataW,R0,R1,R2,R3;
             logic [1:0] rA, rB;

			assign dataW = {{4{SW[3]}},SW[3:0]};
             assign enable = KEY[1];
             assign rA = SW[8:7];
             assign rB = SW[6:5];
             

             always_ff @( posedge enable ) begin : 
                if(SW[9] ==1) begin
                    case (rA)
                        2'b00: begin
                            R0 <= dataW;
                        end

                        2'b01: begin
                            R1 <= dataW;
                        end

                        2'b10: begin
                            R2 <= dataW;
                        end

                        2'b11: begin
                            R3 <= dataW;
                        end
                    endcase

                    case (rB)
                        2'b00: begin
                            R0 <= dataW;
                        end

                        2'b01: begin
                            R1 <= dataW;
                        end

                        2'b10: begin
                            R2 <= dataW;
                        end

                        2'b11: begin
                            R3 <= dataW;
                        end
                    endcase
                end
                else begin
                    R0 <= R0;
                    R1 <=R1;
                    R2 <= R2;
                    R3 <= R3;

             end
             end

            always_comb begin
                case(rA)
                    2'b00: begin
                        sevenseg Hex5A(.data(R0[7:4]),
                                      .segments(HEX5));
                        sevenseg Hex4A(.data(R0[3:0]),
                                      .segments(HEX4));
                    end

                    2'b01: begin
                        sevenseg Hex5B(.data(R1[7:4]),
                                      .segments(HEX5));
                        sevenseg Hex4B(.data(R1[3:0]),
                                      .segments(HEX4));
                    end

                    2'b10: begin
                        sevenseg Hex5C(.data(R2[7:4]), 
                                      .segments(HEX5));
                        sevenseg Hex4B(.data(R2[3:0]),
                                      .segments(HEX4));
                        
                        end

                    2'b11: begin
                        sevenseg Hex5D(.data(R3[7:4]), 
                                      .segments(HEX5));
                        sevenseg Hex4D(.data(R3[3:0]),
                                      .segments(HEX4));
                    end
            endcase
            end

            always_comb begin
                case(rB)
                    2'b00: begin
                        sevenseg Hex3A(.data(R0[7:4]),
                                      .segments(HEX3));
                        sevenseg Hex2A(.data(R0[3:0]),
                                      .segments(HEX2));
                    end

                    2'b01: begin
                        sevenseg Hex3B(.data(R1[7:4]),
                                      .segments(HEX3));
                        sevenseg Hex2B(.data(R1[3:0]),
                                      .segments(HEX2));
                    end

                    2'b10: begin
                        sevenseg Hex3C(.data(R2[7:4]), 
                                      .segments(HEX3));
                        sevenseg Hex2B(.data(R2[3:0]),
                                      .segments(HEX2));
                        
                        end

                    2'b11: begin
                        sevenseg Hex3D(.data(R3[7:4]), 
                                      .segments(HEX3));
                        sevenseg Hex2D(.data(R3[3:0]),
                                      .segments(HEX2));
                    end
            endcase
            end    
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