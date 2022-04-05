`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2022 09:41:18
// Design Name: 
// Module Name: readImage
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


module readImage #(parameter file_name = "", width = 0, height = 0) (
    input [8:0] x,y,
    output [15:0] oled_data
    );
    
    reg [15:0] data [width * height - 1:0];
    initial $readmemb(file_name, data);
    
    assign oled_data = data[width * y + x];
endmodule
