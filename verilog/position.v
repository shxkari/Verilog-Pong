/*
	This module is taking in button information, state information,
	and outputing the position of the players and the ball, as well
	as passing boundary signals to the state machine
*/

module position(
	board_clk, 
	reset,
	player_1_pos,
	player_2_pos, 
	ball_x,
	ball_y,
	btnU, 
	btnD
	);

input clk;
input reset;
input btnU;
input btnD;

output [8:0] player_1_y;
output [8:0] player_2_y;
output [9:0] ball_x;
output [8:0] ball_y;

reg [8:0] ball_delta_x;
reg [8:0] ball_delta_y;

reg [27:0]	DIV_CLK;

parameter ball_radius = 5;
parameter player_height = 40;
parameter player_width = 5;
parameter screen_width = 640;
parameter screen_height = 480;
parameter player_1_x = 40;
parameter player_2_x = 600;

/************************Clock************/
always @ (posedge board_clk, posedge reset)  
begin : CLOCK_DIVIDER
  if (reset)
		DIV_CLK <= 0;
  else
		DIV_CLK <= DIV_CLK + 1'b1;
end	

/****************Clock Divider************/
assign	button_clk = DIV_CLK[18];
assign	clk = DIV_CLK[1];


/**************player 1*******************/
always @(posedge button_clk)
	begin
		if(reset)
			player_1_y <=240;
		else if(btnD && ~btnU)
			player_1_y<=player_1_y+2;
		else if(btnU && ~btnD)
			player_1_y<=player_1_y-2;
	end

/********************player 2************/
always @(posedge button_clk)
	begin
		
		if(reset)
			player_2_y <=240;
		/*
		else if()
			player_1_pos<=player_1_pos+2;
		else if(btnU && ~btnD)
			player_1_pos<=player_1_pos-2;
		*/
		else
			player_2_y <= ball_y;
	end


/***************ball boundaries*********/
always @(posedge button_clk)
	begin
		if(reset)
			begin
				ball_delta_x <= 2;
				ball_delta_y <= 2;
			end
		else if
			(
			ball_x - ball_radius < 0 || 
			ball_x + ball_radius > screen_width ||
				(
				ball_x + ball_radius < player_1_x + player_width/2 &&
					(
					ball_y + ball_radius > player_1_y + player_height/2 ||
					ball_y - ball_radius < player_1_y - player_height/2
					)
				)			
			)
			ball_delta_x <= ~ball_delta_x;
		else if
			(
			ball_y < 0 || 
			ball_y > screen_height
			)
			ball_delta_y <= ~ball_delta_y;
		else 
			begin
				ball_x <= ball_x + ball_delta_x;
				ball_y <= ball_y + ballls_delta_y;
			end
	end
