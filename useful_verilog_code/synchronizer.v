`timescale 1ns / 1ps;
/*{{{ ------ synchronizer to cross clock domains ------
Author : Nathan Gonzales
File : synchronize.v
Date : 02/20/2014
Description : Use this module to connect between clock domains.
}}}*/

module synchronize(
   input clk1, clk2, t_rdy_in, r_done_in,
   output reg t_rdy_out, r_done_out
);

reg [1:0] t_regs, t_regs_nxt;
reg [1:0] r_regs, r_regs_nxt;

// register sequential block
always @(posedge clk1)
   t_regs <= t_regs_nxt;

always @(posedge clk2)
   r_regs <= r_regs_nxt;

// register next combinational logic
always @*
begin
   t_regs_nxt = {t_rdy_in, t_regs[1]};
   r_regs_nxt = {r_done_in, r_regs[1]};
end

// output combinational logic
always @*
begin
   t_rdy_out = t_regs[0];
   r_done_out = r_regs[0];
end

endmodule

