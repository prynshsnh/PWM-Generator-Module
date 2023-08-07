
module Basic_PWM #(
    parameter R_bits=8
) (
    input [R_bits-1:0] duty,
    input clk, reset_n,
    output PWM_out
);

    reg [R_bits-1:0] q_reg, q_next;


    always @(posedge clk, negedge reset_n ) begin
        if (!reset_n)
            q_reg<='d0;
        else
            q_reg<=q_next;
    end

        always @(*) begin
            q_next = q_reg+1;
        end

        assign PWM_out = (q_reg<=duty);   

endmodule

