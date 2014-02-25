'timescale 1ns / 1ps
/*{{{ --- Simple Alu ---
Author : Nathan Gonzales
Date : Feb. 25, 2014
Description : just a tiny example alu
}}}*/
module simple_alu(
   input [1:0] a, b,
   input [1:0] op_code,
   output [1:0] c
);

always @*
begin
   case(op_code)
      0: c = a&b;
      1: c = a|b;
      2: c = a~&b;
      3: c = a~|b;
   endcase
endmodule

