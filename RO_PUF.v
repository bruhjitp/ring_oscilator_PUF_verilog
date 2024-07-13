`timescale 1ns / 1ps

/////////////////////////////////////////////////////////top module
module RO_PUF(
    input ro_en,
    input [7:0]challenge,
    output response
    );
    wire [31:0]ro_mux;
    wire [1:0]mux_count;
    wire [7:0]count_comp_0;
    wire [7:0]count_comp_1;
    wire comp_d;
    wire or_d;
 
    genvar i; //instantiate the 32 ring oscilators

for(i=0; i<32; i=i+1)
    begin
    unit_oscilator_en (ro_en, ro_mux[i]);
    end
    
    mux_16x1 (ro_mux[15:0], challenge[3:0], mux_count[0]);//instantiate the muxes
    mux_16x1 (ro_mux[31:16], challenge[7:4], mux_count[1]);
    
    up_count(mux_count[0],count_comp_0); //instantiate the counters
    up_count(mux_count[1],count_comp_1);
    
    count_comp(count_comp_0, count_comp_1, comp_d);
    
    or(or_d, count_comp_0, count_comp_1);
    
    rise_d_ff(comp_d, or_d, response);
endmodule
/////////////////////////////////////////////////////end top module

//31 level ring oscilator with enable
module unit_oscilator_en(
input en,
output out);

wire w[29:0];
nand(w[0], en, out); //inverter with an enable control

genvar g;

for(g=1; g<30; g=g+1)
    begin
    not(w[g],w[g-1]);
    end
not(out, w[29]);
endmodule

//16x1 mus for 8 bit challenge
module mux_16x1(
    input [15:0]data, [7:0]sel_chal,
    output out_res);
    wire [3:0]w;
    mux_4x1 u0(data[3:0], sel_chal[1:0], w[0]);
    mux_4x1 u1(data[7:4], sel_chal[1:0], w[1]);
    mux_4x1 u2(data[11:8], sel_chal[1:0], w[2]);
    mux_4x1 u3(data[15:12], sel_chal[1:0], w[3]);
    mux_4x1 u4(w[3:0], sel_chal[3:2], out_res);
endmodule

//////////////////////////////////////// 
module mux_4x1(
    input [3:0]data,[1:0]sel,
    output out);
    wire [1:0]w;
    mux_2x1 u0(data[1:0], sel[0], w[0]);
    mux_2x1 u1(data[3:2], sel[0], w[1]);
    mux_2x1 u2(w[1:0], sel[1], out);
endmodule

module mux_2x1(
    input [1:0]data,
    input sel,
    output out
    );
    assign out = sel? data[0] : data[1] ;
endmodule
//////////////////////////////////////////

//8 bit upcounter
module up_count(
input clk,
output reg [7:0]count=8'd0);
    always@(posedge clk)
    begin
        if(count==8'd255)
            assign count =8'd0;
        else
            assign count=count+1;
    end
endmodule

//count comparator
module count_comp(
input [7:0]count_0,
input [7:0]count_1,
output reg comp);
    always@(count_0 or count_1)
    begin
        if(count_1>=count_0)
            assign comp=1;
        else
            assign comp=0;
    end

endmodule

//d flipflop
module rise_d_ff(
input d,
input clk,  
output reg q);
    always @(posedge clk) 
     assign q = d; 
endmodule 
