module traffic_light (
    input clk,
    input rst,
    output reg [2:0] light_A,
    output reg [2:0] light_B
);

    parameter red = 3'b001,
        yellow = 3'b010,
        green = 3'b100;
    
    parameter S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100,
        S5 = 3'b101;

    reg[2:0] state,next_state;
    //counter variables 
    reg[3:0] sixcounter;
    reg[3:0] onecounter;
    //counter outputs
    reg C6,C1;
    //counter enables
    reg en1,en6;

    initial begin 
        C1 = 0; C6 = 0; en1 = 0; en6 = 1;
        onecounter = 3'b000; sixcounter = 3'b000;
    end

    //modulo 6 counter
    always @(posedge clk, posedge rst) begin
        if(en6) begin
            if(rst)
                sixcounter <= 3'b000;
            else begin
                if( sixcounter == 3'b101 ) begin
                    sixcounter <= 3'b000;
                    C6 <= 1'b1;
                end
                else sixcounter <= sixcounter + 1;
            end    
        end
        else begin
            sixcounter <= 3'b000;
            C6 <= 1'b0;
        end
    end

    //modulo 1 counter
    always @(posedge clk, posedge rst) begin
        if(en1) begin
            if(rst)
                onecounter <= 3'b000;
            else begin
                if( onecounter == 3'b000 ) begin
                    onecounter <= 3'b000;
                    C1 <= 1'b1;
                end
                else onecounter <= onecounter + 1;
            end 
        end
        else begin
            onecounter <= 3'b000;
            C1 <= 1'b0;
        end
    end

    //changes state by each positive edge of clock
    always @(posedge clk, posedge rst) begin
        if(rst)
            state <= S0;
        else 
            state <= next_state;
    end

    //assigns values for each state
    always @(state) begin
        light_A <= red;
        light_B <= green;
        case(state)
            S0: begin
                light_A <= red; 
                light_B <= green;
            end
            S1: begin
                light_A <= red; 
                light_B <= yellow;
            end
            S2: begin
                light_A <= red; 
                light_B <= red;
            end
            S3: begin
                light_A <= green; 
                light_B <= red;
            end
            S4: begin
                light_A <= yellow; 
                light_B <= red;
            end
            S5: begin
                light_A <= red; 
                light_B <= red;
            end
        endcase
    end    

    //main block
    always @(state,C1,C6) begin
        //set default state to S0
        next_state <= S0;
        en1 <= 1'b0;
        en6 <= 1'b1;
        case(state)
            S0: begin
                if(C6) begin
                    //modulo 6 counter off and modulo 1 counter on
                    en6 <= 1'b0;
                    en1 <= 1'b1;
                    next_state <= S1;
               end
                else next_state <= S0; //stay 6 seconds
            end
            S1: begin
                if(C1) begin
                    //modulo 6 counter off and modulo 1 counter on
                    en6 <= 1'b0;
                    en1 <= 1'b1;
                    next_state <= S2;
                end
                else next_state <= S1; //stay 1 second
            end
            S2: begin
                if(C1) begin
                    //modulo 6 counter on and modulo 1 counter off
                    en1 <= 1'b0;
                    en6 <= 1'b1;
                    next_state <= S3;
                end
                else next_state <= S2; //stay 1 second
            end
            S3: begin
                if(C6) begin
                    //modulo 6 counter off and modulo 1 counter on
                    en6 <= 1'b0;
                    en1 <= 1'b1;
                    next_state <= S4;
                end
                else next_state <= S3; //stay 6 seconds
            end
            S4: begin
                if(C1) begin
                    //modulo 6 counter off and modulo 1 counter on
                    en1 <= 1'b1;
                    en6 <= 1'b0;
                    next_state <= S5;
                end
                else next_state <= S4; //stay 1 second
            end
            S5: begin
                if(C1) begin
                    //modulo 6 counter on and modulo 1 counter off
                    en1 <= 1'b0;
                    en6 <= 1'b1;
                    next_state <= S0;
                end
                else next_state <= S5; //stay 1 second
            
            end
        endcase
    end

endmodule