`ifndef max_v
`define max_v

// finds the frequency with the maximum amplitude
module max #(parameter FFT_WIDTH, FFT_WIDTH_LOG_2) (
        input clk,
        input enable,
        input [31:0] amplitude,
        
        output reg [15:0] frequency
    );

    reg [FFT_WIDTH_LOG_2 - 1:0] count;
    reg [31:0] max_amplitude;
    
    always @(posedge clk)
    begin
        if (enable == 1'b0)
        begin
            count <= 0;
            max_amplitude <= 32'b0;
            frequency <= frequency;
        end
        else  // enable == 1'b1
        begin
            if ((count < FFT_WIDTH/2) && (count > 0))  // 0 introduces some edge cases that I'd rather not worry about. Just ignore them.
            begin
                if (amplitude > max_amplitude)
                begin
                    max_amplitude <= amplitude;
                    frequency <= count*16'd24000/29'd16384;  // hardcode the width since nothing else is working
                end
                else  // amplitude <= max_amplitude
                    max_amplitude <= max_amplitude;
            end
            else  // count >= FFT_WIDTH/2
                ;
            
            count <= count + 1;
        end
    end
    
endmodule


`endif
    