`include "C:/Users/HP/Downloads/project_1/project_1.srcs/sources_1/new/ALU.v"


module stimulus ();
    reg [31:0] A, B;
    reg [3:0] ALUControl;
    wire ZERO;
    wire [31:0] ALUResult;

    // Instantiating ALU module
    ALU ALU_module(.in1(A), .in2(B), .alu_control(ALUControl), .zero_flag(ZERO), .alu_result(ALUResult));

    // Setting up waveform
    initial begin
        $dumpfile("output_wave.vcd");
        $dumpvars(0, stimulus);
    end

    // Monitoring changing values
    initial
        $monitor($time, "\nInput_1 = %d, \nInput_2 = %d,\nALU_control = %b,\nALU_result = %d, Zero_flag = %b\n", A, B, ALUControl, ALUResult, ZERO);

    // Comprehensive test conditions
    initial begin
        $display("Starting ALU Comprehensive Tests");
        $display("==================================");
        
        // Test AND operation
        $display("Testing AND operation:");
        A = 23; B = 42; ALUControl = 4'b0000;
        #20 $display("AND: %d & %d = %d", A, B, ALUResult);
        
        // Test OR operation  
        $display("Testing OR operation:");
        A = 23; B = 42; ALUControl = 4'b0001;
        #20 $display("OR: %d | %d = %d", A, B, ALUResult);
        
        // Test ADD operation
        $display("Testing ADD operation:");
        A = 23; B = 42; ALUControl = 4'b0010;
        #20 $display("ADD: %d + %d = %d", A, B, ALUResult);
        
        // Test SLL operation
        $display("Testing SLL operation:");
        A = 8; B = 2; ALUControl = 4'b0011;
        #20 $display("SLL: %d << %d = %d", A, B, ALUResult);
        
        // Test SRL operation
        $display("Testing SRL operation:");
        A = 32; B = 2; ALUControl = 4'b0101;
        #20 $display("SRL: %d >> %d = %d", A, B, ALUResult);
        
        // Test MUL operation
        $display("Testing MUL operation:");
        A = 6; B = 7; ALUControl = 4'b0110;
        #20 $display("MUL: %d * %d = %d", A, B, ALUResult);
        
        // Test XOR operation
        $display("Testing XOR operation:");
        A = 23; B = 42; ALUControl = 4'b0111;
        #20 $display("XOR: %d ^ %d = %d", A, B, ALUResult);
        
        // Test SLT operation
        $display("Testing SLT operation:");
        A = 23; B = 42; ALUControl = 4'b1000;
        #20 $display("SLT: %d < %d = %d", A, B, ALUResult);
        A = 42; B = 23; ALUControl = 4'b1000;
        #20 $display("SLT: %d < %d = %d", A, B, ALUResult);
        
        // ===== EXTENSIVE HCF TESTING =====
        $display("\n========== HCF INSTRUCTION TESTING ==========");
        
        // Test Case 1: HCF(48, 18) = 6 - Normal case
        A = 48; B = 18; ALUControl = 4'b1001;
        #20 $display("HCF Test 1: HCF(%d, %d) = %d (Expected: 6)", A, B, ALUResult);
        
        // Test Case 2: HCF(12, 8) = 4 - Simple case
        A = 12; B = 8; ALUControl = 4'b1001;
        #20 $display("HCF Test 2: HCF(%d, %d) = %d (Expected: 4)", A, B, ALUResult);
        
        // Test Case 3: HCF(15, 10) = 5 - Another simple case
        A = 15; B = 10; ALUControl = 4'b1001;
        #20 $display("HCF Test 3: HCF(%d, %d) = %d (Expected: 5)", A, B, ALUResult);
        
        // Test Case 4: HCF(17, 13) = 1 - Coprime numbers
        A = 17; B = 13; ALUControl = 4'b1001;
        #20 $display("HCF Test 4: HCF(%d, %d) = %d (Expected: 1)", A, B, ALUResult);
        
        // Test Case 5: HCF(0, 5) = 5 - Zero input case 1
        A = 0; B = 5; ALUControl = 4'b1001;
        #20 $display("HCF Test 5: HCF(%d, %d) = %d (Expected: 5)", A, B, ALUResult);
        
        // Test Case 6: HCF(7, 0) = 7 - Zero input case 2
        A = 7; B = 0; ALUControl = 4'b1001;
        #20 $display("HCF Test 6: HCF(%d, %d) = %d (Expected: 7)", A, B, ALUResult);
        
        // Test Case 7: HCF(9, 9) = 9 - Equal inputs
        A = 9; B = 9; ALUControl = 4'b1001;
        #20 $display("HCF Test 7: HCF(%d, %d) = %d (Expected: 9)", A, B, ALUResult);
        
        // Test Case 8: HCF(100, 25) = 25 - One divides the other
        A = 100; B = 25; ALUControl = 4'b1001;
        #20 $display("HCF Test 8: HCF(%d, %d) = %d (Expected: 25)", A, B, ALUResult);
        
        // Test Case 9: HCF(81, 54) = 27 - Larger numbers
        A = 81; B = 54; ALUControl = 4'b1001;
        #20 $display("HCF Test 9: HCF(%d, %d) = %d (Expected: 27)", A, B, ALUResult);
        
        // Test Case 10: HCF(7, 5) = 1 - Small coprime
        A = 7; B = 5; ALUControl = 4'b1001;
        #20 $display("HCF Test 10: HCF(%d, %d) = %d (Expected: 1)", A, B, ALUResult);
        
        // Test Case 11: HCF(24, 16) = 8 - Additional test
        A = 24; B = 16; ALUControl = 4'b1001;
        #20 $display("HCF Test 11: HCF(%d, %d) = %d (Expected: 8)", A, B, ALUResult);
        
        // Test Case 12: HCF(30, 18) = 6 - Additional test
        A = 30; B = 18; ALUControl = 4'b1001;
        #20 $display("HCF Test 12: HCF(%d, %d) = %d (Expected: 6)", A, B, ALUResult);
        
        $display("========== HCF TESTING COMPLETED ==========\n");
        
        // Additional edge case testing for other operations
        $display("Testing edge cases:");
        
        // Test zero results
        A = 0; B = 0; ALUControl = 4'b0010; // ADD
        #20 $display("Zero test ADD: %d + %d = %d, Zero_flag = %b", A, B, ALUResult, ZERO);
        
        A = 5; B = 5; ALUControl = 4'b0111; // XOR (should give 0)
        #20 $display("Zero test XOR: %d ^ %d = %d, Zero_flag = %b", A, B, ALUResult, ZERO);
        
        $display("All ALU tests completed!");
    end

    // Finish after sufficient time for all tests
    initial
        #600 $finish;

endmodule