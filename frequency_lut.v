`ifndef frequency_lut_v
`define frequency_lut_v


module frequency_lut(
        input [2:0] oct0, oct1, oct2, oct3, oct4, oct5, oct6, oct7, oct8, //all octave numbers
        input [2:0] C, CHDb, D, DHEb, E, F, FHGb, G, GHAb, A, AHBb, B, //all note names
        input [15:0] frequency, //input from the FFT

        output reg [2:0] octaveColour, //selected octave number
        output reg [2:0] noteColour, //selected note name
        output reg [11:0] freqOffset, //offset from desired frequncy in Hz
        output reg positive //whether the offset is positive or negative
    );
    
    always @*
    begin
        if (frequency <= 16'd27)
        begin
            octaveColour <= oct0;
            noteColour <= A;
            freqOffset <= 16'd27 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd28)
        begin
            octaveColour <= oct0;
            noteColour <= A;
            freqOffset <= frequency - 16'd27;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd29)
        begin
            octaveColour <= oct0;
            noteColour <= AHBb;
            freqOffset <= 16'd29 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd30)
        begin
            octaveColour <= oct0;
            noteColour <= AHBb;
            freqOffset <= frequency - 16'd29;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd31)
        begin
            octaveColour <= oct0;
            noteColour <= B;
            freqOffset <= 16'd31 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd32)
        begin
            octaveColour <= oct0;
            noteColour <= B;
            freqOffset <= frequency - 16'd31;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd33)
        begin
            octaveColour <= oct1;
            noteColour <= C;
            freqOffset <= 16'd33 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd34)
        begin
            octaveColour <= oct1;
            noteColour <= C;
            freqOffset <= frequency - 16'd33;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd35)
        begin
            octaveColour <= oct1;
            noteColour <= CHDb;
            freqOffset <= 16'd35 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd36)
        begin
            octaveColour <= oct1;
            noteColour <= CHDb;
            freqOffset <= frequency - 16'd35;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd37)
        begin
            octaveColour <= oct1;
            noteColour <= D;
            freqOffset <= 16'd37 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd38)
        begin
            octaveColour <= oct1;
            noteColour <= D;
            freqOffset <= frequency - 16'd37;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd39)
        begin
            octaveColour <= oct1;
            noteColour <= DHEb;
            freqOffset <= 16'd39 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd40)
        begin
            octaveColour <= oct1;
            noteColour <= DHEb;
            freqOffset <= frequency - 16'd39;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd41)
        begin
            octaveColour <= oct1;
            noteColour <= E;
            freqOffset <= 16'd41 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd42)
        begin
            octaveColour <= oct1;
            noteColour <= E;
            freqOffset <= frequency - 16'd41;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd44)
        begin
            octaveColour <= oct1;
            noteColour <= F;
            freqOffset <= 16'd44 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd45)
        begin
            octaveColour <= oct1;
            noteColour <= F;
            freqOffset <= frequency - 16'd44;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd46)
        begin
            octaveColour <= oct1;
            noteColour <= FHGb;
            freqOffset <= 16'd46 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd47)
        begin
            octaveColour <= oct1;
            noteColour <= FHGb;
            freqOffset <= frequency - 16'd46;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd49)
        begin
            octaveColour <= oct1;
            noteColour <= G;
            freqOffset <= 16'd49 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd50)
        begin
            octaveColour <= oct1;
            noteColour <= G;
            freqOffset <= frequency - 16'd49;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd52)
        begin
            octaveColour <= oct1;
            noteColour <= GHAb;
            freqOffset <= 16'd52 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd53)
        begin
            octaveColour <= oct1;
            noteColour <= GHAb;
            freqOffset <= frequency - 16'd52;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd55)
        begin
            octaveColour <= oct1;
            noteColour <= A;
            freqOffset <= 16'd55 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd56)
        begin
            octaveColour <= oct1;
            noteColour <= A;
            freqOffset <= frequency - 16'd55;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd58)
        begin
            octaveColour <= oct0;
            noteColour <= AHBb;
            freqOffset <= 16'd58 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd60)
        begin
            octaveColour <= oct0;
            noteColour <= AHBb;
            freqOffset <= frequency - 16'd58;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd62)
        begin
            octaveColour <= oct0;
            noteColour <= B;
            freqOffset <= 16'd62 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd63)
        begin
            octaveColour <= oct0;
            noteColour <= B;
            freqOffset <= frequency - 16'd62;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd65)
        begin
            octaveColour <= oct2;
            noteColour <= C;
            freqOffset <= 16'd65 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd67)
        begin
            octaveColour <= oct2;
            noteColour <= C;
            freqOffset <= frequency - 16'd65;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd69)
        begin
            octaveColour <= oct2;
            noteColour <= CHDb;
            freqOffset <= 16'd69 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd71)
        begin
            octaveColour <= oct2;
            noteColour <= CHDb;
            freqOffset <= frequency - 16'd69;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd73)
        begin
            octaveColour <= oct2;
            noteColour <= D;
            freqOffset <= 16'd73 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd75)
        begin
            octaveColour <= oct2;
            noteColour <= D;
            freqOffset <= frequency - 16'd73;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd78)
        begin
            octaveColour <= oct2;
            noteColour <= DHEb;
            freqOffset <= 16'd78 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd80)
        begin
            octaveColour <= oct2;
            noteColour <= DHEb;
            freqOffset <= frequency - 16'd78;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd82)
        begin
            octaveColour <= oct2;
            noteColour <= E;
            freqOffset <= 16'd82 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd84)
        begin
            octaveColour <= oct2;
            noteColour <= E;
            freqOffset <= frequency - 16'd82;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd87)
        begin
            octaveColour <= oct2;
            noteColour <= F;
            freqOffset <= 16'd87 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd89)
        begin
            octaveColour <= oct2;
            noteColour <= F;
            freqOffset <= frequency - 16'd87;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd92)
        begin
            octaveColour <= oct2;
            noteColour <= FHGb;
            freqOffset <= 16'd92 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd95)
        begin
            octaveColour <= oct2;
            noteColour <= FHGb;
            freqOffset <= frequency - 16'd92;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd98)
        begin
            octaveColour <= oct2;
            noteColour <= G;
            freqOffset <= 16'd98 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd101)
        begin
            octaveColour <= oct2;
            noteColour <= G;
            freqOffset <= frequency - 16'd98;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd104)
        begin
            octaveColour <= oct2;
            noteColour <= GHAb;
            freqOffset <= 16'd104 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd107)
        begin
            octaveColour <= oct2;
            noteColour <= GHAb;
            freqOffset <= frequency - 16'd104;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd110)
        begin
            octaveColour <= oct2;
            noteColour <= A;
            freqOffset <= 16'd110 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd113)
        begin
            octaveColour <= oct2;
            noteColour <= A;
            freqOffset <= frequency - 16'd110;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd117)
        begin
            octaveColour <= oct2;
            noteColour <= AHBb;
            freqOffset <= 16'd117 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd120)
        begin
            octaveColour <= oct2;
            noteColour <= AHBb;
            freqOffset <= frequency - 16'd117;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd123)
        begin
            octaveColour <= oct2;
            noteColour <= B;
            freqOffset <= 16'd123 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd127)
        begin
            octaveColour <= oct2;
            noteColour <= B;
            freqOffset <= frequency - 16'd123;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd131)
        begin
            octaveColour <= oct3;
            noteColour <= C;
            freqOffset <= 16'd131 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd135)
        begin
            octaveColour <= oct3;
            noteColour <= C;
            freqOffset <= frequency - 16'd131;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd139)
        begin
            octaveColour <= oct3;
            noteColour <= CHDb;
            freqOffset <= 16'd139 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd143)
        begin
            octaveColour <= oct3;
            noteColour <= CHDb;
            freqOffset <= frequency - 16'd139;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd147)
        begin
            octaveColour <= oct3;
            noteColour <= D;
            freqOffset <= 16'd147 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd151)
        begin
            octaveColour <= oct3;
            noteColour <= D;
            freqOffset <= frequency - 16'd147;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd156)
        begin
            octaveColour <= oct3;
            noteColour <= DHEb;
            freqOffset <= 16'd156 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd160)
        begin
            octaveColour <= oct3;
            noteColour <= DHEb;
            freqOffset <= frequency - 16'd156;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd165)
        begin
            octaveColour <= oct3;
            noteColour <= E;
            freqOffset <= 16'd165 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd170)
        begin
            octaveColour <= oct3;
            noteColour <= E;
            freqOffset <= frequency - 16'd165;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd175)
        begin
            octaveColour <= oct3;
            noteColour <= F;
            freqOffset <= 16'd175 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd180)
        begin
            octaveColour <= oct3;
            noteColour <= F;
            freqOffset <= frequency - 16'd175;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd185)
        begin
            octaveColour <= oct3;
            noteColour <= FHGb;
            freqOffset <= 16'd185 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd190)
        begin
            octaveColour <= oct3;
            noteColour <= FHGb;
            freqOffset <= frequency - 16'd185;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd196)
        begin
            octaveColour <= oct3;
            noteColour <= G;
            freqOffset <= 16'd196 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd202)
        begin
            octaveColour <= oct3;
            noteColour <= G;
            freqOffset <= frequency - 16'd196;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd208)
        begin
            octaveColour <= oct3;
            noteColour <= GHAb;
            freqOffset <= 16'd208 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd214)
        begin
            octaveColour <= oct3;
            noteColour <= GHAb;
            freqOffset <= frequency - 16'd208;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd220)
        begin
            octaveColour <= oct3;
            noteColour <= A;
            freqOffset <= 16'd220 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd226)
        begin
            octaveColour <= oct3;
            noteColour <= A;
            freqOffset <= frequency - 16'd220;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd233)
        begin
            octaveColour <= oct3;
            noteColour <= AHBb;
            freqOffset <= 16'd233 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd240)
        begin
            octaveColour <= oct3;
            noteColour <= AHBb;
            freqOffset <= frequency - 16'd233;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd247)
        begin
            octaveColour <= oct3;
            noteColour <= B;
            freqOffset <= 16'd247 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd254)
        begin
            octaveColour <= oct3;
            noteColour <= B;
            freqOffset <= frequency - 16'd247;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd262)
        begin
            octaveColour <= oct4;
            noteColour <= C;
            freqOffset <= 16'd262 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd269)
        begin
            octaveColour <= oct4;
            noteColour <= C;
            freqOffset <= frequency - 16'd262;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd277)
        begin
            octaveColour <= oct4;
            noteColour <= CHDb;
            freqOffset <= 16'd277 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd285)
        begin
            octaveColour <= oct4;
            noteColour <= CHDb;
            freqOffset <= frequency - 16'd277;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd294)
        begin
            octaveColour <= oct4;
            noteColour <= D;
            freqOffset <= 16'd294 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd302)
        begin
            octaveColour <= oct4;
            noteColour <= D;
            freqOffset <= frequency - 16'd294;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd311)
        begin
            octaveColour <= oct4;
            noteColour <= DHEb;
            freqOffset <= 16'd311 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd320)
        begin
            octaveColour <= oct4;
            noteColour <= DHEb;
            freqOffset <= frequency - 16'd311;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd330)
        begin
            octaveColour <= oct4;
            noteColour <= E;
            freqOffset <= 16'd330 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd339)
        begin
            octaveColour <= oct4;
            noteColour <= E;
            freqOffset <= frequency - 16'd330;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd349)
        begin
            octaveColour <= oct4;
            noteColour <= F;
            freqOffset <= 16'd349 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd359)
        begin
            octaveColour <= oct4;
            noteColour <= F;
            freqOffset <= frequency - 16'd349;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd370)
        begin
            octaveColour <= oct4;
            noteColour <= FHGb;
            freqOffset <= 16'd370 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd381)
        begin
            octaveColour <= oct4;
            noteColour <= FHGb;
            freqOffset <= frequency - 16'd370;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd392)
        begin
            octaveColour <= oct4;
            noteColour <= G;
            freqOffset <= 16'd392 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd403)
        begin
            octaveColour <= oct4;
            noteColour <= G;
            freqOffset <= frequency - 16'd392;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd415)
        begin
            octaveColour <= oct4;
            noteColour <= GHAb;
            freqOffset <= 16'd415 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd427)
        begin
            octaveColour <= oct4;
            noteColour <= GHAb;
            freqOffset <= frequency - 16'd415;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd440)
        begin
            octaveColour <= oct4;
            noteColour <= A;
            freqOffset <= 16'd440 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd453)
        begin
            octaveColour <= oct4;
            noteColour <= A;
            freqOffset <= frequency - 16'd440;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd466)
        begin
            octaveColour <= oct4;
            noteColour <= AHBb;
            freqOffset <= 16'd466 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd480)
        begin
            octaveColour <= oct4;
            noteColour <= AHBb;
            freqOffset <= frequency - 16'd466;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd494)
        begin
            octaveColour <= oct4;
            noteColour <= B;
            freqOffset <= 16'd494 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd508)
        begin
            octaveColour <= oct4;
            noteColour <= B;
            freqOffset <= frequency - 16'd494;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd523)
        begin
            octaveColour <= oct5;
            noteColour <= C;
            freqOffset <= 16'd523 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd538)
        begin
            octaveColour <= oct5;
            noteColour <= C;
            freqOffset <= frequency - 16'd523;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd554)
        begin
            octaveColour <= oct5;
            noteColour <= CHDb;
            freqOffset <= 16'd554 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd570)
        begin
            octaveColour <= oct5;
            noteColour <= CHDb;
            freqOffset <= frequency - 16'd554;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd587)
        begin
            octaveColour <= oct5;
            noteColour <= D;
            freqOffset <= 16'd587 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd604)
        begin
            octaveColour <= oct5;
            noteColour <= D;
            freqOffset <= frequency - 16'd587;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd622)
        begin
            octaveColour <= oct5;
            noteColour <= DHEb;
            freqOffset <= 16'd622 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd640)
        begin
            octaveColour <= oct5;
            noteColour <= DHEb;
            freqOffset <= frequency - 16'd622;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd659)
        begin
            octaveColour <= oct5;
            noteColour <= E;
            freqOffset <= 16'd659 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd678)
        begin
            octaveColour <= oct5;
            noteColour <= E;
            freqOffset <= frequency - 16'd659;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd698)
        begin
            octaveColour <= oct5;
            noteColour <= F;
            freqOffset <= 16'd698 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd719)
        begin
            octaveColour <= oct5;
            noteColour <= F;
            freqOffset <= frequency - 16'd698;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd740)
        begin
            octaveColour <= oct5;
            noteColour <= FHGb;
            freqOffset <= 16'd740 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd762)
        begin
            octaveColour <= oct5;
            noteColour <= FHGb;
            freqOffset <= frequency - 16'd740;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd784)
        begin
            octaveColour <= oct5;
            noteColour <= G;
            freqOffset <= 16'd784 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd807)
        begin
            octaveColour <= oct5;
            noteColour <= G;
            freqOffset <= frequency - 16'd784;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd831)
        begin
            octaveColour <= oct5;
            noteColour <= GHAb;
            freqOffset <= 16'd831 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd855)
        begin
            octaveColour <= oct5;
            noteColour <= GHAb;
            freqOffset <= frequency - 16'd831;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd880)
        begin
            octaveColour <= oct5;
            noteColour <= A;
            freqOffset <= 16'd880 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd906)
        begin
            octaveColour <= oct5;
            noteColour <= A;
            freqOffset <= frequency - 16'd880;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd932)
        begin
            octaveColour <= oct5;
            noteColour <= AHBb;
            freqOffset <= 16'd932 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd960)
        begin
            octaveColour <= oct5;
            noteColour <= AHBb;
            freqOffset <= frequency - 16'd932;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd988)
        begin
            octaveColour <= oct5;
            noteColour <= B;
            freqOffset <= 16'd988 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd1017)
        begin
            octaveColour <= oct5;
            noteColour <= B;
            freqOffset <= frequency - 16'd988;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd1047)
        begin
            octaveColour <= oct6;
            noteColour <= C;
            freqOffset <= 16'd1047 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd1078)
        begin
            octaveColour <= oct6;
            noteColour <= C;
            freqOffset <= frequency - 16'd1047;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd1109)
        begin
            octaveColour <= oct6;
            noteColour <= CHDb;
            freqOffset <= 16'd1109 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd1142)
        begin
            octaveColour <= oct6;
            noteColour <= CHDb;
            freqOffset <= frequency - 16'd1109;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd1175)
        begin
            octaveColour <= oct6;
            noteColour <= D;
            freqOffset <= 16'd1175 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd1210)
        begin
            octaveColour <= oct6;
            noteColour <= D;
            freqOffset <= frequency - 16'd1175;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd1245)
        begin
            octaveColour <= oct6;
            noteColour <= DHEb;
            freqOffset <= 16'd1245 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd1282)
        begin
            octaveColour <= oct6;
            noteColour <= DHEb;
            freqOffset <= frequency - 16'd1245;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd1319)
        begin
            octaveColour <= oct6;
            noteColour <= E;
            freqOffset <= 16'd1319 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd1358)
        begin
            octaveColour <= oct6;
            noteColour <= E;
            freqOffset <= frequency - 16'd1319;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd1397)
        begin
            octaveColour <= oct6;
            noteColour <= F;
            freqOffset <= 16'd1397 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd1438)
        begin
            octaveColour <= oct6;
            noteColour <= F;
            freqOffset <= frequency - 16'd1397;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd1480)
        begin
            octaveColour <= oct6;
            noteColour <= FHGb;
            freqOffset <= 16'd1480 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd1524)
        begin
            octaveColour <= oct6;
            noteColour <= FHGb;
            freqOffset <= frequency - 16'd1480;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd1568)
        begin
            octaveColour <= oct6;
            noteColour <= G;
            freqOffset <= 16'd1568 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd1614)
        begin
            octaveColour <= oct6;
            noteColour <= G;
            freqOffset <= frequency - 16'd1568;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd1661)
        begin
            octaveColour <= oct6;
            noteColour <= GHAb;
            freqOffset <= 16'd1661 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd1710)
        begin
            octaveColour <= oct6;
            noteColour <= GHAb;
            freqOffset <= frequency - 16'd1661;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd1760)
        begin
            octaveColour <= oct6;
            noteColour <= A;
            freqOffset <= 16'd1760 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd1812)
        begin
            octaveColour <= oct6;
            noteColour <= A;
            freqOffset <= frequency - 16'd1760;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd1865)
        begin
            octaveColour <= oct6;
            noteColour <= AHBb;
            freqOffset <= 16'd1865 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd1920)
        begin
            octaveColour <= oct6;
            noteColour <= AHBb;
            freqOffset <= frequency - 16'd1865;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd1976)
        begin
            octaveColour <= oct6;
            noteColour <= B;
            freqOffset <= 16'd1976 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd2034)
        begin
            octaveColour <= oct6;
            noteColour <= B;
            freqOffset <= frequency - 16'd1976;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd2093)
        begin
            octaveColour <= oct7;
            noteColour <= C;
            freqOffset <= 16'd2093 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd2105)
        begin
            octaveColour <= oct7;
            noteColour <= C;
            freqOffset <= frequency - 16'd2093;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd2217)
        begin
            octaveColour <= oct7;
            noteColour <= CHDb;
            freqOffset <= 16'd2217 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd2283)
        begin
            octaveColour <= oct7;
            noteColour <= CHDb;
            freqOffset <= frequency - 16'd2217;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd2349)
        begin
            octaveColour <= oct7;
            noteColour <= D;
            freqOffset <= 16'd2349 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd2419)
        begin
            octaveColour <= oct7;
            noteColour <= D;
            freqOffset <= frequency - 16'd2349;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd2489)
        begin
            octaveColour <= oct7;
            noteColour <= DHEb;
            freqOffset <= 16'd2489 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd2563)
        begin
            octaveColour <= oct7;
            noteColour <= DHEb;
            freqOffset <= frequency - 16'd2489;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd2637)
        begin
            octaveColour <= oct7;
            noteColour <= E;
            freqOffset <= 16'd2637 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd2715)
        begin
            octaveColour <= oct7;
            noteColour <= E;
            freqOffset <= frequency - 16'd2637;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd2793)
        begin
            octaveColour <= oct7;
            noteColour <= F;
            freqOffset <= 16'd2793 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd2876)
        begin
            octaveColour <= oct7;
            noteColour <= F;
            freqOffset <= frequency - 16'd2793;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd2960)
        begin
            octaveColour <= oct7;
            noteColour <= FHGb;
            freqOffset <= 16'd2960 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd3048)
        begin
            octaveColour <= oct7;
            noteColour <= FHGb;
            freqOffset <= frequency - 16'd2960;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd3136)
        begin
            octaveColour <= oct7;
            noteColour <= G;
            freqOffset <= 16'd3136 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd3229)
        begin
            octaveColour <= oct7;
            noteColour <= G;
            freqOffset <= frequency - 16'd3136;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd3322)
        begin
            octaveColour <= oct7;
            noteColour <= GHAb;
            freqOffset <= 16'd3322 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd3421)
        begin
            octaveColour <= oct7;
            noteColour <= GHAb;
            freqOffset <= frequency - 16'd3322;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd3520)
        begin
            octaveColour <= oct7;
            noteColour <= A;
            freqOffset <= 16'd3520 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd3624)
        begin
            octaveColour <= oct7;
            noteColour <= A;
            freqOffset <= frequency - 16'd3520;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd3729)
        begin
            octaveColour <= oct7;
            noteColour <= AHBb;
            freqOffset <= 16'd3729 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd3840)
        begin
            octaveColour <= oct7;
            noteColour <= AHBb;
            freqOffset <= frequency - 16'd3729;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd3951)
        begin
            octaveColour <= oct7;
            noteColour <= B;
            freqOffset <= 16'd3951 - frequency;
            positive <= 1'b0;
        end
        else if (frequency <= 16'd4068)
        begin
            octaveColour <= oct7;
            noteColour <= B;
            freqOffset <= frequency - 16'd3951;
            positive <= 1'b1;
        end
        else if (frequency <= 16'd4186)
        begin
            octaveColour <= oct8;
            noteColour <= C;
            freqOffset <= 16'd4186 - frequency;
            positive <= 1'b0;
        end
        else // frequency > 16'd4186
        begin
            octaveColour <= oct8;
            noteColour <= C;
            freqOffset <= frequency - 16'd4186;
            positive <= 1'b1;
        end
    end

endmodule

`endif