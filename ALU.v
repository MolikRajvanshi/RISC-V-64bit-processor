/*
ALU module, which takes two operands of size 32-bits each and a 4-bit ALU_control as input.
Operation is performed on the basis of ALU_control value and output is 32-bit ALU_result. 
If the ALU_result is zero, a ZERO FLAG is set.
Modified to implement HCF instruction and remove SUB instruction.
*/

/*
ALU Control lines | Function
-----------------------------
        0000    Bitwise-AND
        0001    Bitwise-OR
        0010    Add (A+B)
        0011    Shift left logical
        0101    Shift right logical
        0110    Multiply
        0111    Bitwise-XOR
        1000    Set on less than
        1001    HCF (Highest Common Factor)
*/

module ALU (
    input [31:0] in1, in2, 
    input [3:0] alu_control,
    output reg [31:0] alu_result,
    output reg zero_flag
);
    // Temporary variables for HCF calculation
    reg [31:0] a, b, temp;
    integer i;
    
    always @(*)
    begin
        // Operating based on control input
        case(alu_control)
            4'b0000: alu_result = in1 & in2;                // AND
            4'b0001: alu_result = in1 | in2;                // OR
            4'b0010: alu_result = in1 + in2;                // ADD
            4'b0011: alu_result = in1 << in2;               // SLL
            4'b0101: alu_result = in1 >> in2;               // SRL
            4'b0110: alu_result = in1 * in2;                // MUL
            4'b0111: alu_result = in1 ^ in2;                // XOR
            4'b1000: begin                                  // SLT
                if(in1 < in2)
                    alu_result = 1;
                else
                    alu_result = 0;
            end
            4'b1001: begin                                  // HCF - Single cycle implementation
                // Handle edge cases first
                if (in2 == 0)
                    alu_result = in1;                       // HCF(a,0) = a
                else if (in1 == 0)
                    alu_result = in2;                       // HCF(0,b) = b
                else if (in1 == in2)
                    alu_result = in1;                       // HCF(a,a) = a
                else begin
                    // Initialize values
                    a = (in1 > in2) ? in1 : in2;            // Set a to the larger value
                    b = (in1 > in2) ? in2 : in1;            // Set b to the smaller value
                    
                    // Perform up to 4 iterations of the Euclidean algorithm in combinational logic
                    // This is a simplified implementation for single-cycle execution
                    
                    // Iteration 1
                    temp = a - b;
                    if (temp < b) begin
                        a = b;
                        b = temp;
                    end else begin
                        a = temp;
                    end
                    
                    // Iteration 2
                    if (b != 0) begin
                        temp = a - b;
                        if (temp < b) begin
                            a = b;
                            b = temp;
                        end else begin
                            a = temp;
                        end
                    end
                    
                    // Iteration 3
                    if (b != 0) begin
                        temp = a - b;
                        if (temp < b) begin
                            a = b;
                            b = temp;
                        end else begin
                            a = temp;
                        end
                    end
                    
                    // Iteration 4
                    if (b != 0) begin
                        temp = a - b;
                        if (temp < b) begin
                            a = b;
                            b = temp;
                        end else begin
                            a = temp;
                        end
                    end
                    
                    // Final result
                    alu_result = (b == 0) ? a : b;
                end
            end
            default: alu_result = 0;                        // Default case
        endcase

        // Setting Zero_flag if ALU_result is zero
        if (alu_result == 0)
            zero_flag = 1'b1;
        else
            zero_flag = 1'b0;
    end
endmodule