/*
	This module is taking in button information, state information,
	and outputing the position of the players and the ball, as well
	as passing boundary signals to the state machine
*/

module position(
	clk, 
	reset,
	player_1_y,
	player_2_y, 
	ball_x,
	ball_y,
	btnU, 
	btnD,
	player_1_point,
	player_2_point,
	state,
	btnR,
	btnL
	);

localparam NEW_GAME	=   4'b0001;
localparam PLAY		=   4'b0010;
localparam NEW_BALL	=   4'b0100;
localparam GAME_OVER	=   4'b1000;

input clk;
input reset;
input btnU;
input btnD;
input btnL;
input btnR;
input [3:0] state;

output reg [9:0] player_1_y;
output reg [9:0] player_2_y;
output reg [9:0] ball_x;
output reg [9:0] ball_y;

output reg player_1_point;
output reg player_2_point;

reg ball_delta_x;
reg ball_delta_y;

reg [27:0]	DIV_CLK;

parameter ball_radius = 5;
parameter player_height = 40;
parameter player_width = 5;
parameter screen_width = 640;
parameter screen_height = 480;
parameter player_1_x = 40;
parameter player_2_x = 600;

/************************Clock************/
always @ (posedge clk, posedge reset)  
	begin : CLOCK_DIVIDER
	  if (reset)
			DIV_CLK <= 0;
	  else
			DIV_CLK <= DIV_CLK + 1'b1;
	end	

/****************Clock Divider************/
assign	button_clk = DIV_CLK[18];

/**************player 1*******************/
always @(posedge button_clk)
	begin
		if(reset || (state==NEW_GAME) || (state==NEW_BALL))
			player_1_y <= screen_height/2;
		else if(btnD && ~btnL)
			player_1_y<=player_1_y+2;
		else if(btnL && ~btnD)
			player_1_y<=player_1_y-2;
	end

/********************player 2************/
always @(posedge button_clk)
	begin
		if(reset || (state==NEW_GAME) || (state==NEW_BALL))
			player_2_y <=screen_height/2;
		else if(btnR && ~btnU)
			player_2_y<=player_2_y+2;
		else if(btnU && ~btnR)
			player_2_y<=player_2_y-2;	
	end

/*********update output*****************/
always @(posedge clk)
	begin
		if(reset || (state == NEW_GAME) || (state == NEW_BALL))
			begin
				player_1_point <= 1'b0;
				player_2_point <= 1'b0;
				ball_delta_x <= 1'b1;
				ball_delta_y <= 1'b1;
			end
		else 
			begin
				if(ball_x - ball_radius == 0)
					player_2_point <= 1;
				else if(ball_x + ball_radius == screen_width)
					player_1_point <= 1;
				
				if(
				(ball_x - ball_radius == 20) && 
				((ball_y < player_1_y + player_height/2) && (ball_y > player_1_y - player_height/2))
				)
					ball_delta_x <= 1'b0;
				else if(
				(ball_x + ball_radius == 620) && 
				((ball_y < player_2_y + player_height/2) && (ball_y > player_2_y - player_height/2))
				)
					ball_delta_x <= 1'b1;
					
				if(ball_y - ball_radius == 0 )
					ball_delta_y <= 1'b0;
				else if(ball_y + ball_radius == screen_height)
					ball_delta_y <= 1'b1;
					
			end
	end
	
always @(posedge button_clk)
		begin
			if(state==PLAY)
				begin
					if(ball_delta_y)
						ball_y <= ball_y - 1'b1;
					else
						ball_y <= ball_y + 1'b1;
						
					if(ball_delta_x)
						ball_x <= ball_x - 1'b1;
					else
						ball_x <= ball_x + 1'b1;
				end
			else 
				begin
					ball_x <= screen_width/2;
					ball_y <= screen_height/2;
				end
		end
	
endmodule