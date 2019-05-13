`ifndef tone_generator_v
`define tone_generator_v

`include "tuning_lut.v"

module tone_generator(
        CLOCK_50,
        SW,
        
        audio_out_allowed,
        write_audio_out,
        sound
    );

    input CLOCK_50;
    input [9:0] SW;
    input audio_out_allowed;

    output write_audio_out;
    output [31:0] sound;
    
    wire [21:0] delay;
    wire [25:0] clock_freq = 26'd50000000;  // may change later to be more precise
    wire [31:0] amplitude = 32'd15000000;
    
    reg [21:0] delay_count;
    reg switch;  // dictates whether the square wave is positive or negative

    // increment delay_count every clock edge until delay_count == delay
    // this determines the period, and thus the frequency, of the signal
    always @(posedge CLOCK_50)
    begin
        if (delay_count == delay)
        begin
            delay_count <= 0;
            switch <= !switch;  // toggle between positive and negative values of the square wave
        end
        else 
            delay_count <= delay_count + 1;
    end
    
    // generates a square wave
    assign sound = switch ? amplitude : -amplitude;
    
    // only write if enable is on and delay is not 0 (i.e. note selection is not out of range)
    assign write_audio_out = (SW[9] == 1) && (delay != 22'b0) && (audio_out_allowed == 1);
    
    tuning_lut tuning_lut0(
        .note_name(SW[7:4]), 
        .octave(SW[3:0]), 
        .clock_freq(clock_freq),
        .delay(delay)  // delay will be 0 if note selection is out of range
    );

endmodule

`endif