`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2022 09:32:47
// Design Name: 
// Module Name: read_image
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


module read_image #(parameter file_name = "", WIDTH = 0, HEIGHT = 0) (
    input [15:0] x,y,
    output [15:0] pixel_data
    );
    
    reg [15:0] data [WIDTH * HEIGHT - 1:0];
    initial $readmemb(FILE_NAME, data);
    
    assign pixel_data = data[WIDTH * y + x];
endmodule
