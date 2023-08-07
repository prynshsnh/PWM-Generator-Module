
`timescale 1ns/1ps

module timer_with_input #(parameter timer_bits = 15) 
    (
        input [timer_bits-1 : 0] timer_final_value,
        input clk, reset_n, enable,
        output timer_done
    );

        reg[timer_bits-1 : 0] q_reg, q_next;

        always @(posedge clk, negedge reset_n) begin
            if(~reset_n)
                    q_reg <= 'd0;
            else 
                    q_reg <= q_next;
                
        end

        always @(*) begin
            if (q_reg == timer_final_value)
                q_next = 'd0;
            else 
                if(enable)
                    q_next = q_reg + 1'b1;
                else
                    q_next = q_next;

        end
        assign timer_done = (q_reg == timer_final_value);
        
    endmodule


module timer_with_input_tb ();

localparam timer_bits = 15 ;
localparam period = 10 ;

reg [timer_bits-1:0] timer_final_value;
reg clk, reset_n, enable;
wire timer_done;

timer_with_input #(.timer_bits(timer_bits)) UUT(.clk(clk), .timer_final_value(timer_final_value), .enable(enable), .timer_done(timer_done), .reset_n(reset_n));

always begin
  clk=1'b1;
  #( period / 2 );
  clk=1'b0;
  #( period / 2 );
end

initial begin
  reset_n=1'b0;
  enable=1'b1;
  timer_final_value = 'd20;
  #period;

  reset_n=1'b1;
  
  repeat(5) @( posedge timer_done);
  enable=1'b0;
  timer_final_value= 'd10;
  #(30 * period);
  enable=1'b1;
  repeat (7) @( negedge timer_done);
  
  $finish;

end

endmodule

