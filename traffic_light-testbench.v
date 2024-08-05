`include "traffic_light.v"
`timescale 1s / 100ms
module traffic_light_tb();

    reg clock,reset;
    wire [2:0] A,B;
    traffic_light tb(clock, reset, A, B);

initial begin

    $dumpfile("traffic_light-testbench.vcd");
	$dumpvars(0,traffic_light_tb);

    clock = 1'b0;
    reset = 1'b0;
end

always#0.5 clock = ~clock;

initial begin 
    #2 reset = 1'b1;
    #2 reset = 1'b0;
    #60 $finish;
end

endmodule