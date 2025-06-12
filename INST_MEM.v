/* 
Instruction memory takes in two inputs: A 32-bit Program counter and a 1-bit reset. 
The memory is initialized when reset is 1.
When reset is set to 0, based on the value of PC, the corresponding 32-bit instruction code is output.
Modified to include HCF instruction and remove SUB instruction.
*/
module INST_MEM(
    input [31:0] PC,
    input reset,
    output reg [31:0] Instruction_Code // Changed output to reg to avoid continuous assignment issues
);
    reg [7:0] Memory [0:31]; // Ensured proper indexing of memory

    // Under normal operation (reset = 0), we assign the instruction code, based on PC
    always @(*) begin
        Instruction_Code = {Memory[PC+3], Memory[PC+2], Memory[PC+1], Memory[PC]};
    end

    // Initializing memory when reset is one
    always @(posedge reset) begin // Changed to posedge reset to avoid unintended updates
        if (reset) begin
            // Setting 32-bit instruction: add t1, s0, s1 => 0x00940333 
            Memory[3]  <= 8'h00;
            Memory[2]  <= 8'h94;
            Memory[1]  <= 8'h03;
            Memory[0]  <= 8'h33;
            
            // Setting 32-bit instruction: hcf t2, s2, s3 => 0x013900b3
            // This replaces the previous SUB instruction
            // Format: funct7(0000001) rs2(s3) rs1(s2) funct3(000) rd(t2) opcode(0110011)
            Memory[7]  <= 8'h01;  // funct7 = 0000001 (HCF)
            Memory[6]  <= 8'h39;  // rs2 = s3 (11001), rs1 = s2 (10010)
            Memory[5]  <= 8'h00;  // funct3 = 000, rd = t2 (00111)
            Memory[4]  <= 8'hb3;  // opcode = 0110011
            
            // Setting 32-bit instruction: mul t0, s4, s5 => 0x035a02b3
            Memory[11] <= 8'h03;
            Memory[10] <= 8'h5a;
            Memory[9]  <= 8'h02;
            Memory[8]  <= 8'hb3;
            
            // Setting 32-bit instruction: xor t3, s6, s7 => 0x017b4e33
            Memory[15] <= 8'h01;
            Memory[14] <= 8'h7b;
            Memory[13] <= 8'h4e;
            Memory[12] <= 8'h33;
            
            // Setting 32-bit instruction: sll t4, s8, s9
            Memory[19] <= 8'h01;
            Memory[18] <= 8'h9c;
            Memory[17] <= 8'h1e;
            Memory[16] <= 8'hb3;
            
            // Setting 32-bit instruction: srl t5, s10, s11
            Memory[23] <= 8'h01;
            Memory[22] <= 8'hbd;
            Memory[21] <= 8'h5f;
            Memory[20] <= 8'h33;
            
            // Setting 32-bit instruction: and t6, a2, a3
            Memory[27] <= 8'h00;
            Memory[26] <= 8'hd6;
            Memory[25] <= 8'h7f;
            Memory[24] <= 8'hb3;
            
            // Setting 32-bit instruction: or a7, a4, a5
            Memory[31] <= 8'h00;
            Memory[30] <= 8'hf7;
            Memory[29] <= 8'h68;
            Memory[28] <= 8'hb3;
        end
    end
endmodule