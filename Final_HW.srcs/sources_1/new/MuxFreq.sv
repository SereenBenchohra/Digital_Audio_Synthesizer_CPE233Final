`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sanders Sanabria and Filippo Cheein
// 
// Create Date: 01/18/2019 12:41:11 PM
// Module Name: MuxFreq
// Project Name: 
// Description: Mux that outputs the value the
// clock divider should divide the clock by.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MuxFreq(
    input [7:0] sel,
    output logic [15:0] out
    );
    
    always_comb
    begin
        case (sel)
            0:  out=1;
            1:  out=47778;
            2:  out=45096;
            3:  out=42565;
            4:  out=40176;
            5:  out=37921;
            6:  out=35793;
            7:  out=33784;
            8:  out=31888;
            9:  out=30098;
            10: out=28409;
            11: out=26814;
            12: out=25309;
            13: out=23889;
            14: out=22548;
            15: out=21282;
            16: out=20088;
            17: out=18960;
            18: out=17896;
            19: out=16892;
            20: out=15944;
            21: out=15049;
            22: out=14204;
            23: out=13407;
            24: out=12654;
            25: out=11944;
            26: out=11274;
            27: out=10641;
            28: out=10044;
            29: out=9480;
            30: out=8948;
            31: out=8446;
            32: out=7972;
            33: out=7524;
            34: out=7102;
            35: out=6703;
            36: out=6327;
            default: out=1;
        endcase
    end
    
endmodule
