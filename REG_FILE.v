module REG_FILE(
    input [4:0] read_reg_num1,
    input [4:0] read_reg_num2,
    input [4:0] write_reg,
    input [31:0] write_data,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2,
    input regwrite,
    input clock,
    input reset
);

    reg [31:0] reg_memory [31:0];
    integer i;

 always @(posedge clock or posedge reset) begin
        if (reset) begin
            // Initialize all 32 registers with index value (0 to 31)
            for (i = 0; i < 32; i = i + 1) begin
                reg_memory[i] <= i;
            end
        end else begin
            // Handle write operation
            if (regwrite && write_reg != 0) begin
                reg_memory[write_reg] <= write_data;
                $display("Writing %h to reg[%0d] at time %t", write_data, write_reg, $time);
            end
    
            // Handle read operations
            read_data1 <= reg_memory[read_reg_num1];
            read_data2 <= reg_memory[read_reg_num2];
        end
    end

endmodule
