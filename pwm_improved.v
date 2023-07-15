// improve pwm utilizes timer, counter, comparator modules 
// usign the timer gives the ability of controling the frequency of the pwm signal by a known equation
module improved_PWM_instances #(parameter counter_bits = 15, parameter timer_bits = 15, parameter duty_bits = 15 ) 
(
    input clk, reset_n, enable, 
    input [duty_bits : 0]duty, 
    input [timer_bits-1 : 0] timer_final_value,
    output pwm_out
);
    wire timer_done;
    wire [counter_bits-1:0] counter_out;
    
    //comparator logic
    wire comparator_out;
    assign comparator_out = (counter_out < duty);
    //meaning as long as the counter output is less than the duty value the output will be high logic

    //modules inistantiations

        //timer instance
            timer_with_input #(.timer_bits(timer_bits)) timer_instance
            (.clk(clk), .enable(1'b1), .reset_n(reset_n), .timer_final_value(timer_final_value), .timer_done(timer_done));
        //counter instance 
            up_counter #(.counter_bits(counter_bits)) counter_instance 
            (.clk(clk), .enable(timer_done), .reset_n(reset_n), .counter_out(counter_out));
        //D_FF instance
            D_FF D_FF_instance 
            (.clk(clk), .D_in(comparator_out), .D_out(pwm_out));

endmodule


//tb-module


module improved_PWM_instances_tb();

//port and parameter declaration
localparam period =10;
localparam duty_bits = 15 ;
localparam timer_bits =15 ;
localparam counter_bits = 15 ;

reg [duty_bits : 0] duty;
reg [timer_bits-1 : 0] timer_final_value; 
// wire [counter_bits : 0] counter_out;
reg clk, reset_n/*, enable*/;
wire pwm_out;
// wire timer_done;

//inistaniate the UUT module

improved_PWM_instances #(.timer_bits(timer_bits), .duty_bits(duty_bits), .counter_bits(counter_bits)) UUT
        ( .clk(clk), .reset_n(reset_n), /*.enable(enable),*/ .timer_final_value(timer_final_value), 
          .duty(duty), .pwm_out(pwm_out));



//stopwatch
// initial
//     #(8192 * period) $finish;

//generate clock and stimuli 
always begin
    clk=1'b1;
    #(period / 2);
    clk=1'b0;
    #(period / 2);
end

initial begin
    // timer_final_value='d128;
    timer_final_value='d1;
    reset_n=1'b0;
    #period;
    reset_n=1'b1;

    duty = 0.5 * (2 ** duty_bits );
    repeat(4) @ (posedge pwm_out);
    #period;
    duty = 0.75 * (2 ** duty_bits );
    repeat(4) @ (posedge pwm_out);
    #period;
    duty = 0.25 * (2 ** duty_bits );
    repeat(4) @ (posedge pwm_out);
    #period;
    duty = (1 * (2 ** duty_bits )-1);
    repeat(4) @ (posedge pwm_out);

    $finish;        
end

endmodule


