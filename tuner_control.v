`ifndef tuner_control_v
`define tuner_control_v


// facilitates transfer of data from the FIFO to the FFT
module fft_fsm(
        input clk,
        input resetn,
        input go,  // note-to-self: probably hook this up to wrfull
        input sink_ready,
        input source_valid,
        input rdempty,
        
        output reg rdreq,
        output reg sink_sop,
        output reg sink_eop,
        output reg sink_valid
    );
    
    reg [2:0] current_state, next_state;
    
    localparam WAIT_GO         = 3'd0,
               START           = 3'd1,
               READ            = 3'd2,
               STOP            = 3'd3,
               WAIT_FFT        = 3'd4,
               WAIT_FFT_STILL  = 3'd5;
             
    // next state logic
    always @*
    begin
        case (current_state)
            WAIT_GO: next_state = (sink_ready == 1'b1 && go == 1'b1) ? START : WAIT_GO;
            START: next_state = READ;
            READ: next_state = (rdempty == 1'b0) ? READ : STOP;
            STOP: next_state = WAIT_FFT;
            //WAIT_FFT: next_state = (source_valid == 1'b1) ? WAIT_FFT_STILL : WAIT_FFT;
            //WAIT_FFT_STILL: next_state = (source_valid == 1'b0) ? WAIT_GO : WAIT_FFT_STILL;
            WAIT_FFT: next_state = WAIT_FFT_STILL;
            WAIT_FFT_STILL: next_state = WAIT_GO;
            default: next_state = WAIT_GO;
        endcase
    end
    
    // output logic
    always @*
    begin
        rdreq = 1'b0;
        sink_sop = 1'b0;
        sink_eop = 1'b0;
        sink_valid = 1'b0;
        
        case (current_state)
            WAIT_GO: begin
                rdreq = 1'b0;
                sink_sop = 1'b0;
                sink_eop = 1'b0;
                sink_valid = 1'b0;
            end
            
            START: begin
                rdreq = 1'b1;
                sink_sop = 1'b1;
                sink_eop = 1'b0;
                sink_valid = 1'b1;
            end
            
            READ: begin
                rdreq = 1'b1;
                sink_sop = 1'b0;
                sink_eop = 1'b0;
                sink_valid = 1'b1;
            end
            
            STOP: begin
                rdreq = 1'b0;
                sink_sop = 1'b0;
                sink_eop = 1'b1;
                sink_valid = 1'b0;
            end
            
            WAIT_FFT: begin
                rdreq = 1'b0;
                sink_sop = 1'b0;
                sink_eop = 1'b0;
                sink_valid = 1'b0;
            end
            
            WAIT_FFT_STILL: begin
                rdreq = 1'b0;
                sink_sop = 1'b0;
                sink_eop = 1'b0;
                sink_valid = 1'b0;
            end
            // default case not necessary
        endcase
    end
    
    always @(posedge clk)
    begin
        if (resetn == 1'b0)
            current_state <= WAIT_GO;
        else 
            current_state <= next_state;
    end
    
endmodule


// facilitates transfer of data from the input audio stream to the FIFO
module fifo_fsm(
        input clk,
        input resetn,
        input go,  // note-to-self: probably hook this up to rdempty
        input wrfull,
        
        output reg wrreq
    );
    
    reg current_state, next_state;
    
    localparam WAIT   = 1'd0,
               WRITE  = 1'd1;
    
    // next state logic
    always @*
    begin
        case (current_state)
            WAIT: next_state = (go == 1'b1 && wrfull == 1'b0) ? WRITE : WAIT;
            WRITE: next_state = (wrfull == 1'b1) ? WAIT : WRITE;
            default: next_state = WAIT;
        endcase
    end
    
    // output logic
    always @*
    begin
        wrreq = 1'b0;
        case (current_state)
            WAIT: wrreq = 1'b0;
            WRITE: wrreq = 1'b1;
            default: wrreq = 1'b0;  // not necessary
        endcase
    end
    
    always @(posedge clk)
    begin
        if (resetn == 1'b0)
            current_state <= WAIT;
        else
            current_state <= next_state;
    end
    
endmodule


`endif
