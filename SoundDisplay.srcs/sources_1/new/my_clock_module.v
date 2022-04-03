`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2022 09:22:28
// Design Name: 
// Module Name: my_clock_module
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


module my_clock_module(
    input basys_clock,
    output reg clk_20kHz = 0
    );
    
    reg [31:0] count = 0;
    
    
    always @ (posedge basys_clock)
    begin
        count <= (count === 2499) ? 0 : count + 1;
        clk_20kHz <= (count == 0) ? ~clk_20kHz : clk_20kHz;
    end
endmodule

module flexible_clock_module(
    input basys_clock,
    input [31:0] compare,
    output reg clk_20kHz = 0
    );
    
    reg [31:0] count = 0;
    
    
    always @ (posedge basys_clock)
    begin
        count <= (count === compare) ? 0 : count + 1;
        clk_20kHz <= (count == 0) ? ~clk_20kHz : clk_20kHz;
    end
endmodule
