`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2022 09:37:19
// Design Name: 
// Module Name: test_my_clock
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

`timescale 1ns / 1ns
module test_my_clock(

    );
    
    reg CLOCK; reg [31:0] SIM_M; wire LED; wire twentykHZ;
            
    my_clock_module dut(CLOCK, LED);
    flexible_clock_module clk_20kHz(CLOCK, 2499, twentykHZ);
            
            initial begin
                CLOCK = 0;
                SIM_M = 2;
            end
            
            always begin
                #5 CLOCK = ~CLOCK;
            end
endmodule
