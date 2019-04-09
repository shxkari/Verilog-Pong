`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:44:22 04/10/2018 
// Design Name: 
// Module Name:    pong_game 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//	I will take in the position from Taylor's module
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_pos_input(clk, inDisplayArea, R, G, B, CounterY, CounterX, position_x_p1, position_y_p1, position_x_p2, position_y_p2, position_ball_x, position_ball_y);
	input [9:0] CounterY;
	input [9:0] CounterX;
	input clk;
	input inDisplayArea;
	input [9:0] position_x_p1, position_y_p1, position_x_p2, position_y_p2, position_ball_x, position_ball_y; 
	output R, G, B;
	
	



	assign R = ((CounterY >=(position_y_p1-20) && CounterY <=(position_y_p1+20) && CounterX <= position_x_p1) || 
	(CounterY >=(position_y_p2-20) && CounterY <=(position_y_p2+20) && CounterX >= position_x_p2) || 
	(CounterY >= (position_ball_y-5) && CounterY <= (position_ball_y+5) && CounterX >= (position_ball_x-5) && CounterX <= (position_ball_x+5)));
	assign G = R;
	assign B = R;
	

	 
	 



endmodule
	//Tommy's design to read use hvsync signals and output to vga, will also use taylor's outputs which are????