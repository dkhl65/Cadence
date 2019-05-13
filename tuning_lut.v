`ifndef tuning_lut_v
`define tuning_lut_v


// maybe figure out how to use floating point later do be more precise
module tuning_lut(note_name, octave, clock_freq, delay);
    input [3:0] note_name;
    input [3:0] octave;
    input [25:0] clock_freq;
    
    output [21:0] delay;
    reg [12:0] note_freq;
    
    // assign 0 to delay if the selected note_name/octave combination is not within range
    // otherwise, assign the value of clock_freq/note_freq to delay
    assign delay = (note_freq == 13'd0) ? 22'b0 : clock_freq/note_freq;
    
    // just hardcode everything
    always @*
    begin
        case (note_name)
            // A
            4'b0000: begin
                case (octave)
                    4'b0000: note_freq = 13'd27;  // 27.5
                    4'b0001: note_freq = 13'd55;
                    4'b0010: note_freq = 13'd110;
                    4'b0011: note_freq = 13'd220;
                    4'b0100: note_freq = 13'd440;
                    4'b0101: note_freq = 13'd880;
                    4'b0110: note_freq = 13'd1760;
                    4'b0111: note_freq = 13'd3520;
                    default: note_freq = 13'd0;
                endcase
            end
            
            // A#/Bb
            4'b0001: begin
                case (octave)
                    4'b0000: note_freq = 13'd29;    // 29.14
                    4'b0001: note_freq = 13'd58;    // 58.27
                    4'b0010: note_freq = 13'd117;   // 116.54
                    4'b0011: note_freq = 13'd233;   // 233.08
                    4'b0100: note_freq = 13'd466;   // 466.16
                    4'b0101: note_freq = 13'd932;   // 932.33
                    4'b0110: note_freq = 13'd1865;  // 1864.66
                    4'b0111: note_freq = 13'd3729;  // 3729.31
                    default: note_freq = 13'd0;
                endcase
            end
            
            // B
            4'b0010: begin
                case (octave)
                    4'b0000: note_freq = 13'd31;    // 30.87
                    4'b0001: note_freq = 13'd62;    // 61.74
                    4'b0010: note_freq = 13'd123;   // 123.47
                    4'b0011: note_freq = 13'd247;   // 246.94
                    4'b0100: note_freq = 13'd494;   // 493.88
                    4'b0101: note_freq = 13'd988;   // 987.77
                    4'b0110: note_freq = 13'd1976;  // 1975.53
                    4'b0111: note_freq = 13'd3951;  // 3951.07
                    default: note_freq = 13'd0;
                endcase
            end
            
            // C
            4'b0011: begin
                case (octave)
                    4'b0001: note_freq = 13'd33;    // 32.70
                    4'b0010: note_freq = 13'd65;    // 65.41
                    4'b0011: note_freq = 13'd131;   // 130.81
                    4'b0100: note_freq = 13'd262;   // 261.63
                    4'b0101: note_freq = 13'd523;   // 523.25
                    4'b0110: note_freq = 13'd1047;  // 1046.50
                    4'b0111: note_freq = 13'd2093;  // 2093.01
                    4'b1000: note_freq = 13'd4186;  // 4186.01
                    default: note_freq = 13'd0;
                endcase
            end
            
            // C#/Db
            4'b0100: begin
                case (octave)
                    4'b0001: note_freq = 13'd35;    // 34.65
                    4'b0010: note_freq = 13'd69;    // 69.30
                    4'b0011: note_freq = 13'd139;   // 138.59
                    4'b0100: note_freq = 13'd277;   // 277.18
                    4'b0101: note_freq = 13'd554;   // 554.37
                    4'b0110: note_freq = 13'd1109;  // 1108.73
                    4'b0111: note_freq = 13'd2217;  // 2217.46
                    default: note_freq = 13'd0;
                endcase
            end
            
            // D
            4'b0101: begin
                case (octave)
                    4'b0001: note_freq = 13'd37;    // 36.71
                    4'b0010: note_freq = 13'd73;    // 73.42
                    4'b0011: note_freq = 13'd147;   // 146.83
                    4'b0100: note_freq = 13'd294;   // 293.66
                    4'b0101: note_freq = 13'd587;   // 587.33
                    4'b0110: note_freq = 13'd1175;  // 1174.66
                    4'b0111: note_freq = 13'd2349;  // 2349.32
                    default: note_freq = 13'd0;
                endcase
            end
            
            // D#/Eb
            4'b0110: begin
                case (octave)
                    4'b0001: note_freq = 13'd39;    // 38.89
                    4'b0010: note_freq = 13'd78;    // 77.78
                    4'b0011: note_freq = 13'd156;   // 155.56
                    4'b0100: note_freq = 13'd311;   // 311.13
                    4'b0101: note_freq = 13'd622;   // 622.25
                    4'b0110: note_freq = 13'd1244;  // 1244.51
                    4'b0111: note_freq = 13'd2489;  // 2489.02
                    default: note_freq = 13'd0;
                endcase
            end
            
            // E
            4'b0111: begin
                case (octave)
                    4'b0001: note_freq = 13'd41;    // 41.20
                    4'b0010: note_freq = 13'd82;    // 82.41
                    4'b0011: note_freq = 13'd165;   // 164.81
                    4'b0100: note_freq = 13'd330;   // 329.63
                    4'b0101: note_freq = 13'd659;   // 659.26
                    4'b0110: note_freq = 13'd1319;  // 1318.51
                    4'b0111: note_freq = 13'd2637;  // 2637.02
                    default: note_freq = 13'd0;
                endcase
            end
            
            // F
            4'b1000: begin
                case (octave)
                    4'b0001: note_freq = 13'd44;    // 43.65
                    4'b0010: note_freq = 13'd87;    // 87.31
                    4'b0011: note_freq = 13'd175;   // 174.61
                    4'b0100: note_freq = 13'd349;   // 349.23
                    4'b0101: note_freq = 13'd698;   // 698.46
                    4'b0110: note_freq = 13'd1397;  // 1396.91
                    4'b0111: note_freq = 13'd2794;  // 2793.83
                    default: note_freq = 13'd0;
                endcase
            end
            
            // F#/Gb
            4'b1001: begin
                case (octave)
                    4'b0001: note_freq = 13'd46;    // 46.25
                    4'b0010: note_freq = 13'd92;    // 92.50
                    4'b0011: note_freq = 13'd185;   // 185.00
                    4'b0100: note_freq = 13'd370;   // 370.00
                    4'b0101: note_freq = 13'd740;   // 739.99
                    4'b0110: note_freq = 13'd1480;  // 1479.98
                    4'b0111: note_freq = 13'd2960;  // 2959.96
                    default: note_freq = 13'd0;
                endcase
            end
            
            // G
            4'b1010: begin
                case (octave)
                    4'b0001: note_freq = 13'd49;    // 49.00
                    4'b0010: note_freq = 13'd98;    // 98.00
                    4'b0011: note_freq = 13'd196;   // 196.00
                    4'b0100: note_freq = 13'd392;   // 392.00
                    4'b0101: note_freq = 13'd784;   // 783.99
                    4'b0110: note_freq = 13'd1568;  // 1567.98
                    4'b0111: note_freq = 13'd3136;  // 3135.96
                    default: note_freq = 13'd0;
                endcase
            end
            
            // G#/Ab
            4'b1011: begin
                case (octave)
                    4'b0001: note_freq = 13'd52;    // 51.91
                    4'b0010: note_freq = 13'd104;   // 103.83
                    4'b0011: note_freq = 13'd208;   // 207.65
                    4'b0100: note_freq = 13'd415;   // 415.30
                    4'b0101: note_freq = 13'd831;   // 830.61
                    4'b0110: note_freq = 13'd1661;  // 1661.22
                    4'b0111: note_freq = 13'd3322;  // 3322.44
                    default: note_freq = 13'd0;
                endcase
            end
            default: note_freq = 13'd0;
        endcase
    end
endmodule
                    
`endif