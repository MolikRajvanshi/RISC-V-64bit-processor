`include "C:/Users/HP/Downloads/project_1/project_1.srcs/sources_1/new/Datapath.v"


module stimulus ();
    reg [4:0] read_reg_num1;
    reg [4:0] read_reg_num2;
    reg [4:0] write_reg;
    reg [3:0] alu_control;
    reg regwrite;
    reg clock;
    reg reset;
    wire zero_flag;

    DATAPATH DATAPATH_module( 
        read_reg_num1,
        read_reg_num2,
        write_reg,
        alu_control,
        regwrite,
        clock,
        reset,
        zero_flag
    );

    initial begin
        $dumpfile("output_wave.vcd");
        $dumpvars(0, stimulus);
    end

    // Monitor datapath operations
    always @(posedge clock) begin
        if (!reset) begin
            $display("Time: %t, ALU_Control: %b, RegWrite: %b, Zero_Flag: %b", 
                     $time, alu_control, regwrite, zero_flag);
            $display("  Read Reg1: %d, Read Reg2: %d, Write Reg: %d", 
                     read_reg_num1, read_reg_num2, write_reg);
        end
    end

    // Reset sequence
    initial begin
        $display("Starting Datapath Comprehensive Tests");
        $display("=====================================");
        reset = 1;
        regwrite = 0;
        alu_control = 4'b0000;
        read_reg_num1 = 0;
        read_reg_num2 = 0;
        write_reg = 0;
        #30 reset = 0;
        $display("Reset completed, registers initialized");
    end

    // Comprehensive testing sequence
    initial begin
        // Wait for reset to complete
        #35;
        
        // ===== Test ADD operations =====
        $display("\n===== Testing ADD Operations =====");
        regwrite = 1;
        alu_control = 4'b0010; // ADD
        
        // Test 1: Add reg 5 + reg 6, store in reg 10
        read_reg_num1 = 5; read_reg_num2 = 6; write_reg = 10;
        #20 $display("ADD Test 1: reg[5] + reg[6] -> reg[10]");
        
        // Test 2: Add reg 8 + reg 9, store in reg 11
        read_reg_num1 = 8; read_reg_num2 = 9; write_reg = 11;
        #20 $display("ADD Test 2: reg[8] + reg[9] -> reg[11]");
        
        // ===== Test HCF operations =====
        $display("\n===== Testing HCF Operations =====");
        alu_control = 4'b1001; // HCF
        
        // HCF Test 1: HCF of reg 12 (12) and reg 8 (8) = 4, store in reg 15
        read_reg_num1 = 12; read_reg_num2 = 8; write_reg = 15;
        #20 $display("HCF Test 1: HCF(reg[12], reg[8]) = HCF(12, 8) -> reg[15]");
        
        // HCF Test 2: HCF of reg 15 (should be 4) and reg 10 (should be 11) 
        read_reg_num1 = 15; read_reg_num2 = 10; write_reg = 16;
        #20 $display("HCF Test 2: HCF(reg[15], reg[10]) -> reg[16]");
        
        // HCF Test 3: HCF of reg 9 (9) and reg 9 (9) = 9, store in reg 17
        read_reg_num1 = 9; read_reg_num2 = 9; write_reg = 17;
        #20 $display("HCF Test 3: HCF(reg[9], reg[9]) = HCF(9, 9) -> reg[17]");
        
        // HCF Test 4: HCF of reg 7 (7) and reg 0 (0) = 7, store in reg 18
        read_reg_num1 = 7; read_reg_num2 = 0; write_reg = 18;
        #20 $display("HCF Test 4: HCF(reg[7], reg[0]) = HCF(7, 0) -> reg[18]");
        
        // ===== Test MUL operations =====
        $display("\n===== Testing MUL Operations =====");
        alu_control = 4'b0110; // MUL
        
        // Test 1: Multiply reg 3 * reg 4, store in reg 19
        read_reg_num1 = 3; read_reg_num2 = 4; write_reg = 19;
        #20 $display("MUL Test 1: reg[3] * reg[4] -> reg[19]");
        
        // Test 2: Multiply reg 2 * reg 5, store in reg 20
        read_reg_num1 = 2; read_reg_num2 = 5; write_reg = 20;
        #20 $display("MUL Test 2: reg[2] * reg[5] -> reg[20]");
        
        // ===== Test AND operations =====
        $display("\n===== Testing AND Operations =====");
        alu_control = 4'b0000; // AND
        
        // Test 1: AND reg 7 & reg 6, store in reg 21
        read_reg_num1 = 7; read_reg_num2 = 6; write_reg = 21;
        #20 $display("AND Test 1: reg[7] & reg[6] -> reg[21]");
        
        // ===== Test OR operations =====
        $display("\n===== Testing OR Operations =====");
        alu_control = 4'b0001; // OR
        
        // Test 1: OR reg 5 | reg 6, store in reg 22
        read_reg_num1 = 5; read_reg_num2 = 6; write_reg = 22;
        #20 $display("OR Test 1: reg[5] | reg[6] -> reg[22]");
        
        // ===== Test XOR operations =====
        $display("\n===== Testing XOR Operations =====");
        alu_control = 4'b0111; // XOR
        
        // Test 1: XOR reg 7 ^ reg 7 (should give 0), store in reg 23
        read_reg_num1 = 7; read_reg_num2 = 7; write_reg = 23;
        #20 $display("XOR Test 1: reg[7] ^ reg[7] -> reg[23] (should be 0)");
        
        // Test 2: XOR reg 5 ^ reg 6, store in reg 24
        read_reg_num1 = 5; read_reg_num2 = 6; write_reg = 24;
        #20 $display("XOR Test 2: reg[5] ^ reg[6] -> reg[24]");
        
        // ===== Test SLL operations =====
        $display("\n===== Testing SLL Operations =====");
        alu_control = 4'b0011; // SLL
        
        // Test 1: Shift reg 4 left by reg 1 positions, store in reg 25
        read_reg_num1 = 4; read_reg_num2 = 1; write_reg = 25;
        #20 $display("SLL Test 1: reg[4] << reg[1] -> reg[25]");
        
        // ===== Test SRL operations =====
        $display("\n===== Testing SRL Operations =====");
        alu_control = 4'b0101; // SRL
        
        // Test 1: Shift reg 8 right by reg 1 positions, store in reg 26
        read_reg_num1 = 8; read_reg_num2 = 1; write_reg = 26;
        #20 $display("SRL Test 1: reg[8] >> reg[1] -> reg[26]");
        
        // ===== Additional HCF stress testing =====
        $display("\n===== Additional HCF Stress Testing =====");
        alu_control = 4'b1001; // HCF
        
        // Write specific values for HCF testing
        // First, write value 48 to reg 27
        alu_control = 4'b0010; // ADD to write 48
        read_reg_num1 = 24; read_reg_num2 = 24; write_reg = 27; // 24+24=48
        #20
        
        // Write value 18 to reg 28 (using 9+9)
        read_reg_num1 = 9; read_reg_num2 = 9; write_reg = 28; // 9+9=18
        #20
        
        // Now test HCF(48, 18) = 6
        alu_control = 4'b1001; // HCF
        read_reg_num1 = 27; read_reg_num2 = 28; write_reg = 29;
        #20 $display("HCF Stress Test: HCF(48, 18) -> reg[29] (Expected: 6)");
        
        // Test reading back results to verify correctness
        $display("\n===== Reading Back Test Results =====");
        regwrite = 0; // Disable writing, just read
        alu_control = 4'b0010; // Use ADD to just pass through values
        
        read_reg_num1 = 15; read_reg_num2 = 0; // Read HCF result from earlier
        #20 $display("Verification: Reading reg[15] (HCF result)");
        
        read_reg_num1 = 17; read_reg_num2 = 0; // Read HCF(9,9) result
        #20 $display("Verification: Reading reg[17] (HCF(9,9) result)");
        
        read_reg_num1 = 18; read_reg_num2 = 0; // Read HCF(7,0) result
        #20 $display("Verification: Reading reg[18] (HCF(7,0) result)");
        
        read_reg_num1 = 29; read_reg_num2 = 0; // Read HCF(48,18) result
        #20 $display("Verification: Reading reg[29] (HCF(48,18) result)");
        
        $display("\n===== Datapath Testing Completed =====");
    end

    // Clock generation
    initial begin
        clock = 0;
        forever #10 clock = ~clock;
    end

    // Finish simulation after sufficient time
    initial begin
        #800 $finish;
    end

endmodule