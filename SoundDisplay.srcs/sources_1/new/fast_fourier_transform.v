`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2022 18:42:07
// Design Name: 
// Module Name: fast_fourier_transform
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


module fast_fourier_transform(
    input basys_clock,
    input clk20k,
    input [11:0] sample,
    output [23:0] freq_real, 
    output [23:0] freq_im, 
    output [22:0] freq_real_abs, 
    output [22:0] freq_im_abs, 
    output [23:0] freq_mag, 
    output reg [9:0] freq_addr = 10'b0, 
    output fftDone, 
    output fftOutReady
    );
    
    reg clk20k_earlier, clk20k_now;
    wire clk20k_edge;
    wire fft_reset;
    wire ampl_last;
    wire fftInReady;
    reg fft_wait; 
    
    reg load_update = 1'b0; 
    reg ampl_write = 1'b0;
    reg [12:0] ampl_in; 
    reg [9:0] sample_cnt = 10'b0;
    reg [9:0] ampl_addr_in = 10'b0;
    wire [12:0] ampl_out; 
 
    reg [9:0] load_cnt = 10'b0; 
    reg [9:0] ampl_addr_out = 10'b0; 
    
    parameter max_addresses = 1023; 
    
    bram_4_fft ampl (
    .clka(basys_clock), 
    .wea(ampl_write), 
    .addra(ampl_addr_in), 
    .dina(ampl_in),
    .clkb(basys_clock), 
    .addrb(ampl_addr_out), 
    .doutb(ampl_out)
    );

    xfft_0 fft (
    .aclk(basys_clock), 
    .s_axis_config_tdata(8'b00000001), 
    .s_axis_config_tvalid(1'b1),
    .s_axis_data_tdata({19'b0, ampl_out}), 
    .s_axis_data_tvalid(1'b1), 
    .s_axis_data_tlast(ampl_last), 
    .s_axis_data_tready(fftInReady), 
    .m_axis_data_tdata({freq_im, freq_real}), 
    .m_axis_data_tvalid(fftOutReady), 
    .m_axis_data_tready(1'b1), 
    .aresetn(1'b1), 
    .m_axis_data_tlast(fftDone)
    );    
    
    assign clk20k_edge = clk20k_now & ~clk20k_earlier;
    assign ampl_last = (load_cnt == max_addresses);
     
    always @(posedge basys_clock) begin
        
        clk20k_now <= clk20k;
        clk20k_earlier <= clk20k_now;
        if (clk20k_edge) begin 
            ampl_addr_in <= (ampl_addr_in == max_addresses) ? 10'b0 : ampl_addr_in + 1;
            ampl_write <= 1'b1;
            ampl_in <= sample; 
        end else if (ampl_write) begin 
            ampl_write <= 1'b0;
        end

        if (fftInReady) begin
            ampl_addr_out <= (ampl_addr_out == max_addresses) ? 10'b0 : ampl_addr_out + 1;
            load_cnt <= load_cnt + 1;
        end
        
        if (fftOutReady) begin
            freq_addr <= freq_addr + 1;
        end

        if (fftDone) begin
            ampl_addr_out <= ampl_addr_in;
            load_cnt <= 10'b0;
            freq_addr <= 10'b0;
        end
    end
    
    assign freq_real_abs = (freq_real[23]) ? ~(freq_real[22:0]) + 1 : freq_real[22:0];
    assign freq_im_abs = (freq_im[23]) ? ~(freq_im[22:0]) + 1 : freq_im[22:0];
    assign freq_mag = (freq_real_abs > freq_im_abs) ? freq_real_abs + (freq_im_abs[22:2]) : freq_im_abs + (freq_real_abs[22:2]);
endmodule
