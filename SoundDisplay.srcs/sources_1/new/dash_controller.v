`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2022 20:42:32
// Design Name: 
// Module Name: dash_controller
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


module dash_controller(
    input clock,
    input btnL,
    input btnR,
    output reg [3:0] an = 4'b1110,
    output reg [7:0] seg = 8'b10111111
    );

reg debounceDone = 0;


always @ (posedge clock)
begin
    if (btnL & debounceDone & an != 4'b0111)
    begin
        an <= (an << 1) | 4'b0001; // This is done to bitshift 1 to left, and fill empty space with 1 instead of 0
        debounceDone <= 0;
    end
    
    if (btnR & debounceDone & an != 4'b1110)
    begin
        an <= (an >> 1) | 4'b1000;
        debounceDone <= 0;
    end
    
    if (~btnL & ~btnR & ~debounceDone)
    begin
        debounceDone <= 1;
    end
end
endmodule
