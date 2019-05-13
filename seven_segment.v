`ifndef SEVEN_SEGMENT
`define SEVEN_SEGMENT
`timescale 1ns / 1ns // `timescale time_unit/time_precision

// controls the hex displays
module seven_segment(
        input [8:0] data,
        input enable, 
        input [1:0] mode,
        input [15:0] frequency,
        output reg [6:0] hex0, hex1, hex2, hex3, hex4
    );
    
    // for tone generator
    wire [3:0] noteName;
    wire [3:0] octave;
    assign noteName = data[7:4];
    assign octave = data[3:0];
    
    // for metronome
    reg [3:0] digit_m0, digit_m1, digit_m2;  // three digits for bpm in decimal
    wire [6:0] hex_m0, hex_m1, hex_m2;  // wires for HEX outputs
    
    //convert the BPM value to output for the HEX
    decimal d2(digit_m2, hex_m2);
    decimal d1(digit_m1, hex_m1);
    decimal d0(digit_m0, hex_m0);
    
    // for tuner
    wire [19:0] frequency_bcd;
    reg [3:0] digit_t0, digit_t1, digit_t2, digit_t3, digit_t4;
    wire [6:0] hex_t0, hex_t1, hex_t2, hex_t3, hex_t4;  // wires for HEX outputs
    
    //convert the frequency binary/hexadecimal number to binary-encoded decimal number
    binary_to_bcd b0(
        .binary(frequency),
        .bcd(frequency_bcd)
    );
    
    //convert frequency value to output for the HEX
    decimal d3(digit_t4, hex_t4);
    decimal d4(digit_t3, hex_t3);
    decimal d5(digit_t2, hex_t2);
    decimal d6(digit_t1, hex_t1);
    decimal d7(digit_t0, hex_t0);
    
    always @* 
    begin
        // set to blank by default
        hex4 = 7'b1111111;
        hex3 = 7'b1111111;
        hex2 = 7'b1111111;
        hex1 = 7'b1111111;
        hex0 = 7'b1111111;
        
        if (enable == 1'b1)
        begin
            if (mode == 2'b00)  // tone generator
            begin
                // HEX4 shows the octave number
                case (octave)
                    4'b0000: hex4 = 7'b1000000;
                    4'b0001: hex4 = 7'b1111001;
                    4'b0010: hex4 = 7'b0100100;
                    4'b0011: hex4 = 7'b0110000;
                    4'b0100: hex4 = 7'b0011001;
                    4'b0101: hex4 = 7'b0010010;
                    4'b0110: hex4 = 7'b0000010;
                    4'b0111: hex4 = 7'b1111000;
                    4'b1000: hex4 = 7'b0000000;
                    default: begin
                        hex4 = 7'b0000110; //E
                        hex3 = 7'b0101111; //r
                        hex2 = 7'b0101111; //r
                        hex1 = 7'b0100011; //o
                        hex0 = 7'b0101111; //r
                    end
                endcase

                // whole tones: only HEX3 shows the note name
                // semitones: HEX3 shows the sharp note name, HEX2 shows "H", HEX1 shows the flat note name, HEX0 shows "b"
                if (hex4 != 7'b0000110)  // octave input was valid
                begin
                    case (noteName)
                        4'b0000: hex3 = 7'b0001000;  //A
                        4'b0001: begin //AH bb
                            hex3 = 7'b0001000;
                            hex2 = 7'b0001001;
                            hex1 = 7'b0000011;
                            hex0 = 7'b0000011;
                        end
                        4'b0010: hex3 = 7'b0000011;  //b
                        4'b0011: hex3 = 7'b1000110;  //C
                        4'b0100: begin //CH db
                            hex3 = 7'b1000110;
                            hex2 = 7'b0001001;
                            hex1 = 7'b0100001;
                            hex0 = 7'b0000011;
                        end
                        4'b0101: hex3 = 7'b0100001;  //d
                        4'b0110: begin  //dH Eb
                            hex3 = 7'b0100001;
                            hex2 = 7'b0001001;
                            hex1 = 7'b0000110;
                            hex0 = 7'b0000011;
                        end
                        4'b0111: hex3 = 7'b0000110;  //E
                        4'b1000: hex3 = 7'b0001110;  //F
                        4'b1001: begin  //FH Gb
                            hex3 = 7'b0001110;
                            hex2 = 7'b0001001;
                            hex1 = 7'b1000010;
                            hex0 = 7'b0000011;
                        end
                        4'b1010: hex3 = 7'b1000010;  //G
                        4'b1011: begin  //GH Ab
                            hex3 = 7'b1000010;
                            hex2 = 7'b0001001;
                            hex1 = 7'b0001000;
                            hex0 = 7'b0000011;
                        end
                        default: begin
                            hex4 = 7'b0000110;  //E
                            hex3 = 7'b0101111;  //r
                            hex2 = 7'b0101111;  //r
                            hex1 = 7'b0100011;  //o
                            hex0 = 7'b0101111;  //r
                        end
                    endcase
                end  // end valid octave if
                // corner cases for illegal octave/note combinations
                if (octave == 4'b0000 && noteName > 4'b0010 || octave == 4'b1000 && noteName != 4'b0011) 
                begin
                    hex4 = 7'b0000110; //E
                    hex3 = 7'b0101111; //r
                    hex2 = 7'b0101111; //r
                    hex1 = 7'b0100011; //o
                    hex0 = 7'b0101111; //r
                end
            end 
            else if (mode == 2'b01)  // metronome
            begin
                // convert from hexadecimal to decimal
                digit_m2 = data/9'h64;
                digit_m1 = (data - digit_m2*9'h64)/9'ha;
                digit_m0 = data - digit_m2*9'h64 - digit_m1*9'ha;
                
                // if the two most significant digits are 0, set them to blank
                digit_m2 = (digit_m2 == 0) ? 4'd10 : digit_m2;
                digit_m1 = (digit_m1 == 0 && digit_m2 == 4'd10) ? 4'd10 : digit_m1;
                
                // connect the HEX displays to the BPM decimal number display
                hex2 = hex_m2;
                hex1 = hex_m1;
                hex0 = hex_m0;
            end
            else if (mode == 2'b10)  // tuner
            begin
                // get the value of each digit of the frequency number
                digit_t4 = (frequency_bcd[19:16] == 0) ? 4'd10 : frequency_bcd[19:16];
                digit_t3 = (frequency_bcd[15:12] == 0 && frequency_bcd[19:16] == 0) ? 4'd10 : frequency_bcd[15:12];
                digit_t2 = (frequency_bcd[11:8] == 0 && frequency_bcd[15:12] == 0 && frequency_bcd[19:16] == 0) ? 4'd10 : frequency_bcd[11:8];
                digit_t1 = (frequency_bcd[7:4] == 0 && frequency_bcd[11:8] == 0 && frequency_bcd[15:12] == 0 && frequency_bcd[19:16] == 0) ? 4'd10 : frequency_bcd[7:4];
                digit_t0 = frequency_bcd[3:0];
                
                // connect the HEX displays to the frequency decimal number display
                hex4 = hex_t4;
                hex3 = hex_t3;
                hex2 = hex_t2;
                hex1 = hex_t1;
                hex0 = hex_t0;
            end
            else  // mode value is invalid (should never happen)
            begin
                hex4 = 7'b0000110; //E
                hex3 = 7'b0101111; //r
                hex2 = 7'b0101111; //r
                hex1 = 7'b0100011; //o
                hex0 = 7'b0101111; //r
            end
       end
    end  // end always
    
endmodule


// converts a binary number to a binary-encoded decimal number
module binary_to_bcd(
        input [15:0] binary,
        output reg [19:0] bcd
    );
    
    integer i;
    always @*
    begin
        bcd = 20'b0;
        for (i = 0; i < 16; i = i + 1)
        begin
            if (bcd[19:16] >= 3'd5)
                bcd[19:16] = bcd[19:16] + 3;
            if (bcd[15:12] >= 3'd5)
                bcd[15:12] = bcd[15:12] + 3;
            if (bcd[11:8] >= 3'd5)
                bcd[11:8] = bcd[11:8] + 3;
            if (bcd[7:4] >= 3'd5)
                bcd[7:4] = bcd[7:4] + 3;
            if (bcd[3:0] >= 3'd5)
                bcd[3:0] = bcd[3:0] + 3;
                
            bcd = bcd << 1;
            bcd[0] = binary[15 - i];
        end
    end
    
endmodule


// displays a decimal number on the hex display
module decimal(digit, hex);
    input [3:0] digit;
    output reg [6:0] hex;
    
    always @* 
    begin
        case (digit)
            4'd0: hex = 7'b1000000;
            4'd1: hex = 7'b1111001;
            4'd2: hex = 7'b0100100;
            4'd3: hex = 7'b0110000;
            4'd4: hex = 7'b0011001;
            4'd5: hex = 7'b0010010;
            4'd6: hex = 7'b0000010;
            4'd7: hex = 7'b1111000;
            4'd8: hex = 7'b0000000;
            4'd9: hex = 7'b0010000;
            default: hex = 7'b1111111;
        endcase
    end
endmodule


`endif