`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2022 13:10:00
// Design Name: 
// Module Name: oled_controller
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


module oled_controller(
    input basys_clock,
    input [8:0] x,
    input [8:0] y,
    input [5:0] sw,
    input [11:0] vol_led,
    input [464:0] freq_cnts,
    input frame_begin,
    input btnL,
    output reg [15:0] oled_default
    );
    
    parameter [15:0] oled_green = {5'b00000,6'b111111,5'b00000};
    parameter [15:0] oled_orange = {5'b11111,6'b110000,5'b00000} ;
    parameter [15:0] oled_red = {5'b11111,6'b000000,5'b00000};
    parameter [15:0] oled_black = {5'b00000,6'b000000,5'b00000};
    parameter [5:0] max_freq = 32 + 25;
    parameter [11:0] max_vol = 12'b111111111111;
    wire [15:0]freq_bar = 16'b1101111011111011;
    
    reg [5:0] freq_val [0:14];
    
    wire [15:0] frequency_header;
    wire [15:0] menu_screen;
    wire [15:0] vol_stage_1;
    wire [15:0] vol_stage_2;
    wire [15:0] vol_stage_3;
        
    readImage #("frequency_header.mem",96,64) (
    .x(x), 
    .y(y), 
    .oled_data(frequency_header)
    ); 
    
    readImage #("menu_screen.mem", 96, 64) (
    .x(x), 
    .y(y), 
    .oled_data(menu_screen)
    ); 
    
    readImage #("vol_stage_1.mem", 96, 64) (
    .x(x), 
    .y(y), 
    .oled_data(vol_stage_1)
    ); 
    
    readImage #("vol_stage_2.mem", 96, 64) (
    .x(x), 
    .y(y), 
    .oled_data(vol_stage_2)
    ); 
    
    readImage #("vol_stage_1.mem", 96, 64) (
    .x(x), 
    .y(y), 
    .oled_data(vol_stage_3)
    ); 
    
    // Instantiate 0.5Hz clock and assign to clk_0_5_Hz wire
//    wire clk_0_5_Hz;
//    flexible_clock_module clock_0_5_Hz(basys_clock, 100000000, clk_0_5_Hz);
    
     always @ (posedge basys_clock)
           begin
               if (frame_begin)
               begin : storefreq
                   integer k;
                   for (k = 0; k < 15; k = k + 1   ) begin
                       freq_val[k] <= freq_cnts[30 * (k + 1) - 13 -: 6];
                   end
               end
               if (sw[5]) begin
                    oled_default <=
                    vol_led[4] ? vol_stage_3 :
                    vol_led[2] ? vol_stage_2 :
                    vol_led[0] ? vol_stage_1 :
                    oled_black;
               end
               else if (sw[4]) begin
                    oled_default <= menu_screen;
               end
               else if (sw[3]) begin
                   oled_default <= 
                   (x >= 3 && x <= 13 && y >= (max_freq - freq_val[0]) && y <= 60) ? freq_bar :
                   (x >= 14 && x <= 24 && y >= (max_freq - freq_val[1]) && y <= 60) ? freq_bar :
                   (x >= 25 && x <= 35 && y >= (max_freq - freq_val[2]) && y <= 60) ? freq_bar :
                   (x >= 36 && x <= 46 && y >= (max_freq - freq_val[3]) && y <= 60) ? freq_bar :
                   (x >= 47 && x <= 57 && y >= (max_freq - freq_val[4]) && y <= 60) ? freq_bar :
                   ( (x >= 58 && x <= 70 && y >= (max_freq - freq_val[5]) && y <= 60)) ? freq_bar :
                   ( (x >= 71 && x <= 83 && y >= (max_freq - freq_val[6]) && y <= 60)) ? freq_bar :
                   ( (x >= 84 && x <= 96 && y >= (max_freq - freq_val[7]) && y <= 60)) ? freq_bar : 
                   ( y <= 15 ) ? frequency_header :
                   oled_black;
               end
               else if (btnL) begin
                   oled_default <= oled_black;
                   // Level 1 or 2
                   if (vol_led[0]) begin
                       // Create Green Border
                       if ( ((x == 1 || x == 95) && (1 <= y && y <= 63)) || ((y == 1 || y == 63) && (1 <= x && x <= 95)) ) 
                           oled_default <= oled_green;
                       // Create Green Bar
                       if (x > 18 && x < 78) begin
                           if ( (y >= 13 && y < 20) || (y >= 44 && y < 51) )
                               oled_default <= oled_green;
                       end
                   end
                   // Level 3 or 4
                   if (vol_led[2]) begin
                       // Orange Border
                       if ( ((x == 3 || x == 93) && (3 <= y && y <= 61)) || ((y == 3 || y == 61) && (3 <= x && x <= 93)) ) 
                           oled_default <= {5'b11111,6'b110000,5'b00000};
                       // Orange Bar
                       if (x > 18 && x < 78) begin
                           if ( ~sw[2] && ((y >= 20 && y < 27) || (y >= 37 && y < 44)) )
                               oled_default <= {5'b11111,6'b110000,5'b00000}; 
                       end
                   end
                   // Level 5
                   if (vol_led[4]) begin
                       // Red Border
                       if ( (((5 <= x && x <= 7) || (89 <= x && x <= 91)) && ( 5 <= y && y <= 59)) || (((5 <= y && y <= 7) || (57 <= y && y <= 59)) && ( 5 <= x && x <= 91)) ) 
                           oled_default <= {5'b11111,6'b000000,5'b00000};  
                       // Red Bar
                       if (x > 18 && x < 78) begin
                           if (y >= 27 && y < 37) 
                               oled_default <= {5'b11111,6'b000000,5'b00000};
                       end                                     
                   end                
                   // Level 0
                   if(!vol_led) begin
                   oled_default <= oled_black;
                   end
               end
               else begin
                   // Create the borders
                   if (sw[1]) oled_default <= oled_black;
                   // Green Border
                   else if ( ((x == 1 || x == 95) && (1 <= y && y <= 63)) || ((y == 1 || y == 63) && (1 <= x && x <= 95)) ) 
                       oled_default <= {5'b00000,6'b111111,5'b00000};
                   // Orange Border
                   else if ( ((x == 3 || x == 93) && (3 <= y && y <= 61)) || ((y == 3 || y == 61) && (3 <= x && x <= 93)) ) 
                       oled_default <= {5'b11111,6'b110000,5'b00000};
                   // Red Border
                   else if ( (((5 <= x && x <= 7) || (89 <= x && x <= 91)) && ( 5 <= y && y <= 59)) || (((5 <= y && y <= 7) || (57 <= y && y <= 59)) && ( 5 <= x && x <= 91)) ) 
                       oled_default <= {5'b11111,6'b000000,5'b00000};
                   else oled_default <= oled_black;
                   
                   // Create the middle bars
                   if (x > 18 && x < 78) begin
                       // Green Bar
                       if ( (y >= 13 && y < 20) || (y >= 44 && y < 51) )
                           oled_default <= {5'b00000,6'b111111,5'b00000};
                       // Red Bar
                       if (y >= 27 && y < 37) 
                           oled_default <= {5'b11111,6'b000000,5'b00000};
                       // Orange Bar
                       if ( ~sw[2] && ((y >= 20 && y < 27) || (y >= 37 && y < 44)) )
                           oled_default <= {5'b11111,6'b110000,5'b00000};
                   end
               end 
           end
    
    
    
endmodule
