`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Sanders Sanabria and Filippo Cheein
// 
// Create Date: 01/18/2019 01:06:04 PM
// Module Name: SpeakerDriver 
// Description: Outputs a set frequency based on the input.
// Connect the output signal to any PMod pin in the constraints
// Then attach the red wire of a speaker to that pin and the
// black wire of the speaker to the Basys board GND (another PMOD pin)
// Input Note    Octave  Frequency(Hz)
//  0   none    none    0
//  1   C       6       1046.502
//  2   C#/Db   6       1108.731
//  3   D       6       1174.659
//  4   D#/Eb   6       1244.508
//  5   E       6       1318.51
//  6   F       6       1396.913
//  7   F#/Gb   6       1479.978
//  8   G       6       1567.982
//  9   G#/Ab   6       1661.219
//  10  A       6       1760
//  11  A#/Bb   6       1864.655
//  12  B       6       1975.533
//  13  C       7       2093.005
//  14  C#/Db   7       2217.461
//  15  D       7       2349.318
//  16  D#/Eb   7       2489.016
//  17  E       7       2637.021
//  18  F       7       2793.826
//  19  F#/Gb   7       2959.955
//  20  G       7       3135.964
//  21  G#/Ab   7       3322.438
//  22  A       7       3520
//  23  A#/Bb   7       3729.31
//  24  B       7       3951.066
//  25  C       8       4186.009
//  26  C#/Db   8       4434.922
//  27  D       8       4698.636
//  28  D#/Eb   8       4978.032
//  29  E       8       5274.042
//  30  F       8       5587.652
//  31  F#/Gb   8       5919.91
//  32  G       8       6271.928
//  33  G#/Ab   8       6644.876
//  34  A       8       7040
//  35  A#/Bb   8       7458.62
//  36  B       8       7902.132
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Runs on a 100 Mhz clock
// 
//////////////////////////////////////////////////////////////////////////////////


module SpeakerDriver(
    input [7:0] sel,
    input clk,
    output logic freq
    );
    logic [15:0] t1;
    logic t2;
    MuxFreq mux(.sel(sel), .out(t1));
    ClkDivider  sclk(.maxcount(t1), .clk(clk), .sclk(t2));
    
    always_comb
    begin
        if(t1==1)
            freq=0;
        else
            freq=t2;
    end
    
endmodule
