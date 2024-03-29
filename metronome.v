`ifndef metronome_v
`define metronome_v


module metronome(
        CLOCK_50,
        reset,
        SW,
        
        audio_out_allowed,
        write_audio_out,
        sound
    );

    input CLOCK_50;
    input reset;
    input [9:0] SW;
    input audio_out_allowed;
    
    output write_audio_out;
    output [31:0] sound;

    wire [25:0] clock_freq = 26'd50000000;  // may change later to be more precise
	wire [18:0] delay = clock_freq/13'd1047; // frequency of the metronome tick (i.e. how low/high the tick is)
    wire [8:0] bpm;  // frequency of the metronome in bpm
    wire [31:0] bpm_delay;  // metronome bpm in clock cycles
    wire [26:0] tick_length = 27'd10000;  // length of the metronome tick in clock cycles
    wire [31:0] amplitude = 32'd300000000;
    
    reg [18:0] delay_count;
    reg [31:0] bpm_delay_count;
    reg switch;  // dictates whether the square wave is positive or negative
    reg metronome_enable;

    // increment delay_count every clock edge until delay_count == delay
    // this determines the period, and thus the frequency, of the metronome sound
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
    
    // increment bpm_delay_count every clock edge until bpm_delay_count == bpm_delay
    // this determines the speed of the metronome ticks
    always @(posedge CLOCK_50, posedge reset)
    begin
        if (reset == 1'b1)
            bpm_delay_count <= 0;
            
        else if (bpm_delay_count == bpm_delay)
        begin
            bpm_delay_count <= 0;
            metronome_enable <= 1;
        end
        
        // metronome still plays tick
        else if (bpm_delay_count <= tick_length)
        begin
            bpm_delay_count <= bpm_delay_count + 1;
            metronome_enable <= 1;
        end
        
        // metronome no longer plays tick
        else  // (bpm_delay_count > tick_length)
        begin
            bpm_delay_count <= bpm_delay_count + 1;
            metronome_enable <= 0;
        end
    end

    assign bpm = SW[8:0];
    assign bpm_delay = (bpm == 0) ? 0 : clock_freq/bpm*6'd60;
    
    // generates a square wave if metronome tick is enabled
    assign sound = metronome_enable ? (switch ? amplitude : -amplitude) : 0;
    
    // only write if enable is on and bpm isn't 0
    assign write_audio_out = (SW[9] == 1) && (bpm_delay != 0) && (audio_out_allowed == 1);
    
endmodule

`endif