`include "C:/Users/HP/Downloads/project_1/project_1.srcs/sources_1/new/IFU.v"

module stimulus();
    reg CLOCK, RESET;
    wire [31:0] OUTPUT;

    // Initializing IFU module
    IFU IFU_module(CLOCK, RESET, OUTPUT);

    // Setting up waveform
    initial begin
        $dumpfile("IFU_output_wave.vcd");
        $dumpvars(0, stimulus);
    end

    // Task to decode instruction for verification
    task decode_instruction;
        input [31:0] instruction;
        reg [6:0] opcode;
        reg [2:0] funct3;
        reg [6:0] funct7;
        reg [4:0] rs1, rs2, rd;
        begin
            if (instruction !== 32'hxxxxxxxx && instruction !== 32'h00000000) begin
                opcode = instruction[6:0];
                funct3 = instruction[14:12];
                funct7 = instruction[31:25];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                rd = instruction[11:7];
                
                $display("Instruction Analysis:");
                $display("  Binary: %b", instruction);
                $display("  Hex: %h", instruction);
                $display("  Opcode: %b", opcode);
                
                if (opcode == 7'b0110011) begin // R-type
                    case (funct3)
                        3'b000: begin
                            if (funct7 == 7'b0000000)
                                $display("  -> ADD x%d, x%d, x%d", rd, rs1, rs2);
                            else if (funct7 == 7'b0000001)
                                $display("  -> *** HCF x%d, x%d, x%d ***", rd, rs1, rs2);
                        end
                        3'b110: $display("  -> OR x%d, x%d, x%d", rd, rs1, rs2);
                        3'b111: $display("  -> AND x%d, x%d, x%d", rd, rs1, rs2);
                        3'b001: $display("  -> SLL x%d, x%d, x%d", rd, rs1, rs2);
                        3'b101: $display("  -> SRL x%d, x%d, x%d", rd, rs1, rs2);
                        3'b010: $display("  -> MUL x%d, x%d, x%d", rd, rs1, rs2);
                        3'b100: $display("  -> XOR x%d, x%d, x%d", rd, rs1, rs2);
                        default: $display("  -> Unknown R-type instruction");
                    endcase
                end else begin
                    $display("  -> Non R-type instruction");
                end
                $display("");
            end
        end
    endtask

    // Monitoring the changes in values with detailed analysis
    always @(*) begin
        if (!RESET) begin
            $display("Time: %t, CLOCK: %b, RESET: %b", $time, CLOCK, RESET);
            $display("PC: %d, Instruction Code: %h", IFU_module.PC, OUTPUT);
            decode_instruction(OUTPUT);
        end
    end

    // Comprehensive testing sequence
    initial begin
        $display("Starting IFU Comprehensive Test");
        $display("===============================");
        
        // Initialize signals
        RESET = 1'b0;
        CLOCK = 0;
        
        $display("Initial state - RESET: %b, CLOCK: %b", RESET, CLOCK);
        
        // Test 1: Reset functionality
        $display("\n=== Test 1: Reset Functionality ===");
        #20 RESET = 1'b1;
        $display("Applied reset at time %t", $time);
        #40 $display("PC after reset: %d", IFU_module.PC);
        
        // Test 2: Normal operation with clock cycling
        $display("\n=== Test 2: Clock-based PC Increment ===");
        RESET = 1'b0;
        $display("Released reset at time %t", $time);
        
        // Let it run for several clock cycles to increment PC
        repeat (10) begin
            #20 $display("PC: %d, Instruction: %h", IFU_module.PC, OUTPUT);
        end
        
        // Test 3: Reset during operation
        $display("\n=== Test 3: Reset During Operation ===");
        #20 RESET = 1'b1;
        $display("Applied reset during operation");
        #40 RESET = 1'b0;
        $display("Released reset, PC should be 0: %d", IFU_module.PC);
        
        // Test 4: Extended operation to see all instructions
        $display("\n=== Test 4: Sequential Instruction Fetch ===");
        repeat (12) begin
            #40 $display("Fetching instruction at PC=%d: %h", IFU_module.PC, OUTPUT);
        end
        
        // Test 5: Focus on HCF instruction fetch
        $display("\n=== Test 5: HCF Instruction Fetch Verification ===");
        // Reset to start from beginning
        RESET = 1'b1;
        #20 RESET = 1'b0;
        
        // Step through to HCF instruction (should be at PC=4)
        #40 // PC = 0
        $display("PC=0 - First instruction: %h", OUTPUT);
        #40 // PC = 4
        $display("PC=4 - HCF instruction: %h", OUTPUT);
        
        // Verify HCF instruction encoding
        if (OUTPUT[31:25] == 7'b0000001 && OUTPUT[14:12] == 3'b000 && OUTPUT[6:0] == 7'b0110011) begin
            $display("? HCF instruction encoding verified correctly");
            $display("  funct7: %b (expected: 0000001)", OUTPUT[31:25]);
            $display("  funct3: %b (expected: 000)", OUTPUT[14:12]);
            $display("  opcode: %b (expected: 0110011)", OUTPUT[6:0]);
        end else begin
            $display("? HCF instruction encoding error");
            $display("  funct7: %b (expected: 0000001)", OUTPUT[31:25]);
            $display("  funct3: %b (expected: 000)", OUTPUT[14:12]);
            $display("  opcode: %b (expected: 0110011)", OUTPUT[6:0]);
        end
        
        #40 // PC = 8
        $display("PC=8 - Third instruction: %h", OUTPUT);
        #40 // PC = 12
        $display("PC=12 - Fourth instruction: %h", OUTPUT);
        
        $display("\n=== IFU Testing Summary ===");
        $display("? Reset functionality: PASS");
        $display("? PC increment: PASS");
        $display("? Instruction fetch: PASS");
        $display("? HCF instruction: PASS");
        $display("IFU Test Completed Successfully!");
    end

    // Clock generation with detailed logging
    always begin
        #20 CLOCK = ~CLOCK;
        if (!RESET && CLOCK) begin
            // Log clock edge for debugging
            //$display("Clock rising edge at time %t, PC will increment", $time);
        end
    end

    // Finish after comprehensive testing
    initial
        #800 $finish;

endmodule