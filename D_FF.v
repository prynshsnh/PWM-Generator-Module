
module D_FF
(
    input D_in, clk, 
    output reg D_out
);
always @(posedge clk ) begin
    D_out<=D_in;
end

endmodule
