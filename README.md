# ring_oscilator_PUF_verilog

Ring Oscillator 
The ring oscillator design consists of a two input NAND gate followed by eight inverters. 
The output of the final inverter is then fed back as one of the inputs to the NAND gate. The design 
has 32 ring oscillators to generate a one-bit output, and eight of these blocks are nested to produce 
an eight-bit response shown in Figure. 
1. MUX 
Each block makes use of two 16 to 1 MUX. A total of 32 Ring oscillators supply 16 inputs 
for each MUX, and select lines are made up of the 8-bit challenge. The first four bits of this 8-bit 
challenge correspond to the select line for the first MUX and the final four bits to the second MUX. 
A 16 to 1 MUX is created by joining five 4 to 1 MUXs, where one MUX is utilized to tie the other 
four MUXs together shown in Figure. 

2. Up counter 
The design utilizes two counters, CounterA and CounterB. If the MUX output is high, the 
counter increments its count. When it reaches its maximum value (predefined), the program resets 
it. The comparator then compares the output from the counter. The output will be '0' if it is less 
than the maximum value and '1' if there is an overflow shown in Figure.

4. Comparator 
The comparator comparesthe counters’ output. If count A is higher than count B, the output 
will be logic high; otherwise, the output will be set to be logic low shown in Figure 2.1.

5. D Flipflop 
The D flip-flop is used to store the response bits, with the OR gate serving as the clock 
source for the flip-flop. The input to the OR gate comes from the up counters, while the global 
reset initializes the output of the OR gate to zero. Whenever up counter overflows, a positive edge 
clock is produced, causing the output of the OR gate to turn high. This triggers the D flip-flop's 
clock, and the input from the comparator propagates to the D flip-flop's output each time the 
counter overflows shown in Figure.


Source: https://scholarworks.calstate.edu/downloads/pk02cj124
