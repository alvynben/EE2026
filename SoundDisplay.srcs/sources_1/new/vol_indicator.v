`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2022 20:50:41
// Design Name: 
// Module Name: vol_indicator
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


module vol_indicator(
    input clk_20kHz,
    input [11:0] sample,
    output reg [11:0] vol_led = 0,
    output reg [6:0] seg = 0,
    output reg [3:0] an = 4'b1110,
    output reg [2:0] level = 0
    );
    
    
    reg [11:0] mic_max = 0;
    reg [10:0] count = 0;
    reg [11:0] mic_level = 0;
            
    
    always @ (posedge clk_20kHz) begin
        
        if (sample > mic_max)
            mic_max <= sample;
        
        count <= count + 1;
        
        // Reset every 0.1s
        if (count == 11'b11111010000) begin
            mic_level <= mic_max;            
            mic_max <= 0;
            count <= 0;
        end
    
    
        if (mic_level < 12'd2400) begin //Level 0
            vol_led <= 0;
            seg <= 7'b1000000;
            level <= 0;
        end
        
        else if (mic_level < 12'd2800) begin //Level 1
            vol_led <= 5'b00001;
            seg <= 7'b1111001;
            level <= 3'd1;
        end
        
        else if (mic_level < 12'd3200) begin //Level 2
            vol_led <= 5'b00011;
            seg <= 7'b0100100;
            level <= 3'd2;
        end
        
        else if (mic_level < 12'd3600) begin //Level 3
            vol_led <= 5'b00111;
            seg <= 7'b0110000;
            level <= 3'd3;
        end
            
        else if (mic_level < 12'd4000) begin //Level 4     
            vol_led <= 5'b01111;
            seg <= 7'b0011001;
            level <= 3'd4; 
        end
        
        else begin //Level 5
            vol_led <= 5'b11111;
            seg <= 7'b0010010;
            level <= 3'd5;
        end

    end
    
    
endmodule
