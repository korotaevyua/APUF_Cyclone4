//MIT License
//
//Copyright (c) 2024 Yuri Korotaev
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

module delay_line

# (parameter line_length = 3)

(
	input clk,
	input [line_length - 1 :0] challenge,
	output line_out_1,
	output line_out_2
);

(* keep *) wire [2 * line_length + 1 : 0] net;

assign net[0] = clk;
assign net[1] = clk;

genvar i;
generate
	for (i=1; i<= line_length; i = i +1) 
	begin : mux_line
		mux inst_mux_1(
			.in1(net[i * 2 - 2]),
			.in2(net[i * 2 - 1]),
			.select(challenge[i-1]),
			.out_mux(net[i * 2])
		);

		mux inst_mux_2(
			.in1(net[i * 2 - 1]),
			.in2(net[i * 2 - 2]),
			.select(challenge[i-1]),
			.out_mux(net[i * 2 + 1])
		);
	end
endgenerate

assign line_out_1 = net[line_length * 2];
assign line_out_2 = net[line_length * 2 + 1];

endmodule