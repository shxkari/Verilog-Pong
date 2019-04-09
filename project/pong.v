`timescale 1ns / 1ps
module pong(clk, reset, L, R, C, U, D, miss1, miss2, score1, score2, state);

input clk, reset;
input L, R, U, D, C;
input miss1, miss2;
output reg [1:0] score1, score2;
output reg [3:0] state;


wire btn_pressed;

localparam NEW_GAME	=   4'b0001;
localparam PLAY		=   4'b0010;
localparam NEW_BALL	=   4'b0100;
localparam GAME_OVER	=   4'b1000;

assign btn_pressed = L || R || U || D || C;

/*  ===========================================================
    ////////////////////////////////////////////////////////
					STATE MACHINE LOGIC
    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ======================================================== */

always @ (posedge clk, posedge reset)
begin
	if(reset)
		state <= NEW_GAME;
	else
		begin
			case(state)
				NEW_GAME:
					begin
						score1 <= 0;
						score2 <= 0;
						if(btn_pressed)
							state <= PLAY;
					end
				PLAY:
					begin
						if(miss1)
							begin
								score1 <= score1 + 1;
								state <= NEW_BALL;
							end
						if(miss2)
							begin
								score2 <= score2 + 1;
								state <= NEW_BALL;
							end
						if(score1 == 2'b11 || score2 == 2'b11)
							state <= GAME_OVER;
					end
				NEW_BALL:
					begin
						if(btn_pressed)
							state <= PLAY;
					end

				GAME_OVER:
					begin
						if(btn_pressed)
							state <= NEW_GAME;
					end
			endcase
		end
	end
		
endmodule

