`include "C:/Users/HP/Downloads/project_1/project_1.srcs/sources_1/new/INST_MEM.v"

module stimulus ();
    reg [31:0] PC;
    reg RESET;
    wire [31:0] INST_CODE;

    // Instantiating instruction memory module
    INST_MEM INST_MEM_module(PC, RESET, INST_CODE);

    // Setting up waveform
    initial begin
        $dumpfile("INST_MEM_output_wave.vcd");
        $dumpvars(0, stimulus);
    end

    // Function to decode and display instruction details
    task display_instruction;
        input [31:0] instruction;
        input [31:0] pc_val;
        reg [6:0] opcode;
        reg [2:0] funct3;
        reg [6:0] funct7;
        reg [4:0] rs1, rs2, rd;
        begin
            opcode = instruction[6:0];
            funct3 = instruction[14:12];
            funct7 = instruction[31:25];
            rs1 = instruction[19:15];
            rs2 = instruction[24:20];
            rd = instruction[11:7];
            
            $display("PC = %d: Instruction = %h", pc_val, instruction);
            $display("  Opcode: %b, Funct3: %b, Funct7: %b", opcode, funct3, funct7);
            $display("  rs1: %d, rs2: %d, rd: %d", rs1, rs2, rd);
            
            // Decode instruction type
            if (opcode == 7'b0110011) begin // R-type
                if (funct3 == 3'b000) begin
                    if (funct7 == 7'b0000000)
                        $display("  -> ADD instruction: ADD x%d, x%d, x%d", rd, rs1, rs2);
                    else if (funct7 == 7'b0000001)
                        $display("  -> HCF instruction: HCF x%d, x%d, x%d", rd, rs1, rs2);
                end else if (funct3 == 3'b110)
                    $display("  -> OR instruction: OR x%d, x%d, x%d", rd, rs1, rs2);
                else if (funct3 == 3'b111)
                    $display("  -> AND instruction: AND x%d, x%d, x%d", rd, rs1, rs2);
                else if (funct3 == 3'b001)
                    $display("  -> SLL instruction: SLL x%d, x%d, x%d", rd, rs1, rs2);
                else if (funct3 == 3'b101)
                    $display("  -> SRL instruction: SRL x%d, x%d, x%d", rd, rs1, rs2);
                else if (funct3 == 3'b010)
                    $display("  -> MUL instruction: MUL x%d, x%d, x%d", rd, rs1, rs2);
                else if (funct3 == 3'b100)
                    $display("  -> XOR instruction: XOR x%d, x%d, x%d", rd, rs1, rs2);
                else
                    $display("  -> Unknown R-type instruction");
            end else
                $display("  -> Non R-type instruction");
            $display("");
        end
    endtask

    // Monitor instruction changes with detailed decoding
    always @(*) begin
        if (!RESET) begin
            display_instruction(INST_CODE, PC);
        end
    end

    // Setting test conditions
    initial begin
        $display("Starting Instruction Memory Comprehensive Tests");
        $display("===============================================");
        
        // Initialize
        RESET = 1'b0;
        PC = 32'd0;
        
        // Apply reset to initialize memory
        $display("Applying reset to initialize instruction memory...");
        #20 RESET = 1'b1;
        #20 RESET = 1'b0;
        $display("Reset completed. Memory initialized with test instructions.\n");
        
        // Test all instructions in memory by cycling through PC values
        $display("=== Testing All Instructions in Memory ===");
        
        // Instruction 1: ADD (PC = 0)
        PC = 32'd0;
        #20 $display("--- Instruction 1 (PC = 0) ---");
        
        // Instruction 2: HCF (PC = 4) - This replaces the SUB instruction
        PC = 32'd4;
        #20 $display("--- Instruction 2 (PC = 4) - HCF Instruction ---");
        
        // Instruction 3: MUL (PC = 8)
        PC = 32'd8;
        #20 $display("--- Instruction 3 (PC = 8) ---");
        
        // Instruction 4: XOR (PC = 12)
        PC = 32'd12;
        #20 $display("--- Instruction 4 (PC = 12) ---");
        
        // Instruction 5: SLL (PC = 16)
        PC = 32'd16;
        #20 $display("--- Instruction 5 (PC = 16) ---");
        
        // Instruction 6: SRL (PC = 20)
        PC = 32'd20;
        #20 $display("--- Instruction 6 (PC = 20) ---");
        
        // Instruction 7: AND (PC = 24)
        PC = 32'd24;
        #20 $display("--- Instruction 7 (PC = 24) ---");
        
        // Instruction 8: OR (PC = 28)
        PC = 32'd28;
        #20 $display("--- Instruction 8 (PC = 28) ---");
        
        // Test boundary conditions
        $display("\n=== Testing Boundary Conditions ===");
        
        // Test PC = 32 (beyond initialized memory)
        PC = 32'd32;
        #20 $display("--- PC = 32 (Beyond initialized memory) ---");
        
        // Test PC = 30 (partial instruction read)
        PC = 32'd30;
        #20 $display("--- PC = 30 (Partial instruction boundary) ---");
        
        // Test rapid PC changes to verify timing
        $display("\n=== Testing Rapid PC Changes ===");
        PC = 32'd0;  #5
        PC = 32'd4;  #5  
        PC = 32'd8;  #5
        PC = 32'd12; #5
        $display("Rapid PC change test completed");
        
        // Focus on HCF instruction verification
        $display("\n=== Detailed HCF Instruction Verification ===");
        PC = 32'd4; // HCF instruction location
        #20 
        $display("HCF Instruction Details:");
        $display("  Expected encoding: funct7=0000001, funct3=000, opcode=0110011");
        $display("  Actual instruction: %h", INST_CODE);
        $display("  Binary breakdown:");
        $display("    Bits 31-25 (funct7): %b", INST_CODE[31:25]);
        $display("    Bits 24-20 (rs2):    %b (%d)", INST_CODE[24:20], INST_CODE[24:20]);
        $display("    Bits 19-15 (rs1):    %b (%d)", INST_CODE[19:15], INST_CODE[19:15]);
        $display("    Bits 14-12 (funct3): %b", INST_CODE[14:12]);
        $display("    Bits 11-7  (rd):     %b (%d)", INST_CODE[11:7], INST_CODE[11:7]);
        $display("    Bits 6-0   (opcode): %b", INST_CODE[6:0]);
        
        // Verify HCF instruction encoding is correct
        if (INST_CODE[31:25] == 7'b0000001 && INST_CODE[14:12] == 3'b000 && INST_CODE[6:0] == 7'b0110011) begin
            $display("  ? HCF instruction encoding is CORRECT");
        end else begin
            $display("  ? HCF instruction encoding is INCORRECT");
        end
        
        $display("\n=== Sequential Program Execution Simulation ===");
        // Simulate sequential program execution
        PC = 32'd0;
        repeat (8) begin
            #20 $display("Executing instruction at PC = %d", PC);
            PC = PC + 4; // Increment PC by 4 for next instruction
        end
        
        $display("\nInstruction Memory Testing Completed!");
        $display("=====================================");
    end

    // Finish simulation after comprehensive testing
    initial
        #500 $finish;

endmodule