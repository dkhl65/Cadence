`ifndef VGA_V
`define VGA_V
`include "frequency_lut.v"

module vga
    (
        CLOCK_50,
        KEY,
        SW,
        mode,
        frequency,
        redraw,
        colour,
        x,
        y,
        writeEn,
        resetn
    );
    
    //standard FPGA inputs
    input CLOCK_50;
    input [3:0] KEY;
    input [9:0] SW;
    input [1:0] mode;
    input [15:0] frequency;
    
    //special command input for redrawing the screen
    input redraw;

    //create the colour, x, y and writeEn outputs that are inputs to the vga_adapter
    output [2:0] colour;
    output [8:0] x;
    output [7:0] y;
    output writeEn;
    output resetn;

    wire [16:0] address; //counter variable for accessing RAM
    wire [2:0] draw; //indicates what to draw

    assign resetn = KEY[0]; //vga_adapter reset, controlled by KEY0
    assign writeEn = (draw > 0)?1:0; //allow the image on the monitor to change
    
    //control
    addressCounter addrCount(
            .draw(draw),
            .clock(CLOCK_50),
            .resetn(resetn),
            .address(address)
    );
    controlVGA ctrl(
            .mode(mode),
            .clock(CLOCK_50),
            .resetn(resetn),
            .redraw(redraw),
            .SW(SW),
            .address(address),
            .draw(draw)
    );
    
    //datapath
    datapathVGA data(
            .draw(draw),
            .mode(mode),
            .frequency(frequency),
            .SW(SW),
            .clock(CLOCK_50),
            .resetn(resetn),
            .address(address),
            .x(x),
            .y(y),
            .colour(colour)
    );
endmodule

//counts from 0 to a number depending on the command to output a RAM address
module addressCounter(draw, clock, resetn, address);
    input [2:0] draw; //indicates counting limit
	input clock, resetn; 
	output reg [16:0] address;

	initial address = 0;

	always@(posedge clock) begin
		if(!resetn) address <= 0;
        else if(draw == 3'd1) begin //normal drawing mode
			if(address < 17'd76799) address <= address + 1;
        end else if(draw == 3'd2) begin //draw a note (oval)
            if(address < 17'd31) address <= address + 1;
        end else if(draw == 3'd3) begin //draw a sharp symbol (#)
            if(address < 17'd48) address <= address + 1;
        end else address <= 0;
	end
endmodule

//main control for sending the correct draw commands to the datapath
module controlVGA(mode, clock, resetn, redraw, SW, address, draw);
    input [1:0] mode;
    input clock, resetn, redraw;
    input [9:0] SW;
    input [16:0] address;
    output reg [2:0] draw;

    reg [2:0] currentState, nextState; //for FSM
    
    //FSM modes
    localparam DONE       = 3'd0, //reset the counter
               BACKGROUND = 3'd1, //draws the background
               
               //only for tone generator mode
               WAIT1      = 3'd2, //reset the counter
               NOTE       = 3'd3, //draw an oval shaped whole note
               WAIT2      = 3'd4, //reset the counter
               SHARP      = 3'd5, //draw a sharp sign
               HOLD       = 3'd6; //wait until redraw signal is given

    //FSM state transitions
    always@(*) begin
        case(currentState)
            DONE: nextState = BACKGROUND;
            BACKGROUND: begin
                if(address == 17'd76799) begin //count enough addresses to draw the whole screen
                    if(mode == 2'b00 && !(SW[3:0] == 4'd0 && SW[7:4] > 4'd2 || 
                        SW[3:0] == 4'd8 && SW[7:4] != 4'd3 || SW[7:4] > 4'd11 || SW[3:0] > 4'd8))
                        nextState = WAIT1; //note and octave combos are legal, so go to the note drawing states
                    else nextState = DONE;
                end else nextState = BACKGROUND;
            end
            WAIT1: nextState = NOTE;
            NOTE: begin
                if(address == 17'd31) begin //count the number of pixels of the oval shaped whole note
                    if(SW[7:4] == 4'd1 || SW[7:4] == 4'd4 || SW[7:4] == 4'd6 || SW[7:4] == 4'd9 || SW[7:4] == 4'd11)
                        nextState = WAIT2; //go to the sharp sign drawing states for semitones
                    else nextState= HOLD;
                end else nextState = NOTE;
            end
            WAIT2: nextState = SHARP;
            SHARP: nextState = (address == 17'd48)? HOLD : SHARP; //count the number of pixels of "#"
            HOLD: nextState = (mode == 2'b00)? HOLD : BACKGROUND; //wait here until there is a need to redraw
            default: nextState = BACKGROUND;
        endcase
    end
    
    //set the draw signals
    always@(*) begin
        draw = 3'd0;
        case(currentState)
            BACKGROUND: draw = 3'd1;
            NOTE: draw = 3'd2;
            SHARP: draw = 3'd3;
        endcase
    end
    
    //sychronous state changes
    always@(posedge clock) begin
        if(!resetn || redraw) currentState <= BACKGROUND;
        else currentState <= nextState;
    end
endmodule

//provides all the input the vga_adapter needs
module datapathVGA(draw, mode, frequency, SW, clock, resetn, address, x, y, colour);
    input [2:0] draw;
    input [1:0] mode;
    input [15:0] frequency;
    input [9:0] SW;
    input clock, resetn;
    input [16:0] address;
    output reg [8:0] x;
    output reg [7:0] y;
    output reg [2:0] colour;
    
    //outputs from RAM
    wire [2:0] staffColour, metronomeColour, tunerColour; //background pixel colours
    wire [2:0] C, CHDb, D, DHEb, E, F, FHGb, G, GHAb, A, AHBb, B; //all music note names
    wire [2:0] oct0, oct1, oct2, oct3, oct4, oct5, oct6, oct7, oct8; //all octave numbers
    wire [2:0] noteColour, octaveColour; //pixel colours of note name and octave number
    
    //RAM address to access for drawing octave number and note name
    wire [8:0] octAddr, noteAddr;
    wire [5:0] octaveAddress;
    wire [7:0] noteAddress;
    
    //for drawing the red line indicating deviation in tuner mode
    wire [11:0] freqOffset;
    wire positive;
    
    //for drawing a whole note and sharp sign on the staff
    wire [8:0] nx, sx;
    wire [7:0] ny, sy;
    reg [7:0] noteOffset;
    
    //initialize coordinates to (0,0)
    initial begin
        x = 0;
        y = 0;
    end
    
    //plot pixels one by one on the screen
    always@(posedge clock) begin
        if(!resetn) begin //start from top left of the screen
            x <= 0;
            y <= 0;
        end else if(draw == 3'd1) begin //draw the whole screen background
            if(mode == 2'b00) colour <= staffColour; //draw the staff for tone generator mode
            if(mode == 2'b01) begin
                if((SW[8:0] >= 9'd320 && x == 9'd318 || SW[8:0] > 0 && x == SW[8:0]-1 || SW[8:0] == 0 && x == 0)
                    && y >= 8'd96 && y <= 8'd143) colour <= 3'b100; //draw the red line indicating BPM setting
                else colour <= metronomeColour; //draw the metronome scale
            end
            if(mode == 2'b10) begin 
                if(x >= 9'd156 && x <= 9'd160 && y >= 8'd49 && y <= 8'd55) 
                    colour <= octaveColour; //draw the octave number
                else if(x >= 9'd149 && x <= 9'd168 && y >= 8'd178 && y <= 8'd184) 
                    colour <= noteColour; //draw the note name
                else if(y >= 8'd96 && y <= 8'd143 && (positive && x == 9'd159+freqOffset[8:0] 
                    || !positive && x == 9'd159-freqOffset[8:0]))
                    colour <= 3'b100; //draw the red line indicating frequency deviation
                else colour <= tunerColour; //draw the tuner scale
            end
            
            //set the xy coordinates so pixels are draw left to right, top to bottom
            x <= address % 320;
            y <= address / 320;
        end else if(draw == 3'd2) begin //draw the whole note
            x <= nx;
            y <= ny - noteOffset;
            colour <= 3'b100;
        end else if(draw == 3'd3) begin //draw the sharp sign
            x <= sx;
            y <= sy - noteOffset;
            colour <= 3'b100;
        end
    end

    //set positioning of whole note and sharp symbols
    always@(*) begin
        noteOffset = 8'd0;
        //special offset for notes A to B
        if(SW[7:4] >= 4'd0 && SW[7:4] <= 4'd2) noteOffset = noteOffset + {4'b0000, SW[3:0]} * 8'd28;
        else noteOffset = noteOffset + {4'b0000, SW[3:0]-1'b1} * 8'd28; //offset for octaves
        
        //add offset based on note name
        if(SW[7:4] == 4'd2) noteOffset = noteOffset + 8'd4;
        else if(SW[7:4] == 4'd3 || SW[7:4] == 4'd4) noteOffset = noteOffset + 8'd8;
        else if(SW[7:4] == 4'd5 || SW[7:4] == 4'd6) noteOffset = noteOffset + 8'd12;
        else if(SW[7:4] == 4'd7) noteOffset = noteOffset + 8'd16;
        else if(SW[7:4] == 4'd8 || SW[7:4] == 4'd9) noteOffset = noteOffset + 8'd20;
        else if(SW[7:4] == 4'd10 || SW[7:4] == 4'd11) noteOffset = noteOffset + 8'd24;
    end

    //determine note being played
    frequency_lut lut(oct0, oct1, oct2, oct3, oct4, oct5, oct6, oct7, oct8,
        C, CHDb, D, DHEb, E, F, FHGb, G, GHAb, A, AHBb, B,
        frequency,

        octaveColour,
        noteColour,
        freqOffset,
        positive
    );

    //instantiate RAM for background images
    staff240 staff(
            .address(address),
            .clock(clock),
            .data(3'b000),
            .wren(1'b0),
            .q(staffColour)
    );
    metronome240 met(
            .address(address),
            .clock(clock),
            .data(3'b000),
            .wren(1'b0),
            .q(metronomeColour)
    );
    tuner240 tun(
            .address(address),
            .clock(clock),
            .data(3'b000),
            .wren(1'b0),
            .q(tunerColour)
    );
    
    //instantiate RAM for whole note and sharp sprites
    noteX nX(
            .address(address[4:0]),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(nx)
    );
    noteY nY(
            .address(address[4:0]),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(ny)
    );
    sharpX sX(
            .address(address[5:0]),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(sx)
    );
    sharpY sY(
            .address(address[5:0]),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(sy)
    );
    
    //calculate the RAM address of the octave number sprite based on xy coordinates
    assign octAddr = x-9'd155 + ({1'b0, y}-9'd49)*9'd5;
    assign octaveAddress = octAddr[5:0];
    
    //instantiate RAM for octave number sprites
    octave0 o0(
            .address(octaveAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(oct0)
    );
    octave1 o1(
            .address(octaveAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(oct1)
    );
    octave2 o2(
            .address(octaveAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(oct2)
    );
    octave3 o3(
            .address(octaveAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(oct3)
    );
    octave4 o4(
            .address(octaveAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(oct4)
    );
    octave5 o5(
            .address(octaveAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(oct5)
    );
    octave6 o6(
            .address(octaveAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(oct6)
    );
    octave7 o7(
            .address(octaveAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(oct7)
    );
    octave8 o8(
            .address(octaveAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(oct8)
    );
    
    //calculate the RAM address of the note name sprite based on xy coordinates
    assign noteAddr = x-9'd148 + ({1'b0, y}-9'd178)*9'd20;
    assign noteAddress = noteAddr[7:0];
    
    //instantiate RAM for note name sprites
    noteC nC(
            .address(noteAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(C)
    );
    noteCHDb nCHDb(
            .address(noteAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(CHDb)
    );
    noteD nD(
            .address(noteAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(D)
    );
    noteDHEb nDHEb(
            .address(noteAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(DHEb)
    );
    noteE nE(
            .address(noteAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(E)
    );
    noteF nF(
            .address(noteAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(F)
    );
    noteFHGb nFHGb(
            .address(noteAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(FHGb)
    );
    noteG nG(
            .address(noteAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(G)
    );
    noteGHAb nGHAb(
            .address(noteAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(GHAb)
    );
    noteA nA(
            .address(noteAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(A)
    );
    noteAHBb nAHBb(
            .address(noteAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(AHBb)
    );
    noteB nB(
            .address(noteAddress),
            .clock(clock),
            .data(8'd0),
            .wren(1'b0),
            .q(B)
    );
endmodule

`endif