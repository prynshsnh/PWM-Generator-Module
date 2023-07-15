//this module utilizes the improved_PWM we created before and is used to drive an RGB LEDs
module RGB_driver #(parameter pwm_bits = 15)
(
    input clk, reset_n,
    input [pwm_bits:0] red_duty, green_duty, blue_duty,
    output red_LED, green_LED, blue_LED
);
    
    localparam timer_bits = 8 ;
    localparam timer_final_value = 195; //controls PWM switching frequency


    //RED PWM driver instance
    improved_PWM_instances #(.timer_bits(timer_bits), .duty_bits(pwm_bits), .counter_bits(pwm_bits)) RED_pwm
        ( .clk(clk), .reset_n(reset_n), .timer_final_value(timer_final_value), 
          .duty(red_duty), .pwm_out(red_LED));



    //Green PWM driver instance
    improved_PWM_instances #(.timer_bits(timer_bits), .duty_bits(pwm_bits), .counter_bits(pwm_bits)) Green_pwm
        ( .clk(clk), .reset_n(reset_n), .timer_final_value(timer_final_value), 
          .duty(green_duty), .pwm_out(green_LED));

    //Blue PWM driver instance
    improved_PWM_instances #(.timer_bits(timer_bits), .duty_bits(pwm_bits), .counter_bits(pwm_bits)) Blue_pwm
        ( .clk(clk), .reset_n(reset_n), .timer_final_value(timer_final_value), 
          .duty(blue_duty), .pwm_out(blue_LED));




endmodule  
