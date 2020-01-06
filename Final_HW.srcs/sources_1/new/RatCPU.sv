`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Nicholas Garcia
// Create Date: 05/02/2019 05:23:16 PM
//////////////////////////////////////////////////////////////////////////////////

module RatCPU(
    input CLK, RESET, INTERRUPT,
    input [7:0] IN_PORT,
    output logic [7:0] OUT_PORT, PORT_ID,
    output logic IO_STRB
    );
    
logic rst, pc_ld, pc_inc, rf_wr, alu_opy_sel,
       c, c_flag, flg_c_set, flg_c_ld, flg_c_clr, c_mux_sel, z, z_flag, flg_z_ld, z_mux_sel,
       i_set, i_clr, i_flag, sp_ld, sp_incr, sp_decr, flg_ld_sel, flg_shad_ld, shad_c_flag, shad_z_flag, scr_we,
       scr_data_sel, inter;
logic [1:0] pc_mux_sel, rf_wr_sel, scr_addr_sel;
logic [3:0] alu_sel;
logic [7:0] reg_file_din, dx_out, dy_out, sp_data_out, sp_data_out_1, result, alu_mux_out,scr_mux_out;
logic [9:0] pc_din, pc_count,scr_din, scram_out;
logic [17:0] ir;

//instantiate ProgramCounter    
Register #(10) PC (.CLK (CLK), .RST(rst), .LD(pc_ld), .INC(pc_inc),
                   .DIN(pc_din), .DOUT(pc_count), .DECR(1'b0)
                    );
                    
//instantiate Program Counter's Mux
Mux4 #(10) PC_Mux (.SEL(pc_mux_sel), .ZERO(ir[12:3]),
                   .ONE(scram_out), .TWO(10'b1111111111), .THREE(10'b0), .MUXOUT(pc_din)
                  );
                  
//instantiate ProgRom
ProgRom Prog_Rom (.PROG_CLK(CLK), .PROG_ADDR(pc_count),
                   .PROG_IR(ir)     
                  );
                  
//instantiate RegisterFile
Ram #(5,8) Register_File (.CLK(CLK), .ADRX(ir[12:8]), 
                          .ADRY(ir[7:3]), .WE(rf_wr),
                          .DIN(reg_file_din), .DX_OUT(dx_out),
                          .DY_OUT(dy_out)
                             );
                             
//instantiate the RegisterFile's Mux
Mux4 #(8) Reg_File_Mux (.SEL(rf_wr_sel), .ZERO(result),
                         .ONE(scram_out[7:0]), .TWO(sp_data_out), 
                         .THREE(IN_PORT), .MUXOUT(reg_file_din)
                        );

//instantiate the ALU
ALU ALU (.A(dx_out), .B(alu_mux_out),
         .SEL(alu_sel), .CIN(c_flag),
         .RESULT(result), .C(c), .Z(z) 
        );
        
//instantiate the ALU's Mux
Mux2 #(8) ALU_Mux(.SEL(alu_opy_sel), .ZERO(dy_out),
           .ONE(ir[7:0]), .MUXOUT(alu_mux_out)
           );
    
//instantiate the CFlag
Flag C_Flag (.CLK(CLK),.SET(flg_c_set), 
             .LD(flg_c_ld),.DIN(c_mux_sel), 
             .CLR(flg_c_clr), .DOUT(c_flag)
            );
            
//instantiate the ZFlag
Flag Z_Flag (.CLK(CLK),.LD(flg_z_ld),
             .DIN(z_mux_sel), .DOUT(z_flag)
            );

//instantiate the ControlUnit
ControlUnit Control_Unit (.CLK(CLK), .C(c_flag), .Z(z_flag), .INTERRUPT(inter),
                          .RESET(RESET), .OPCODE_HI_5(ir[17:13]), .OPCODE_LOW_2(ir[1:0]),
                          .I_SET(i_set), .I_CLR(i_clr), .PC_LD(pc_ld),
                          .PC_INC(pc_inc), .PC_MUX_SEL(pc_mux_sel), .ALU_OPY_SEL(alu_opy_sel),
                          .ALU_SEL(alu_sel), .RF_WR(rf_wr), .RF_WR_SEL(rf_wr_sel), .SP_LD(sp_ld),
                          .SP_INCR(sp_incr), .SP_DECR(sp_decr), .FLG_C_SET(flg_c_set),
                          .FLG_C_CLR(flg_c_clr), .FLG_C_LD(flg_c_ld), .FLG_Z_LD(flg_z_ld),
                          .FLG_LD_SEL(flg_ld_sel), .FLG_SHAD_LD(flg_shad_ld), .SCR_WE(scr_we),
                          .SCR_ADDR_SEL(scr_addr_sel), .SCR_DATA_SEL(scr_data_sel), .RST(rst),
                          .IO_STRB(IO_STRB)
                          );
                          
//instantiate the Scratch Ram
Ram #(8,10) Scratch_Ram (.CLK(CLK), .ADRX(scr_mux_out), 
                        .ADRY(8'b0), .WE(scr_we),
                        .DIN(scr_din), .DX_OUT(scram_out)
                        );
                        
//instantiate the ScratchRamMux for address
Mux4 #(8) Scratch_Ram_Mux_Addr (.SEL(scr_addr_sel), .ZERO(dy_out),
                                .ONE(ir[7:0]), .TWO(sp_data_out), 
                                .THREE(sp_data_out_1), .MUXOUT(scr_mux_out)
                        );
                        
//instantiate the Scratch Rams's Data sel Mux
Mux2 #(10) Scratch_Ram_Mux_Sel (.SEL(scr_data_sel), .ZERO({2'b0,dx_out}),
           .ONE(pc_count), .MUXOUT(scr_din)
           );
           
//instantiate the StackPointer
Register #(8) Stack_Pointer (.CLK (CLK), .RST(rst), .LD(sp_ld), .INC(sp_incr),
                             .DIN(dx_out), .DOUT(sp_data_out), .DECR(sp_decr)
                            );
                            
//instantiate the InterruptFlag
Flag I_Flag (.CLK(CLK),.SET(i_set), 
             .LD(1'b0),.DIN(1'b0), 
             .CLR(i_clr), .DOUT(i_flag)
            );
            
//instantiate the Shad_C_Flag
Flag Shad_C_Flag (.CLK(CLK),.SET(1'b0), 
                  .LD(flg_shad_ld),.DIN(c_flag), 
                  .CLR(1'b0), .DOUT(shad_c_flag)
                  );
                  
//instantiate the C_shad sel Mux
Mux2 #(1) C_Flag_Mux_Sel (.SEL(flg_ld_sel), .ZERO(c),
           .ONE(shad_c_flag), .MUXOUT(c_mux_sel)
           );
                  
//instantiate the Shad_C_Flag
Flag Shad_Z_Flag (.CLK(CLK),.SET(1'b0), 
                  .LD(flg_shad_ld),.DIN(z_flag), 
                  .CLR(1'b0), .DOUT(shad_z_flag)
                  );
                  
//instantiate the Z_shad sel Mux
Mux2 #(1) Z_Flag_Mux_Sel (.SEL(flg_ld_sel), .ZERO(z),
           .ONE(shad_z_flag), .MUXOUT(z_mux_sel)
           );
            
always_comb
begin
    if (INTERRUPT == 1 && i_flag == 1)
        inter = 1;
    else
        inter = 0;
end

    
assign sp_data_out_1 = sp_data_out - 1;                          
assign PORT_ID = ir[7:0];
assign OUT_PORT = dx_out;
                          
endmodule
