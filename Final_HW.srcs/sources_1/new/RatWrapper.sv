`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Nicholas Garcia
//////////////////////////////////////////////////////////////////////////////////

module RatWrapper(
    input CLK, BTNL, BTNU, BTNR, BTND, BTNC, 
    input [15:0] SWITCHES,
    input PS2CLK,
    input PS2DATA,
    output logic [7:0] LEDS, SSEG,
    output logic [3:0] AN,
    output logic JA2
    );
    
    localparam SWITCHES_ID = 8'h20;
    localparam U_SWITCHES_ID = 8'h21;
    localparam LEDS_ID = 8'h40;
    localparam BUTTONS_ID = 8'hFF;
    localparam SSEG_ID = 8'h81;
    localparam KEYBOARD_ID = 8'h44;
    localparam SPEAKER_ID = 8'h46;
    
    logic [7:0] s_input_port, s_port_id, s_output_port, r_led, r_sseg, buttons, r_speaker;
    logic s_clk_50 = 0;
    logic s_load, s_reset, s_interrupt;
    
    // Signals for connecting Keyboard Driver
    logic [7:0] s_scancode;
    
    assign buttons = {4'b0, BTNL, BTNU, BTNR, BTND};
    
    //instantiate the CPU
    RatCPU myCPU(
        .CLK(s_clk_50), 
        .IN_PORT(s_input_port),
        .OUT_PORT(s_output_port),
        .PORT_ID(s_port_id), 
        .RESET(s_reset),
        .INTERRUPT(s_interrupt),
        .IO_STRB(s_load)
        );
        
    //insantiate 7-Seg Display
    UnivSseg mySseg (
        .clk(CLK),
        .cnt1({5'b0,r_sseg}),
        .valid(1'b1),
        .disp_en(AN),
        .ssegs(SSEG)
         );
         
//    //instantiate the debounce
//    Debounce MyDebounce (.CLK(s_clk_50),
//                         .BTN(BTNL),
//                         .DB_BTN(s_interrupt)
//                        );    
                        
    //instantiate the KeyboardDriver
    KeyboardDriver KEYBD (.CLK(CLK), .PS2DATA(PS2DATA), .PS2CLK(PS2CLK),
                          .INTRPT(s_interrupt), .SCANCODE(s_scancode));
                          
    //instantiate the SpeakerDriver
    SpeakerDriver SPEAKER (.sel(r_speaker),
                           .clk(CLK),
                           .freq(JA2)
                           );
        
    //clk divider
    always_ff @ (posedge CLK)
    begin
        s_clk_50 <= ~s_clk_50;
    end
        
    //input mux selects which input to read
    always_comb
    begin
        if (s_port_id == SWITCHES_ID)
            s_input_port = SWITCHES [7:0];
        else if (s_port_id == U_SWITCHES_ID)
            s_input_port = SWITCHES [15:8];    
        else if (s_port_id == BUTTONS_ID)
            s_input_port = buttons;
        else if (s_port_id == KEYBOARD_ID)
            s_input_port = s_scancode;
        else
            s_input_port = 0;
    end    
    
    //Mux for updating output registers
    //Register updates on rising clock edge and asserted load signal
    always_ff @ (posedge CLK)
    begin
        if (s_load == 1'b1)
        begin  
            if (s_port_id == LEDS_ID)
                r_led <= s_output_port;
            else if (s_port_id == SSEG_ID)
                r_sseg <= s_output_port;
            else if (s_port_id == SPEAKER_ID)
                r_speaker <= s_output_port;
        end
    end
    
    //connect signals
    assign s_reset = BTNC;
   // assign s_interrupt = BTNL;
    
    //output assignments
    assign LEDS = r_led;
    
endmodule

