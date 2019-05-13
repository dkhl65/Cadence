`include "tone_generator.v"
`include "metronome.v"
`include "tuner.v"
`include "vga.v"
`include "seven_segment.v"

module music_tools(
        // basic FPGA I/O
        input CLOCK_50,
        input [3:0] KEY,
        input [9:0] SW,
        output [6:0] HEX4, HEX3, HEX2, HEX1, HEX0,
        output [9:0] LEDR,
        
        // audio I/O
        input AUD_ADCDAT,
        inout AUD_BCLK,
        inout AUD_ADCLRCK,
        inout AUD_DACLRCK,
        inout FPGA_I2C_SDAT,
        output AUD_XCK,
        output AUD_DACDAT,
        output FPGA_I2C_SCLK,
        
        // VGA I/O
        output VGA_CLK,        //  VGA Clock
        output VGA_HS,         //  VGA H_SYNC
        output VGA_VS,         //  VGA V_SYNC
        output VGA_BLANK_N,    //  VGA BLANK
        output VGA_SYNC_N,     //  VGA SYNC
        output [7:0] VGA_R,    //  VGA Red[9:0]
        output [7:0] VGA_G,    //  VGA Green[9:0]
        output [7:0] VGA_B     //  VGA Blue[9:0]
    );
    
    // for the audio core to transmit and receive data
    wire write_audio_out;
    wire read_audio_in;
    wire audio_out_allowed;
    wire audio_in_available;
    wire [31:0] sound;  // both left and right channel outputs
    wire [31:0] left_channel_audio_in, right_channel_audio_in;
    
    // write_audio_out and sound for sub-modules
    wire waoToneGenerator;
    wire [31:0] soundToneGenerator;
    wire waoMetronome;
    wire [31:0] soundMetronome;
    
    // for getting the strongest frequency from the tuner
    wire [15:0] frequency;

    // VGA connectors
    wire [2:0] colour;
    wire [8:0] x;
    wire [7:0] y; 
    wire writeEn, resetn;
    
    // mode == 2'b00: tone generator
    // mode == 2'b01: metronome
    // mode == 2'b10: tuner
    reg [1:0] mode;
    
    // for resetting purposes
    reg [9:0] switches;  // store current state of switches for detection
    reg [2:0] keys; //store mode for resetting on mode change
    reg currResetState, nextResetState;  // auto reset when switches or mode changes
    wire reset;  // the main reset wire
    
    //initial regs to 0
    initial begin
        mode = 2'b00;
        currResetState = 1'b0;
        nextResetState = 1'b0;
        switches = 10'b0;
        keys = 2'b00;
    end
  
    // set the mode
    always @*
    begin
        if (KEY[1] == 0) mode = 2'b00;
        else if (KEY[2] == 0) mode = 2'b01;
        else if (KEY[3] == 0) mode = 2'b10;
    end
    
    // reset is trigger auto-reset triggers, reset key is pressed or enable switch is down
    assign reset = (currResetState > 1'b0 || KEY[0] == 0 || SW[9] == 0) ? 1 : 0;
    
    // get output from the sub-modules
    assign write_audio_out = (mode == 2'b10) ? 1'b0 : ((mode == 2'b00) ? waoToneGenerator : waoMetronome);
    assign sound = (mode == 2'b10) ? 32'b0 : ((mode == 2'b00) ? soundToneGenerator : soundMetronome);
    
    // make led flash to the beat of the metronome
    assign LEDR[0] = (sound != 0 && mode == 2'b01 && SW[9] == 1)? 1 : 0;
    
    // FSM for auto-resetting
    // when switches change, a reset is sometimes needed to get the audio core going
    // it also triggers vga to redraw
    always @* 
    begin
        case (currResetState)
            1'b0: nextResetState = 1'b0;
            1'b1: nextResetState = 1'b0;
        endcase
    end
    always @(posedge CLOCK_50) // synchronous trigger
    begin
        if(switches != SW || keys != KEY[3:1]) begin // triggers if switches moved or modes changed
            currResetState <= 1'b1;
            switches <= SW;
            keys <= KEY[3:1];
        end else currResetState <= nextResetState;
    end
    
    // module for tone generator (mode 1)
    tone_generator tone_generator1(
        .CLOCK_50(CLOCK_50),
        .SW(SW),
        
        .audio_out_allowed(audio_out_allowed),
        .write_audio_out(waoToneGenerator),
        .sound(soundToneGenerator)
    );
    
    // module for metronome (mode 2)
    metronome metronome1(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .SW(SW),
        
        .audio_out_allowed(audio_out_allowed),
        .write_audio_out(waoMetronome),
        .sound(soundMetronome)
    );
    
    // module for tuner (mode 3)
    tuner tuner1(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .SW(SW),
        
        .audio_in_available(audio_in_available),
        .left_channel_audio_in(left_channel_audio_in),
        .right_channel_audio_in(right_channel_audio_in),
        .read_audio_in(read_audio_in),
        
        .frequency(frequency)
    );
    
    // the controller module for the HEX displays
    seven_segment ssd(
        .data(SW[8:0]),
        .enable(SW[9]),
        .mode(mode),
        .frequency(frequency),
        
        .hex0(HEX0),
        .hex1(HEX1),
        .hex2(HEX2),
        .hex3(HEX3),
        .hex4(HEX4)
    );
    
    // audio core modules the get input from the mic and output to the speakers
    Audio_Controller controller(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        
        .clear_audio_in_memory((mode != 2'b10)),

        .left_channel_audio_in(left_channel_audio_in),
        .right_channel_audio_in(right_channel_audio_in),
        .read_audio_in(read_audio_in),
        .audio_in_available(audio_in_available),

        .left_channel_audio_out(sound),
        .right_channel_audio_out(sound),
        .write_audio_out(write_audio_out),
        .audio_out_allowed(audio_out_allowed),

        .AUD_ADCDAT(AUD_ADCDAT),
        .AUD_BCLK(AUD_BCLK),
        .AUD_ADCLRCK(AUD_ADCLRCK),
        .AUD_DACLRCK(AUD_DACLRCK),
        .AUD_XCK(AUD_XCK),
        .AUD_DACDAT(AUD_DACDAT)
    );
    avconf #(.USE_MIC_INPUT(1)) avc(
        .FPGA_I2C_SCLK(FPGA_I2C_SCLK),
        .FPGA_I2C_SDAT(FPGA_I2C_SDAT),
        .CLOCK_50(CLOCK_50),
        .reset(reset)
    );
    
    // module for sending drawing commands to the vga_adapter
    vga vgaData(
            .CLOCK_50(CLOCK_50),
            .KEY(KEY),
            .SW(SW),
            .mode(mode),
            .frequency(frequency),
            .redraw(reset),
            .colour(colour),
            .x(x),
            .y(y),
            .writeEn(writeEn),
            .resetn(resetn)
    );
    
    // VGA core module that displays the image on the monitor
    // Define the number of colours as well as the initial background
    // image file (.MIF) for the controller.
    vga_adapter VGA(
            .resetn(resetn),
            .clock(CLOCK_50),
            .colour(colour),
            .x(x),
            .y(y),
            .plot(writeEn),
            /* Signals for the DAC to drive the monitor. */
            .VGA_R(VGA_R),
            .VGA_G(VGA_G),
            .VGA_B(VGA_B),
            .VGA_HS(VGA_HS),
            .VGA_VS(VGA_VS),
            .VGA_BLANK(VGA_BLANK_N),
            .VGA_SYNC(VGA_SYNC_N),
            .VGA_CLK(VGA_CLK));
        defparam VGA.RESOLUTION = "320x240";
        defparam VGA.MONOCHROME = "FALSE";
        defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
        defparam VGA.BACKGROUND_IMAGE = "blank240.mif";
endmodule 