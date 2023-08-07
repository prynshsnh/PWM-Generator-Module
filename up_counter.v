`timescale 1ns/1ps

    module up_counter #(parameter counter_bits = 4) 
    (
        input clk, reset_n,enable, 
        output[counter_bits-1:0] counter_out
    );

        reg [counter_bits-1:0] q_reg, q_next;


        always @(posedge clk, negedge reset_n) begin
            if (~reset_n)
                q_reg <= 'd0;
            else
                if(enable)
                    q_reg <= q_next;
                else
                    q_reg <= q_reg;

        end
        

        always @(*) begin
            q_next = q_reg + 1'b1; 
        end



        assign counter_out = q_reg;

    endmodule




module up_counter_tb();


  localparam counter_bits = 7;
  localparam period = 5;

  reg clk, reset_n, enable;
  wire [counter_bits-1:0]counter_out;


   up_counter #(.counter_bits(counter_bits))UUT (.clk(clk), .reset_n(reset_n), .counter_out(counter_out), .enable(enable));



  initial begin
    #1000;
    $finish;
  end


  always begin
    clk = 1'b1;
    #period;
    clk = 1'b0;
    #period;
  end

  initial begin
    enable=1'b1;
    reset_n = 1'b0;
    #period;
    reset_n = 1'b1;

  end

  initial begin
    $monitor("time = %d\t  output = %d\t reset = %b", $time, counter_out, reset_n);
  end


endmodule

