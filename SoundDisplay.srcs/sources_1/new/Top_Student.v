`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): THURSDAY A.M.
//
//  STUDENT A NAME: 
//  STUDENT A MATRICULATION NUMBER: 
//
//  STUDENT B NAME: 
//  STUDENT B MATRICULATION NUMBER: 
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input  J_MIC3_Pin3,         // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,         // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,         // Connect to this signal from Audio_Capture.v
    input basys_clock,
    input MISO,                 // J_MIC3_Pin3, serial mic input
    input [5:0] sw,             // Switch 0 to control input to cs
    output reg [11:0] led,      // LED Ports on BASYS
    output [7:0] JC,            // Pins for OLED
    input btnC,                 // Reset button for OLED
    input btnL, btnR,           // Left and Right buttons to control dash
    output [3:0] an,            // The 7-segment display anodes
    output [6:0] seg,           // The 7-segment display segments
    output dp                   // The 7-segment decimal points          
    );
    
    // Instantiate 20kHz clock and assign to clk_20kHz wire
    wire clk_20kHz;
    flexible_clock_module clock_20kHz(basys_clock, 2499, clk_20kHz);
    
    // Instantiate 10Hz clock and assign to clk_10Hz wire
    wire clk_10Hz;
    flexible_clock_module clock_10Hz(basys_clock, 4999999, clk_10Hz);
    
    // Instantiate 6.25MHz clock and assign to clk_6_25MHz wire
    wire clk_6_25_MHz;
    flexible_clock_module clock_6_25MHz(basys_clock, 7, clk_6_25MHz);
    
    wire [11:0] sample;         // Output from the Audio Capture
    Audio_Capture audioCapture
    (basys_clock,               // BASYS_CLOCK
    clk_20kHz,                  // 20kHz clock
    J_MIC3_Pin3,                // Serial Mic input, aka MISO
    J_MIC3_Pin1,                // clk_samp
    J_MIC3_Pin4,                // MIC3 Serial Clock 
    sample                      // 12-bit audio sample data
    );
    
    // OLED Data to be stored into device
    wire [15:0] oled_data; 
    wire reset, frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    wire [4:0] teststate;
    
    // Create variables to track x & y variables
    wire [8:0] x;
    wire [8:0] y;
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
        
    //    wire [15:0] oled_default;
    wire [11:0] vol_led;
    
    wire [23:0]freq_real;
    wire [23:0]freq_im;
    wire [22:0] freq_real_abs;
    wire [22:0] freq_im_abs;
    wire [23:0] freq_mag;
    wire [9:0] freq_addr;
    wire fft_done; 
    wire fft_out_rdy; 
    wire [464:0]freq_cnts;
    
    fast_fourier_transform fft1 (
        .basys_clock(basys_clock),
        .clk20k(clk_20kHz),
        .sample(sample),
        .freq_real(freq_real), 
        .freq_im(freq_im), 
        .freq_real_abs(freq_real_abs), 
        .freq_im_abs(freq_im_abs), 
        .freq_mag(freq_mag), 
        .freq_addr(freq_addr), 
        .fftDone(fft_done), 
        .fftOutReady(fft_out_rdy)
        );
    
    freq_to_graph fft2 (
        .basys_clock(basys_clock),
        .fft_out_rdy(fft_out_rdy),
        .start(fft_done),
        .addr(freq_addr),
        .freq_mag(freq_mag),
        .freq_cnts(freq_cnts)
        );
        
    vol_indicator volIndicator (clk_20kHz, sample, vol_led, seg, an);
    oled_controller oledController(
    .basys_clock(basys_clock),
    .x(x),
    .y(y),
    .sw(sw[5:0]),
    .vol_led(vol_led),
    .freq_cnts(freq_cnts),
    .frame_begin(frame_begin),
    .btnL(btnL),
    .oled_default(oled_data)
    );
    
    Oled_Display oledDisplay(
    .clk(clk_6_25MHz),
    .reset(btnC),
    .frame_begin(frame_begin),
    .sending_pixels(sending_pixels),
    .sample_pixel(sample_pixel),
    .pixel_index(pixel_index),
    .pixel_data(oled_data),
    .cs(JC[0]),
    .sdin(JC[1]),
    .sclk(JC[3]),
    .d_cn(JC[4]),
    .resn(JC[5]),
    .vccen(JC[6]),
    .pmoden(JC[7]),
    .teststate(teststate)
    );
    
//    // Clocks to change the frequency at which LEDs are updated
//    wire led_update_clock;
//    assign led_update_clock = sw[0] ? clk_10Hz : clk_20kHz;
    
//    // Transfer sample to LED
//    always @ (posedge led_update_clock)
//    begin
//        led[11:0] <= sample[11:0];
//    end
//    assign led = vol_led;
//    assign oled_data = oled_default;
    assign dp = 1;
    
    // Transfer sample to OLED
   
        
//        wire [23:0] freq_re;
//        wire [23:0] freq_im;
//        wire [23:0] freq_re_abs;
//        wire [23:0] freq_im_abs;
//        wire [23:0] freq_mag;
//        wire [9:0] freq_addr;
//        wire fft_done;
//        wire fft_out_rdy;
//        FFT myFFT(
//        .clk100m(basys_clock),
//        .clk20k(clk_20kHz),
//        .mic_in(sample),
//        .freq_re(freq_re),
//        .freq_im(freq_im),
//        .freq_re_abs(freq_re_abs),
//        .freq_im_abs(freq_im_abs),
//        .freq_mag(freq_mag),
//        .freq_addr(freq_addr),
//        .fft_done(fft_done),
//        .fft_out_rdy(fft_out_rdy)
//        );
    
      
//      wire [15:0] SOUNDFREQ;
//      wire [31:0] M;
//      wire [2:0] FREQ_RANGE;
//      sound_freq snd_frq(
//      .CLK(basys_clock),
//      .MIC_IN(sample),
//      .SOUNDFREQ(SOUNDFREQ),
//      .M(31'd4000),
//      .FREQ_RANGE(FREQ_RANGE)
//      );

    
      
    
    always @ (posedge clk_20kHz)
            begin
                led[11:0] <= vol_led;
            end
    
    
//    dash_controller dashController(
//    clk_10Hz,
//    btnL,
//    btnR,
//    an,
//    seg
//    );
    
    
    
    
endmodule