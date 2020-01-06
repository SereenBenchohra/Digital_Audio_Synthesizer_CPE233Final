`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Nicholas Garcia
// Create Date: 05/02/2019 11:12:01 AM
//////////////////////////////////////////////////////////////////////////////////

module ControlUnit(
    input CLK, C, Z, RESET, INTERRUPT,
    input [4:0] OPCODE_HI_5,
    input [1:0] OPCODE_LOW_2,
    output logic I_SET, I_CLR, PC_LD, PC_INC, ALU_OPY_SEL, RF_WR, SP_LD,
                 SP_INCR, SP_DECR, SCR_WE, SCR_DATA_SEL, FLG_C_SET, FLG_C_CLR,
                 FLG_C_LD, FLG_Z_LD, FLG_LD_SEL,FLG_SHAD_LD, RST, IO_STRB,
    output logic [1:0]PC_MUX_SEL, RF_WR_SEL, SCR_ADDR_SEL,
    output logic [3:0] ALU_SEL
    );
    
typedef enum{INIT, FETCH, EXEC, INTER} State; //Setup state variables
State NS, PS = INIT;

always_ff @ (posedge CLK) //reset control
begin
    if (RESET)
        PS <= INIT;
    else 
        PS <= NS;
end

logic [6:0] OPCODE;
assign OPCODE = {OPCODE_HI_5, OPCODE_LOW_2};

always_comb
begin
//initialize single-bit outputs
PC_LD = 0; PC_INC = 0; ALU_OPY_SEL =0; RF_WR = 0; I_SET = 0; I_CLR = 0;
SP_LD = 0; SP_INCR = 0; SP_DECR = 0; SCR_WE = 0; SCR_DATA_SEL = 0; 
FLG_C_SET = 0; FLG_C_CLR = 0; FLG_C_LD = 0; FLG_Z_LD = 0; FLG_LD_SEL = 0;
FLG_SHAD_LD = 0; RST = 0; IO_STRB = 0; 
//initialize 2-bit outputs
PC_MUX_SEL = 0; RF_WR_SEL = 0; SCR_ADDR_SEL = 0;
//initialize 4-bit outputs
ALU_SEL = 0;
    case(PS)
        INIT:begin
            RST = 1;
            NS = FETCH;
        end
        
        FETCH:begin
            PC_INC = 1;
            NS = EXEC;
        end
        
        EXEC:begin
            if (INTERRUPT)
                NS = INTER;
            else
                NS = FETCH;
    
            //directions for opcodes
            case(OPCODE)
                //BRN
                7'b0010000:begin
                PC_LD = 1;
                end
                //IN
                7'b1100100, 7'b1100101, 7'b1100110, 7'b1100111:begin
                RF_WR = 1;
                RF_WR_SEL = 3;
                end
                
                //OUT
                7'b1101000, 7'b1101001,7'b1101010,7'b1101011:begin
                IO_STRB = 1;
                end

                //MOV REG-REG
                7'b0001001:begin
                ALU_SEL = 14; 
                RF_WR = 1;
                
                end
                
                //MOV REG-IMM
                7'b1101101,7'b1101100, 7'b1101110,7'b1101111:begin
                ALU_SEL = 14;
                ALU_OPY_SEL = 1;
                RF_WR = 1;
                end
              
                //EXOR REG-REG
                7'b0000010:begin
                ALU_SEL = 7;
                RF_WR = 1;
                FLG_C_CLR = 1;
                FLG_Z_LD = 1;
                end
                
                //EXOR REG-IMM
                7'b1001000, 7'b1001001, 7'b1001010, 7'b1001011:begin
                ALU_SEL = 7;
                ALU_OPY_SEL = 1;
                RF_WR = 1;
                FLG_C_CLR = 1;
                FLG_Z_LD = 1;
                end
                
                //ADD REG-REG
                7'b0000100:begin
                RF_WR = 1;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //ADD REG-IMM
                7'b1010000, 7'b1010001, 7'b1010010, 7'b1010011:begin
                RF_WR = 1;
                ALU_OPY_SEL = 1;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //ADDC REG-REG
                7'b0000101:begin
                RF_WR = 1;
                ALU_SEL = 1;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //ADDC REG-IMM
                7'b1010100, 7'b1010101, 7'b1010110, 7'b1010111:begin
                RF_WR = 1;
                ALU_SEL = 1; 
                ALU_OPY_SEL = 1;
                FLG_C_LD = 1 ;
                FLG_Z_LD = 1;
                end
                
                //AND REG-REG
                7'b0000000:begin
                RF_WR = 1;
                ALU_SEL = 5;
                FLG_C_CLR = 1;
                FLG_Z_LD = 1;
                end
                
                //AND REG-IMM
                7'b1000000, 7'b1000001, 7'b1000010, 7'b1000011:begin
                RF_WR = 1;
                ALU_SEL = 5;
                ALU_OPY_SEL = 1;
                FLG_C_CLR = 1;
                FLG_Z_LD = 1;
                end
                
                //ASR
                7'b0100100:begin
                RF_WR = 1;
                ALU_SEL = 13;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //BRCC
                7'b0010101:begin
                if (C == 0)
                     PC_LD = 1;
                end
                
                //BRCS
                7'b0010100:begin
                if (C) 
                    PC_LD = 1;
                end
                
                //BREQ
                7'b0010010:begin
                if (Z)
                    PC_LD = 1;
                end
                
                //BRNE
                7'b0010011:begin
                if (Z == 0)
                    PC_LD = 1;
                end
                
                //CLC
                7'b0110000:
                FLG_C_CLR = 1;
                
                //CMP REG-REG
                7'b0001000:begin
                ALU_SEL = 4;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //CMP REG-IMM
                7'b1100000, 7'b1100001, 7'b 1100010, 7'b1100011:begin
                ALU_SEL = 4;
                ALU_OPY_SEL = 1;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //LSL
                7'b0100000:begin
                RF_WR = 1;
                ALU_SEL = 9;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //LSR
                7'b0100001:begin
                RF_WR = 1;
                ALU_SEL = 10;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //OR REG-REG
                7'b0000001:begin
                RF_WR = 1;
                ALU_SEL = 6;
                FLG_C_CLR = 1;
                FLG_Z_LD = 1;
                end
                
                //OR REG-IMM
                7'b1000100, 7'b1000101, 7'b1000110, 7'b1000111:begin
                RF_WR = 1;
                ALU_SEL = 6;
                ALU_OPY_SEL = 1;
                FLG_C_CLR = 1;
                FLG_Z_LD = 1;
                end
                
                //ROL
                7'b0100010:begin
                RF_WR = 1;
                ALU_SEL = 11;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //ROR
                7'b0100011:begin
                RF_WR = 1;
                ALU_SEL = 12;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //SEC
                7'b0110001:
                FLG_C_SET = 1;
                
                //SUB REG-REG
                7'b0000110:begin
                RF_WR = 1;
                ALU_SEL = 2;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //SUB REG-IMM
                7'b1011000, 7'b1011001, 7'b1011010, 7'b1011011:begin
                RF_WR = 1;
                ALU_SEL = 2;
                ALU_OPY_SEL = 1;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //SUBC REG-REG
                7'b0000111:begin
                RF_WR = 1;
                ALU_SEL = 3;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //SUBC REG-IMM
                7'b1011100, 7'b1011101, 7'b1011110, 7'b1011111:begin
                RF_WR = 1;
                ALU_SEL = 3;
                ALU_OPY_SEL = 1;
                FLG_C_LD = 1;
                FLG_Z_LD = 1;
                end
                
                //TEST REG-REG
                7'b0000011:begin
                ALU_SEL = 5;
                FLG_C_CLR = 1;
                FLG_Z_LD = 1;
                end
                
                //TEST REG-IMM
                7'b1001100, 7'b1001101, 7'b1001110, 7'b1001111:begin
                ALU_SEL = 5;
                ALU_OPY_SEL = 1;
                FLG_C_CLR = 1;
                FLG_Z_LD = 1;
                end
                
                //CALL
                7'b0010001:begin
                PC_LD = 1;
                SCR_WE = 1;
                SCR_DATA_SEL = 1;
                SCR_ADDR_SEL = 3;
                SP_DECR = 1;
                end
                
                //LD Reg-Reg
                7'b0001010:begin
                RF_WR = 1;
                RF_WR_SEL = 1;
                end
                
                //LD Reg-Imm
                7'b1110000, 7'b1110001, 7'b1110010, 7'b1110011:begin
                RF_WR = 1;
                RF_WR_SEL = 1;
                SCR_ADDR_SEL = 1;
                end
                
                //POP
                7'b0100110:begin
                RF_WR = 1;
                RF_WR_SEL = 1;
                SCR_ADDR_SEL = 2;
                SP_INCR = 1;
                end
                
                //PUSH
                7'b0100101:begin
                SCR_WE = 1;
                SCR_ADDR_SEL = 3;
                SP_DECR = 1;
                end
                
                //RET
                7'b0110010:begin
                PC_LD = 1 ;
                PC_MUX_SEL = 1;
                SCR_ADDR_SEL = 2;
                SP_INCR = 1;
                end
                
                //ST Reg-Reg
                7'b0001011:begin
                SCR_WE = 1;
               
                end
                
                //ST Reg-Imm
                7'b1110100, 7'b1110101, 7'b1110110, 7'b1110111:begin
                SCR_WE = 1;
                SCR_ADDR_SEL = 1;
                end
                
                //WSP
                7'b0101000:
                SP_LD = 1;
                
                //CLI
                7'b0110101:
                    I_CLR = 1;
                    
                //RETID
                7'b0110110:begin
                PC_LD = 1;
                PC_MUX_SEL = 1;
                SCR_ADDR_SEL = 2;
                SP_INCR = 1;
                FLG_LD_SEL = 1;
                FLG_Z_LD = 1;
                FLG_C_LD = 1;
                I_CLR = 1;
                end
                    
                //RETIE
                7'b0110111:begin
                PC_LD = 1;
                PC_MUX_SEL = 1;
                SCR_ADDR_SEL = 2;
                SP_INCR = 1;
                FLG_LD_SEL = 1;
                FLG_Z_LD = 1;
                FLG_C_LD = 1;
                I_SET = 1;
                end
                
                //SEI
                7'b0110100:
                    I_SET = 1;
                    
                default:;
            
            endcase
        end
        
        INTER:begin
            NS = FETCH;
            PC_LD = 1;
            PC_MUX_SEL = 2;
            SCR_DATA_SEL = 1;
            SCR_WE = 1;
            SCR_ADDR_SEL = 3;
            SP_DECR = 1;
            FLG_SHAD_LD = 1;
            I_CLR = 1;
        end
        
        default:NS = INIT;
        
    endcase           
end
endmodule
