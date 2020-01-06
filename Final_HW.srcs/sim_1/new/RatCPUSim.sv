`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Generic RatCPU test bench
//////////////////////////////////////////////////////////////////////////////////


module RatCPUSim( );

    logic [7:0] IN_PORT;
    logic RESET, INTERRUPT, CLK;
    logic [7:0] OUT_PORT, PORT_ID;
    logic IO_STRB;
    
    RatCPU RatCPUInstance (.*);
    
    always
    begin
        CLK = 0; #5; CLK = 1; #5;
    end
    
    initial
    begin
        IN_PORT = 8'h54;
        INTERRUPT = 0;
        RESET = 1;
        #10; 
        RESET = 0;
     end
     
endmodule