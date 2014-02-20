`timescale 1ns / 1ps
/*{{{ ------ Positive Edge Detection Circuit ------
Author : Nathan Gonzales
FileName : posedge_detect.v
Date : 02/18/2014
}}}*/
module posedge_detect(
   input clk, din,
   output p_edge
);

reg qn;

always @(posedge clk)
   qn <= ~d;

assign p_edge = qn&d;

endmodule

