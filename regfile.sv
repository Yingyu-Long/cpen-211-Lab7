module regfile ( input logic [9:0]SW,
             input logic [1:0] KEY,
             output logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

             logic enable;
             logic [7:0] dataA, dataB,dataW,R0,R1,R2,R3;
             logic [1:0] rA, rB;

			assign dataW = {{4{SW[3]}},SW[3:0]};
             assign enable = KEY[1];
             assign rA = SW[8:7];
             assign rB = SW[6:5];
             assgin write = SW[9];
				 
function automatic [6:0] sevenseg(input logic [3:0] data);
    logic D3, D2, D1, D0;
    begin
        D3 = data[3];
        D2 = data[2];
        D1 = data[1];
        D0 = data[0];

        sevenseg[6] = (~D3 && ~D2 && ~D1 && ~D0) | 
                             (~D3 && ~D2 && ~D1 && D0)  | 
                             (~D3 && D2 && D1 && D0);

        sevenseg[5] = (~D3 && ~D2 && ~D1 && D0) | 
                             (~D3 && ~D2 && D1 && ~D0) | 
                             (~D3 && ~D2 && D1 && D0)  | 
                             (~D3 && D2 && D1 && D0)   | 
                             (D3 && D2 && ~D1 && ~D0)  | 
                             (D3 && D2 && ~D1 && D0);

        sevenseg[4] = (~D3 && ~D2 && ~D1 && D0) | 
                             (~D3 && ~D2 && D1 && D0)  | 
                             (~D3 && D2 && ~D1 && ~D0) | 
                             (~D3 && D2 && ~D1 && D0)  | 
                             (D3 && ~D2 && ~D1 && D0)  | 
                             (~D3 && D2 && D1 && D0);

        sevenseg[3] = (~D3 && ~D2 && ~D1 && D0) | 
                             (~D3 && D2 && ~D1 && ~D0) | 
                             (~D3 && D2 && D1 && D0)   | 
                             (D3 && ~D2 && D1 && ~D0)  | 
                             (D3 && D2 && D1 && D0);

        sevenseg[2] = (~D3 && ~D2 && D1 && ~D0) | 
                             (D3 && D2 && ~D1 && ~D0)  | 
                             (D3 && D2 && D1 && ~D0)   |  
                             (D3 && D2 && D1 && D0);

        sevenseg[1] = (~D3 && D2 && ~D1 && D0)  | 
                             (~D3 && D2 && D1 && ~D0)  | 
                             (D3 && D2 && ~D1 && ~D0)  | 
                             (D3 && D2 && D1 && ~D0)   | 
                             (D3 && D2 && D1 && D0)    | 
                             (D3 && ~D2 && D1 && D0);

        sevenseg[0] = (~D3 && ~D2 && ~D1 && D0) | 
                             (D3 && D2 && ~D1 && ~D0)  | 
                             (~D3 && D2 && ~D1 && ~D0) | 
                             (D3 && D2 && ~D1 && D0)   | 
                             (D3 && ~D2 && D1 && D0);
    end
endfunction
             

             always_comb begin
                HEX1 = sevenseg(dataW[7:4]);
                HEX0 = sevenseg(dataW[3:0]);

             end
             

             always_ff @( posedge enable ) begin  // write operation
                if(write) begin
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
                end
                else begin
                    R0 <= R0;
                    R1 <=R1;
                    R2 <= R2;
                    R3 <= R3;

             end
             end

                always_comb begin  // read operation
                    case (rA)
                        2'b00: begin
                            dataA = R0;
                        end
    
                        2'b01: begin
                            dataA = R1;
                        end
    
                        2'b10: begin
                            dataA = R2;
                        end
    
                        2'b11: begin
                            dataA = R3;
                        end
                    endcase
    
                    case (rB)
                        2'b00: begin
                            dataB = R0;
                        end
    
                        2'b01: begin
                            dataB = R1;
                        end
    
                        2'b10: begin
                            dataB = R2;
                        end
    
                        2'b11: begin
                            dataB = R3;
                        end
                    endcase
                end

            always_comb begin
                case(rA)
                    2'b00: begin
								HEX5 = sevenseg(R0[7:4]);
								HEX4 = sevenseg(R0[3:0]);
                    end

                    2'b01: begin
								HEX5 = sevenseg(R1[7:4]);
								HEX4 = sevenseg(R1[3:0]);
                    end

                    2'b10: begin
								HEX5 = sevenseg(R2[7:4]);
								HEX4 = sevenseg(R2[3:0]);
                        
                        end

                    2'b11: begin
								HEX5 = sevenseg(R3[7:4]);
								HEX4 = sevenseg(R3[3:0]);
                    end
                    default: begin
                       			HEX5 = sevenseg(4'b0);
								HEX4 = sevenseg(4'b0); 
                    end
            endcase
            end

            always_comb begin
                case(rB)
                    2'b00: begin
								HEX3 = sevenseg(R0[7:4]);
								HEX2 = sevenseg(R0[3:0]);
                    end

                    2'b01: begin
								HEX3 = sevenseg(R1[7:4]);
								HEX2 = sevenseg(R1[3:0]);
                    end

                    2'b10: begin
								HEX3 = sevenseg(R2[7:4]);
								HEX2 = sevenseg(R2[3:0]);
                        end

                    2'b11: begin
								HEX3 = sevenseg(R3[7:4]);
								HEX2 = sevenseg(R3[3:0]);
                    end
                    default: begin
                        		HEX3 = sevenseg(4'b0);
								HEX2 = sevenseg(4'b0);
                    end
            endcase
            end

				
endmodule


