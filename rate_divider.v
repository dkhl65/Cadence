`ifndef rate_divider_16_v
`define rate_divider_16_v

// to create the 48kHz clock that we need for the audio
module rate_divider_16(
        input in_clk,
        input resetn,
        output reg out_clk
    );
    
    reg [3:0] count = 4'b0;
    
    always @(posedge in_clk, negedge resetn)
    begin
        if (resetn == 1'b0)
        begin
            count <= 4'b0;
            out_clk <= 1'b0;
        end
        else if (count == 4'd15)
        begin
            count <= 4'b0;
            out_clk <= ~out_clk;
        end
        else
        begin
            count <= count + 1;
        end
    end
    
endmodule


`endif
