`timescale 1ns / 1ps
`include "C:/Users/HP/Downloads/project_1/project_1.srcs/sources_1/new/REG_FILE.v"

module stimulus ();
    reg [4:0] read_reg_num1;
    reg [4:0] read_reg_num2;
    reg [4:0] write_reg;
    reg [31:0] write_data;
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    reg regwrite;
    reg clock;
    reg reset;
    
    // Test tracking variables
    integer test_number;
    integer pass_count, fail_count;

    // Instantiating register file module
    REG_FILE REG_FILE_module(
        read_reg_num1,
        read_reg_num2,
        write_reg,
        write_data,
        read_data1,
        read_data2,
        regwrite,
        clock,
        reset
    );

    // Setting up output waveform
    initial begin
        $dumpfile("output_wave.vcd");
        $dumpvars(0, stimulus);
    end

    // Task to verify read operation
    task verify_read;
        input [4:0] reg_num;
        input [31:0] expected_value;
        input [31:0] actual_value;
        input string test_desc;
        begin
            $display("  %s", test_desc);
            $display("    Register: %d, Expected: %d, Actual: %d", reg_num, expected_value, actual_value);
            if (actual_value == expected_value) begin
                $display("    Result: ? PASS");
                pass_count = pass_count + 1;
            end else begin
                $display("    Result: ? FAIL");
                fail_count = fail_count + 1;
            end
            $display("");
        end
    endtask

    // Task to perform write operation
    task write_register;
        input [4:0] reg_addr;
        input [31:0] data;
        input string description;
        begin
            $display("  %s", description);
            $display("    Writing %d to register %d", data, reg_addr);
            regwrite = 1;
            write_reg = reg_addr;
            write_data = data;
            #20; // Wait for clock edge
            regwrite = 0;
            $display("    Write completed");
            $display("");
        end
    endtask

    // Comprehensive testing sequence
    initial begin
        $display("Starting Register File Comprehensive Test");
        $display("========================================");
        
        // Initialize variables
        test_number = 0;
        pass_count = 0;
        fail_count = 0;
        
        // Initialize all control signals
        reset = 0;
        regwrite = 0;
        clock = 0;
        read_reg_num1 = 0;
        read_reg_num2 = 0;
        write_reg = 0;
        write_data = 0;
        
        // Test 1: Reset functionality and initialization
        test_number = test_number + 1;
        $display("\n=== Test %d: Reset and Initialization ===", test_number);
        reset = 1;
        #20 reset = 0;
        #20;
        
        $display("Verifying initial register values (should be 0 to 31):");
        read_reg_num1 = 0; #10;
        verify_read(0, 0, read_data1, "Register 0 (hardwired zero)");
        
        read_reg_num1 = 1; #10;
        verify_read(1, 1, read_data1, "Register 1 initialization");
        
        read_reg_num1 = 5; #10;
        verify_read(5, 5, read_data1, "Register 5 initialization");
        
        read_reg_num1 = 15; #10;
        verify_read(15, 15, read_data1, "Register 15 initialization");
        
        read_reg_num1 = 31; #10;
        verify_read(31, 31, read_data1, "Register 31 initialization");

        // Test 2: Basic write operations
        test_number = test_number + 1;
        $display("\n=== Test %d: Basic Write Operations ===", test_number);
        
        write_register(5, 100, "Write 100 to register 5");
        read_reg_num1 = 5; #10;
        verify_read(5, 100, read_data1, "Read back register 5");
        
        write_register(10, 250, "Write 250 to register 10");
        read_reg_num1 = 10; #10;
        verify_read(10, 250, read_data1, "Read back register 10");
        
        write_register(20, 500, "Write 500 to register 20");
        read_reg_num1 = 20; #10;
        verify_read(20, 500, read_data1, "Read back register 20");

        // Test 3: Register 0 write protection
        test_number = test_number + 1;
        $display("\n=== Test %d: Register 0 Write Protection ===", test_number);
        
        write_register(0, 999, "Attempt to write 999 to register 0 (should fail)");
        read_reg_num1 = 0; #10;
        verify_read(0, 0, read_data1, "Register 0 should remain 0");

        // Test 4: Simultaneous dual port reads
        test_number = test_number + 1;
        $display("\n=== Test %d: Dual Port Read Operations ===", test_number);
        
        $display("  Setting up test data in registers...");
        write_register(8, 88, "Write 88 to register 8");
        write_register(12, 144, "Write 144 to register 12");
        
        $display("  Testing simultaneous reads:");
        read_reg_num1 = 8;
        read_reg_num2 = 12;
        #10;
        verify_read(8, 88, read_data1, "Simultaneous read port 1 (register 8)");
        verify_read(12, 144, read_data2, "Simultaneous read port 2 (register 12)");
        
        read_reg_num1 = 5;  // Should still be 100
        read_reg_num2 = 10; // Should still be 250
        #10;
        verify_read(5, 100, read_data1, "Simultaneous read port 1 (register 5)");
        verify_read(10, 250, read_data2, "Simultaneous read port 2 (register 10)");

        // Test 5: Write enable control
        test_number = test_number + 1;
        $display("\n=== Test %d: Write Enable Control ===", test_number);
        
        $display("  Testing writes with regwrite disabled:");
        regwrite = 0;
        write_reg = 15;
        write_data = 777;
        #20;
        read_reg_num1 = 15; #10;
        verify_read(15, 15, read_data1, "Register 15 should retain original value (write disabled)");

        // Test 6: HCF-related register operations
        test_number = test_number + 1;
        $display("\n=== Test %d: HCF-Related Register Operations ===", test_number);
        
        $display("  Setting up HCF test scenarios:");
        // Prepare registers with values that will be used in HCF operations
        write_register(1, 48, "Prepare register 1 with 48 for HCF testing");
        write_register(2, 18, "Prepare register 2 with 18 for HCF testing");
        write_register(3, 12, "Prepare register 3 with 12 for HCF testing");
        write_register(4, 8, "Prepare register 4 with 8 for HCF testing");
        write_register(5, 15, "Prepare register 5 with 15 for HCF testing");
        write_register(6, 10, "Prepare register 6 with 10 for HCF testing");
        write_register(7, 9, "Prepare register 7 with 9 for HCF testing");
        
        $display("  Verifying HCF input register setup:");
        read_reg_num1 = 1; read_reg_num2 = 2; #10;
        $display("    HCF inputs: reg[1]=%d, reg[2]=%d (HCF should be 6)", read_data1, read_data2);
        
        read_reg_num1 = 3; read_reg_num2 = 4; #10;
        $display("    HCF inputs: reg[3]=%d, reg[4]=%d (HCF should be 4)", read_data1, read_data2);
        
        read_reg_num1 = 5; read_reg_num2 = 6; #10;
        $display("    HCF inputs: reg[5]=%d, reg[6]=%d (HCF should be 5)", read_data1, read_data2);
        
        read_reg_num1 = 7; read_reg_num2 = 7; #10;
        $display("    HCF inputs: reg[7]=%d, reg[7]=%d (HCF should be 9)", read_data1, read_data2);
        
        // Simulate storing HCF results
        $display("  Simulating HCF result storage:");
        write_register(25, 6, "Store HCF(48,18)=6 result in register 25");
        write_register(26, 4, "Store HCF(12,8)=4 result in register 26");
        write_register(27, 5, "Store HCF(15,10)=5 result in register 27");
        write_register(28, 9, "Store HCF(9,9)=9 result in register 28");

        // Test 7: Boundary register testing
        test_number = test_number + 1;
        $display("\n=== Test %d: Boundary Register Testing ===", test_number);
        
        $display("  Testing highest register number (31):");
        write_register(31, 1000, "Write 1000 to register 31");
        read_reg_num1 = 31; #10;
        verify_read(31, 1000, read_data1, "Register 31 write/read");
        
        $display("  Testing edge case register numbers:");
        write_register(30, 750, "Write 750 to register 30");
        read_reg_num1 = 30; #10;
        verify_read(30, 750, read_data1, "Register 30 write/read");

        // Test 8: Large value handling
        test_number = test_number + 1;
        $display("\n=== Test %d: Large Value Handling ===", test_number);
        
        write_register(29, 32'hFFFFFFFF, "Write maximum 32-bit value to register 29");
        read_reg_num1 = 29; #10;
        verify_read(29, 32'hFFFFFFFF, read_data1, "Maximum value handling");
        
        write_register(28, 32'h80000000, "Write large negative value to register 28");
        read_reg_num1 = 28; #10;
        verify_read(28, 32'h80000000, read_data1, "Large negative value handling");

        // Test 9: Random access pattern
        test_number = test_number + 1;
        $display("\n=== Test %d: Random Access Pattern ===", test_number);
        
        $display("  Testing non-sequential register access:");
        read_reg_num1 = 25; read_reg_num2 = 1; #10;
        $display("    Random read: reg[25]=%d, reg[1]=%d", read_data1, read_data2);
        
        read_reg_num1 = 7; read_reg_num2 = 29; #10;
        $display("    Random read: reg[7]=%d, reg[29]=%d", read_data1, read_data2);
        
        read_reg_num1 = 15; read_reg_num2 = 0; #10;
        $display("    Random read: reg[15]=%d, reg[0]=%d", read_data1, read_data2);

        // Final summary
        $display("\n=== Register File Test Summary ===");
        $display("Total Tests Passed: %d", pass_count);
        $display("Total Tests Failed: %d", fail_count);
        $display("Success Rate: %.1f%%", (pass_count * 100.0) / (pass_count + fail_count));
        
        if (fail_count == 0) begin
            $display("? ALL REGISTER FILE TESTS PASSED!");
        end else begin
            $display("? Some tests failed. Review results above.");
        end
        
        $display("Register File Testing Completed!");
        $display("=================================");
    end

    // Clock generation
    initial begin
        clock = 0;
        forever #10 clock = ~clock;
    end

    // Simulation timeout
    initial begin
        #2000 $finish;
    end

endmodule