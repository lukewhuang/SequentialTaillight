module dimmer ( input [5:0] pattern ,
    input dim_clk ,
    input run_light ,
    output reg [5:0] out ) ;

// pattern = 5:3 right, 2:0 left C-B-A A-B-C
    always@(posedge dim_clk) begin
        if (run_light) begin
            if (out == pattern) begin
                out = 6'b111111;
            end else begin
                out = pattern;
            end
        end
        else begin
            out = pattern;
        end
    end
endmodule

module controller ( input clk ,
                    input dimclk ,
                    input rst ,
                    input left ,
                    input right ,
                    input brake ,
                    input hazard ,
                    input runlight ,
                    output [5:0] lights
                    ) ;
    reg [5:0] pattern = 6'b000000;
    reg [1:0] ls = 2'b00;
    reg [1:0] rs = 2'b00;
    reg [1:0] lsNext = 2'b00;
    reg [1:0] rsNext = 2'b00;
// instantiate dimmer module
dimmer dim (.pattern (pattern) ,
            .dim_clk (dimclk) ,
            .run_light (runlight) ,
            .out (lights) ) ;

// update the pattern based off the input
    always@ ( posedge clk )
        begin
            if (rst) begin
                ls = 2'b00;
                rs = 2'b00;
            end else begin
                ls <= lsNext;
                rs <= rsNext;
            end
        end
    always@(ls or rs) begin
    //convert to patterns
        case(rs)
            2'b00: pattern[5:3] = 3'b000;
            2'b01: pattern[5:3] = 3'b001;
            2'b10: pattern[5:3] = 3'b011;
            2'b11: pattern[5:3] = 3'b111;
        endcase

        case(ls)
            2'b00: pattern[2:0] = 3'b000;
            2'b01: pattern[2:0] = 3'b100;
            2'b10: pattern[2:0] = 3'b110;
            2'b11: pattern[2:0] = 3'b111;   
        endcase
    end

    always@(ls or rs or left or right or brake or hazard) begin
            //left light
            casex({left, right, brake, hazard})
                // Off
                4'b0x00: begin
                    lsNext = 2'b00;
                end
                
                // Hazard
                4'bxx01, 4'b110x: begin
                    if (ls == 2'b00) begin
                        lsNext = 2'b11;
                    end else begin
                        lsNext = 2'b00;
                    end
                end

                // Turn Signal
                4'b101x, 4'b10x0: begin
                    if (ls == 2'b00) begin
                        lsNext= 2'b01;
                    end else if (ls == 2'b01) begin
                        lsNext = 2'b10;
                    end
                    else if (ls == 2'b10) begin
                        lsNext = 2'b11;
                    end
                    else begin
                        lsNext = 2'b00;
                    end
                end

                // Brake
                4'b0x1x, 4'bx11x: begin
                    lsNext = 2'b11;
                end
            endcase

            //right light
            casex({left, right, brake, hazard})
                // Off
                4'bx000: begin
                    rsNext = 2'b00;
                end
                
                // Hazard
                4'bxx01, 4'b110x: begin
                    if (rs == 2'b00) begin
                        rsNext = 2'b11;
                    end else begin
                        rsNext = 2'b00;
                    end
                end

                // Turn Signal
                4'b01x0, 4'b011x: begin
                    if (rs == 2'b00) begin
                        rsNext = 2'b01;
                    end 
                    else if (rs == 2'b01) begin
                        rsNext = 2'b10;
                    end
                    else if (rs == 2'b10) begin
                        rsNext = 2'b11;
                    end
                    else if (rs == 2'b11) begin
                        rsNext = 2'b00;
                    end
                end

                // Brake
                4'bx01x, 4'b1x1x: begin
                    rsNext = 2'b11;
                end

            endcase
    end

    

endmodule


