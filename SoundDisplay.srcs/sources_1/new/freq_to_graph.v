`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2022 18:50:02
// Design Name: 
// Module Name: freq_to_graph
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module freq_to_graph(
    input basys_clock,
    input fft_out_rdy,
    input start,
    input [9:0] addr,
    input [23:0] freq_mag,
    output reg [464:0] freq_cnts
    );
    
    reg [30:0] freq_bins [0:14];
    reg start_pipe;
    integer i;
    
    // add freq values to 10 bins
    always @(posedge basys_clock) begin
        start_pipe <= start;
        if (start_pipe) begin
            for (i = 0; i < 15; i = i + 1) begin
                freq_cnts[30 * (i + 1) -: 31] <= freq_bins[i];
                freq_bins[i] <= 31'd0;
            end
        end else if (fft_out_rdy) begin
            for (i = 0; i < 15; i = i + 1) begin
                if (addr >= 68 * i && addr < 68 * (i + 1)) begin
                    freq_bins[i] <= freq_bins[i] + freq_mag;
                end 
            end
            if (addr >= 68 * 15) begin
                freq_bins[14] <= freq_bins[14] + freq_mag;
            end
        end
    end
endmodule
